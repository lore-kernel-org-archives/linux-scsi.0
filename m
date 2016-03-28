From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] scsi: remove orphaned modular code from non-modular
 drivers
Date: Sun, 27 Mar 2016 22:31:47 -0700
Message-ID: <1459143107.13004.21.camel@linux.vnet.ibm.com>
References: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1459098025-26269-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-m68k@vger.kernel.org, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-03-27 at 13:00 -0400, Paul Gortmaker wrote:
> In the ongoing audit/cleanup of non-modular code needlessly using 
> modular infrastructure, the SCSI subsystem fortunately only contains 
> two instances that I detected.  Both are for legacy drivers that 
> predate the git epoch, so cleary there is no demand for converting 
> these drivers to be tristate.
> 
> For anyone new to the underlying goal of this cleanup, we are trying 
> to not use module support for code that isn't buildable as a module
> since:
> 
>  (1) it is easy to accidentally write unused module_exit and remove
> code
>  (2) it can be misleading when reading the source, thinking it can be
>      modular when the Makefile and/or Kconfig prohibit it
>  (3) it requires the include of the module.h header file which in
> turn
>      includes nearly everything else, thus adding to CPP overhead.
>  (4) it gets copied/replicated into other code and spreads like
> weeds.

I don't really buy any of these as being credible issues for the
ancient drivers, so there doesn't appear to be an real benefit to this
conversion; however, besides the danger of touching old stuff, there
are some down sides:

> -MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
> -MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
> -MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRV_VERSION);

These tags are usefully greppable for drivers, regardless of whether
they generate actual kernel side information.

> We explicitly disallow a driver unbind, since that doesn't have a
> sensible use case anyway, and it allows us to drop the ".remove"
> code for non-modular drivers.

That's bogus.  I use bind and unbind a lot for testing built in drivers
but the usual user use case is for resetting the devices.

> Build tested for mips (jazz) and m68k (sun3x) on 4.6-rc1 to ensure no
> silly typos crept in.

For trivial changes, build testing is not really sufficient: a
significant fraction of them break something that isn't spotted by the
reviewers.  For the older drivers, this isn't discovered for months to
years and then someone has to go digging back through all the so called
trivial changes to find which one it was.

James
