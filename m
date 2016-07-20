From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v5 4/8] char: rpmb: provide a user space interface
Date: Wed, 20 Jul 2016 10:21:31 -0400
Message-ID: <20160720142131.GS21225@windriver.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
 <CAP=VYLqZCXjWUohLZ35Kvrx7B8z7cbEFzDt4ugaUosrh2ca+8g@mail.gmail.com>
 <5B8DA87D05A7694D9FA63FD143655C1B54297958@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B54297958@hasmsx108.ger.corp.intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[RE: [PATCH v5 4/8] char: rpmb: provide a user space interface] On 20/07/2016 (Wed 09:02) Winkler, Tomas wrote:

> > 
> > On Mon, Jul 18, 2016 at 4:27 PM, Tomas Winkler <tomas.winkler@intel.com>
> > wrote:
> > > The user space API is achieved via two synchronous IOCTL.
> > > Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is
> > performed
> > > by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD
> > where
> > > the whole RPMB sequence including RESULT_READ is supplied by the caller.
> > > The latter is intended for  easier adjusting  of the  applications
> > > that use MMC_IOC_MULTI_CMD ioctl.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > ---
> > 
> > [...]
> > 
> > > diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
> > > index c5e6e909efce..6794be9fcc5e 100644
> > > --- a/drivers/char/rpmb/Kconfig
> > > +++ b/drivers/char/rpmb/Kconfig
> > > @@ -6,3 +6,10 @@ config RPMB
> > >           access RPMB partition.
> > >
> > >           If unsure, select N.
> > > +
> > > +config RPMB_INTF_DEV
> > > +       bool "RPMB character device interface /dev/rpmbN"
> > 
> > A bool Kconfig should ideally....
> > 
> > > +       depends on RPMB
> > > +       help
> > > +         Say yes here if you want to access RPMB from user space
> > > +         via character device interface /dev/rpmb%d
> > > diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
> > > index 812b3ed264c0..b5dc087b1299 100644
> > > --- a/drivers/char/rpmb/Makefile
> > > +++ b/drivers/char/rpmb/Makefile
> > > @@ -1,4 +1,5 @@
> > >  obj-$(CONFIG_RPMB) += rpmb.o
> > >  rpmb-objs += core.o
> > > +rpmb-$(CONFIG_RPMB_INTF_DEV) += cdev.o
> 
> This is not a builtin, this is an optional part of the module 

Object files that are not stand-alone, but linked into a larger object
to create a module generally still don't need module.h if they
themselves specifically aren't registering the module or similar.

The exception is a module that doesn't actively do anything but export
symbols (i.e. a library).  Then somewhere in it there needs to be a
MODULE_LICENSE so that the kernel can audit GPL and taint etc.

> 
> > > +#include <linux/module.h>
> > 
> > ....not use module.h or any MODULE_ macros from within it.
> 
> Can be dropped in this case as no macros are used, 
> but the pattern Kconfig bool -> no include module.h  you are following has false positive cases.

Yes, of course there are other things, like the exception table
searches, and symbol_get / symbol_put, macros defining string
lengths, etc... and I try to watch for those via inspection and
build testing. 

However the majority bool->module.h are there for two reasons:

1) in core code we had to use module.h in the past when export.h
   did not exist.

2) in driver code that largely capitalizes on copying from other
   drivers without explicitly considering modularity.

...and it is worth our while to clean both up, I think.

If you can think of specific false positives that I might not be
aware of, please don't hesitate to call them out.

Thanks,
Paul.
--

> 
> Thanks
> Tomas
> 
