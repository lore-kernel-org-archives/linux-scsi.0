From: James Bottomley <jejbbe@hansenpartnership.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Fri, 25 May 2012 08:45:21 +0100
Message-ID: <1337931921.2932.3.camel@dabdike.int.hansenpartnership.com>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
	 <1337826142.6877.7.camel@dwillia2-mobl>
	 <1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
	 <201205242152.50397.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55660 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab2EYHp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 03:45:26 -0400
In-Reply-To: <201205242152.50397.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dan Williams <dan.j.williams@intel.com>, David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, Arjan van de Ven <arjan@infradead.org>

On Thu, 2012-05-24 at 21:52 +0200, Rafael J. Wysocki wrote:
> On Thursday, May 24, 2012, James Bottomley wrote:
> > On Wed, 2012-05-23 at 19:22 -0700, Dan Williams wrote:
> > > On Wed, 2012-05-23 at 23:56 +0100, James Bottomley wrote:
> > > > On Wed, 2012-05-23 at 14:04 -0400, David Miller wrote:
> > > > > From: Meelis Roos <mroos@linux.ee>
> > > > > Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)
> > > > > 
> > > > > CC:'ing interested parties.
> > > > > 
> > > > > >> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> > > > > >> > them work (including 3 different sparc64 machines with real scsi disks), 
> > > > > >> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> > > > > >> > is recognized but no partitions. 3.3.0 works fine, as did something 
> > > > > >> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> > > > > >> > yet since I have none with remote console at the moment.
> > > > > >> 
> > > > > >> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
> > > > > >> possibility could be the sparc64 NOBOOTMEM conversion that went into
> > > > > >> the merge window.
> > > > > > 
> > > > > > Bisecting leads to this commit:
> > > > > > 
> > > > > > a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
> > > > > > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > > > > > Author: Dan Williams <dan.j.williams@intel.com>
> > > > > > Date:   Thu Mar 22 17:05:11 2012 -0700
> > > > > > 
> > > > > >     [SCSI] sd: limit the scope of the async probe domain
> > > > 
> > > > My theory is that this is an init problem: The assumption in a lot of
> > > > our code is that async_synchronize_full() waits for everything ... even
> > > > the domain specific async schedules, which isn't true.
> > > > 
> > > > The code in init that makes this assumption is wait_for_device_probe().
> > > > There's also a fun async_synchronize_full() in init_post() that assumes
> > > > it can free the init memory after, which would fail badly if anything in
> > > > init used an async domain.
> > > > 
> > > > So either we fix the assumptions or we can't use domain specific async
> > > > schedules.
> > > > 
> > > 
> > > Hm, we already have cases of code not trusting the semantics of
> > > wait_for_device_probe(), especially as it relates to async scanning like
> > > in kernel/power/hibernate.c:
> > > 
> > >                 /*
> > >                  * Some device discovery might still be in progress; we need
> > >                  * to wait for this to finish.
> > >                  */
> > >                 wait_for_device_probe();
> > > 
> > >                 if (resume_wait) {
> > >                         while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
> > >                                 msleep(10);
> > >                         async_synchronize_full();
> > >                 }
> > > 
> > >                 /*
> > >                  * We can't depend on SCSI devices being available after loading
> > >                  * one of their modules until scsi_complete_async_scans() is
> > >                  * called and the resume device usually is a SCSI one.
> > >                  */
> > >                 scsi_complete_async_scans();
> > 
> > This is actually looks wrong: it works if SCSI is built in, but it's a
> > nop if SCSI is a module (the nop function is gated by the else clause of
> > #ifdef CONFIG_SCSI)
> > 
> > Rafael, you added this not via the SCSI tree,
> 
> That's correct, it was committed directly by Linus.
> 
> > is that the intention?
> 
> Pretty much it is.
> 
> The code snippet is slightly out of context and it is a part of the
> software_resume() routine, which is only called when the kernel's built-in
> image reading code checks whether or not the image is present.  It won't
> work anyway if SCSI is not built in.

I don't understand this.

Why would it make a difference whether SCSI is modular at hybernation
resume time?  The reason it makes a difference at boot time is because
there's no initrd to wait for the scans and mount the root if we're not
modular, so the init path has to do it.  However, when resuming an
image, the module is already loaded into that image, so there should be
no difference at all between steps taken in the modular and non-modular
cases.

James


