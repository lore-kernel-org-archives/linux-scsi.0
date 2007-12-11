From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
	directory) (fwd)
Date: Tue, 11 Dec 2007 22:53:03 +0100
Message-ID: <1197409983.6288.9.camel@localhost.localdomain>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz>
	 <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de>
	 <20071130021226T.tomof@acm.org>  <20071130103450.GC7697@1und1.de>
	 <1197384034.19679.13.camel@n2o.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2069 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXLKVwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 16:52:53 -0500
In-Reply-To: <1197384034.19679.13.camel@n2o.xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anders Henke <anders.henke@1und1.de>
Cc: FUJITA Tomonori <tomof@acm.org>, matthew@wil.cx, jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, miquels@cistron.nl

On Tue, 2007-12-11 at 15:40 +0100, Miquel van Smoorenburg wrote:
> I just noticed the same bug when I tried to update a 2.6.18 server to
> 2.6.23.9 .. also tried 2.6.24-rc4. The symptom I'm seeing is that init
> segfaults, or can't be found .. anyway, driver/fs errors.
> 
> In the kernel config, under "processor type and features", I disabled
> "64GB memory" support (changed to 4GB) and I also disabled "64 bit
> Memory and IO resources" and the problem went away. Do you by any chance
> happen to have those features enabled ?
> 
> The dpt_i2o driver is not 64-bit clean, it happens to work with
> PAE/64-bit dma in earlier kernels but that might be by chance. Perhaps
> the different initialization ordering exposes the problem.
> 
> I got the 64-bit dpt_i2o driver from Adaptec some time ago, and I have
> added 64-bit support to the 2.6.23.1 dpt_i2o driver based on that
> driver. I intended to submit it for 2.6.25 or so ... if I have some time
> later today or tomorrow I'll try that next to see if that makes a
> difference.

I just recompiled 2.6.23.9 with the 64 bit patch for dpt_i2o and now it
boots just fine.

The patch is here:
http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch

It's not the final version - it needs a few cleanups before it can be
submitted, but perhaps you can test if it also works for you.

Mike.

