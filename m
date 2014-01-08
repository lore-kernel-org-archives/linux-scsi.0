From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
Date: Wed, 8 Jan 2014 12:16:02 +0000
Message-ID: <811b9a4297a34f07be49db76acb84afb@DM2PR07MB400.namprd07.prod.outlook.com>
References: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:40070
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755441AbaAHMcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 07:32:04 -0500
In-Reply-To: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "simon.puels@gmail.com" <simon.puels@gmail.com>, "jkosina@suse.cz" <jkosina@suse.cz>
Cc: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>-----Original Message-----
>From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
>Sent: Friday, December 20, 2013 8:38 AM
>To: DL-MegaRAID Linux; JBottomley@parallels.com; simon.puels@gmail.com;
>jkosina@suse.cz
>Cc: yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
>Subject: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
>
>From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
>A spin lock is taken here so we should use GFP_ATOMIC.
>
>Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>---
> drivers/scsi/megaraid/megaraid_mm.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_mm.c
>b/drivers/scsi/megaraid/megaraid_mm.c
>index a706927..99fa5d3 100644
>--- a/drivers/scsi/megaraid/megaraid_mm.c
>+++ b/drivers/scsi/megaraid/megaraid_mm.c
>@@ -570,7 +570,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t
>*kioc, int xferlen)
>
> 	kioc->pool_index	= right_pool;
> 	kioc->free_buf		= 1;
>-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
>+	kioc->buf_vaddr		= pci_pool_alloc(pool->handle,
>GFP_ATOMIC,
> 							&kioc->buf_paddr);
> 	spin_unlock_irqrestore(&pool->lock, flags);
>
>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit

