From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Mon, 05 Oct 2009 15:01:15 +0200
Message-ID: <4AC9EE1B.7030702@suse.de>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> Hello All,
>=20
> Currently, device handlers process path activation in series. This lead=
s
> to a lot of time delay when more than 100 luns are involved. For exampl=
e,
> with lsi rdac 100+ luns take about 12-15 minutes. This was found by Mog=
er
> Babu of LSI.
>=20
> This time delay can be avoided if we can do the activations asynchronou=
sly.
> By making scsi_dh_activate() async, we can give the device handlers an
> oppurtunity to decide on how to send the device activation down the wir=
e
> to make the turn around time faster. They can send the commands
> asynchronously or send them in batches.
>=20
> I brought up this issue on the mailing list
> (http://marc.info/?l=3Dlinux-scsi&m=3D123888063818755&w=3D2) and provid=
ed a
> set of patch a loooong while back http://marc.info/?l=3Dlinux-scsi&m=3D=
124088712709821&w=3D2
>=20
> This set of patches applies cleanly on 2.6.31 and I tested the rdac han=
dler
> on the same.
>=20
> Please review and provide comments.
>=20
> This set of patched adds asynchronous support for rdac, hp, and alua ha=
ndlers.
>=20
Hmm. IIRC we added the synchronous mode by request of LSI/IBM, as the RDA=
C
handler could only support on MODE SELECT command at a time.
If LSI checked this, okay, no objections.

However: The main reason why we're getting flooded with MODE SELECT comma=
nds
is that the RDAC handler switches _each LUN_, not the entire controller.
Seeing that the controller simply cannot cope with the resulting MODE SEL=
ECT
flood wouldn't it be more sensible to switch the entire controller here?

After all, we're trying to address a communication failure between the
HBA and the controller, not a failure between the controller and the LUN.
And by that reasoning switching individual LUNs is quite pointless as we
have to switch _all_ LUNs handled by this controller eventually.

So I would suggest to first issue a MODE SENSE command to check which LUN=
s
are currently handled by this controller and then switch those LUNs in
one go. This way we would be sending quite a few MODE SENSE commands,
but I was under the impression that those do not have any restriction.

I will see to draw up a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
