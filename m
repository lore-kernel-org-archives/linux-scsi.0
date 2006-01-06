From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Sat, 07 Jan 2006 09:44:55 +1000
Message-ID: <43BF00F7.9010104@torque.net>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com> <43BDDCAE.7000506@torque.net> <43BE6506.7090901@torque.net> <20060106194652.GB6404@aracnet.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060106194652.GB6404@aracnet.com>
Sender: linux-ide-owner@vger.kernel.org
To: Patrick Mansfield <patman@aracnet.com>
Cc: Chris Paulson-Ellis <chris@edesix.com>, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Fri, Jan 06, 2006 at 10:39:34PM +1000, Douglas Gilbert wrote:
> 
<snip>
> 
> I was trying to figure out if we are guranteed will have unique values
> across all ATA devices with Doug's patch. I am not familiar with ATA and
> IDENTIFY DEVICE.

http://www.t13.org/docs2005/D1699r2a-ATA8-ACS.pdf
is the most recent draft of the ATA-8 command set.

> For page 0x83, Doug's change above gives us:
> 
> 	ATA + 40 bytes of model/product (must have white space) + serial number
> 
> Under "10.3.4.2.3 Logical unit name derived from the model number and
> serial number" the spec says:
> 
> 	NOTE 9 The logical unit name using the T10 vendor identification
> 	format is not guaranteed to be worldwide unique, since ATA/ATAPI-7
> 	only requires the combination of the MODEL NUMBER field and SERIAL
> 	NUMBER field to be unique for a given manufacturer but defines no
> 	manufacturer identification field.
> 
> I don't know why they have this given the above. So it is possible (though
> unlikely?) that model numbers will overlap, and so scsi_id values too?

Unlikely but two vendors could use the same model and
serial numbers.

> If we put had an actual vendor in the sdev->vendor, we could use page 0x83
> type 0 with no name collisions (if that vendor + model actually gives us
> unique serial numbers). 
> 
> Why does the SAT translation spec have the vendor identification of ATA???

I guess because there is no requirement for a manufacturer
of (s)ATA disks to have a registered t10 vendor id ...
IEEE wants money for OUI registrations, t10 probably wants
money for a t10 vendor id, t13 probably wants money etc ...
BTW As I have mentioned in the past, linux probably should
have a OUI registration (paid by whom??).

> The "logical unit name derived from the world wide name" looks nicer, but I
> assume not all vendors support that.

Yes and not yet, until it becomes mandatory, if ever. ATA8-ACS shows
a naa-5 (8 byte, 4 word) identifier
starting at word 108 in the IDENTIFY DEVICE response. I like the
ACS wording: "Words 111-108 shall contain the optional value of the
world wide name"! The "shall" implies it is mandatory but obviously
the "optional" doesn't. Perhaps it was written by a lawyer :-)

We probably could and should add the naa-5 designator in VPD
page 0x83, perhaps dependent on whether there is a 0x5 in
word 108 bits 15-12 . For example, an old-ish Seagate ST380013AS
sata disks has zero in those 8 bytes.

Perhaps others could check their sata disks and report back if
any have a real naa-5 wwn starting at word 108. ["sg_inq -AH"
on a (s/p)ATA disk will dump the IDENTIFY DEVICE response in hex.]

Doug Gilbert

