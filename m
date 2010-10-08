From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/15] qla4xxx: Do not wait for the outstanding commands
 to complete
Date: Thu, 07 Oct 2010 21:46:28 -0500
Message-ID: <4CAE8604.1020702@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA87129406789@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060806040501080001090307"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43590 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0JHCkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2010 22:40:13 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87129406789@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Nilesh Javali <nilesh.javali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

This is a multi-part message in MIME format.
--------------060806040501080001090307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2010 12:49 AM, Vikas Chaudhary wrote:
> From: Nilesh Javali<nilesh.javali@qlogic.com>
>
> Do not wait for the outstanding commands to complete in case
> of firmware hang.
>
> Signed-off-by: Nilesh Javali<nilesh.javali@qlogic.com>
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 56962e5..a6455fb 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -1102,7 +1102,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
>   		    ha->host_no, __func__));
>   		status = ha->isp_ops->reset_firmware(ha);
>   		if (status == QLA_SUCCESS) {
> -			qla4xxx_cmd_wait(ha);
> +			if (!test_bit(AF_FW_RECOVERY,&ha->flags))
> +				qla4xxx_cmd_wait(ha);
>   			ha->isp_ops->disable_intrs(ha);
>   			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
>   			qla4xxx_abort_active_cmds(ha, DID_RESET<<  16);
> @@ -1119,7 +1120,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
>   	 * or if stop_firmware fails for ISP-82xx.
>   	 * This is the default case for ISP-4xxx */
>   	if (!is_qla8022(ha) || reset_chip) {
> -		qla4xxx_cmd_wait(ha);
> +		if (!test_bit(AF_FW_RECOVERY,&ha->flags))
> +			qla4xxx_cmd_wait(ha);
>   		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
>   		qla4xxx_abort_active_cmds(ha, DID_RESET<<  16);
>   		DEBUG2(ql4_printk(KERN_INFO, ha,

If we go from qla4xxx_eh_host_reset->qla4xxx_recover_adapter and you do 
not wait, is is possible for the driver to be accessing scsi commands 
after qla4xxx_eh_host_reset returns? If so I think there is a problem 
where the scsi eh will fail or retry the cmd so the memory for the scsi 
command could be reallocated/freed.

On a related note, has qla4xxx_eh_host_reset ever returned SUCCESS? I 
think there is a problem in qla4xxx_cmd_wait when the scsi eh is 
running. At that time blk_finish_request->blk_queue_end_tag is not going 
to be run, because if the driver were to call scsi_done the block layer 
would do blk_complete_request and the blk_mark_rq_complete would fail 
(this is because the scsi/block eh timeout could has already marked it 
complete).

I think you need the attached patch.


--------------060806040501080001090307
Content-Type: text/plain;
 name="qla4xxx-fix-cmd-wait-cmd-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qla4xxx-fix-cmd-wait-cmd-check.patch"

qla4xxx: Fix cmd check in qla4xxx_cmd_wait

If the command has timedout then the block layer has called
blk_mark_rq_complete. If qla4xxx_cmd_wait is then called
from qla4xxx_eh_host_reset, we will always fail, because if
the driver calls scsi_done then the the block layer will fail
at blk_complete_request's blk_mark_rq_complete call instead of
calling the normal completion path including the function,
blk_queue_end_tag, which releases the tag.

Patch is not tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 370d40f..97f6d68 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -885,7 +885,13 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 		/* Find a command that hasn't completed. */
 		for (index = 0; index < ha->host->can_queue; index++) {
 			cmd = scsi_host_find_tag(ha->host, index);
-			if (cmd != NULL)
+			/*
+			 * We cannot just check if the index is valid,
+			 * becase if we are run from the scsi eh, then
+			 * the scsi/block layer is going to prevent
+			 * the tag from being released.
+			 */ 
+			if (cmd != NULL && CMD_SP(cmd))
 				break;
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);

--------------060806040501080001090307--
