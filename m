From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 13/47] megaraid: pass in NULL scb for host reset
Date: Wed, 28 Jun 2017 19:11:01 +0530
Message-ID: <f5b7e09b259b22452afe1da669712af6@mail.gmail.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de> <1498638793-44672-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36496 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdF1NlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 09:41:04 -0400
Received: by mail-oi0-f53.google.com with SMTP id p187so41557881oif.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 06:41:03 -0700 (PDT)
In-Reply-To: <1498638793-44672-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>Sent: Wednesday, June 28, 2017 2:03 PM
>To: Christoph Hellwig
>Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
Hannes
>Reinecke; Hannes Reinecke
>Subject: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>
>When calling a host reset we shouldn't rely on the command triggering the
>reset, so allow megaraid_abort_and_reset() to be called with a NULL scb.
>And drop the pointless 'bus_reset' and 'target_reset' handlers, which
just call
>the same function as host_reset.

If this patch address any functional issue, then we should consider this.
If it's code optimization, can we ignore this as this is being very old
driver
and no more maintained by Broadcom/LSI ?

>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
>---
> drivers/scsi/megaraid.c | 42 ++++++++++++++++--------------------------
> 1 file changed, 16 insertions(+), 26 deletions(-)
>
>diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
>3c63c29..7e504d3 100644
>--- a/drivers/scsi/megaraid.c
>+++ b/drivers/scsi/megaraid.c
>@@ -1909,7 +1909,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
>
> 	spin_lock_irq(&adapter->lock);
>
>-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
>+	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);

If cmd=NULL is passed, it will crash inside function
megaraid_abort_and_reset() while dereferencing "cmd" pointer.
Below is the code of function  megaraid_abort_and_reset() where it will
crash-

static int
megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
{
	struct list_head	*pos, *next;
	scb_t			*scb;

	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
	     (aor == SCB_ABORT)? "ABORTING":"RESET",
	     cmd->cmnd[0],
cmd->device->channel,>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>it should crash
here
	     cmd->device->id, (u32)cmd->device->lun);

Please correct if I am missing something here.
>
> 	/*
> 	 * This is required here to complete any completed requests @@ -
>1948,7 +1948,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
>
> 		scb = list_entry(pos, scb_t, list);
>
>-		if (scb->cmd == cmd) { /* Found command */
>+		if (!cmd || scb->cmd == cmd) { /* Found command */
>
> 			scb->state |= aor;
>
>@@ -1967,31 +1967,23 @@ static DEF_SCSI_QCMD(megaraid_queue)
>
> 				return FAILED;
> 			}
>-			else {
>-
>-				/*
>-				 * Not yet issued! Remove from the pending
>-				 * list
>-				 */
>-				dev_warn(&adapter->dev->dev,
>-					"%s-[%x], driver owner\n",
>-					(aor==SCB_ABORT) ?
>"ABORTING":"RESET",
>-					scb->idx);
>-
>-				mega_free_scb(adapter, scb);
>-
>-				if( aor == SCB_ABORT ) {
>-					cmd->result = (DID_ABORT << 16);
>-				}
>-				else {
>-					cmd->result = (DID_RESET << 16);
>-				}
>+			/*
>+			 * Not yet issued! Remove from the pending
>+			 * list
>+			 */
>+			dev_warn(&adapter->dev->dev,
>+				 "%s-[%x], driver owner\n",
>+				 (cmd) ? "ABORTING":"RESET",
>+				 scb->idx);
>+			mega_free_scb(adapter, scb);
>
>+			if (cmd) {
>+				cmd->result = (DID_ABORT << 16);
> 				list_add_tail(SCSI_LIST(cmd),
>-						&adapter->completed_list);
>-
>-				return SUCCESS;
>+					      &adapter->completed_list);
> 			}
>+
>+			return SUCCESS;
> 		}
> 	}
>
>@@ -4180,8 +4172,6 @@ static inline void mega_create_proc_entry(int
index,
>struct proc_dir_entry *pare
> 	.cmd_per_lun			= DEF_CMD_PER_LUN,
> 	.use_clustering			= ENABLE_CLUSTERING,
> 	.eh_abort_handler		= megaraid_abort,
>-	.eh_device_reset_handler	= megaraid_reset,
>-	.eh_bus_reset_handler		= megaraid_reset,
> 	.eh_host_reset_handler		= megaraid_reset,
> 	.no_write_same			= 1,
> };
>--
>1.8.5.6
