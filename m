From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Build error: `.exit.text' referenced in section `.rodata'
Date: Mon, 12 May 2008 09:01:44 -0500
Message-ID: <1210600904.3078.1.camel@localhost.localdomain>
References: <20080511151902.GA733@ds20.borg.net>
	 <1210524907.3199.6.camel@localhost.localdomain>
	 <20080511192007.GB724@ds20.borg.net> <20080512115255.GA16942@ds20.borg.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20080512115255.GA16942@ds20.borg.net>
Sender: linux-alpha-owner@vger.kernel.org
To: dl8bcu@dl8bcu.de
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-05-12 at 11:52 +0000, Thorsten Kranzkowski wrote:
> On Sun, May 11, 2008 at 07:20:07PM +0000, Thorsten Kranzkowski wrote:
> > On Sun, May 11, 2008 at 11:55:07AM -0500, James Bottomley wrote:
> > > On Sun, 2008-05-11 at 15:19 +0000, Thorsten Kranzkowski wrote:
> > > > Hello,
> > > > 
> > > > compiling 2.6.26-rc1 (latest git) on an Alpha DS20 (ev6, everything built in,
> > > > gcc version 4.1.2) fails with the following link errors:
> > > > 
> > > >   CC      init/version.o
> > > >   LD      init/built-in.o
> > > >   LD      .tmp_vmlinux1
> > > > `.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> > 
> > 
> > > > I believe the problem is static int sd_major(int major_idx) being inlined
> > > > into exit_sd(). IIUC the switch statement therein uses sort of a jump table.
> > > > And the targets of this jump table can not be resolved because the section
> > > > they live in is just discarded.
> > > 
> > > It's plausible.  However, my version of gcc (4.2.3) doesn't actually
> > > inline this; even when I force it to by adding the inline directive to
> > > sd_major() I don't see the problem.  I suspect it might be a gcc bug
> > > 
> > > > 
> > > > applying this patch makes the problem go away:
> > > > 
> > > > Signed-off-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
> > > > 
> > > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > > index 01cefbb..adf79ad 100644
> > > > --- a/drivers/scsi/sd.c
> > > > +++ b/drivers/scsi/sd.c
> > > > @@ -1913,7 +1913,7 @@ err_out:
> > > >   *
> > > >   *	Note: this function unregisters this driver from the scsi mid-level.
> > > >   **/
> > > > -static void __exit exit_sd(void)
> > > > +static void exit_sd(void)
> > > 
> > > We can't really do this because that text genuinely does belong in the
> > > exit section.  We might be able to fix it up on the alpha by just adding
> > > the noinline directive to sd_major.  Does this work?
> > 
> > Yes, this works as well! Thanks!
> > 
> >    text    data     bss     dec     hex filename
> > 6834571  504320  397508 7736399  760c4f vmlinux
> > 6835267  504056  397508 7736831  760dff vmlinux-exit_sd-not-in-.exit.text
> > 
> > Tested-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
> >  
> > Now I'll update gcc and try again with gcc 4.2.3.
> 
> 
> With gcc 4.2.3 I get the same error. The noinline patch fixes it again.
> 
>    text    data     bss     dec     hex filename
> 6721720  624416  397508 7743644  76289c vmlinux-gcc-4.2.3

OK, so it's an unfixed bug in gcc, and it looks to be specific to the
alpha backend.  if the compiler chooses to inline a function, it has to
respect the sectional (and other constraints) of the outer function.
Can someone file a bug report with the relevant compiler people?

Jmaes


