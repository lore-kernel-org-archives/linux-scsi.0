From: "jack_wang" <jack_wang@usish.com>
Subject: [PATCH]libsas: fix loopback topology bug during discovery
Date: Sat, 19 Feb 2011 18:20:53 +0800
Message-ID: <201102191820533434720@usish.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====001_Dragon645363882282_====="
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:54062 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1BSKU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 05:20:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: lindar_liu <lindar_liu@usish.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, jack_wang <jack_wang@usish.com>

This is a multi-part message in MIME format.

--=====001_Dragon645363882282_=====
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 From e8a58c706308409dec0ba21971d382dee4adc39e Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Sat, 19 Feb 2011 17:52:24 +0800
Subject: [PATCH] Fix loopback topology bug during discovery
 In some test envirenment, there is loopback topology test. We should
 handle this during discovery.

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/libsas/sas_expander.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 505ffe3..1a113c4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -244,6 +244,12 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 		 * dev to host FIS as described in section G.5 of
 		 * sas-2 r 04b */
 		dr = &((struct smp_resp *)disc_resp)->disc;
+		if (memcmp(dev->sas_addr, dr->attached_sas_addr,
+			  SAS_ADDR_SIZE) == 0) {
+			sas_printk("Found loopback topology,"
+			"just ignore it!\n");
+			return 0;
+		}
 		if (!(dr->attached_dev_type == 0 &&
 		      dr->attached_sata_dev))
 			break;
-- 

2011-02-19 



jack_wang 
--=====001_Dragon645363882282_=====
Content-Type: application/octet-stream;
	name="0001-Fix-loopback-topology-bug-during-discovery.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0001-Fix-loopback-topology-bug-during-discovery.patch"

RnJvbSBlOGE1OGM3MDYzMDg0MDlkZWMwYmEyMTk3MWQzODJkZWU0YWRjMzllIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGphY2tfd2FuZ0B1c2lzaC5jb20+CkRhdGU6
IFNhdCwgMTkgRmViIDIwMTEgMTc6NTI6MjQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBGaXggbG9v
cGJhY2sgdG9wb2xvZ3kgYnVnIGR1cmluZyBkaXNjb3ZlcnkKIEluIHNvbWUgdGVzdCBlbnZpcmVu
bWVudCwgdGhlcmUgaXMgbG9vcGJhY2sgdG9wb2xvZ3kgdGVzdC4gV2Ugc2hvdWxkCiBoYW5kbGUg
dGhpcyBkdXJpbmcgZGlzY292ZXJ5LgoKU2lnbmVkLW9mZi1ieTogSmFjayBXYW5nIDxqYWNrX3dh
bmdAdXNpc2guY29tPgotLS0KIGRyaXZlcnMvc2NzaS9saWJzYXMvc2FzX2V4cGFuZGVyLmMgfCAg
ICA2ICsrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYyBiL2Ry
aXZlcnMvc2NzaS9saWJzYXMvc2FzX2V4cGFuZGVyLmMKaW5kZXggNTA1ZmZlMy4uMWExMTNjNCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYworKysgYi9kcml2
ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jCkBAIC0yNDQsNiArMjQ0LDEyIEBAIHN0YXRp
YyBpbnQgc2FzX2V4X3BoeV9kaXNjb3Zlcl9oZWxwZXIoc3RydWN0IGRvbWFpbl9kZXZpY2UgKmRl
diwgdTggKmRpc2NfcmVxLAogCQkgKiBkZXYgdG8gaG9zdCBGSVMgYXMgZGVzY3JpYmVkIGluIHNl
Y3Rpb24gRy41IG9mCiAJCSAqIHNhcy0yIHIgMDRiICovCiAJCWRyID0gJigoc3RydWN0IHNtcF9y
ZXNwICopZGlzY19yZXNwKS0+ZGlzYzsKKwkJaWYgKG1lbWNtcChkZXYtPnNhc19hZGRyLCBkci0+
YXR0YWNoZWRfc2FzX2FkZHIsCisJCQkgIFNBU19BRERSX1NJWkUpID09IDApIHsKKwkJCXNhc19w
cmludGsoIkZvdW5kIGxvb3BiYWNrIHRvcG9sb2d5LCIKKwkJCSJqdXN0IGlnbm9yZSBpdCFcbiIp
OworCQkJcmV0dXJuIDA7CisJCX0KIAkJaWYgKCEoZHItPmF0dGFjaGVkX2Rldl90eXBlID09IDAg
JiYKIAkJICAgICAgZHItPmF0dGFjaGVkX3NhdGFfZGV2KSkKIAkJCWJyZWFrOwotLSAKMS43LjQu
bXN5c2dpdC4wCgo=

--=====001_Dragon645363882282_=====--

