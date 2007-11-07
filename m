From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Wed, 7 Nov 2007 10:58:12 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au> <jefxzqqeha.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C82157.000DDF72"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:52084 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbXKGP6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 10:58:14 -0500
Content-class: urn:content-classes:message
In-Reply-To: <jefxzqqeha.fsf@sykes.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C82157.000DDF72
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Good point, thanks. The intent of the management applications
utilization of this AIF report is to observe the LSB of the value of
integer value in BlinkLED. The actions of the cpu_to_le32 actually
breaks this and reports the wrong content in swapped architectures.

This attached follow-up patch is against current scsi-misc-2.6 *after*
the application of the 'don't assign cpu_to_le32(constant) to u8' patch
submitted by Stephen Rothwell which has already been taken by the -mm
tree. Inspection of other areas of the aacraid driver came up blank for
similar style bugs.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/commsup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -ru a/drivers/scsi/aacraid/commsup.c
b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c    2007-11-07 10:35:16.603727464
-0500
+++ b/drivers/scsi/aacraid/commsup.c    2007-11-07 10:37:50.540311107
-0500
@@ -1342,7 +1342,7 @@
                        aif->data[0] =3D AifEnExpEvent;
                        aif->data[1] =3D AifExeFirmwarePanic;
                        aif->data[2] =3D AifHighPriority;
-                       aif->data[3] =3D cpu_to_le32(BlinkLED);
+                       aif->data[3] =3D BlinkLED;

                        /*
                         * Put the FIB onto the

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Andreas Schwab [mailto:schwab@suse.de]=20
> Sent: Thursday, November 01, 2007 9:31 AM
> To: Stephen Rothwell
> Cc: AACRAID; linux-scsi@vger.kernel.org; LKML
> Subject: Re: [PATCHv2] aacraid: don't assign=20
> cpu_to_le32(constant) to u8
>=20
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> > diff --git a/drivers/scsi/aacraid/commsup.c=20
> b/drivers/scsi/aacraid/commsup.c
> > index 240a0bb..3c2dbc0 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
> >  			aif =3D (struct aac_aifcmd *)hw_fib->data;
> >  			aif->command =3D cpu_to_le32(AifCmdEventNotify);
> >  		 	aif->seqnum =3D cpu_to_le32(0xFFFFFFFF);
> > -		 	aif->data[0] =3D cpu_to_le32(AifEnExpEvent);
> > -			aif->data[1] =3D cpu_to_le32(AifExeFirmwarePanic);
> > -		 	aif->data[2] =3D cpu_to_le32(AifHighPriority);
> > +			aif->data[0] =3D AifEnExpEvent;
> > +			aif->data[1] =3D AifExeFirmwarePanic;
> > +			aif->data[2] =3D AifHighPriority;
> >  			aif->data[3] =3D cpu_to_le32(BlinkLED);
>=20
> What about the last line?
>=20
> Andreas.

------_=_NextPart_001_01C82157.000DDF72
Content-Type: application/octet-stream;
	name="aacraid_BlinkLED.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_BlinkLED.patch
Content-Disposition: attachment;
	filename="aacraid_BlinkLED.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMgYi9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9jb21tc3VwLmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jCTIw
MDctMTEtMDcgMTA6MzU6MTYuNjAzNzI3NDY0IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL2NvbW1zdXAuYwkyMDA3LTExLTA3IDEwOjM3OjUwLjU0MDMxMTEwNyAtMDUwMApAQCAtMTM0
Miw3ICsxMzQyLDcgQEAKIAkJCWFpZi0+ZGF0YVswXSA9IEFpZkVuRXhwRXZlbnQ7CiAJCQlhaWYt
PmRhdGFbMV0gPSBBaWZFeGVGaXJtd2FyZVBhbmljOwogCQkJYWlmLT5kYXRhWzJdID0gQWlmSGln
aFByaW9yaXR5OwotCQkJYWlmLT5kYXRhWzNdID0gY3B1X3RvX2xlMzIoQmxpbmtMRUQpOworCQkJ
YWlmLT5kYXRhWzNdID0gQmxpbmtMRUQ7CiAKIAkJCS8qCiAJCQkgKiBQdXQgdGhlIEZJQiBvbnRv
IHRoZQo=

------_=_NextPart_001_01C82157.000DDF72--
