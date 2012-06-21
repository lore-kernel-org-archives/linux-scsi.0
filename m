From: Praveen Murali <pmurali@logicube.com>
Subject: [PATCH v1] Fix sector number translation in sense buffer for SATA
 drives
Date: Thu, 21 Jun 2012 16:42:16 -0700
Message-ID: <1340322136.3712.61.camel@praveen-debian.lg.local>
Reply-To: pmurali@logicube.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TdfcCtRJLQEtgnigx7wj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:59879 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759721Ab2FUXnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 19:43:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-TdfcCtRJLQEtgnigx7wj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For my large capacity drives connected to my SAS HBA i get improper
sector values when i use hdparm to get the native max. Also, the drives
have known bad sectors, but when read fails, the sector information
printed in the sense buffer is incorrect.
 In fill_result_tf() of libata-core.c the flags for the resultant tf is
copied from the request tf before calling the qc_fill_rtf() for the
driver. In case of SAS we convert the FIS to tf after receiving the
response and memcpy this tf over to the result tf in
sas_ata_qc_fill_rtf(); which results in overwriting the flags
for rtf. As a result, when ata_tf_read_block() is called by
ata_gen_ata_sense() ata_tf_read_block() does not find ATA_TFLAG_LBA or
ATA_TFLAG_LBA48 in the rtf flags. Hence, the returned block value is not
calculated correctly.

The fix sets the flags in result tf from tf after calling qc_fill_rtf()
to take care of overwrites (as in libsas). Also, if the overwrite was
intentional, we will only setup the right bits here.

--=-TdfcCtRJLQEtgnigx7wj
Content-Disposition: attachment;
	filename="0003-Fix-sector-number-translation-in-sense-buffer.patch"
Content-Type: text/x-patch;
	name="0003-Fix-sector-number-translation-in-sense-buffer.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA2OGM3N2U4N2RhMmQzM2MyZmRiNWI1ZjM0OTI1MmMyODM3NGYxZGM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUHJhdmVlbiBNdXJhbGkgPHBtdXJhbGlAbG9naWN1YmUuY29t
