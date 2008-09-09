From: David Miller <davem@davemloft.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 09 Sep 2008 14:30:12 -0700 (PDT)
Message-ID: <20080909.143012.193704777.davem@davemloft.net>
References: <20080909020102.GE25591@plap4-2.qlogic.org>
	<20080909143932.GA27117@orion.carnet.hr>
	<20080909150023.GA31517@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080909150023.GA31517@orion.carnet.hr>
Sender: sparclinux-owner@vger.kernel.org
To: joy@entuzijast.net
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Josip Rodin <joy@entuzijast.net>
Date: Tue, 9 Sep 2008 17:00:24 +0200

> On Tue, Sep 09, 2008 at 04:39:32PM +0200, Josip Rodin wrote:
> > On Mon, Sep 08, 2008 at 07:01:02PM -0700, Andrew Vasquez wrote:
> > > Yes, please do try the patch.  Could you also enable error-logging via
> > > the ql2xextended_error_logging module parameter:
> > > 
> > > 	# insmod qla2xxx.ko ql2xextended_error_logging=1
> > > 
> > > And send the kernel messages...  Thanks, AV
> > 
> > OK, I reset the bisection, pulled the latest updates, applied your patch
> > and added the parameter to the initrd module setup, rebuilt after an
> > all-enter make oldconfig. After rebooting, it failed to load the firmware:
> > 
> > scsi(0): **** Load RISC code **** 
> > firmware: requesting ql2200_fw.bin 
> > scsi(0): Failed to load firmware image (ql2200_fw.bin). 
> > qla2xxx 0001:00:04.0: Firmware image unavailable. 
> > 
> > After the reboot, I noticed that I managed to screw up my silo setup,
> > so it's going to take me a wee bit more to recover. :<
> 
> OK, so it wasn't as hosed as I thought, and I got back in action :)
> So I tried disabling CONFIG_FIRMWARE_IN_KERNEL, but upon the next boot
> it couldn't load the firmware image either.

I assume you use this device for your too filesystem, in which case
the firmware has to be in the initial ramdisk.

The qla2xxx firmware isn't in the firmware tree, it's in the filesystem
somewhere, and that gets put into the initial ramdisk you build for
a particular kernel image.  For this reason CONFIG_FIRMWARE_IN_KERNEL
won't make any difference.

This takes a bit of skill to get working properly, I hate it too.  It's
really unfriendly to users and even kernel developers.  These drivers
should "just work" when you build them, rather than require contortions
such as this.

