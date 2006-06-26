From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 10:24:45 +0200
Message-ID: <1151310285.3185.16.camel@laptopd505.fenrus.org>
References: <20060511143352.GI12272@parisc-linux.org>
	<20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060625224631.GD1608@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>
List-Id: linux-scsi@vger.kernel.org


> > How about this solution which works for me with debian on a huge 6 bus
> > scsi machine:  it introduces a new module scsi_wait_scan.ko whose sole
> > job is to wait for the scans to complete in its init function.  The
> > initrd/initramfs sequence now becomes:
> > 
> > insert all other modules
> > modprobe scsi_wait_scan
> 
> I think that's a great idea.  I wonder about making it always fail
> initialisation, since then it can be loaded multiple times without being
> unloaded.  I think Arjan was suggesting some proc or sysfs file that
> would cause scsi_complete_async_scans() to be called, but I couldn't
> figure out where a good place to put such a file would be. 

Hi,

just to expand on this: The reason I am suggesting this is to allow the
initrd to have a way to wait for device scans before (re)trying to mount
the root filesystem. One of the interesting challenges today for the
initrd with USB is that you don't know when the devices are visible; now
I know this won't fix USB, but it at least introduces a proper method
for ensuring that for scsi; I suppose we should make it a generic thing
with a notifier chain so that all subsystems that want to can get a
callback and finalize their initialization... I can imagine fiber
channel cards wanting to use this to wait for LIP etc...

One question is if this should get a timeout parameter or if that should
be left up to the devices...

(and I think the initrd needs to try to find the rootfs at least once
without waiting, or there should be 2 levels of expensiveness to the
wait, so that it'll first try the asynchronous way, but that it can do
the more expensive wait rather than causing an outright panic() as
happens today when the rootfs cannot be found..)

Greetings,
    Arjan van de Ven


Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
