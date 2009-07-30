From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] bnx2i : Fix CMDSN jump issue seen during cable pull
 test
Date: Thu, 30 Jul 2009 10:31:16 -0500
Message-ID: <4A71BCC4.6090506@cs.wisc.edu>
References: <1245805860.9829.50.camel@anilgv-desktop> <1248929388.26650.349.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57700 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZG3PbZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 11:31:25 -0400
In-Reply-To: <1248929388.26650.349.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, mchan@broadcom.com

Anil Veerabhadrappa wrote:
> 
>     * Without the fix bnx2i would fail tt->xmit_task() when link is down
>     * libiscsi would have already incremented session->cmdsn before calling
>       bnx2i's xmit_task() entry point and will just return the command to
>       SCSI-ML when xmit_task() fails. libiscsi does not retract the session->cmdsn
>       as the command was never sent on wire

I fixed this in libiscsi.

>     * It is generally good idea for LLD, bnx2i to accept the scsi cmnd/nopout
>       and let upper layer timeout and go though normal session recovery process
>     * When link is down, unsolicited nopout will not be accepted by bnx2i and
>       connection will never enter recovery state. This fix is required for MPIO
>       to work corectly
> 
> Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index f741219..9535bb6 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1160,9 +1160,6 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
>  	struct bnx2i_cmd *cmd = task->dd_data;
>  	struct iscsi_cmd *hdr = (struct iscsi_cmd *) task->hdr;
>  
> -	if (test_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state))
> -		return -ENOTCONN;
> -
>  	if (!bnx2i_conn->is_bound)
>  		return -ENOTCONN;
>  

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
