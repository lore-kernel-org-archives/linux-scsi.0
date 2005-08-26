From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 11:47:22 -0400
Message-ID: <430F398A.30200@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:52134 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965087AbVHZPrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 11:47:25 -0400
In-Reply-To: <20050824091230.GB26447@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 08/24/05 05:12, Christoph Hellwig wrote:
> On Tue, Aug 23, 2005 at 08:02:39PM -0400, Luben Tuikov wrote:
> 
>>In effect FC tells SCSI Core: here is a device I do not know anything
>>about, other than the fact that it is on the fabric and it has
>>a SCSI Target (or Initiator) Port: how you get to is is _my_ business,
>>what is done with or to the device is _your_ business.
>>
>>Then SCSI Core does LU discovery using SPC and SAM on the device
>>using Execute Task.
>>
>>All this _completely_ eliminates the need for HCIL.
>>
>>How the FC layer identifies the device is the FC's layer problem.
>>How SCSI Core identifies the device is SCSI Core's problem.
>>
>>HCIL should have never been available to SCSI Core in the first place,
>>but then again SAM didn't exist back then.
> 
> 
> Ok, Luben, here's the TODO list to get there:
> 
>  (1) add a sdev_printk that takes a struct scsi_device * and prints
>      a sensible name for it.  Later we might or might not make this
>      a transport hook, but for now it gets rid of all these ->id
>      references in LLDDs
>  (2) add a variant of scsi_scan_target that takes a scsi_target * to
>      scan, make the old scsi_scan_target a wrapper around it and
>      introduce similar wrappers for transport-specific target identifiers
>      (e.g. WWNs for FC and SAS)

Hi Christoph,

Yeah this sounds cool.

Do you think it would be beneficial to revisit struct
scsi_target to something like struct scsi_domain_device and
have a kobject in it.  Then the FC/SAS/iSCSI/USB layer upon finding
a domain device, they call a suitable function which allocates them
struct scsi_domain_device, which sets the "release" method for the
kobject embedded.  Then they call SCSI Core to register the domain device.
(All in all, the transport layer may also do kobject_get.)
SCSI Core does kobject_register (thus kobject_get) and starts
doing LU discovery for the device (all through the pointer to struct
scsi_domain_device), and thus the LUs are discovered and struct
scsi_device is created for each one.

Then if the device is unplugged from the domain, the protocol layer
does whatever is necessary, including kobject_put(), and then 
calls the unregister function in SCSI Core to unregister the device.
SCSI Core does whatever it wants and then does kobject_unregister(kobject_put),
and the device is gone.

If OTOH, the unplug event came from userspace, SCSI Core does whatever is
necessary to finish with the device, and then calls the slave_destroy()
function (you get the idea), and then does kobject_put.

Of course the order of those doesn't have to be quite like so.

I've all this implemented for the _current_ architecture of SCSI Core.
The aforementioned was a draft to extend (move) domain devices _and_ LUs
into SCSI Core where they belong, as opposed to the transport layer
doing LU discovery _as_well_as_ domain device discovery and giving only
LUs to SCSI Core.

>  (3) fix a bunch of internal functions that use ->id despite not actually
>      needing it, e.g. starget_for_each_device

Yeah, that sounds cool.  In effect, all you'll have is a struct list_head
of LUs, and that list_head would live in the struct scsi_domain_device.

>  (4) eventually move the traditional scsi_scan_target and other functions
>      that lookup a scsi_target based on ->id into the spi transport class

Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
a pointer to struct scsi_domain_device.  If you want, you an send REPORT
LUNS and other things to it."

The current slave_alloc/slave_configure/slave_destroy implementation is
_very_good_, but slight adjustments would have to be made when the domain
device concept arrives at SCSI Core -- nothing unprecedented.  If anything,
it would be a _simplification_, and I'm actually in _favour_ of keeping the
current infra in place as well -- no big, sudden changes.

>  (5) add an SPI-specific taget ID accessor and move all drivers over to it

Yeah, sure.  The transport layer would actually assign these ids as part of
it doing domain discovery.  They would be some opaque string in some opaque
format, "WWN", "H:C:I:L", "X,Y", etc, which the transport layer tacked to the
domain device before announcing that it exists to SCSI Core.  SCSI Core
can feel free to add more and other various labels if it wishes to do so.
Imagine a struct list_head of labels.

	Luben
P.S. Transport class != Transport layer.

SCSI Core >> transport layer (FC/SAS/USB/iSCSI) >> LLDD/transport >> interconnect >> physical world.

Anything to the left is completely unaware of internals of anything to the
right.  Access to the right is provided as dictated by some spec.


