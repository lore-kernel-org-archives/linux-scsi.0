From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 1/6] scsi_error: count medium access timeout only once
 per EH run
Date: Mon, 13 Mar 2017 10:37:28 -0300
Message-ID: <10894b48-b215-f2ef-6df0-d48a94ec7158@linux.vnet.ibm.com>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdCMNhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 09:37:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2DDXjv7017281
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 09:37:42 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 294emfb7vp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 09:37:41 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 13 Mar 2017 10:37:39 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2DDbZAr32243732
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 10:37:36 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2DDbYUd004347
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 10:37:35 -0300
In-Reply-To: <1488359720-130871-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

Hannes,

On 03/01/2017 06:15 AM, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f2cafae..cec439c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -58,6 +58,7 @@
>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>  				 struct scsi_cmnd *);
> +static int scsi_eh_reset(struct scsi_cmnd *scmd);
>
>  /* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
> @@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>  	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
>  		eh_flag &= ~SCSI_EH_CANCEL_CMD;
>  	scmd->eh_eflags |= eh_flag;
> +	scsi_eh_reset(scmd);
>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>  	shost->host_failed++;
>  	scsi_eh_wakeup(shost);
> @@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>  	if (!blk_rq_is_passthrough(scmd->request)) {
>  		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>  		if (sdrv->eh_action)
> -			rtn = sdrv->eh_action(scmd, rtn);
> +			rtn = sdrv->eh_action(scmd, rtn, false);
> +	}
> +	return rtn;
> +}
> +
> +static int scsi_eh_reset(struct scsi_cmnd *scmd)
> +{
> +	int rtn = SUCCESS;
> +
> +	if (!blk_rq_is_passthrough(scmd->request)) {
> +		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
> +		if (sdrv->eh_action)
> +			rtn = sdrv->eh_action(scmd, rtn, true);
>  	}
>  	return rtn;
>  }

Apparently we can de-duplicate code in scsi_eh_reset()/scsi_eh_action(),
and change less of sd_eh_action() (i.e., no new parameter).

Something like this.  Thoughts?


- Deduplicate code in scsi_eh_reset() and scsi_eh_action()
   - A call to scsi_eh_reset() with reset == false calls into eh_action()

   - A call to scsi_eh_reset() with reset == true returns early,
     (as happens with/if sd_eh_action() is called in your patch)

   - A call to scsi_eh_reset() in scsi_eh_scmd_add() uses SUCCESS just
     for consistency with scsi_eh_reset() in your patch, as the return
     value is ignored in it.

- Less changes to sd_eh_action()
   - Removed one chunk in sd_eh_action() ('reset gate variable')
   - No more parameter changes in sd_eh_action() (no 'reset' parameter)

- Removed forward declaration of scsi_eh_reset(), as already suggested



static int scsi_eh_reset(struct scsi_cmnd *scmd, int eh_disp, bool reset)
{
	int rtn = eh_disp;

	if (!blk_rq_is_passthrough(scmd->request)) {
		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
		if (sdrv->eh_action) {
			if (reset) {
			 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);

				/* New SCSI EH run, reset gate variable */
				sdkp->medium_access_reset = 0;
				return rtn;
			}
			rtn = sdrv->eh_action(scmd, rtn);
		}
  	}
  	return rtn;
}

Plus,

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f2cafae..cec439c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int 
eh_flag)
  	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
  		eh_flag &= ~SCSI_EH_CANCEL_CMD;
  	scmd->eh_eflags |= eh_flag;
+	scsi_eh_reset(scmd, SUCCESS, true); // return value is ignored (early 
exit due to reset)
  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
  	shost->host_failed++;
  	scsi_eh_wakeup(shost);
@@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, 
int rtn)
-	if (!blk_rq_is_passthrough(scmd->request)) {
-		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
-		if (sdrv->eh_action)
-			rtn = sdrv->eh_action(scmd, rtn);
-	}
-	return rtn;
+	return scsi_eh_reset(scmd, rtn, false);
  }


And the rest, without the 'reset' parameter.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6..c794686 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1689,X +1689,Y @@ static int sd_pr_clear(struct block_device *bdev, 
u64 key)
   *	sd_eh_action - error handling callback
   *	@scmd:		sd-issued command that has failed
   *	@eh_disp:	The recovery disposition suggested by the midlayer
   *
   *	This function is called by the SCSI midlayer upon completion of an
   *	error test command (currently TEST UNIT READY). The result of sending
   *	the eh command is passed in eh_disp.  We're looking for devices that
   *	fail medium access commands but are OK with non access commands like
   *	test unit ready (so wrongly see the device as having a successful
- *	recovery)
+ *	recovery).
+ *	We have to be careful to count a medium access failure only once
+ *	per SCSI EH run; there might be several timed out commands which
+ *	will cause the 'max_medium_access_timeouts' counter to trigger
+ *	after the first SCSI EH run already and set the device to offline.
   **/
@@ -1714,7 +1724,10 @@ static int sd_eh_action(struct scsi_cmnd *scmd, 
int eh_disp)
  	 * process of recovering or has it suffered an internal failure
  	 * that prevents access to the storage medium.
  	 */
-	sdkp->medium_access_timed_out++;
+	if (!sdkp->medium_access_reset) {
+		sdkp->medium_access_timed_out++;
+		sdkp->medium_access_reset = 1;
+	}

  	/*
  	 * If the device keeps failing read/write commands but TEST UNIT
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e..6a4f75a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -106,6 +106,7 @@ struct scsi_disk {
  	unsigned	rc_basis: 2;
  	unsigned	zoned: 2;
  	unsigned	urswrz : 1;
+	unsigned	medium_access_reset : 1;
  };
  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)











-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
