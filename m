From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 09:18:28 -0600
Message-ID: <20060626151828.GH1608@parisc-linux.org>
References: <447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
	<20060626144442.GA13319@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20060626144442.GA13319@one-eyed-alien.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 26, 2006 at 07:44:42AM -0700, Matthew Dharm wrote:
> On Mon, Jun 26, 2006 at 06:40:01AM -0600, Matthew Wilcox wrote:
> > I'm not 100% sure what the problem is with USB.  If it's that we may not
> > have discovered all the USB devices currently plugged in, then I think
> > we need to change the way USB works to use one Scsi_Host for all USB
> > storage devices, and then make each device either its own target or its
> > own channel (probably the former; the latter is less well-tested code).
> 
> There are a couple of things which make this difficult for USB.
> 
> First, some (many?) USB devices need to be left alone for several seconds
> after attachment in order to allow them to initialize to the point where
> they are usable.

That's OK.  Once we know they're there, we can reserve their place
and delay until they're ready to go.

> Second, depending on how many hubs are between the host and target, the
> time-to-discover the device is highly variable.

Can, or does, USB keep track of hub discovery, and hence know whether
or not it's completed USB discovery?

> Third, once discovered the device may still take a long time to be "ready".
> Think of this as a slow spin-up time.  This is different from my first
> point in that the device can actually accept commands, but all commands
> will fail with some sort of not-ready type error.

That's OK too.

> As for using one Scsi_Host... there are several usb-storage devices which
> attach to an entire SCSI bus (not just a single target), so can't make each
> device it's own target.

Oh.  My fault for reading the comment rather than the code.

                /* reject if target != 0 or if LUN is higher than
                 * the maximum known LUN
                 */
                else if (us->srb->device->id && 
                                !(us->flags & US_FL_SCM_MULT_TARG)) {

Do these devices stick to occupying only target IDs from 0-7?  If not,
you may wish to increase ->max_id for those devices.  I think it'd be worth
exporting scsi_scan_channel() from the midlayer (and rearranging it to have
__scsi_scan_channel() as was done with __scsi_scan_target) for USB's benefit.

> Also, at the time this was all written it wasn't
> possible to dynamically remove (with any stability) individual targets or
> channels.  Perhaps that has changed?

It's definitely possible to remove individual targets dynamically now;
Fibre Channel has sorted that out (and will complain loudly if it breaks).
The scsi core doesn't really have a channel object; channel is just an integer 
that describes a path to a target.  So I think there should be no problem in
converting USB to have one host and many channels.

Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
