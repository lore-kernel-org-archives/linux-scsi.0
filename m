From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Wed, 16 Oct 2013 19:22:09 +0000
Message-ID: <1381840900.3752.19.camel@dabdike.lan>
References: <1378123118-111972-1-git-send-email-hare@suse.de>
	 <1378123118-111972-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:53318 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288Ab3JPTWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 15:22:33 -0400
In-Reply-To: <1378123118-111972-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <E00B99A208F5EC45A22EA13D701E40E6@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Mon, 2013-09-02 at 13:58 +0200, Hannes Reinecke wrote:
> Commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8
> (Handle disk devices which can not process medium access commands)
> was introduced to offline any device which cannot process medium
> access commands.
> However, commit 3eef6257de48ff84a5d98ca533685df8a3beaeb8
> (Reduce error recovery time by reducing use of TURs) reduced
> the number of TURs by sending it only on the first failing
> command, which might or might not be a medium access command.
> So in combination this results in an erratic device offlining
> during EH; if the command where the TUR was sent upon happens
> to be a medium access command the device will be set offline,
> if not everything proceeds as normal.
> 
> So instead of checking the EH command in the ->eh_action
> callback we should rather call ->eh_action when we're
> about to finish the command _and_ have sent a TUR previously.
> This should then set the device offline as advertised.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ewan Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index abf0916..c88cb7e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -941,12 +941,6 @@ retry:
>  
>  	scsi_eh_restore_cmnd(scmd, &ses);
>  
> -	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> -		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
> -		if (sdrv->eh_action)
> -			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
> -	}
> -
>  	return rtn;
>  }
>  
> @@ -964,6 +958,18 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
>  	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
>  }
>  
> +static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
> +{
> +	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
> +
> +	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> +		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
> +		if (sdrv->eh_action)
> +			rtn = sdrv->eh_action(scmd, tur_command, 6, rtn);

This is all a bit pointless.  You've altered eh_action so it's always
input an eh TUR command, so just eliminate the check of the eh command
and assume it's a TUR in the implementation (i.e. fix up sd.c)

Once that's done, I think the patch looks like the one below, is that
OK?

I still have qualms about the media access check because what can happen
is that we abort, TUR succeeds then the next Media access command fails,
we abort, TUR succeeds etc until the media access timeout goes off.  The
problem is that it never gets escalated to a reset which might fix the
condition.  However, this is beyond the scope of the current patch set.

James

---
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 83e591b..aef80f1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -923,12 +923,6 @@ retry:
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
-		if (sdrv->eh_action)
-			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
-	}
-
 	return rtn;
 }
 
@@ -946,6 +940,16 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
 	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
 }
 
+static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
+{
+	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_action)
+			rtn = sdrv->eh_action(scmd, rtn);
+	}
+	return rtn;
+}
+
 /**
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
@@ -1094,7 +1098,9 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 
 		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
 			if (scmd->device == sdev) {
-				if (finish_cmds)
+				if (finish_cmds &&
+				    (try_stu ||
+				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
 					scsi_eh_finish_cmd(scmd, done_q);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
@@ -1208,7 +1214,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			    !scsi_eh_tur(stu_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							  work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
 						scsi_eh_finish_cmd(scmd, done_q);
 				}
 			}
@@ -1264,7 +1271,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, rtn) != FAILED)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
 				}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..d037391 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,7 +109,7 @@ static int sd_suspend(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
-static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
+static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
@@ -1530,23 +1530,23 @@ static const struct block_device_operations sd_fops = {
 /**
  *	sd_eh_action - error handling callback
  *	@scmd:		sd-issued command that has failed
- *	@eh_cmnd:	The command that was sent during error handling
- *	@eh_cmnd_len:	Length of eh_cmnd in bytes
  *	@eh_disp:	The recovery disposition suggested by the midlayer
  *
- *	This function is called by the SCSI midlayer upon completion of
- *	an error handling command (TEST UNIT READY, START STOP UNIT,
- *	etc.) The command sent to the device by the error handler is
- *	stored in eh_cmnd. The result of sending the eh command is
- *	passed in eh_disp.
+ *	This function is called by the SCSI midlayer upon completion of an
+ *	error test command (currently TEST UNIT READY). The result of sending
+ *	the eh command is passed in eh_disp.  We're looking for devices that
+ *	fail medium access commands but are OK with non access commands like
+ *	test unit ready (so wrongly see the device as having a successful
+ *	recovery)
  **/
-static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
-			int eh_cmnd_len, int eh_disp)
+static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
 
 	if (!scsi_device_online(scmd->device) ||
-	    !scsi_medium_access_command(scmd))
+	    !scsi_medium_access_command(scmd) ||
+	    host_byte(scmd->result) != DID_TIME_OUT ||
+	    eh_disp != SUCCESS)
 		return eh_disp;
 
 	/*
@@ -1556,9 +1556,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
 	 * process of recovering or has it suffered an internal failure
 	 * that prevents access to the storage medium.
 	 */
-	if (host_byte(scmd->result) == DID_TIME_OUT && eh_disp == SUCCESS &&
-	    eh_cmnd_len && eh_cmnd[0] == TEST_UNIT_READY)
-		sdkp->medium_access_timed_out++;
+	sdkp->medium_access_timed_out++;
 
 	/*
 	 * If the device keeps failing read/write commands but TEST UNIT
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index d443aa0..20fdfc2 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -16,7 +16,7 @@ struct scsi_driver {
 
 	void (*rescan)(struct device *);
 	int (*done)(struct scsi_cmnd *);
-	int (*eh_action)(struct scsi_cmnd *, unsigned char *, int, int);
+	int (*eh_action)(struct scsi_cmnd *, int);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)

