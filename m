From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] SMR: Disrupting recording technology meriting
 a new class of storage device
Date: Fri, 07 Feb 2014 14:46:20 +0100
Message-ID: <52F4E3AC.9060309@suse.de>
References: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03> <20140207130014.GA5078@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbaBGNqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 08:46:21 -0500
In-Reply-To: <20140207130014.GA5078@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>, Albert Chen <Albert.Chen@wdc.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, James Borden <James.Borden@wdc.com>, Jim Malina <Jim.Malina@wdc.com>, Curtis Stevens <curtis.stevens@wdc.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/07/2014 02:00 PM, Carlos Maiolino wrote:
> Hi,
>=20
> On Sat, Feb 01, 2014 at 02:24:33AM +0000, Albert Chen wrote:
>> [LSF/MM TOPIC] SMR: Disrupting recording technology meriting
>> a new class of storage device
>>
>> Shingle Magnetic Recording is a disruptive technology that
>> delivers the next areal density gain for the HDD industry by
>> partially overlapping tracks. Shingling requires physical
>> writes to be sequential, and opens the question of how to
>> address this behavior at a system level. Two general approaches
>> contemplated are to either to do the block management in
>> the device or in the host storage stack/file system through
>> Zone Block Commands (ZBC).
>>
>> The use of ZBC to handle SMR block management yields several
>> benefits such as:
>> - Predictable performance and latency
>> - Faster development time
>> - Access to application and system level semantic information
>> - Scalability / Fewer Drive Resources
>> - Higher reliability
>>
>> Essential to a host managed approach (ZBC) is the openness of
>> Linux and its community is a good place for WD to validate and
>> seek feedback for our thinking - where in the Linux system stack
>> is the best place to add ZBC handling? at the Device Mapper layer?
>> or somewhere else in the storage stack? New ideas and comments
>> are appreciated.
>=20
> If you add ZBC handling into the device-mapper layer, aren't you supp=
osing that
> all SMR devices will be managed by device-mapper? This doesn't look r=
ight IMHO.
> These devices should be able to be managed via DM or either directly =
via de
> storage layer. And any other layers making use of these devices (like=
 DM for
> example) should be able to communicate with them and send ZBC command=
s as
> needed.
>=20
Precisely. Adding a new device type (and a new ULD to the SCSI
midlayer) seems to be the right idea here.
Then we could think of how to integrate this into the block layer;
eg we could identify the zones with partitions,
or mirror the zones via block_limits.

There is actually a good chance that we can tweak btrfs to
run unmodified on such a disk; after all, sequential writes
are not a big deal for btrfs. The only issue we might have
is that we might need to re-allocate blocks to free up zones.
But some btrfs developers have assured me this shouldn't be too hard.

Personally I don't like the idea of _having_ to use a device-mapper
module for these things. What I would like is giving the user a
choice; if there are specialized fs around which can deal with such
a disk (hello, ltfs :-) then fine. If not of course we should be
having a device-mapper module to hide the grubby details for
unsuspecting filesystems.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
