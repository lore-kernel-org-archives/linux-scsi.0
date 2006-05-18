From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] dpt_i2o underflow check (Was: dpt_i2o and sd driver's problem)
Date: Thu, 18 May 2006 08:55:35 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02727AF7@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C67A7A.5A9908AD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:5328 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751358AbWERMzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 08:55:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C67A7A.5A9908AD
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I agree, the math for underflow is flawed for block sizes other than
512, but I leave it up to the community to decide if there is some
history behind this decision. This math has remained this way 'forever'.

The dpt_i2o driver should have the following (and more accurately
enclosed) patch to match up with what other sections of code in this
driver are doing with regards to the underflow check. Other drivers all
appear to be performing the underflow check in this manner.

         len =3D cmd->request_bufflen;

-        if(cmd->underflow && len !=3D cmd->underflow){
+        if(cmd->underflow && len < cmd->underflow){
                 printk(KERN_WARNING"Cmd len %08X Cmd underflow %08X\n",
                         len, cmd->underflow);
         }

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Sakurai Hiroomi [mailto:sakurai_hiro@soft.fujitsu.com]=20
> Sent: Thursday, May 18, 2006 6:39 AM
> To: linux-scsi@vger.kernel.org; Salyzyn, Mark
> Subject: dpt_i2o and sd driver's problem
>=20
>=20
> Dear Mark,
>=20
> When I was using MO device , following messages showed in
> our /var/log/messages.
> The kernel version is kernel-2.6.16.16.
>=20
> kernel: Cmd len 00001000 Cmd underflow 00000400
>=20
> This messages is reported from dpt_i2o driver.
> It is reported when request_bufflen member/underflow member
> of the Scsi_Cmnd structure is not match.
> ---------------------------------------
> dpt_i2o.c
> static s32 adpt_scsi_to_i2o(adpt_hba* pHba,
>                             Scsi_Cmnd* cmd, struct adpt_device* d)
> {
>                 :
>         len =3D cmd->request_bufflen;
>                 :
>         if(cmd->underflow && len !=3D cmd->underflow){
>                 printk(KERN_WARNING"Cmd len %08X Cmd=20
> underflow %08X\n",
>                         len, cmd->underflow);
>         }
>                 :
> }
> ---------------------------------------
>=20
> The request_bufflen member/underflow member is set in sd driver.
> But, each sector size is not match except 512 bytes.
> ---------------------------------------
> sd.c
> static int sd_init_command(Scsi_Cmnd * SCpnt)
> {
>                 :
>         this_count =3D SCpnt->request_bufflen >> 9;
>                 :
>         if (sdp->sector_size =3D=3D 1024) {
>                 if ((block & 1) || (rq->nr_sectors & 1)) {
>                         printk(KERN_ERR "sd: Bad block number=20
> requested");
>                         return 0;
>                 } else {
>                         block =3D block >> 1;
>                         this_count =3D this_count >> 1;
>                 }
>         }
>         if (sdp->sector_size =3D=3D 2048) {
>                 if ((block & 3) || (rq->nr_sectors & 3)) {
>                         printk(KERN_ERR "sd: Bad block number=20
> requested");
>                         return 0;
>                 } else {
>                         block =3D block >> 2;
>                         this_count =3D this_count >> 2;
>                 }
>         }
>         if (sdp->sector_size =3D=3D 4096) {
>                 if ((block & 7) || (rq->nr_sectors & 7)) {
>                         printk(KERN_ERR "sd: Bad block number=20
> requested");
>                         return 0;
>                 } else {
>                         block =3D block >> 3;
>                         this_count =3D this_count >> 3;
>                 }
>         }
>                 :
>         SCpnt->underflow =3D this_count << 9;
> }
> ---------------------------------------
>=20
> There are no problem for the hard disk because of 512 bytes=20
> in the sector size.
> But, when I tested MO media(1.3GB), the sector size was 2048 byte.
>=20
> I have 2 questions.
>=20
> 1. I think the value of underflow is a calculation mistake.
>    Is it true?
>=20
> 2. What is the purpose to compare the values of
>    request_bufflen member/underflow member with dpt_i2o driver?
>=20
>=20
> I'm not participated in the linux-scsi mailing list.
> Please reply to the following addresses.=20
>=20
>     E-Mail : sakurai_hiro@soft.fujitsu.com
>=20
> Best Regards
> Hiroomi Sakurai
>=20
>=20
>=20
>=20

------_=_NextPart_001_01C67A7A.5A9908AD
Content-Type: application/octet-stream;
	name="dpt_i2o-underflow.patch"
Content-Transfer-Encoding: base64
Content-Description: dpt_i2o-underflow.patch
Content-Disposition: attachment;
	filename="dpt_i2o-underflow.patch"

LS0tIGEvZHJpdmVycy9zY3NpL2RwdF9pMm8uYwkyMDA2LTAyLTI0IDE0OjAwOjIyLjAwMDAwMDAw
MCAtMDUwMAorKysgYi9kcml2ZXJzL3Njc2kvZHB0X2kyby5jCTIwMDYtMDUtMTggMDg6NTE6MDIu
MTkyNDAxODc3IC0wNDAwCkBAIC0yMTYxLDcgKzIxNjEsNyBAQAogCQlyZXFsZW4gPSBtcHRyIC0g
bXNnOwogCQkqbGVucHRyID0gbGVuOwogCQkKLQkJaWYoY21kLT51bmRlcmZsb3cgJiYgbGVuICE9
IGNtZC0+dW5kZXJmbG93KXsKKwkJaWYoY21kLT51bmRlcmZsb3cgJiYgbGVuIDwgY21kLT51bmRl
cmZsb3cpewogCQkJcHJpbnRrKEtFUk5fV0FSTklORyJDbWQgbGVuICUwOFggQ21kIHVuZGVyZmxv
dyAlMDhYXG4iLAogCQkJCWxlbiwgY21kLT51bmRlcmZsb3cpOwogCQl9Cg==

------_=_NextPart_001_01C67A7A.5A9908AD--
