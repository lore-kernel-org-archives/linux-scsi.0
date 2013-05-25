From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 09:21:10 +0200
Message-ID: <51A06666.1060207@redhat.com>
References: <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com> <1369456502.5008.5.camel@dabdike> <20130525052744.GA25186@infradead.org> <51A062B5.8040601@redhat.com> <20130525071118.GA11912@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38149 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3EYHVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 May 2013 03:21:21 -0400
In-Reply-To: <20130525071118.GA11912@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Il 25/05/2013 09:11, Christoph Hellwig ha scritto:
> > Linus wanted to keep that for CAP_SYS_RAWIO.  We found two uses of SG_IO
> > on partitions: zfs-fuse used SYNCHRONIZE CACHE; some proprietary driver
> > used TEST UNIT READY.
> > 
> > Really, the solution is to make the bitmaps configurable in userspace.
> > It is no less secure than unpriv_sgio.  Then the kernel can be
> > configured at build-time to have either an MMC bitmap and a basic
> > whitelist of a dozen commands.  We can even avoid working around those
> > few conflicting opcodes; if you're paranoid you can just configure your
> > kernel right.
> 
> Keep it simple.  Allowing SG_IO for CAP_SYS_RAWIO probably is fine,
> allowing it for permissions only clearly isn't. All the per-command
> filetering is just complete bullshit and the kind of bloat that
> eventually will make Linux unmaintainable.

What I'm proposing is:

- by default, only allow INQUIRY / REPORT LUNS / TEST UNIT READY.  Keep
the old whitelist available for backwards-compatibility, configurable at
build-time.

- let CAP_SYS_ADMIN users set a different per-device whitelist.

Paolo
