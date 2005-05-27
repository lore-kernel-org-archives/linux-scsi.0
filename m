From: James.Smart@Emulex.Com
Subject: RE: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 13:45:26 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC3D@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-ide-owner@vger.kernel.org
To: luben_tuikov@adaptec.com, dougg@torque.net
Cc: jgarzik@pobox.com, axboe@suse.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Folks,

This discussion brings up some latent questions...

The transport can be a subsystem on it's own and is perhaps independent
of SCSI altogether. In this case, SCSI just happens to be a personality
of something on the transport. This is at odds with the current design
in which the transport is something under SCSI and inherently bound to
the SCSI "host".

I understand how we got to where we are, but shouldn't we consider making
some transports independent subsystems ? If the only protocol that
can be run on the transport is SCSI (ex: SPI), then the transport can be
under SCSI. However, if the transport can support multiple protocols (FC
can support SCSI, IP, (or ATA)), shouldn't it be structured more like an io
bus like pci ? 

It does mess up the device tree heirarchy. In general, you want the
device tree to continue along the transport specific elements until it finds
remote endpoints (things your going to use), at which point the protocol
specific elements can kick in. For example (using FC):
 /sys/devices/<pci>/fcport5/rport-5:3/target10:0:0/10:0:0:0  - the SCSI lun

What this leaves out is : where is the scsi host device ? It doesn't make
sense to insert it in-between the transport elements. It likely just becomes
a leaf entity. Continuing the example:
 /sys/devices/<pci>/fcport5/host10  - scsi host interface
 /sys/devices/<pci>/fcport5/eth3    - network interface

Food for thought...   Is this out in left field ?

-- james s


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Luben Tuikov
> Sent: Friday, May 27, 2005 10:42 AM
> To: dougg@torque.net
> Cc: Jeff Garzik; Jens Axboe; James Bottomley; SCSI Mailing List;
> linux-ide@vger.kernel.org
> Subject: Re: libata, SCSI and storage drivers
> 
> 
> On 05/27/05 02:45, Douglas Gilbert wrote:
> > In a) the interconnect is SATA. Still it is hard
> > to believe that the SAS HBA LLD would belong to
> > anything other than the SCSI subsystem (since
> > SAS HBAs come with 4 or 8 phys, others of which could
> > be in scenario b) and/or connected to SAS disks).
> > Hence the initiator_ports/phys/target_ports on and
> > seen by that SAS HBA should (also) have SAS transport
> > classes.
> 
> It should register with the SAS transport class, where
> the SAS discover "function" is.  The Discover function
> would find out what is out on the domain and "register"
> it with the proper "transport" (a more correct way to
> put it there is).
> 
> For SSP devices that would be a "scsi disk", for
> SATA devices that would be a "libata disk" or something
> like this.  The LLDD would either get a CDB for SSP,
> or taskfile for STP, and pass it along to the hardware.
>  
> > When a SAS HBA phy is not connected to anything is it
> > a member of a SAS transport class or a ATA transport
> > class (or both)?
> 
> Quite possibly both: SAS transport class, since it is
> a super class in meaning that the Discover function
> is in there.
>  
> > In scenario b) the left interconnect is SAS and the
> > right interconnect is SATA. The SAS_expander contains
> > the STP<->SATA bridging function (and, for sake of
> > argument, no SCSI-ATA Translation (SAT) layer).
> > Would scenario b) also have a ATA transport
> > class? I'll assume it does. To be discovered it also
> 
> Yes it would.  As far as the class is concerned it
> is a SATA device -- how you get to it (direct or through
> an expander) is the LLDD/firmware/Host Adapter concern.
> 
> > needs a SAS transport class. Larger enclosures are
> > likely to be amplifications of scenario b). The presence
> > of the SATA disk in scenario b) will be discovered via
> > the SAS SMP (i.e. talking to the SAS_expander) or via
> > the SES protocol (i.e. a SCSI Enclosure Services target
> > running near the SAS_expander). Either way if there are
> > a lot of SATA disks then they are likely to be held
> > in their initialization sequence to stop them spinning
> > up all at once. SAS transport intervention may be
> > required (staggered timers are another possibility).
> 
> Yes, spinup-hold states would be managed by the Discover
> function, or by the FW on the expander/ses device.
> 
> BTW, very nice to mention SES devices.  We'll have to
> bring that up more as they'd be very much en vogue
> with expanders.
> 
> > Now I may be wrong but I think that one of the SAS HBAs
> > that I have read about that looks (externally) like
> > scenario a) but is actually scenario b). In other words
> > the SAS_expander is silicon on the HBA and it is not
> > controlled via the PCI bus, but rather by SMP.
> 
> I know of such a SAS HA (Host Adapter), and from what it
> seems the role of the expander-on-chip is to simulate
> a larger number of phys than actually/physically supported
> by the HA.  By design, this should be transparent to the
> Discover function, and if it is not, I believe the Discover
> fn. would do the right thing (i.e. treat is as an expander).
> 
> > This suggests to me we would need an ordered sequence of
> > transport classes. I really wonder about trying to model
> > this level of complexity in sysfs, plus the nightmare of
> > keeping state data of (topologically) distant nodes up
> > to date. At some point one needs to supply a management
> 
> When a SSP talking device is found it is registered
> as a "scsi device".  When a STP talking device is
> discovered (directly attached or elsewhere) it would
> be registered as a "libata device".
> 
> > pass through and hand the problem over to the user
> > space. The question is, at what point.
> 
> I'm not 100% sure about user space.  The Discover function
> is pretty straightforward, and simple.  Plus the root/bootable
> device could be a SATA device on an expander or even deeper
> in the domain.
> 
> Thanks,
> 	Luben
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
