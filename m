From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/5] ipr: Don't set NO_ULEN_CHK bit when resource is a
 vset.
Date: Tue, 3 Nov 2015 14:39:36 -0600
Message-ID: <56391B88.8090102@linux.vnet.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:48529 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbKCUjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 15:39:10 -0500
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 13:39:09 -0700
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2AF7D1FF0049
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 13:27:19 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA3Kd7ll1245470
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 13:39:07 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA3Kd71M011887
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 13:39:07 -0700
In-Reply-To: <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

Gabriel:

On applying this patch, I noticed that this statement
seems to be unnecessary:

                 else
                         ioarcb->cmd_pkt.flags_lo |= 
IPR_FLAGS_LO_UNTAGGED_TASK;

As the value is 0x00:
#define IPR_FLAGS_LO_UNTAGGED_TASK              0x00

You can resolve this in a future update.

Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar

On 11/3/2015 12:26 PM, Gabriel Krisman Bertazi wrote:
> According to the IPR specification, Inhibit Underlength Checking bit
> must be disabled when issuing commands to vsets.  Enabling it in this
> case might cause SCSI commands to fail with an Illegal Request, so make
> sure we keep this bit cleared when resource is a vset.
>
> Changes since v1:
> 	- Put gsci exclusive stuff in a separate block.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>   drivers/scsi/ipr.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 238efab..6849b7f 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6363,15 +6363,19 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
>   	ipr_cmd->scsi_cmd = scsi_cmd;
>   	ipr_cmd->done = ipr_scsi_eh_done;
>
> -	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
> +	if (ipr_is_gscsi(res)) {
>   		if (scsi_cmd->underflow == 0)
>   			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
>
> -		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> -		if (ipr_is_gscsi(res) && res->reset_occurred) {
> +		if (res->reset_occurred) {
>   			res->reset_occurred = 0;
>   			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
>   		}
> +	}
> +
> +	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
> +		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> +
>   		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
>   		if (scsi_cmd->flags & SCMD_TAGGED)
>   			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_SIMPLE_TASK;
>

