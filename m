From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 09:20:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020910092015.B7765@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909170847.A24352@eng2.beaverton.ibm.com> <10209100055.ZM65139@classic.engr.sgi.com> <20020910130427.GP2992@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020910130427.GP2992@marowsky-bree.de>; from lmb@suse.de on Tue, Sep 10, 2002 at 03:04:27PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 10, 2002 at 03:04:27PM +0200, Lars Marowsky-Bree wrote:
> On 2002-09-10T00:55:58,
>    Jeremy Higdon <jeremy@classic.engr.sgi.com> said:
>=20
> > Is there any plan to do something for hardware RAIDs in which two d=
ifferent
> > RAID controllers can get to the same logical unit, but you pay a pe=
rformance
> > penalty when you access the lun via both controllers?=20
>=20
> This is implemented in the md multipath patch in 2.4; it distinguishe=
s between
> "active" and "spare" paths.
>=20
> The LVM1 patch also does this by having priorities for each path and =
only
> going to the next priority group if all paths in the current one have=
 failed,
> which IMHO is slightly over the top but there is always someone who m=
ight need
> it ;-)
>=20
> This functionality is a generic requirement IMHO.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>

The current scsi multi-path has a default setting of "last path used", =
so
that it will always work with such controllers (I refer to such control=
lers
as fail-over devices). You have to modify the config, or boot with a
flag to get round-robin path selection. Right now, all paths will start
out on the same adapter (initiator), this is bad if you have more than
a few arrays attached to and adapter.

I was planning on implementing something similiar to what you describe=20
for LVM1, with path weighting. Yes, it seems a bit heavy, but if there
are only two weights or priorities, it looks just like your active/spar=
e
code, and is a bit more flexible.

=46iguring out what ports are active or spare is not easy, and varies
from array to array. This is a (another) good canidate for user level
probing/configuration. I will likely probably hard-code device
personallity information into the kernel for now, and hopefully in
2.7 we could move SCSI to user level probe/scan/configure.

I have heard that some arrays at one time had a small penalty for
switching controllers, and it was best to use the last path used,
but it was still OK to use both at the same time (cache warmth). I
was trying to think of a way to allow good load balancing in such
cases, but didn't come up with a good solution. Like use last path
used selection, and once a path is too "busy" move to another path
- but then all devices might switch at the same time; some hearistics
or timing could probably be added to avoid such problems. The code
allows for path selection in a single function, so it should not
be difficult to add more complex path selection.

I have also put NUMA path selection into the latest code. I've tested
it with 2.5.32, and a bunch of NUMA + NUMAQ patches on IBM/Sequent
NUMAQ systems.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
