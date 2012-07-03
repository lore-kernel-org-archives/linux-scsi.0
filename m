From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2i: fix the bit manipulation when setting the
 error mask
Date: Tue, 3 Jul 2012 09:45:35 -0700
Message-ID: <1341333935.10180.742.camel@dhcp-10-12-137-160.irv.broadcom.com>
References: <4FF2A889.30102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4788 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2GCQpx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jul 2012 12:45:53 -0400
In-Reply-To: <4FF2A889.30102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, mchan@broadcom.com


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
Looks good.  Thanks.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>


