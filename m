From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] scsi: stex: Remove use of struct timeval
Date: Tue, 05 May 2015 11:09:16 +0200
Message-ID: <2715896.J41QkhJNzb@wuerfel>
References: <20150505070427.GA4979@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51605 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbbEEJJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 05:09:33 -0400
In-Reply-To: <20150505070427.GA4979@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org

On Tuesday 05 May 2015 12:34:27 Tina Ruchandani wrote:
> Function stex_gettime uses 'struct timeval' whose tv_sec value
> will overflow on 32-bit systems in year 2038 and beyond. This patch
> replaces the use of struct timeval and do_gettimeofday with
> ktime_get_real_seconds, which returns a 64-bit seconds value.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> --

[+ y2038 list]

Looks good,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> Changes in v3:
> - Remove stex_gettime altogether, directly assign the timestamp.
> Changes in v2:
> - Change subject line to indicate that the patch is restricted to stex driver.
> ---
> ---
>  drivers/scsi/stex.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 98a62bc..84e196e 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -25,6 +25,7 @@
>  #include <linux/types.h>
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
> +#include <linux/ktime.h>
>  #include <asm/io.h>
>  #include <asm/irq.h>
>  #include <asm/byteorder.h>
> @@ -362,14 +363,6 @@ MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(ST_DRIVER_VERSION);
>  
> -static void stex_gettime(__le64 *time)
> -{
> -	struct timeval tv;
> -
> -	do_gettimeofday(&tv);
> -	*time = cpu_to_le64(tv.tv_sec);
> -}
> -
>  static struct status_msg *stex_get_status(struct st_hba *hba)
>  {
>  	struct status_msg *status = hba->status_buffer + hba->status_tail;
> @@ -1002,7 +995,7 @@ static int stex_common_handshake(struct st_hba *hba)
>  	h->req_cnt = cpu_to_le16(hba->rq_count+1);
>  	h->status_sz = cpu_to_le16(sizeof(struct status_msg));
>  	h->status_cnt = cpu_to_le16(hba->sts_count+1);
> -	stex_gettime(&h->hosttime);
> +	h->hosttime = cpu_to_le64(ktime_get_real_seconds());
>  	h->partner_type = HMU_PARTNER_TYPE;
>  	if (hba->extra_offset) {
>  		h->extra_offset = cpu_to_le32(hba->extra_offset);
> @@ -1076,7 +1069,7 @@ static int stex_ss_handshake(struct st_hba *hba)
>  	h->req_cnt = cpu_to_le16(hba->rq_count+1);
>  	h->status_sz = cpu_to_le16(sizeof(struct status_msg));
>  	h->status_cnt = cpu_to_le16(hba->sts_count+1);
> -	stex_gettime(&h->hosttime);
> +	h->hosttime = cpu_to_le64(ktime_get_real_seconds());
>  	h->partner_type = HMU_PARTNER_TYPE;
>  	h->extra_offset = h->extra_size = 0;
>  	scratch_size = (hba->sts_count+1)*sizeof(u32);
> 

