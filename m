From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix compile warning
Date: Wed, 28 Jun 2017 15:12:08 -0700
Message-ID: <1498687928.2769.20.camel@HansenPartnership.com>
References: <20170628220026.5706-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53100 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751804AbdF1WML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 18:12:11 -0400
In-Reply-To: <20170628220026.5706-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2017-06-28 at 15:00 -0700, Himanshu Madhani wrote:
> Fixes following warning
> 
> drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
> include/uapi/linux/byteorder/big_endian.h:32:26: warning: large
> integer
> implicitly truncated to unsigned type [-Woverflow]
>  #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
> 
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c
> b/drivers/scsi/qla2xxx/qla_nvme.c
> index 1da8fa8f641d..14e25e32e622 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -441,7 +441,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
>  				req->ring_ptr++;
>  			}
>  			cont_pkt = (cont_a64_entry_t *)req-
> >ring_ptr;
> -			cont_pkt->entry_type =
> cpu_to_le32(CONTINUE_A64_TYPE);
> +			cont_pkt->entry_type = CONTINUE_A64_TYPE;
> 

Well the code is definitely buggy, because it will load 0 on a BE
system.  However, are you sure this is the right fix?  I thought the
qlogic engine did groups of 32 bit words, which is why the pre-nvme
code loads this field as:

	*((uint32_t *)(&cont_pkt->entry_type)) = cpu_to_le32(CONTINUE_TYPE);

James
