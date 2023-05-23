Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D922C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 10:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjEWKwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 06:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbjEWKvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 06:51:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C789D11A;
        Tue, 23 May 2023 03:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nNaVVitAdqly0HV3wb/gpkjgT9kyHVKcL6u7vHyYEuo=; b=tZQeapXf+QATFM4a3PS6TRgoJc
        1ccZwWLDnCgasphlRBVwQmZ5rT6ozj6PDDHRoqmMnKjszz4T9KdpIhwmDxHrUnDq7KA4s0OxTd4xq
        j/XftNjnyOMUEf+itf+JgO2LT8lUEbLQqWYcEdyyZK0L+orUCxF+qQvytMUMi0mrqrv4K+/3J6xOO
        VBDpnlw2klvY+vydmdriPp4tPQXLng08oq/Q0us4pRTPh23lKlfUzjUmmsT/FAWy4V5DpdDM0FWZt
        Rj7dPHCUywOtL8+88Gj/QUIdzlT5PW7kE0bLAqBvhzzRZd1tQZ//Ii4nVnGBtl9COM82vPKbHic6f
        rtqgDUdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49026)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1q1PcK-0000ET-9C; Tue, 23 May 2023 11:51:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1q1PcH-0000Vk-28; Tue, 23 May 2023 11:51:45 +0100
Date:   Tue, 23 May 2023 11:51:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Helge Deller <deller@gmx.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: spinlock recursion in aio_complete()
Message-ID: <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
 <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 12:24:04PM +0200, Helge Deller wrote:
> On 5/22/23 23:22, Helge Deller wrote:
> > > > It hangs in fs/aio.c:1128, function aio_complete(), in this call:
> > > >      spin_lock_irqsave(&ctx->completion_lock, flags);
> > > 
> > > All code that I found and that obtains ctx->completion_lock disables IRQs.
> > > It is not clear to me how this spinlock can be locked recursively? Is it
> > > sure that the "spinlock recursion" report is correct?
> > 
> > Yes, it seems correct.
> > [...]
> 
> Bart, thanks to your suggestions I was able to narrow down the problem!
> 
> I got LOCKDEP working on parisc, which then reports:
> 	raw_local_irq_restore() called with IRQs enabled
> for the spin_unlock_irqrestore() in function aio_complete(), which shouldn't happen.
> 
> Finally, I found that parisc's flush_dcache_page() re-enables the IRQs
> which leads to the spinlock hang in aio_complete().
> 
> So, this is NOT a bug in aio or scsci, but we need fix in the the arch code.

You can find some of the background to this at:

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=16ceff2d5dc9f0347ab5a08abff3f4647c2fee04

which introduced flush_dcache_mmap_lock(). It looks like Hugh had
questions over whether this should be _irqsave() rather than _irq()
but I guess at the time all callers had interrupts enabled, and
it's only recently that someone came up with the idea of calling
flush_dcache_page() with interrupts disabled.

Adding another arg to flush_dcache_mmap_lock() to save the flags
may be doable, but requires a patch that touches not only architectures
that have a private implementation, but also various code in mm/.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
