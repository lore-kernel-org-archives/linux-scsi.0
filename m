From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2i: fix the bit manipulation when setting the
 error mask
Date: Mon, 10 Dec 2012 19:09:47 -0800
Message-ID: <1355195388.31189.976.camel@dhcp-10-12-137-160.irv.broadcom.com>
References: <4FF2A889.30102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4593 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab2LKDJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2012 22:09:56 -0500
In-Reply-To: <4FF2A889.30102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, mchan@broadcom.com

Hello James,

I'm re-sending this patch fix by Tomas as it hasn't made it upstream yet
in any of the trees.

Thanks,
Eddie

On Tue, 2012-07-03 at 10:08 +0200, Tomas Henzl wrote:
> The intention in bnx2i_send_fw_iscsi_init_msg was to zero out
> only the lower 32bits, but instead the whole mask64 is zeroed.
> This patch fixes it.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index ece47e5..1cbf402 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -1314,7 +1314,7 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
>  		(1ULL << ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_LUN));
>  	if (error_mask1) {
>  		iscsi_init2.error_bit_map[0] = error_mask1;
> -		mask64 &= (u32)(~mask64);
> +		mask64 ^= (u32)(mask64);
>  		mask64 |= error_mask1;
>  	} else
>  		iscsi_init2.error_bit_map[0] = (u32) mask64;
> 
> 
> 


