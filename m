From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Tue, 8 Nov 2005 11:50:48 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C5E49D.B74FD0F2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:20039 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S932344AbVKHTux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 14:50:53 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5E49D.B74FD0F2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


> On Mon, 7 Nov 2005, James Bottomley wrote:
>=20
> > > It's quite possible that usb-storage no longer needs to force the=20
> > > scsi-level to 2.  No one has recently tested what would=20
> happen without=20
> > > it.  Matt probably has the best selection of devices for=20
> testing...
> > >=20
> > > There is one problem we have with devices that report=20
> themselves as SCSI-3=20
> > > or SCSI-4 but hang when they receive a REPORT LUNS=20
> command.  That's easily=20
> > > handled by making usb-storage set the NOREPORTLUN flag. =20
> Maybe that's all=20
> > > we need to do.
> >=20
> > If you could try this out, I'd be grateful.
>=20
> I tried the patch below on several combinations of SCSI=20
> levels and device=20
> types.  It seems to do exactly what we want; for reads I always saw=20
> READ(10) and for MODE SENSE I saw either the 6- or 10-byte=20
> form, depending=20
> on the device type and USB subclass value.
>=20
> The question remains whether pass-thru will now work and=20
> whether the patch
> will mess up some existing non-compliant device that=20
> currently works okay. =20
> The only way to know is by trying it out.  Matt and Timothy,=20
> that's up to
> you.
>=20
> Alan Stern
>=20

I did some initial testing on Alan's patch with a sandisk cruzer
mini thumb drive (level 2), a memorex thumb drive (level 0),
and that cypress part (level 0), and I haven't seen any IO
problems.

After that I made another patch (below and attached because
of wrapping) you can apply after Alan's that disables cdb mangling
on level 0 devices. It was generated against Linus' git repo after
applying Alan's patch.

With both patches applied I can now do passthru cdbs on the
cypress part without issue, and I still don't see any IO issues.

Anyone out there have a better selection of hardware to test with?


Signed-off-by: Timothy Thelin <timothy.thelin@wdc.com>

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -569,9 +569,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
=20
 	/*=20
-	 * If SCSI-2 or lower, store the LUN value in cmnd.
+	 * If SCSI-2 or lower (except SCSI-0), store the LUN value in cmnd.
 	 */
-	if (cmd->device->scsi_level <=3D SCSI_2) {
+	if (cmd->device->scsi_level !=3D SCSI_UNKNOWN &&
+		cmd->device->scsi_level <=3D SCSI_2) {
 		cmd->cmnd[1] =3D (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
 	}

------_=_NextPart_001_01C5E49D.B74FD0F2
Content-Type: application/octet-stream;
	name="scsi-level-0-aware.patch"
Content-Transfer-Encoding: base64
Content-Description: scsi-level-0-aware.patch
Content-Disposition: attachment;
	filename="scsi-level-0-aware.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpLmMgYi9kcml2ZXJzL3Njc2kvc2NzaS5jCi0t
LSBhL2RyaXZlcnMvc2NzaS9zY3NpLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2kuYwpAQCAtNTY5
LDkgKzU2OSwxMCBAQCBpbnQgc2NzaV9kaXNwYXRjaF9jbWQoc3RydWN0IHNjc2lfY21uZCAqCiAJ
fQogCiAJLyogCi0JICogSWYgU0NTSS0yIG9yIGxvd2VyLCBzdG9yZSB0aGUgTFVOIHZhbHVlIGlu
IGNtbmQuCisJICogSWYgU0NTSS0yIG9yIGxvd2VyIChleGNlcHQgU0NTSS0wKSwgc3RvcmUgdGhl
IExVTiB2YWx1ZSBpbiBjbW5kLgogCSAqLwotCWlmIChjbWQtPmRldmljZS0+c2NzaV9sZXZlbCA8
PSBTQ1NJXzIpIHsKKwlpZiAoY21kLT5kZXZpY2UtPnNjc2lfbGV2ZWwgIT0gU0NTSV9VTktOT1dO
ICYmCisJCWNtZC0+ZGV2aWNlLT5zY3NpX2xldmVsIDw9IFNDU0lfMikgewogCQljbWQtPmNtbmRb
MV0gPSAoY21kLT5jbW5kWzFdICYgMHgxZikgfAogCQkJICAgICAgIChjbWQtPmRldmljZS0+bHVu
IDw8IDUgJiAweGUwKTsKIAl9Cg==

------_=_NextPart_001_01C5E49D.B74FD0F2--
