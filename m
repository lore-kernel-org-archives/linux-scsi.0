From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Wed, 30 Sep 2009 22:19:09 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474E78371@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>
List-Id: linux-scsi@vger.kernel.org

Hi Chandra,
   Thanks for the patches. Patches applied cleanly on 2.6.31. I am testin=
g the patches right now. Will post the with test results tomorrow.
These are my initial comments.=20
1. Patches do not apply on 2.6.32. You may have to regenerate it on 2.6.3=
2.
2. Also, I noticed few errors and warnings while running checkpatch.pl sc=
ript. =20
3. Subject line for patch 3 and 4 may need to be modified. It still says =
"rdac handler". It should be hp and alua handler.=20

Thanks..

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Chandra Seetharaman
> Sent: Tuesday, September 29, 2009 9:08 PM
> To: linux-scsi@vger.kernel.org
> Cc: dm-devel@redhat.com; Moger, Babu; michaelc@cs.wisc.edu;
> Benoit_Arthur@emc.com; Eddie.Williams@steeleye.com;
> berthiaume_wayne@emc.com; Chandra Seetharaman
> Subject: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
>=20
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
> This time delay can be avoided if we can do the activations
> asynchronously.
> By making scsi_dh_activate() async, we can give the device handlers an
> oppurtunity to decide on how to send the device activation down the wir=
e
> to make the turn around time faster. They can send the commands
> asynchronously or send them in batches.
>=20
> I brought up this issue on the mailing list
> (http://marc.info/?l=3Dlinux-scsi&m=3D123888063818755&w=3D2) and provid=
ed a
> set of patch a loooong while back http://marc.info/?l=3Dlinux-
> scsi&m=3D124088712709821&w=3D2
>=20
> This set of patches applies cleanly on 2.6.31 and I tested the rdac
> handler
> on the same.
>=20
> Please review and provide comments.
>=20
> This set of patched adds asynchronous support for rdac, hp, and alua
> handlers.
>=20
> Didn't add async support for EMC for the following reasons:
>  - EMC handler is getting more hairy (when I try to move to _nowait())
>  - I do not know if EMC has a special command to group them (like rdac)=
.
>  - I wasn't sure if EMC has this problem in the first place ( I did not
> get
>    any response from EMC).
> Can somebody from EMC comment, please.
>=20
> Thanks & Regards,
>=20
> chandra
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
