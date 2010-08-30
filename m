From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 16:52:36 +0200
Message-ID: <4C7BC5B4.3010707@suse.de>
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de>	<4C7B9F14.9080900@mvista.com> <4C7BA670.2060303@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080001040105040309060106"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C7BA670.2060303@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, rwheeler@redhat.com, konishi.ryusuke@lab.ntt.co.jp, Tejun Heo <tj@kernel.org>, jack@suse.cz, vst@vlnb.net, swhiteho@redhat.com, chris.mason@oracle.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080001040105040309060106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hannes Reinecke wrote:
> Sergei Shtylyov wrote:
>> Hello.
>>
>> Hannes Reinecke wrote:
>>
>>> Actually, I think we have two separate issues here:
>>> 1) The need of having more detailed I/O errors even in the fs layer. This
>>>    we've already discussed at the LSF, consensus here is to allow other
>>>    errors than just 'EIO'.
>>>    Instead of Mike's approach I would rather use existing error codes
>>> here;
>>>    this will make the transition somewhat easier.
>>>    Initially I would propose to return 'ENOLINK' for a transport failure,
>>>    'EIO' for a non-retryable failure on the target, and 'ENODEV' for a
>>>    retryable failure on the target.
>>    Are you sure it's not vice versa: EIO for retryable and ENODEV for
>> non-retryable failures. ENODEV looks more like permanent condition to me.
>>
> Ok, can do.
> And looking a the error numbers again, maybe we should be using 'EREMOTEIO'
> for non-retryable failures.
> 
> So we would be ending with:
> 
> ENOLINK: transport failure
> EIO: retryable remote failure
> EREMOTEIO: non-retryable remote failure
> 
And here is the corresponding patch.
Compile tested only; just to give an idea of the possible implementation.

I have decided to pass the I/O failure information in-line:
- scsi_check_sense() might now return 'TARGET_ERROR' to signal
  a permanent error
- scsi_decide_disposition() sets the driver byte of the result
  field to 'DID_TARGET_FAILURE' if a return code of 'TARGET_ERROR'
  is encountered.
- scsi_io_completion() sets the error to ENOLINK for DID_TRANSPORT_FAILFAST,
  EREMOTEIO for DID_TARGET_FAILURE, and EIO for any other error. It also
  resets DID_TARGET_FAILURE back to DID_OK once the error code is set.

I'm not 100% happy with this patch; DID_TARGET_FAILURE is really just
a communication vehicle to signal the permanent target failure.
I looked at passing this information directly via an explicit argument
to scsi_finish_command(), but this would include changing
scsi_io_completion(), too. As both of them are exported / public
interfaces I didn't like modifying them.

Another possibility would be to re-use / redefine the 'DRIVER_'
bits; they don't seem to be used a the moment. Eg 'DRIVER_HARD'
for permanent errors, DRIVER_SOFT for link failures.

Opinions welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080001040105040309060106
Content-Type: text/plain;
 name="scsi-detailed-io-errors"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-detailed-io-errors"

>From f0835d92426cb3938f79f1b7a1e1208de63ca7bc Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 30 Aug 2010 16:21:10 +0200
Subject: [RFC][PATCH] scsi: Detailed I/O errors

Instead of just passing 'EIO' for any I/O errors we should be
notifying the upper layers with some more details about the cause
of this error.
This patch updates the possible I/O errors to:

- ENOLINK: Link failure between host and target
- EIO: Retryable I/O error
- EREMOTEIO: Non-retryable I/O error

'Retryable' in this context means that an I/O error _might_ be
restricted to the I_T_L nexus (vulgo: path), so retrying on another
nexus / path might succeed.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..d49b375 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1270,7 +1270,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
 		return error;
 
 	if (clone->cmd_flags & REQ_DISCARD)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ce089df..5da040b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * @scmd:	Cmd to have sense checked.
  *
  * Return value:
- * 	SUCCESS or FAILED or NEEDS_RETRY
+ *	SUCCESS or FAILED or NEEDS_RETRY or TARGET_ERROR
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -338,25 +338,25 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
-		return SUCCESS;
+	case DATA_PROTECT:
+	case BLANK_CHECK:
+		return TARGET_ERROR;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return SUCCESS;
+			return TARGET_ERROR;
 		}
 		return NEEDS_RETRY;
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
-		else
-			return SUCCESS;
-
+		else {
+			return TARGET_ERROR;
+		}
 	case ILLEGAL_REQUEST:
-	case BLANK_CHECK:
-	case DATA_PROTECT:
 	default:
 		return SUCCESS;
 	}
@@ -819,6 +819,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		case SUCCESS:
 		case NEEDS_RETRY:
 		case FAILED:
+		case TARGET_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
 			rtn = NEEDS_RETRY;
@@ -1512,6 +1513,12 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
+		if (rtn == TARGET_ERROR) {
+			/* Need to modify host byte to signal a
+			 * permanent target failure */
+			scmd->result |= (DID_TARGET_FAILURE << 16);
+			rtn = SUCCESS;
+		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
@@ -1529,6 +1536,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case RESERVATION_CONFLICT:
 		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
 						"reservation conflict\n"));
+		scmd->result |= (DID_TARGET_FAILURE << 16);
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ade720..fb841e3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -736,8 +736,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				memcpy(req->sense, cmd->sense_buffer,  len);
 				req->sense_len = len;
 			}
-			if (!sense_deferred)
-				error = -EIO;
+			if (!sense_deferred) {
+				switch(host_byte(result)) {
+				case DID_TRANSPORT_FAILFAST:
+					error = -ENOLINK;
+					break;
+				case DID_TARGET_FAILURE:
+					cmd->result |= (DID_OK << 16);
+					error = -EREMOTEIO;
+					break;
+				default:
+					error = -EIO;
+					break;
+				}
+			}
 		}
 
 		req->resid_len = scsi_get_resid(cmd);
@@ -796,7 +808,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	error = -EIO;
+	switch (host_byte(result)) {
+	case DID_TRANSPORT_FAILFAST:
+		error = -ENOLINK;
+		break;
+	case DID_TARGET_FAILURE:
+		cmd->result |= (DID_OK << 16);
+		error = -EREMOTEIO;
+		break;
+	default:
+		error = -EIO;
+		break;
+	}
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -1418,7 +1441,6 @@ static void scsi_softirq_done(struct request *rq)
 			    wait_for/HZ);
 		disposition = SUCCESS;
 	}
-			
 	scsi_log_completion(cmd, disposition);
 
 	switch (disposition) {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8fcb6e0..abfee76 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -397,6 +397,8 @@ static inline int scsi_is_wlun(unsigned int lun)
 				      * recover the link. Transport class will
 				      * retry or fail IO */
 #define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
+#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
+				 * other paths */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -426,6 +428,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
+#define TARGET_ERROR    0x200A
 
 /*
  * Midlevel queue return values.

--------------080001040105040309060106--
