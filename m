From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT request
Date: Wed, 17 Nov 2010 21:40:32 -0600
Message-ID: <4CE4A030.7080004@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59722 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0KRDcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 22:32:41 -0500
In-Reply-To: <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 11/10/2010 05:04 PM, Eddie Wai wrote:
> In the case the chip is undergoing different invasive operation
> which requires a chip reset, all NOPOUT request during this period

For these invasive operations that reset the chip, do we always end up 
having to relogin the connection/session or once the reset is done are 
we able to just go on happily like nothing ever happened?

> must be silently dropped from queuing to the hardware.  This patch
> will respond to libiscsi immediately with sent success.  Since the
> request was not actually sent, the NOPIN wait timeout will get
> triggered and another NOPOUT request will commence through the
> proper channel.
>
> Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
> Acked-by: Anil Veerabhadrappa<anilgv@broadcom.com>
> ---
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index b32baf8..507cd25 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1068,6 +1068,22 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
>   	char *buf;
>   	int data_len;
>
> +	/*
> +	 * Forcefully terminate all in progress connection recovery at the
> +	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
> +	 */
> +	if (bnx2i_adapter_ready(bnx2i_conn->ep->hba)) {
> +		if ((task->hdr->opcode&  ISCSI_OPCODE_MASK) ==
> +		    ISCSI_OP_NOOP_OUT)
> +			/* This is a WA to indicate to libiscsi that the nopout
> +			 * request was sent successfully without actually
> +			 * submitting to the hardware.
> +			 * Just silently drop the nopout request
> +			 */
> +			return 0;
> +		else
> +			return -EIO;
> +	}
>   	bnx2i_iscsi_prep_generic_pdu_bd(bnx2i_conn);
>   	switch (task->hdr->opcode&  ISCSI_OPCODE_MASK) {
>   	case ISCSI_OP_LOGIN:

