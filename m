From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5] Update Documentation/pci.txt
Date: Fri, 15 Dec 2006 09:02:07 -0800
Message-ID: <20061215170207.GB15058@kroah.com>
References: <456404E2.1060102@jp.fujitsu.com>
	<20061122182804.GE378@colo.lackof.org>
	<45663EE8.1080708@jp.fujitsu.com>
	<20061124051217.GB8202@colo.lackof.org>
	<20061206072651.GG17199@kroah.com>
	<20061210072508.GA12272@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20061210072508.GA12272@colo.lackof.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@osdl.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 10, 2006 at 12:25:08AM -0700, Grant Grundler wrote:
> On Tue, Dec 05, 2006 at 11:26:51PM -0800, Greg KH wrote:
> ...
> > I do have a few minor comments:
> ...
> > > Please mark the initialization and cleanup functions where appropriate
> > > (the corresponding macros are defined in <linux/init.h>):
> > > 
> > > 	__init		Initialization code. Thrown away after the driver
> > > 			initializes.
> > > 	__exit		Exit code. Ignored for non-modular drivers.
> > > 	__devinit	Device initialization code. Identical to __init if
> > > 			the kernel is not compiled with CONFIG_HOTPLUG, normal
> > > 			function otherwise.
> > > 	__devexit	The same for __exit.
> > > 
> > > Tips on marks:
> > > 	o The module_init()/module_exit() functions (and all initialization
> > >           functions called _only_ from these) should be marked __init/__exit.
> > > 
> > > 	o The struct pci_driver shouldn't be marked with any of these tags.
> > > 
> > > 	o The ID table array should be marked __devinitdata.
> > > 
> > > 	o The probe() and remove() functions (and all initialization
> > > 	  functions called only from these) should be marked __devinit
> > > 	  and __devexit.
> > > 
> > > 	o If the driver is not a hotplug driver then use only
> > > 	  __init/__exit and __initdata/__exitdata.
> > 
> > No, don't say this, pci drivers are not "hotplug drivers",
> 
> agreed - removed that bullet item.
> 
> > and since CONFIG_HOTPLUG is really hard to turn off these days,
> > don't confuse people with the devinit stuff.  Everyone gets it wrong...
> 
> While revisiting this bit, I started thinking:
> 
> o While I agree HOTPLUG is essential to desktop and server,
>   I don't think that's true for "embedded" (e.g. routers/switches).

Agreed, but those are the minority.

> o drivers should use __dev* exactly because HOTPLUG is defined.

Yes, they should, but it is confusing as to why it should be used in
places, and __init used in others.  If you want to detail the
differences better than the current documentation does, please do.

> o Why does everyone get __dev* wrong? Bad API? Missing or bad Documentation?
>   [ This is not a free-for-all...I'd like a clear answer from
>   Greg what would help driver writers get this right. ]

They get it wrong usually because they cut-and-paste from others.  The
proof of that is seeing __dev* used in pci hotplug controller drivers :)

I'm just pointing out that about every 6 months I have to sweep the tree
and fix up all of the improper usages.  And the whole __devexit_p()
stuff is usually used incorrectly too.

> o Prefer a seperate patch to clean this up?
>   Take what I have for now and sort out the __devinit handling in
>   another round?
> 
> o Note what I have is essentially the original text - just reformatted
>   to be a bit more readable.
> 
> o Hrm...what did greg mean with "it"? All of the markers?
>   Or just the __dev* markers?

Just the __dev stuff.

> > > 	o Pointers to functions marked as __devexit must be created using
> > > 	  __devexit_p(function_name).  That will generate the function
> > > 	  name or NULL if the __devexit function will be discarded.
> > 
> > I really recommend just not using any of these for almost all PCI
> > drivers, as the space savings just really isn't there...
> 
> It's a bit too late for that, no?
> And even if it's more of a PITA than it's worth, we do save something:
> 
> # hppa64-linux-gnu-readelf -S vmlinux
> ...
>  [26] .init.text        PROGBITS         0000000040598000  00457000
>       0000000000022280  0000000000000000  AX       0     0     8
>  [27] .init.data        PROGBITS         00000000405ba280  00479280
>       000000000001faf0  0000000000000000  WA       0     0     8
> ...
> 
> Reality is they are used in _alot_ of drivers.
> I checked 2.6.19:
> grundler <514>find -name \*.c | xargs fgrep __devinit | wc
>    2723   16812  235863
> 
> I'd prefer to keep the short references here if you
> don't mind too much. At least until you can get some
> consensus that __init and __exit should go away
> or get replaced by easier-to-get-right markers.

Ok, just describe them properly and we should be fine.

thanks,

greg k-h

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
