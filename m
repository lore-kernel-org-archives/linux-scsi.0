From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 driver update for 2.6.13-git10
Date: Fri, 9 Sep 2005 15:55:13 -0700
Message-ID: <b1bc6a00050909155559ebbe61@mail.gmail.com>
Reply-To: aradford@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3694_31184820.1126306513497"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:49345 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030780AbVIIWzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 18:55:15 -0400
Received: by wproxy.gmail.com with SMTP id i2so1487375wra
        for <linux-scsi@vger.kernel.org>; Fri, 09 Sep 2005 15:55:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

------=_Part_3694_31184820.1126306513497
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The attached patch updates the driver for the 3ware 9000 series to do
the following:

- Correctly handle single sgl's with use_sg =3D 1.

This is needed with the latest scsi-block-2.6 merge otherwise the 3w-9xxx
driver will not work.  I tested the patch James sent a few weeks back to fi=
x
this, and it had a bug where the request_buffer was accessed in
twa_scsiop_execute_scsi_complete() when it was invalid.  This is a correcte=
d
variation of that patch.

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

Note: The patch is attached as an attachment, and also included
in-line below.   The below
         may have line-wrap issues since I'm pasting into gmail.

diff -Naur linux-2.6.13-git9/drivers/scsi/3w-9xxx.c
linux-2.6.13-git10/drivers/scsi/3w-9xxx.c
--- linux-2.6.13-git9/drivers/scsi/3w-9xxx.c=092005-08-28 16:41:01.00000000=
0 -0700
+++ linux-2.6.13-git10/drivers/scsi/3w-9xxx.c=092005-09-09
15:37:34.000000000 -0700
@@ -59,6 +59,7 @@
                  Fix 'handled=3D1' ISR usage, remove bogus IRQ check.
                  Remove un-needed eh_abort handler.
                  Add support for embedded firmware error strings.
+   2.26.02.003 - Correctly handle single sgl's with use_sg=3D1.
 */
=20
 #include <linux/module.h>
@@ -81,7 +82,7 @@
 #include "3w-9xxx.h"
