From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not recognized
Date: Thu, 24 May 2012 21:52:50 +0200
Message-ID: <201205242152.50397.rjw@sisk.pl>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee> <1337826142.6877.7.camel@dwillia2-mobl> <1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejbbe@hansenpartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday, May 24, 2012, James Bottomley wrote:
> On Wed, 2012-05-23 at 19:22 -0700, Dan Williams wrote:
> > On Wed, 2012-05-23 at 23:56 +0100, James Bottomley wrote:
> > > On Wed, 2012-05-23 at 14:04 -0400, David Miller wrote:
> > > > From: Meelis Roos <mroos@linux.ee>
> > > > Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)
> > > > 
> > > > CC:'ing interested parties.
> > > > 
> > > > >> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> > > > >> > them work (including 3 different sparc64 machines with real scsi disks), 
> > > > >> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> > > > >> > is recognized but no partitions. 3.3.0 works fine, as did something 
> > > > >> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> > > > >> > yet since I have none with remote console at the moment.
> > > > >> 
> > > > >> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
> > > > >> possibility could be the sparc64 NOBOOTMEM conversion that went into
> > > > >> the merge window.
> > > > > 
> > > > > Bisecting leads to this commit:
> > > > > 
> > > > > a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
> > > > > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > > > > Author: Dan Williams <dan.j.williams@intel.com>
> > > > > Date:   Thu Mar 22 17:05:11 2012 -0700
> > > > > 
> > > > >     [SCSI] sd: limit the scope of the async probe domain
> > > 
> > > My theory is that this is an init problem: The assumption in a lot of
> > > our code is that async_synchronize_full() waits for everything ... even
> > > the domain specific async schedules, which isn't true.
> > > 
> > > The code in init that makes this assumption is wait_for_device_probe().
> > > There's also a fun async_synchronize_full() in init_post() that assumes
> > > it can free the init memory after, which would fail badly if anything in
> > > init used an async domain.
> > > 
> > > So either we fix the assumptions or we can't use domain specific async
> > > schedules.
> > > 
> > 
> > Hm, we already have cases of code not trusting the semantics of
> > wait_for_device_probe(), especially as it relates to async scanning like
> > in kernel/power/hibernate.c:
> > 
> >                 /*
> >                  * Some device discovery might still be in progress; we need
> >                  * to wait for this to finish.
> >                  */
> >                 wait_for_device_probe();
> > 
> >                 if (resume_wait) {
> >                         while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
> >                                 msleep(10);
> >                         async_synchronize_full();
> >                 }
> > 
> >                 /*
> >                  * We can't depend on SCSI devices being available after loading
> >                  * one of their modules until scsi_complete_async_scans() is
> >                  * called and the resume device usually is a SCSI one.
> >                  */
> >                 scsi_complete_async_scans();
> 
> This is actually looks wrong: it works if SCSI is built in, but it's a
> nop if SCSI is a module (the nop function is gated by the else clause of
> #ifdef CONFIG_SCSI)
> 
> Rafael, you added this not via the SCSI tree,

That's correct, it was committed directly by Linus.

> is that the intention?

Pretty much it is.

The code snippet is slightly out of context and it is a part of the
software_resume() routine, which is only called when the kernel's built-in
image reading code checks whether or not the image is present.  It won't
work anyway if SCSI is not built in.

Thanks,
Rafael
