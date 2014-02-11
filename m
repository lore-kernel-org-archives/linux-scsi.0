From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [LSF/MM TOPIC] SMR: Disrupting recording technology meriting a
 new class of storage device
Date: Tue, 11 Feb 2014 09:57:40 -0200
Message-ID: <20140211115739.GD5903@localhost.localdomain>
References: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03>
 <20140207130014.GA5078@localhost.localdomain>
 <52F4E3AC.9060309@suse.de>
 <7DD506441A4CF644AAC1628B9A9C5EBC647EAC9E@wdscexmb06.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7DD506441A4CF644AAC1628B9A9C5EBC647EAC9E@wdscexmb06.sc.wdc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jim Malina <Jim.Malina@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>, Albert Chen <Albert.Chen@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, James Borden <James.Borden@wdc.com>, Curtis Stevens <curtis.stevens@wdc.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Jim,

On Fri, Feb 07, 2014 at 05:32:44PM +0000, Jim Malina wrote:
>=20
>=20
> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> > Sent: Friday, February 07, 2014 5:46 AM
> > To: Carlos Maiolino; Albert Chen
> > Cc: lsf-pc@lists.linux-foundation.org; James Borden; Jim Malina; Cu=
rtis
> > Stevens; linux-ide@vger.kernel.org; linux-fsdevel@vger.kernel.org; =
linux-
> > scsi@vger.kernel.org
> > Subject: Re: [LSF/MM TOPIC] SMR: Disrupting recording technology me=
riting
> > a new class of storage device
> >=20
> > On 02/07/2014 02:00 PM, Carlos Maiolino wrote:
> > > Hi,
> > >
> > > On Sat, Feb 01, 2014 at 02:24:33AM +0000, Albert Chen wrote:
> > >> [LSF/MM TOPIC] SMR: Disrupting recording technology meriting a n=
ew
> > >> class of storage device
> > >>
> > >> Shingle Magnetic Recording is a disruptive technology that deliv=
ers
> > >> the next areal density gain for the HDD industry by partially
> > >> overlapping tracks. Shingling requires physical writes to be
> > >> sequential, and opens the question of how to address this behavi=
or at
> > >> a system level. Two general approaches contemplated are to eithe=
r to
> > >> do the block management in the device or in the host storage
> > >> stack/file system through Zone Block Commands (ZBC).
> > >>
> > >> The use of ZBC to handle SMR block management yields several ben=
efits
> > >> such as:
> > >> - Predictable performance and latency
> > >> - Faster development time
> > >> - Access to application and system level semantic information
> > >> - Scalability / Fewer Drive Resources
> > >> - Higher reliability
> > >>
> > >> Essential to a host managed approach (ZBC) is the openness of Li=
nux
> > >> and its community is a good place for WD to validate and seek
> > >> feedback for our thinking - where in the Linux system stack is t=
he
> > >> best place to add ZBC handling? at the Device Mapper layer?
> > >> or somewhere else in the storage stack? New ideas and comments a=
re
> > >> appreciated.
> > >
> > > If you add ZBC handling into the device-mapper layer, aren't you
> > > supposing that all SMR devices will be managed by device-mapper? =
This
> > doesn't look right IMHO.
> > > These devices should be able to be managed via DM or either direc=
tly
> > > via de storage layer. And any other layers making use of these de=
vices
> > > (like DM for
> > > example) should be able to communicate with them and send ZBC
> > commands
> > > as needed.
> > >
>=20
>  Clarification:  ZBC is an interface protocol.  A new device and comm=
and set.   SMR is a recording technology.  You may have ZBC without SMR=
 or SMR without ZBC.  For examples.  SSD may benefit from ZBC protocol =
to improve performance and reduce wear.   SMR may be 100% device manage=
d and not provide information required of a ZBC device, like write poin=
ters or zone boundaries.
>=20

Thanks for clarification, and, this just enforce my concept that ZBC pr=
otocol
should be integrated in the generic block layer not make it device-mapp=
er
dependent. So, make this available to any device that supports it with =
or
without the help of DM.


> > Precisely. Adding a new device type (and a new ULD to the SCSI
> > midlayer) seems to be the right idea here.
> > Then we could think of how to integrate this into the block layer; =
eg we could
> > identify the zones with partitions, or mirror the zones via block_l=
imits.
> >=20
> > There is actually a good chance that we can tweak btrfs to run unmo=
dified on
> > such a disk; after all, sequential writes are not a big deal for bt=
rfs. The only
> > issue we might have is that we might need to re-allocate blocks to =
free up
> > zones.
> > But some btrfs developers have assured me this shouldn't be too har=
d.
> >=20
> > Personally I don't like the idea of _having_ to use a device-mapper=
 module
> > for these things. What I would like is giving the user a choice; if=
 there are
> > specialized fs around which can deal with such a disk (hello, ltfs =
:-) then fine.
> > If not of course we should be having a device-mapper module to hide=
 the
> > grubby details for unsuspecting filesystems.
> >=20
> > Cheers,
> >=20
> > Hannes
> > --
> > Dr. Hannes Reinecke		      zSeries & Storage
> > hare@suse.de			      +49 911 74053 688
> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>=20
> jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Carlos
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
