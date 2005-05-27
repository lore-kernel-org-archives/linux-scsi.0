From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 10:41:39 -0400
Message-ID: <429731A3.1020600@adaptec.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <20050524071320.GW9855@suse.de> <42968AC9.60705@pobox.com> <4296C212.4030703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:60049 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261757AbVE0Olo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 10:41:44 -0400
In-Reply-To: <4296C212.4030703@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On 05/27/05 02:45, Douglas Gilbert wrote:
> In a) the interconnect is SATA. Still it is hard
> to believe that the SAS HBA LLD would belong to
> anything other than the SCSI subsystem (since
> SAS HBAs come with 4 or 8 phys, others of which could
> be in scenario b) and/or connected to SAS disks).
> Hence the initiator_ports/phys/target_ports on and
> seen by that SAS HBA should (also) have SAS transport
> classes.

It should register with the SAS transport class, where
the SAS discover "function" is.  The Discover function
would find out what is out on the domain and "register"
it with the proper "transport" (a more correct way to
put it there is).

For SSP devices that would be a "scsi disk", for
SATA devices that would be a "libata disk" or something
like this.  The LLDD would either get a CDB for SSP,
or taskfile for STP, and pass it along to the hardware.
 
> When a SAS HBA phy is not connected to anything is it
> a member of a SAS transport class or a ATA transport
> class (or both)?

Quite possibly both: SAS transport class, since it is
a super class in meaning that the Discover function
is in there.
 
> In scenario b) the left interconnect is SAS and the
> right interconnect is SATA. The SAS_expander contains
> the STP<->SATA bridging function (and, for sake of
> argument, no SCSI-ATA Translation (SAT) layer).
> Would scenario b) also have a ATA transport
> class? I'll assume it does. To be discovered it also

Yes it would.  As far as the class is concerned it
is a SATA device -- how you get to it (direct or through
an expander) is the LLDD/firmware/Host Adapter concern.

> needs a SAS transport class. Larger enclosures are
> likely to be amplifications of scenario b). The presence
> of the SATA disk in scenario b) will be discovered via
> the SAS SMP (i.e. talking to the SAS_expander) or via
> the SES protocol (i.e. a SCSI Enclosure Services target
> running near the SAS_expander). Either way if there are
> a lot of SATA disks then they are likely to be held
> in their initialization sequence to stop them spinning
> up all at once. SAS transport intervention may be
> required (staggered timers are another possibility).

Yes, spinup-hold states would be managed by the Discover
function, or by the FW on the expander/ses device.

BTW, very nice to mention SES devices.  We'll have to
bring that up more as they'd be very much en vogue
with expanders.

> Now I may be wrong but I think that one of the SAS HBAs
> that I have read about that looks (externally) like
> scenario a) but is actually scenario b). In other words
> the SAS_expander is silicon on the HBA and it is not
> controlled via the PCI bus, but rather by SMP.

I know of such a SAS HA (Host Adapter), and from what it
seems the role of the expander-on-chip is to simulate
a larger number of phys than actually/physically supported
by the HA.  By design, this should be transparent to the
Discover function, and if it is not, I believe the Discover
fn. would do the right thing (i.e. treat is as an expander).

> This suggests to me we would need an ordered sequence of
> transport classes. I really wonder about trying to model
> this level of complexity in sysfs, plus the nightmare of
> keeping state data of (topologically) distant nodes up
> to date. At some point one needs to supply a management

When a SSP talking device is found it is registered
as a "scsi device".  When a STP talking device is
discovered (directly attached or elsewhere) it would
be registered as a "libata device".

> pass through and hand the problem over to the user
> space. The question is, at what point.

I'm not 100% sure about user space.  The Discover function
is pretty straightforward, and simple.  Plus the root/bootable
device could be a SATA device on an expander or even deeper
in the domain.

Thanks,
	Luben
