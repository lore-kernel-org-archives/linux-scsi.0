Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FEDC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F11F64E4A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhBKX6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:58:01 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52878 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBKX6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:58:00 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 2425B2991B;
        Thu, 11 Feb 2021 18:57:16 -0500 (EST)
Date:   Fri, 12 Feb 2021 10:57:17 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
cc:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: Re: [PATCH for-next 00/32] spin lock usage optimization for SCSI
 drivers
In-Reply-To: <417fa728c3ff4418ac87e0d409b5a084@hisilicon.com>
Message-ID: <c7fdb63e-e84-c685-35f4-6b6f663cd867@telegraphics.com.au>
References: <417fa728c3ff4418ac87e0d409b5a084@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 11 Feb 2021, Song Bao Hua (Barry Song) wrote:

> 
> Actually in m68k, I also saw its IRQ entry disabled interrupts by
> ' move	#0x2700,%sr		/* disable intrs */'
> 
> arch/m68k/include/asm/entry.h:
> 
> .macro SAVE_ALL_SYS
> 	move	#0x2700,%sr		/* disable intrs */
> 	btst	#5,%sp@(2)		/* from user? */
> 	bnes	6f			/* no, skip */
> 	movel	%sp,sw_usp		/* save user sp */
> ...
> 
> .macro SAVE_ALL_INT
> 	SAVE_ALL_SYS
> 	moveq	#-1,%d0			/* not system call entry */
> 	movel	%d0,%sp@(PT_OFF_ORIG_D0)
> .endm
> 
> arch/m68k/kernel/entry.S:
> 
> /* This is the main interrupt handler for autovector interrupts */
> 
> ENTRY(auto_inthandler)
> 	SAVE_ALL_INT
> 	GET_CURRENT(%d0)
> 					|  put exception # in d0
> 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
> 	subw	#VEC_SPUR,%d0
> 
> 	movel	%sp,%sp@-
> 	movel	%d0,%sp@-		|  put vector # on stack
> auto_irqhandler_fixup = . + 2
> 	jsr	do_IRQ			|  process the IRQ
> 	addql	#8,%sp			|  pop parameters off stack
> 	jra	ret_from_exception
> 
> So my question is that " move	#0x2700,%sr" is actually disabling
> all interrupts? And is m68k actually running irq handlers
> with interrupts disabled?
> 

When sonic_interrupt() executes, the IPL is 2 or 3 (since either IRQ may 
be involved). That is, SR & 0x700 is 0x200 or 0x300. The level 3 interrupt 
may interrupt execution of the level 2 handler so an irq lock is used to 
avoid re-entrance.

This patch,

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d17d1b4f2585..041354647bad 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -355,6 +355,8 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
         */
        spin_lock_irqsave(&lp->lock, flags);
 
+       printk_once(KERN_INFO "%s: %08lx\n", __func__, flags);
+
        status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
        if (!status) {
                spin_unlock_irqrestore(&lp->lock, flags);

produces this output,

[    3.800000] sonic_interrupt: 00002300

I ran that code in QEMU, but experience shows that Apple hardware works 
exactly the same. Please do confirm this for yourself, if you still think 
the code and comments in sonic_interrupt are wrong.

> Best Regards
> Barry
> 