Pg0KRGF0ZTogVGh1LCAyMSBKdW4gMjAxMiAxNjoyNTo1MiAtMDcwMA0KU3ViamVjdDogW1BBVENI
IHYxXSBGaXggc2VjdG9yIG51bWJlciB0cmFuc2xhdGlvbiBpbiBzZW5zZSBidWZmZXIgZm9yIFNB
VEEgZHJpdmVzLg0KDQpGb3IgbXkgbGFyZ2UgY2FwYWNpdHkgZHJpdmVzIGNvbm5lY3RlZCB0byBt
eSBTQVMgSEJBIGkgZ2V0IGltcHJvcGVyDQpzZWN0b3IgdmFsdWVzIHdoZW4gaSB1c2UgaGRwYXJt
IHRvIGdldCB0aGUgbmF0aXZlIG1heC4gQWxzbywgdGhlIGRyaXZlcw0KaGF2ZSBrbm93biBiYWQg
c2VjdG9ycywgYnV0IHdoZW4gcmVhZCBmYWlscywgdGhlIHNlY3RvciBpbmZvcm1hdGlvbiBwcmlu
dGVkDQppbiB0aGUgc2Vuc2UgYnVmZmVyIGlzIGluY29ycmVjdC4NCiBJbiBmaWxsX3Jlc3VsdF90
ZigpIG9mIGxpYmF0YS1jb3JlLmMgdGhlIGZsYWdzIGZvciB0aGUgcmVzdWx0YW50IHRmIGlzIGNv
cGllZA0KZnJvbSB0aGUgcmVxdWVzdCB0ZiBiZWZvcmUgY2FsbGluZyB0aGUgcWNfZmlsbF9ydGYo
KSBmb3IgdGhlIGRyaXZlci4gSW4gY2FzZSBvZg0KU0FTIHdlIGNvbnZlcnQgdGhlIEZJUyB0byB0
ZiBhZnRlciByZWNlaXZpbmcgdGhlIHJlc3BvbnNlIGFuZCBtZW1jcHkgdGhpcyB0ZiBvdmVyDQp0
byB0aGUgcmVzdWx0IHRmIGluIHNhc19hdGFfcWNfZmlsbF9ydGYoKTsgd2hpY2ggcmVzdWx0cyBp
biBvdmVyd3JpdGluZyB0aGUgZmxhZ3MNCmZvciBydGYuIEFzIGEgcmVzdWx0LCB3aGVuIGF0YV90
Zl9yZWFkX2Jsb2NrKCkgaXMgY2FsbGVkIGJ5IGF0YV9nZW5fYXRhX3NlbnNlKCkNCmF0YV90Zl9y
ZWFkX2Jsb2NrKCkgZG9lcyBub3QgZmluZCBBVEFfVEZMQUdfTEJBIG9yIEFUQV9URkxBR19MQkE0
OCBpbiB0aGUgcnRmIGZsYWdzLg0KSGVuY2UsIHRoZSByZXR1cm5lZCBibG9jayB2YWx1ZSBpcyBu
b3QgY2FsY3VsYXRlZCBjb3JyZWN0bHkuDQoNClRoZSBmaXggc2V0cyB0aGUgZmxhZ3MgaW4gcmVz
dWx0IHRmIGZyb20gdGYgYWZ0ZXIgY2FsbGluZyBxY19maWxsX3J0ZigpIHRvIHRha2UgY2FyZQ0K
b2Ygb3ZlcndyaXRlcyAoYXMgaW4gbGlic2FzKS4gQWxzbywgaWYgdGhlIG92ZXJ3cml0ZSB3YXMg
aW50ZW50aW9uYWwsIHdlIHdpbGwgb25seQ0Kc2V0dXAgdGhlIHJpZ2h0IGJpdHMgaGVyZS4NCi0t
LQ0KIGRyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMgfCAgICA1ICsrKystDQogMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9hdGEvbGliYXRhLWNvcmUuYyBiL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCmluZGV4IGMw
NGFkNjguLmIwNDZkMzUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQor
KysgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQpAQCAtNDc4Nyw4ICs0Nzg3LDExIEBAIHN0
YXRpYyB2b2lkIGZpbGxfcmVzdWx0X3RmKHN0cnVjdCBhdGFfcXVldWVkX2NtZCAqcWMpDQogew0K
IAlzdHJ1Y3QgYXRhX3BvcnQgKmFwID0gcWMtPmFwOw0KIA0KLQlxYy0+cmVzdWx0X3RmLmZsYWdz
ID0gcWMtPnRmLmZsYWdzOw0KIAlhcC0+b3BzLT5xY19maWxsX3J0ZihxYyk7DQorCS8qIHNldCB0
aGUgZmxhZ3MgaW4gYWZ0ZXIgZmlsbGluZyBpbiBydGYgc2luY2UgdGhlIGZsYWcgbWlnaHQgZ2V0
IA0KKwkgKiBvdmVyd3JpdHRlbiBkb3duc3RyZWFtaSAoYXMgaXMgdGhlIGNhc2Ugd2l0aCBsaWJz
YXMvc2FzX2F0YS5jOw0KKwkgKiBhIG1lbWNvcHkgaXMgZG9uZSBmcm9tIGEgdGYgYnVmZmVyIGNy
ZWF0ZWQgZnJvbSB0aGUgRklTKS4gKi8NCisJcWMtPnJlc3VsdF90Zi5mbGFncyB8PSBxYy0+dGYu
ZmxhZ3M7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGF0YV92ZXJpZnlfeGZlcihzdHJ1Y3QgYXRhX3F1
ZXVlZF9jbWQgKnFjKQ0KLS0gDQoxLjcuMTANCg0K


--=-TdfcCtRJLQEtgnigx7wj--
