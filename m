From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 15:16:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020910131606.GQ2992@marowsky-bree.de>
References: <patmans@us.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909170847.A24352@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020909170847.A24352@eng2.beaverton.ibm.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2002-09-09T17:08:47,
   Patrick Mansfield <patmans@us.ibm.com> said:

Patrick, I am only replying to what I understand. Some of your comments=
 on the
internals of the SCSI layer are beyond me ;-)

> Yes negotiation is at the adapter level, but that does not have to be=
 tied
> to a Scsi_Device. I need to search for Scsi_Device::hostdata usage to
> figure out details, and to figure out if anything is broken in the cu=
rrent
> scsi multi-path code - right now it requires the same adapter drivers=
 be
> used and that certain Scsi_Host parameters are equal if multiple path=
s
> to a Scsi_Device are found.

This seems to be a serious limitation. There are good reasons for wanti=
ng to
use different HBAs for the different paths.

And the Scsi_Device might be quite different. Imagine something like tw=
o
storage boxes which do internal replication among them; yes, you'd only=
 want
to use one of them normal (because the Cache-coherency traffic is going=
 to
kill performance otherwise), but you can failover from one to the other=
 even
if they have different SCSI serials etc.

> of memory that we can waste. And, other devices besides disks can be
> multi-pathed.

That is a good point.

But it would also be true for a generic block device implementation.

> Yes, there could be future multi-path users, or maybe with DASD. If w=
e take
> SCSI and DASD as existing usage, they could be a basis for a block la=
yer
> (or generic) set of multi-path interfaces.

SATA will also support multipathing if the birds were right, so it migh=
t make
sense to keep this in mind, at least for 2.7.

> There is code available for scsi multi-path, this is not a design in =
theory.

Well, there is code available for all the others too ;-)

> IMO, there is demand for scsi multi-path support now, as users move t=
o=20
> large databases requiring higher availabitity. md or volume manager
> for failover is adequate in some of these cases.

The volume manager multi-pathing, at least as done via the LVM1 patch, =
has a
major drawback. It can't easily be stacked with software RAID. It is ve=
ry
awkward to do that right now.

And software RAID on top of multi-pathing is a typical example for a tr=
uely
fault tolerant configuration.

Thats obviously easier with md, and I assume your SCSI code can also do=
 that
nicely.

> Even with generic block layer multi-path support, we still need block
> driver (scsi, ide, etc.) code for multi-path.

Yes. Error handling in particular ;-)

The topology information you mention is also a good candidate for expos=
ure.

> Agreed, but having the block layer be everything is also wrong.

Having the block device handling all block devices seems fairly reasona=
ble to
me.

> My view is that md/volume manager multi-pathing is useful with 2.4.x,=
 scsi
> layer multi-path for 2.5.x, and this (perhaps with DASD) could then e=
volve
> into generic block level (or perhaps integrated with the device model=
)
> multi-pathing support for use in 2.7.x. Do you agree or disagree with=
 this
> approach?

Well, I guess 2.5/2.6 will have all the different multi-path implementa=
tions
mentioned so far (EVMS, LVM2, md, scsi, proprietary) - they all have co=
de and
a userbase... All of them and future implementations can benefit from b=
etter
error handling and general cleanup, so that might be the best to do for=
 now.

I think it is too soon to clean that up and consolidate the m-p approac=
hes,
but I think it really ought to be consolidated in 2.7, and this seems l=
ike a
good time to start planning for that one.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Immortality is an adequate definition of high availability for me.
	--- Gregory F. Pfister
