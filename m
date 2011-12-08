From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: mpt2sas regression: can not add disk...
Date: Thu, 8 Dec 2011 19:00:11 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3@inbmail01.lsi.com>
References: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
	<A6888A6805518E4EA4AF7072A28264A604726F2824@inbmail02.lsi.com>
	<CAE9FiQWY-jhtbCmdfBY1zg_d0nreTHbkVe3CmaPQMgojDAtLaw@mail.gmail.com>
 <CAE9FiQXbu-O2exdhjziWCdiWWGNb8q7_RoECeKC5K80DEOobbw@mail.gmail.com>
 <B2FD678A64EAAD45B089B123FDFC3ED70D912FF83D@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3inbmail01lsic_"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70D912FF83D@inbmail01.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--_002_B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3inbmail01lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Yinghai,

Please try attached patch. This must be on top of latest upstream code.=20
When we have introduced fast load, scan of devices are happening from threa=
d context.

But currently we have not removed " _scsih_probe_devices(ioc);" call from a=
ctual probe and it is getting called from multiple places.
As a result, we end-up into this issue.

Please try the attached patch and provide your feedback. Based upon your re=
sult, we will post this patch to upstream.

Thanks, Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Desai, Kashyap
> Sent: Wednesday, December 07, 2011 11:25 PM
> To: Yinghai Lu; Nandigama, Nagalakshmi; James Bottomley; Rafael J.
> Wysocki
> Cc: linux-scsi-owner@vger.kernel.org; James Bottomley; linux-
> scsi@vger.kernel.org; Linux Kernel Mailing List
> Subject: RE: mpt2sas regression: can not add disk...
>=20
> Yinghai,
>=20
> I am trying to reproduce this issue locally and get back to you with my
> findings.
>=20
>=20
> Thanks, Kashyap
>=20
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Yinghai Lu
> > Sent: Wednesday, December 07, 2011 5:45 AM
> > To: Nandigama, Nagalakshmi; James Bottomley; Rafael J. Wysocki
> > Cc: linux-scsi-owner@vger.kernel.org; James Bottomley; linux-
> > scsi@vger.kernel.org; Linux Kernel Mailing List
> > Subject: Re: mpt2sas regression: can not add disk...
> >
> > On Mon, Nov 28, 2011 at 12:00 PM, Yinghai Lu <yinghai@kernel.org>
> wrote:
> > > On Sun, Nov 27, 2011 at 10:09 PM, Nandigama, Nagalakshmi
> > > <Nagalakshmi.Nandigama@lsi.com> wrote:
> > >> Yinghai Lu,
> > >>
> > >> Please set the driver logging level to 0x421F8 (echo 0x421F8 >
> > >> /sys/module/mpt2sas/parameters/logging_level) and the scsi logging
> > >> level to 0x180000F1 (echo 0x180000F1 >
> > >> /proc/sys/dev/scsi/logging_level) and recreate the issue and
> provide
> > >> the var/log/message
> > >>
> > >
> > > please check two print out...
> >
> > James,
> >
> > one week passed, did not hear anything from the original author.
> >
> > Can you  revert offending commit ?
> >
> > it is 921cd8024b908f8f49f772c8d3a02381b4db2ed2
> > and several related commits after that.
> >
> > please check attached reverting patch that i used locally.
> >
> > Thanks
> >
> > Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3inbmail01lsic_
Content-Type: application/octet-stream; name="fast_load_probe_devices.patch"
Content-Description: fast_load_probe_devices.patch
Content-Disposition: attachment; filename="fast_load_probe_devices.patch";
	size=392; creation-date="Thu, 08 Dec 2011 18:56:58 GMT";
	modification-date="Fri, 09 Dec 2011 03:01:12 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYyBiL2RyaXZl
cnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYwppbmRleCA0ZTA0MWY2Li43NDM2NmNiIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX3Njc2loLmMKKysrIGIvZHJp
dmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19zY3NpaC5jCkBAIC04MDE1LDcgKzgwMTUsNiBAQCBf
c2NzaWhfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNl
X2lkICppZCkKIAl9IGVsc2UKIAkJaW9jLT5oaWRlX2RyaXZlcyA9IDA7CiAKLQlfc2NzaWhfcHJv
YmVfZGV2aWNlcyhpb2MpOwogCXJldHVybiAwOwogCiAgb3V0X2F0dGFjaF9mYWlsOgo=

--_002_B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3inbmail01lsic_--
