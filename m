From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] scsi: fix qla2xxx printk format warning
Date: Fri, 23 Sep 2011 17:16:55 -0700
Message-ID: <CAA26F4A.2A923%giridhar.malavali@qlogic.com>
References: <4E7D0AF2.7020401@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:16744
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab1IXARE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2011 20:17:04 -0400
In-Reply-To: <4E7D0AF2.7020401@xenotime.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>, scsi <linux-scsi@vger.kernel.org>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>


>>

>From: Randy Dunlap <rdunlap@xenotime.net>
>
>sector_t can be different types, so cast it to its largest
>possible type.
>
>drivers/scsi/qla2xxx/qla_isr.c:1509:5: warning: format '%lx' expects type
>'long unsigned int', but argument 5 has type 'sector_t'
>
>Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>---
> drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>--- lnx-31-rc7.orig/drivers/scsi/qla2xxx/qla_isr.c
>+++ lnx-31-rc7/drivers/scsi/qla2xxx/qla_isr.c
>@@ -1507,8 +1507,8 @@ qla2x00_handle_dif_error(srb_t *sp, stru
> 
> 			if (k != blocks_done) {
> 				qla_printk(KERN_WARNING, sp->fcport->vha->hw,
>-				    "unexpected tag values tag:lba=%x:%lx)\n",
>-				    e_ref_tag, lba_s);
>+				    "unexpected tag values tag:lba=%x:%llx)\n",
>+				    e_ref_tag, (unsigned long long)lba_s);
> 				return 1;
> 			}
> 
>


