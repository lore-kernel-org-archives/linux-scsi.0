From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Mon, 2 Apr 2007 16:01:30 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBFE@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7757A.D9B7A6A0"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S966061AbXDBW7y@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7757A.D9B7A6A0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]=20
> Sent: Saturday, March 31, 2007 7:22 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
>=20
>=20
> On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> > The internal id/lun mapping of st_vsc and st_vsc1=20
> controllers is different
> > from st_shasta. The original driver code can only  map=20
> first 16 'entities'
> > for st_vsc and st_vsc1 while there are actually 128 available.
> >=20
> > Also the  ST_MAX_LUN_PER_TARGET should be 8, although this can do
> > no harm because inquiries beyond boundary are discarded by firmware.
> >=20
> > The correct internal mapping should be:
> > id:0~15, lun:0~7 (st_shasta)
> > id:0, lun:0~127 (st_yosemite)
> > id:0~127, lun:0 (st_vsc and st_vsc1)
> > To scsi mid layer they are all channel:0~7, id:0~15, lun:0,=20
> with a maximun
> > 'entity' number of 128. The RAID console only interfaces to=20
> scsi mid layer
> > and is always mapped at channel:0, id:16, lun:0.
>=20
> I'm with Christoph here ... if we're going to break the backwards
> compatibility of the mappings (which your code does) then we=20
> could just
> dump channel and use the SCSI id and lun directly.
>=20
> Understanding this code is predicated on this quirky definition in
> stex_queuecommand:
>=20
> 	id =3D cmd->device->id;
> 	lun =3D cmd->device->channel; /* firmware lun issue work around */
>                            ^^^^^^^
>=20
> > @ -645,12 +645,16 @@ stex_queuecommand(struct scsi_cmnd *cmd,
> > =20
> >  	req =3D stex_alloc_req(hba);
> > =20
> > -	if (hba->cardtype =3D=3D st_yosemite) {
> > -		req->lun =3D lun * (ST_MAX_TARGET_NUM - 1) + id;
>=20
> This looks to be correct, it goes up id 0 to ST_MAX_TARGET_NUM -1 then
> takes the next channel.
>=20
> > -		req->target =3D 0;
> > -	} else {
> > +	if (hba->cardtype =3D=3D st_shasta) {
> >  		req->lun =3D lun;
> >  		req->target =3D id;
> > +	} else if (hba->cardtype =3D=3D st_yosemite){
> > +		req->lun =3D id * ST_MAX_LUN_PER_TARGET + lun;
> > +		req->target =3D 0;
> > +	} else {
> > +		/* st_vsc and st_vsc1 */
> > +		req->lun =3D 0;
> > +		req->target =3D id * ST_MAX_LUN_PER_TARGET + lun;
>=20
> These both look to be wrong.  You're taking the channel as the lowest
> common denominator, so your first target is on channel 1 id=20
> 0, your next
> on channel 2, id 0 and so on.  That's really going to mess with the
> ordering (which will be user visible) is that really what you want?
>=20

How about the attached one?=20

------_=_NextPart_001_01C7757A.D9B7A6A0
Content-Type: application/octet-stream;
	name="s1"
Content-Transfer-Encoding: base64
Content-Description: s1
Content-Disposition: attachment;
	filename="s1"

VGhlIGludGVybmFsIGlkL2x1biBtYXBwaW5nIG9mIHN0X3ZzYyBhbmQgc3RfdnNjMSBjb250cm9s
bGVycyBpcyBkaWZmZXJlbnQKZnJvbSBzdF9zaGFzdGEuIFRoZSBvcmlnaW5hbCBkcml2ZXIgY29k
ZSBjYW4gb25seSAgbWFwIGZpcnN0IDE2ICdlbnRpdGllcycKZm9yIHN0X3ZzYyBhbmQgc3RfdnNj
MSB3aGlsZSB0aGVyZSBhcmUgYWN0dWFsbHkgMTI4IGF2YWlsYWJsZS4KClRoZSBjb3JyZWN0IG1h
cHBpbmcgc2hvdWxkIGJlOgpjaGFubmVsOjB+NywgaWQ6MH4xNSAoc3Rfc2hhc3RhLCBjb25zb2xl
IGlzIGNoYW5uZWw6MCwgaWQ6MTYsIGx1bjowKQpjaGFubmVsOjB+MTI3LCBpZDowIChzdF95b3Nl
bWl0ZSwgY29uc29sZSBpcyBjaGFubmVsOjAsIGlkOjEsIGx1bjowKQpjaGFubmVsOjAsIGlkOjB+
MTI3IChzdF92c2MgYW5kIHN0X3ZzYzEsIGNvbnNvbGUgaXMgY2hhbm5lbDowLCBpZDoxMjgsIGx1
bjowKQoKU2lnbmVkLW9mZi1ieTogRWQgTGluIDxlZC5saW5AcHJvbWlzZS5jb20+Ci0tLQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3N0ZXguYyBiL2RyaXZlcnMvc2NzaS9zdGV4LmMKaW5kZXgg
NjliZTEzMi4uMjlhN2I2MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3N0ZXguYworKysgYi9k
cml2ZXJzL3Njc2kvc3RleC5jCkBAIC0xMTMsMTAgKzExMyw2IEBAIGVudW0gewogCVNHX0NGXzY0
QgkJCQk9IDB4NDAsCS8qIDY0IGJpdCBpdGVtICovCiAJU0dfQ0ZfSE9TVAkJCQk9IDB4MjAsCS8q
IHNnIGluIGhvc3QgbWVtb3J5ICovCiAKLQlTVF9NQVhfQVJSQVlfU1VQUE9SVEVECQkJPSAxNiwK
LQlTVF9NQVhfVEFSR0VUX05VTQkJCT0gKFNUX01BWF9BUlJBWV9TVVBQT1JURUQrMSksCi0JU1Rf
TUFYX0xVTl9QRVJfVEFSR0VUCQkJPSAxNiwKLQogCXN0X3NoYXN0YQkJCQk9IDAsCiAJc3RfdnNj
CQkJCQk9IDEsCiAJc3RfdnNjMQkJCQkJPSAyLApAQCAtNjA2LDcgKzYwMiw3IEBAIHN0ZXhfcXVl
dWVjb21tYW5kKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCwKIAkJcmV0dXJuIDA7CiAJfQogCWNhc2Ug
SU5RVUlSWToKLQkJaWYgKGlkICE9IFNUX01BWF9BUlJBWV9TVVBQT1JURUQpCisJCWlmIChpZCAh
PSBob3N0LT5tYXhfaWQgLSAxKQogCQkJYnJlYWs7CiAJCWlmIChsdW4gPT0gMCAmJiAoY21kLT5j
bW5kWzFdICYgSU5RVUlSWV9FVlBEKSA9PSAwKSB7CiAJCQlzdGV4X2RpcmVjdF9jb3B5KGNtZCwg
Y29uc29sZV9pbnFfcGFnZSwKQEAgLTYyNCw3ICs2MjAsNyBAQCBzdGV4X3F1ZXVlY29tbWFuZChz
dHJ1Y3Qgc2NzaV9jbW5kICpjbWQsCiAJCQl2ZXIub2VtID0gU1RfT0VNOwogCQkJdmVyLmJ1aWxk
ID0gU1RfQlVJTERfVkVSOwogCQkJdmVyLnNpZ25hdHVyZVswXSA9IFBBU1NUSFJVX1NJR05BVFVS
RTsKLQkJCXZlci5jb25zb2xlX2lkID0gU1RfTUFYX0FSUkFZX1NVUFBPUlRFRDsKKwkJCXZlci5j
b25zb2xlX2lkID0gaG9zdC0+bWF4X2lkIC0gMTsKIAkJCXZlci5ob3N0X25vID0gaGJhLT5ob3N0
LT5ob3N0X25vOwogCQkJY21kLT5yZXN1bHQgPSBzdGV4X2RpcmVjdF9jb3B5KGNtZCwgJnZlciwg
c2l6ZW9mKHZlcikpID8KIAkJCQlESURfT0sgPDwgMTYgfCBDT01NQU5EX0NPTVBMRVRFIDw8IDgg
OgpAQCAtNjQ1LDEzICs2NDEsOCBAQCBzdGV4X3F1ZXVlY29tbWFuZChzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQsCiAKIAlyZXEgPSBzdGV4X2FsbG9jX3JlcShoYmEpOwogCi0JaWYgKGhiYS0+Y2FyZHR5
cGUgPT0gc3RfeW9zZW1pdGUpIHsKLQkJcmVxLT5sdW4gPSBsdW4gKiAoU1RfTUFYX1RBUkdFVF9O
VU0gLSAxKSArIGlkOwotCQlyZXEtPnRhcmdldCA9IDA7Ci0JfSBlbHNlIHsKLQkJcmVxLT5sdW4g
PSBsdW47Ci0JCXJlcS0+dGFyZ2V0ID0gaWQ7Ci0JfQorCXJlcS0+bHVuID0gbHVuOworCXJlcS0+
dGFyZ2V0ID0gaWQ7CiAKIAkvKiBjZGIgKi8KIAltZW1jcHkocmVxLT5jZGIsIGNtZC0+Y21uZCwg
U1RFWF9DREJfTEVOR1RIKTsKQEAgLTEyMjksMTEgKzEyMjAsMjIgQEAgc3RleF9wcm9iZShzdHJ1
Y3QgcGNpX2RldiAqcGRldiwgY29uc3QgcwogCWhiYS0+Y29weV9idWZmZXIgPSBoYmEtPmRtYV9t
ZW0gKyBNVV9CVUZGRVJfU0laRTsKIAloYmEtPm11X3N0YXR1cyA9IE1VX1NUQVRFX1NUQVJUSU5H
OwogCi0JLyogZmlybXdhcmUgdXNlcyBpZC9sdW4gcGFpciBmb3IgYSBsb2dpY2FsIGRyaXZlLCBi
dXQgbHVuIHdvdWxkIGJlCi0JICAgYWx3YXlzIDAgaWYgQ09ORklHX1NDU0lfTVVMVElfTFVOIG5v
dCBjb25maWd1cmVkLCBzbyB3ZSB1c2UKLQkgICBjaGFubmVsIHRvIG1hcCBsdW4gaGVyZSAqLwot
CWhvc3QtPm1heF9jaGFubmVsID0gU1RfTUFYX0xVTl9QRVJfVEFSR0VUIC0gMTsKLQlob3N0LT5t
YXhfaWQgPSBTVF9NQVhfVEFSR0VUX05VTTsKKwkvKgorCSAqIGZpcm13YXJlIHVzZXMgaWQvbHVu
IHBhaXIgZm9yIGEgbG9naWNhbCBkcml2ZSwgYnV0IGx1biB3b3VsZCBiZQorCSAqIGFsd2F5cyAw
IGlmIENPTkZJR19TQ1NJX01VTFRJX0xVTiBub3QgY29uZmlndXJlZCwgc28gd2UgdXNlCisJICog
Y2hhbm5lbCB0byBtYXAgbHVuIGhlcmUKKwkgKi8KKwlpZiAoaGJhLT5jYXJkdHlwZSA9PSBzdF9z
aGFzdGEpIHsKKwkJaG9zdC0+bWF4X2NoYW5uZWwgPSA3OworCQlob3N0LT5tYXhfaWQgPSAxNiAr
IDE7CisJfSBlbHNlIGlmIChoYmEtPmNhcmR0eXBlID09IHN0X3lvc2VtaXRlKSB7CisJCWhvc3Qt
Pm1heF9jaGFubmVsID0gMTI3OworCQlob3N0LT5tYXhfaWQgPSAxICsgMTsKKwl9IGVsc2Ugewor
CQkvKiBzdF92c2MgYW5kIHN0X3ZzYzEgKi8KKwkJaG9zdC0+bWF4X2NoYW5uZWwgPSAwOworCQlo
b3N0LT5tYXhfaWQgPSAxMjggKyAxOworCX0KIAlob3N0LT5tYXhfbHVuID0gMTsKIAlob3N0LT51
bmlxdWVfaWQgPSBob3N0LT5ob3N0X25vOwogCWhvc3QtPm1heF9jbWRfbGVuID0gU1RFWF9DREJf
TEVOR1RIOwo=

------_=_NextPart_001_01C7757A.D9B7A6A0--