=20
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.002"
+#define TW_DRIVER_VERSION "2.26.02.003"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major =3D -1;
@@ -1805,6 +1806,8 @@
 =09=09=09if (tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH)=
 {
 =09=09=09=09command_packet->sg_list[0].address =3D
tw_dev->generic_buffer_phys[request_id];
 =09=09=09=09command_packet->sg_list[0].length =3D TW_MIN_SGL_LENGTH;
+=09=09=09=09if (tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_TO_D=
EVICE
|| tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_BIDIRECTIONAL)
+=09=09=09=09=09memcpy(tw_dev->generic_buffer_virt[request_id],
tw_dev->srb[request_id]->request_buffer,
tw_dev->srb[request_id]->request_bufflen);
 =09=09=09} else {
 =09=09=09=09buffaddr =3D twa_map_scsi_single_data(tw_dev, request_id);
 =09=09=09=09if (buffaddr =3D=3D 0)
@@ -1823,6 +1826,12 @@
=20
 =09=09if (tw_dev->srb[request_id]->use_sg > 0) {
 =09=09=09if ((tw_dev->srb[request_id]->use_sg =3D=3D 1) &&
(tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH)) {
+=09=09=09=09if (tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_TO_D=
EVICE
|| tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_BIDIRECTIONAL) {
+=09=09=09=09=09struct scatterlist *sg =3D (struct scatterlist
*)tw_dev->srb[request_id]->request_buffer;
+=09=09=09=09=09char *buf =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+=09=09=09=09=09memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->le=
ngth);
+=09=09=09=09=09kunmap_atomic(buf - sg->offset, KM_IRQ0);
+=09=09=09=09}
 =09=09=09=09command_packet->sg_list[0].address =3D
tw_dev->generic_buffer_phys[request_id];
 =09=09=09=09command_packet->sg_list[0].length =3D TW_MIN_SGL_LENGTH;
 =09=09=09} else {
@@ -1888,11 +1897,20 @@
 /* This function completes an execute scsi operation */
 static void twa_scsiop_execute_scsi_complete(TW_Device_Extension
*tw_dev, int request_id)
 {
-=09/* Copy the response if too small */
-=09if ((tw_dev->srb[request_id]->request_buffer) &&
(tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH)) {
-=09=09memcpy(tw_dev->srb[request_id]->request_buffer,
-=09=09       tw_dev->generic_buffer_virt[request_id],
-=09=09       tw_dev->srb[request_id]->request_bufflen);
+=09if (tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH &&
+=09    (tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_FROM_DEVICE =
||
+=09     tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_BIDIRECTIONA=
L)) {
+=09=09if (tw_dev->srb[request_id]->use_sg =3D=3D 0) {
+=09=09=09memcpy(tw_dev->srb[request_id]->request_buffer,
+=09=09=09       tw_dev->generic_buffer_virt[request_id],
+=09=09=09       tw_dev->srb[request_id]->request_bufflen);
+=09=09}
+=09=09if (tw_dev->srb[request_id]->use_sg =3D=3D 1) {
+=09=09=09struct scatterlist *sg =3D (struct scatterlist
*)tw_dev->srb[request_id]->request_buffer;
+=09=09=09char *buf =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+=09=09=09memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
+=09=09=09kunmap_atomic(buf - sg->offset, KM_IRQ0);
+=09=09}
 =09}
 } /* End twa_scsiop_execute_scsi_complete() */

------=_Part_3694_31184820.1126306513497
Content-Type: text/x-patch; name="3ware_update_2.6.13-git10.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="3ware_update_2.6.13-git10.patch"

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMTMtZ2l0OS9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jIGxpbnV4
LTIuNi4xMy1naXQxMC9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCi0tLSBsaW51eC0yLjYuMTMtZ2l0
OS9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDUtMDgtMjggMTY6NDE6MDEuMDAwMDAwMDAwIC0w
NzAwCisrKyBsaW51eC0yLjYuMTMtZ2l0MTAvZHJpdmVycy9zY3NpLzN3LTl4eHguYwkyMDA1LTA5
LTA5IDE1OjM3OjM0LjAwMDAwMDAwMCAtMDcwMApAQCAtNTksNiArNTksNyBAQAogICAgICAgICAg
ICAgICAgICBGaXggJ2hhbmRsZWQ9MScgSVNSIHVzYWdlLCByZW1vdmUgYm9ndXMgSVJRIGNoZWNr
LgogICAgICAgICAgICAgICAgICBSZW1vdmUgdW4tbmVlZGVkIGVoX2Fib3J0IGhhbmRsZXIuCiAg
ICAgICAgICAgICAgICAgIEFkZCBzdXBwb3J0IGZvciBlbWJlZGRlZCBmaXJtd2FyZSBlcnJvciBz
dHJpbmdzLgorICAgMi4yNi4wMi4wMDMgLSBDb3JyZWN0bHkgaGFuZGxlIHNpbmdsZSBzZ2wncyB3
aXRoIHVzZV9zZz0xLgogKi8KIAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgpAQCAtODEsNyAr
ODIsNyBAQAogI2luY2x1ZGUgIjN3LTl4eHguaCIKIAogLyogR2xvYmFscyAqLwotI2RlZmluZSBU
V19EUklWRVJfVkVSU0lPTiAiMi4yNi4wMi4wMDIiCisjZGVmaW5lIFRXX0RSSVZFUl9WRVJTSU9O
ICIyLjI2LjAyLjAwMyIKIHN0YXRpYyBUV19EZXZpY2VfRXh0ZW5zaW9uICp0d2FfZGV2aWNlX2V4
dGVuc2lvbl9saXN0W1RXX01BWF9TTE9UXTsKIHN0YXRpYyB1bnNpZ25lZCBpbnQgdHdhX2Rldmlj
ZV9leHRlbnNpb25fY291bnQ7CiBzdGF0aWMgaW50IHR3YV9tYWpvciA9IC0xOwpAQCAtMTgwNSw2
ICsxODA2LDggQEAKIAkJCWlmICh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+cmVxdWVzdF9idWZm
bGVuIDwgVFdfTUlOX1NHTF9MRU5HVEgpIHsKIAkJCQljb21tYW5kX3BhY2tldC0+c2dfbGlzdFsw
XS5hZGRyZXNzID0gdHdfZGV2LT5nZW5lcmljX2J1ZmZlcl9waHlzW3JlcXVlc3RfaWRdOwogCQkJ
CWNvbW1hbmRfcGFja2V0LT5zZ19saXN0WzBdLmxlbmd0aCA9IFRXX01JTl9TR0xfTEVOR1RIOwor
CQkJCWlmICh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gRE1B
X1RPX0RFVklDRSB8fCB0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+c2NfZGF0YV9kaXJlY3Rpb24g
PT0gRE1BX0JJRElSRUNUSU9OQUwpCisJCQkJCW1lbWNweSh0d19kZXYtPmdlbmVyaWNfYnVmZmVy
X3ZpcnRbcmVxdWVzdF9pZF0sIHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5yZXF1ZXN0X2J1ZmZl
ciwgdHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0tPnJlcXVlc3RfYnVmZmxlbik7CiAJCQl9IGVsc2Ug
ewogCQkJCWJ1ZmZhZGRyID0gdHdhX21hcF9zY3NpX3NpbmdsZV9kYXRhKHR3X2RldiwgcmVxdWVz
dF9pZCk7CiAJCQkJaWYgKGJ1ZmZhZGRyID09IDApCkBAIC0xODIzLDYgKzE4MjYsMTIgQEAKIAog
CQlpZiAodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0tPnVzZV9zZyA+IDApIHsKIAkJCWlmICgodHdf
ZGV2LT5zcmJbcmVxdWVzdF9pZF0tPnVzZV9zZyA9PSAxKSAmJiAodHdfZGV2LT5zcmJbcmVxdWVz
dF9pZF0tPnJlcXVlc3RfYnVmZmxlbiA8IFRXX01JTl9TR0xfTEVOR1RIKSkgeworCQkJCWlmICh0
d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gRE1BX1RPX0RFVklD
RSB8fCB0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gRE1BX0JJ
RElSRUNUSU9OQUwpIHsKKwkJCQkJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZyA9IChzdHJ1Y3Qgc2Nh
dHRlcmxpc3QgKil0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+cmVxdWVzdF9idWZmZXI7CisJCQkJ
CWNoYXIgKmJ1ZiA9IGttYXBfYXRvbWljKHNnLT5wYWdlLCBLTV9JUlEwKSArIHNnLT5vZmZzZXQ7
CisJCQkJCW1lbWNweSh0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3ZpcnRbcmVxdWVzdF9pZF0sIGJ1
Ziwgc2ctPmxlbmd0aCk7CisJCQkJCWt1bm1hcF9hdG9taWMoYnVmIC0gc2ctPm9mZnNldCwgS01f
SVJRMCk7CisJCQkJfQogCQkJCWNvbW1hbmRfcGFja2V0LT5zZ19saXN0WzBdLmFkZHJlc3MgPSB0
d19kZXYtPmdlbmVyaWNfYnVmZmVyX3BoeXNbcmVxdWVzdF9pZF07CiAJCQkJY29tbWFuZF9wYWNr
ZXQtPnNnX2xpc3RbMF0ubGVuZ3RoID0gVFdfTUlOX1NHTF9MRU5HVEg7CiAJCQl9IGVsc2UgewpA
QCAtMTg4OCwxMSArMTg5NywyMCBAQAogLyogVGhpcyBmdW5jdGlvbiBjb21wbGV0ZXMgYW4gZXhl
Y3V0ZSBzY3NpIG9wZXJhdGlvbiAqLwogc3RhdGljIHZvaWQgdHdhX3Njc2lvcF9leGVjdXRlX3Nj
c2lfY29tcGxldGUoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9pZCkK
IHsKLQkvKiBDb3B5IHRoZSByZXNwb25zZSBpZiB0b28gc21hbGwgKi8KLQlpZiAoKHR3X2Rldi0+
c3JiW3JlcXVlc3RfaWRdLT5yZXF1ZXN0X2J1ZmZlcikgJiYgKHR3X2Rldi0+c3JiW3JlcXVlc3Rf
aWRdLT5yZXF1ZXN0X2J1ZmZsZW4gPCBUV19NSU5fU0dMX0xFTkdUSCkpIHsKLQkJbWVtY3B5KHR3
X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5yZXF1ZXN0X2J1ZmZlciwKLQkJICAgICAgIHR3X2Rldi0+
Z2VuZXJpY19idWZmZXJfdmlydFtyZXF1ZXN0X2lkXSwKLQkJICAgICAgIHR3X2Rldi0+c3JiW3Jl
cXVlc3RfaWRdLT5yZXF1ZXN0X2J1ZmZsZW4pOworCWlmICh0d19kZXYtPnNyYltyZXF1ZXN0X2lk
XS0+cmVxdWVzdF9idWZmbGVuIDwgVFdfTUlOX1NHTF9MRU5HVEggJiYKKwkgICAgKHR3X2Rldi0+
c3JiW3JlcXVlc3RfaWRdLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBETUFfRlJPTV9ERVZJQ0UgfHwK
KwkgICAgIHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBETUFf
QklESVJFQ1RJT05BTCkpIHsKKwkJaWYgKHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT51c2Vfc2cg
PT0gMCkgeworCQkJbWVtY3B5KHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5yZXF1ZXN0X2J1ZmZl
ciwKKwkJCSAgICAgICB0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3ZpcnRbcmVxdWVzdF9pZF0sCisJ
CQkgICAgICAgdHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0tPnJlcXVlc3RfYnVmZmxlbik7CisJCX0K
KwkJaWYgKHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT51c2Vfc2cgPT0gMSkgeworCQkJc3RydWN0
IHNjYXR0ZXJsaXN0ICpzZyA9IChzdHJ1Y3Qgc2NhdHRlcmxpc3QgKil0d19kZXYtPnNyYltyZXF1
ZXN0X2lkXS0+cmVxdWVzdF9idWZmZXI7CisJCQljaGFyICpidWYgPSBrbWFwX2F0b21pYyhzZy0+
cGFnZSwgS01fSVJRMCkgKyBzZy0+b2Zmc2V0OworCQkJbWVtY3B5KGJ1ZiwgdHdfZGV2LT5nZW5l
cmljX2J1ZmZlcl92aXJ0W3JlcXVlc3RfaWRdLCBzZy0+bGVuZ3RoKTsKKwkJCWt1bm1hcF9hdG9t
aWMoYnVmIC0gc2ctPm9mZnNldCwgS01fSVJRMCk7CisJCX0KIAl9CiB9IC8qIEVuZCB0d2Ffc2Nz
aW9wX2V4ZWN1dGVfc2NzaV9jb21wbGV0ZSgpICovCiAK
------=_Part_3694_31184820.1126306513497--
