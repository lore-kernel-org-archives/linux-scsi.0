From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: SAS Management Protocol (SMP)
Date: Fri, 26 Aug 2005 12:31:11 -0400
Message-ID: <430F43CF.5090002@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com> <20050818175648.GA27894@lst.de> <4304EA09.1070804@adaptec.com> <20050819141552.GC12485@lst.de> <430C6C2B.4070904@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27315 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965090AbVHZQbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 12:31:15 -0400
In-Reply-To: <430C6C2B.4070904@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 08/24/05 08:46, Douglas Gilbert wrote:
> 
> Well lets talk about SMP for a bit. We need to
> be able to use this protocol for more complex SAS
> topologies. Monitoring simple SAS topologies with
> only one expander would be aided by using SMP.
> 
> Like many management protocols, SMP violates
> the layer abstraction. Since it sits besides SSP and STP
> above the transport and port layers in the SAS stack then
> it should be addressing via a (source) port. However its
> functions talk about phys (not ports).

Ok.

> Further, if you look at SDI (revision 0), specifically
> the SDI_SMP_PASSTHROUGH in section 5.12, then it assumes
> the SAS initiator (rather than an initiator port) can
> have an ioctl sent to it. On the source side it routes
> via either:
>   - a phy  ***
>   - a port
>   - or both (a phy within a port)
> 
> It also specifies the connection rate (SAS defines both
> 1.5 and 3 Gbps), and the destination SAS address (most likely
> of an expander). That ioctl reports two levels of errors:
>   - associated with the connection (e.g. ...REJECT_BAD_DESTINATION)
>   - from the SMP target (e.g. UNKNOWN_SMP_FUNCTION)
> 
> and if all is well the response may include information
> from the target (i.e. an expander). The ioctl also handles
> security issues which a pretty simple in the case of
> SMP [codes 0x0->0x7f fetch information while codes
> 0x80->0xff potentially change the state of an expander].
> 
> BTW There is nothing to stop a SAS HBA implementing a
> SMP target, which would allow multiple initiators to
> at least see one another. Also SMP has its own pass-through
> to read and write a GPIO register.
> 
> Now the SDI_SMP_PASSTHROUGH ioctl seems pretty ugly,

Yeah. ;-)

> passing over 2048 bytes of data for each function
> (1024 bytes for the request and 1024 bytes for the
> response). That 1024 matches the maximum payload
> for SMP requests and responses (SAS 1.1 transport
> layer). Given the definition of SAS-1.1 SMP functions
> that is massive overkill. However zoning in SAS-2

Exactly my sentiments.

> will increase the number and size of some SMP functions
> (and responses). [One company has already announced
> silicon for SAS-2 zoning.]

I love zoning.

> So the SDI_SMP_PASSTHROUGH is closely tuned to the
> capabilities of SMP rather than a generic pass through.
> 
> A SAS expander must have an SMP target whose SAS address
> is by definition the expander's address. Expanders are
> not SCSI devices (but may include or be associated with
> SCSI devices (e.g. a SES device)). Expanders directly
> connected to a SAS HBA are visible as "attached" (SAS)
> devices; other expanders are discovered via SMP.
> 
> My theme here is if we are not going to use the
> SDI_SMP_PASSTHROUGH at least we should understand what
> it does.

Forget about it.  I think we should go by the spec -- it's
our best friend.

> It is different from the SG_IO ioctl (for
> example) which opens a connection to an end device

True.

> that has a device node and a sysfs identity (in
> /sys/class/scsi_device). The SG_IO ioctl has no
> addressing information in its metadata. Rather
> SDI_SMP_PASSTHROUGH talks via a SAS HBA which has a
> sysfs identity (and could have a device node) and
> passes addressing information (source port/phy and
> SMP target address) through as part of its metadata.
> That way expanders (especially those not directly
> attached to the HBA) do not have to appear in sysfs.
> 
> I'll stop here to see who objects to the above.

Nothing to object to.

Question:  What if the transport layer (please see my
email to Christoph I just sent), "shows" you a picture
of how the physical world "looks" and then you just
"point" at an object with SMP port and voila you can
send an SMP request and receive and SMP response back.

No frame limitations, nothing.

Note, SCSI Core, abiding by SPC/SAM, will be completely
unaware of SMP devices.  That is, SMP is a _protocol_
"thing", we should keep it at the protocol layer.

	Luben


 
> *** SMP seems to consume one connection along a path for
>     the duration of its request-response cycle. So when
>     an SMP initiator sends a request through a source phy then
>     nothing else will happen on that phy until the response
>     (or some error) arrives back on that phy.
> 
> Doug Gilbert
> 
> 

