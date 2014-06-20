From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/4] megaraid_sas: Fix LD/VF affiliation parsing
Date: Thu, 19 Jun 2014 17:32:00 -0700
Message-ID: <CAHtARFFK3yMX62JWRP-6wNm1T4Ff8E5wez-V=wyfpP6+44tNuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf303635bb2b941e04fc399ffe
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56756 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaFTAcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 20:32:01 -0400
Received: by mail-yh0-f46.google.com with SMTP id c41so2317283yho.5
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 17:32:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

--20cf303635bb2b941e04fc399ffe
Content-Type: text/plain; charset=UTF-8

James/linux-scsi,

The following patch for megaraid_sas fixes the LD/VF affiliation
policy parsing code to account for LD targetId's and Hidden LD's (not
yet affiliated with any Virtual Functions).

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_base.c
2014-06-19 15:03:05.000000000 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_base.c
2014-06-19 15:53:26.537229974 -0700
@@ -1836,7 +1836,7 @@
  struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
  dma_addr_t new_affiliation_h;
  dma_addr_t new_affiliation_111_h;
- int ld, retval = 0;
+ int ld, i, j, retval = 0, found = 0, doscan = 0;
  u8 thisVf;

  cmd = megasas_get_cmd(instance);
@@ -1944,14 +1944,6 @@

  if (!initial) {
  if (instance->PlasmaFW111) {
- if (!new_affiliation_111->vdCount) {
- printk(KERN_WARNING "megasas: SR-IOV: Got new "
-       "LD/VF affiliation for passive path "
-       "for scsi%d.\n",
- instance->host->host_no);
- retval = 1;
- goto out;
- }
  thisVf = new_affiliation_111->thisVf;
  for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
  if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
new_affiliation_111->map[ld].policy[thisVf]) {
@@ -1977,29 +1969,75 @@
  newmap = new_affiliation->map;
  savedmap = instance->vf_affiliation->map;
  thisVf = new_affiliation->thisVf;
- for (ld = 0 ; ld < new_affiliation->ldCount; ld++) {
- if (savedmap->policy[thisVf] !=
-    newmap->policy[thisVf]) {
- printk(KERN_WARNING "megasas: SR-IOV: "
-       "Got new LD/VF affiliation "
-       "for scsi%d.\n",
- instance->host->host_no);
- memcpy(instance->vf_affiliation,
-       new_affiliation,
-       new_affiliation->size);
- retval = 1;
+ for (i = 0 ; i < new_affiliation->ldCount; i++) {
+ found = 0;
+ for (j = 0;
+     j < instance->vf_affiliation->ldCount;
+     j++) {
+ if (newmap->ref.targetId ==
+    savedmap->ref.targetId) {
+ found = 1;
+ if (newmap->policy[thisVf] !=
+    savedmap->policy[thisVf]) {
+ doscan = 1;
+ goto out;
+ }
+ }
+ savedmap =
+  (struct MR_LD_VF_MAP *)
+  ((unsigned char *)savedmap +
+   savedmap->size);
+ }
+ if (!found && newmap->policy[thisVf] !=
+    MR_LD_ACCESS_HIDDEN) {
+ doscan = 1;
  goto out;
  }
- savedmap = (struct MR_LD_VF_MAP *)
- ((unsigned char *)savedmap +
- savedmap->size);
  newmap = (struct MR_LD_VF_MAP *)
- ((unsigned char *)newmap +
- newmap->size);
+  ((unsigned char *)newmap + newmap->size);
+ }
+
+ newmap = new_affiliation->map;
+ savedmap = instance->vf_affiliation->map;
+
+ for (i = 0 ; i < instance->vf_affiliation->ldCount;
+     i++) {
+ found = 0;
+ for (j = 0 ; j < new_affiliation->ldCount;
+     j++) {
+ if (savedmap->ref.targetId ==
+    newmap->ref.targetId) {
+ found = 1;
+ if (savedmap->policy[thisVf] !=
+    newmap->policy[thisVf]) {
+ doscan = 1;
+ goto out;
+ }
+ }
+ newmap = (struct MR_LD_VF_MAP *)
+  ((unsigned char *)newmap +
+   newmap->size);
+ }
+ if (!found && savedmap->policy[thisVf] !=
+    MR_LD_ACCESS_HIDDEN) {
+ doscan = 1;
+ goto out;
+ }
+ savedmap = (struct MR_LD_VF_MAP *)
+  ((unsigned char *)savedmap +
+   savedmap->size);
  }
  }
  }
 out:
+ if (doscan) {
+ printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+       "affiliation for scsi%d.\n", instance->host->host_no);
+ memcpy(instance->vf_affiliation, new_affiliation,
+       new_affiliation->size);
+ retval = 1;
+ }
+
  if (new_affiliation) {
  if (instance->PlasmaFW111)
  pci_free_consistent(instance->pdev,
diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:31:49.110125604 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:42:37.229075664 -0700
@@ -1659,6 +1659,7 @@
 /* Plasma 1.11 FW backward compatibility structures */
 #define IOV_111_OFFSET 0x7CE
 #define MAX_VIRTUAL_FUNCTIONS 8
+#define MR_LD_ACCESS_HIDDEN 15

 struct IOV_111 {
  u8 maxVFsSupported;

--20cf303635bb2b941e04fc399ffe
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwmrdm340

ZGlmZiAtTmF1ciBzY3NpLWZvci1uZXh0Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYyBzY3NpLWZvci1uZXh0Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYwotLS0gc2NzaS1mb3ItbmV4dC5vbGQvZHJpdmVycy9zY3NpL21lZ2Fy
YWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxNC0wNi0xOSAxNTowMzowNS4wMDAwMDAwMDAgLTA3
MDAKKysrIHNjc2ktZm9yLW5leHQubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jCTIwMTQtMDYtMTkgMTU6NTM6MjYuNTM3MjI5OTc0IC0wNzAwCkBAIC0xODM2LDcg
KzE4MzYsNyBAQAogCXN0cnVjdCBNUl9MRF9WRl9NQVAgKm5ld21hcCA9IE5VTEwsICpzYXZlZG1h
cCA9IE5VTEw7CiAJZG1hX2FkZHJfdCBuZXdfYWZmaWxpYXRpb25faDsKIAlkbWFfYWRkcl90IG5l
d19hZmZpbGlhdGlvbl8xMTFfaDsKLQlpbnQgbGQsIHJldHZhbCA9IDA7CisJaW50IGxkLCBpLCBq
LCByZXR2YWwgPSAwLCBmb3VuZCA9IDAsIGRvc2NhbiA9IDA7CiAJdTggdGhpc1ZmOwogCiAJY21k
ID0gbWVnYXNhc19nZXRfY21kKGluc3RhbmNlKTsKQEAgLTE5NDQsMTQgKzE5NDQsNiBAQAogCiAJ
aWYgKCFpbml0aWFsKSB7CiAJCWlmIChpbnN0YW5jZS0+UGxhc21hRlcxMTEpIHsKLQkJCWlmICgh
bmV3X2FmZmlsaWF0aW9uXzExMS0+dmRDb3VudCkgewotCQkJCXByaW50ayhLRVJOX1dBUk5JTkcg
Im1lZ2FzYXM6IFNSLUlPVjogR290IG5ldyAiCi0JCQkJICAgICAgICJMRC9WRiBhZmZpbGlhdGlv
biBmb3IgcGFzc2l2ZSBwYXRoICIKLQkJCQkgICAgICAgImZvciBzY3NpJWQuXG4iLAotCQkJCQlp
bnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7Ci0JCQkJcmV0dmFsID0gMTsKLQkJCQlnb3RvIG91dDsK
LQkJCX0KIAkJCXRoaXNWZiA9IG5ld19hZmZpbGlhdGlvbl8xMTEtPnRoaXNWZjsKIAkJCWZvciAo
bGQgPSAwIDsgbGQgPCBuZXdfYWZmaWxpYXRpb25fMTExLT52ZENvdW50OyBsZCsrKQogCQkJCWlm
IChpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25fMTExLT5tYXBbbGRdLnBvbGljeVt0aGlzVmZdICE9
IG5ld19hZmZpbGlhdGlvbl8xMTEtPm1hcFtsZF0ucG9saWN5W3RoaXNWZl0pIHsKQEAgLTE5Nzcs
MjkgKzE5NjksNzUgQEAKIAkJCW5ld21hcCA9IG5ld19hZmZpbGlhdGlvbi0+bWFwOwogCQkJc2F2
ZWRtYXAgPSBpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb24tPm1hcDsKIAkJCXRoaXNWZiA9IG5ld19h
ZmZpbGlhdGlvbi0+dGhpc1ZmOwotCQkJZm9yIChsZCA9IDAgOyBsZCA8IG5ld19hZmZpbGlhdGlv
bi0+bGRDb3VudDsgbGQrKykgewotCQkJCWlmIChzYXZlZG1hcC0+cG9saWN5W3RoaXNWZl0gIT0K
LQkJCQkgICAgbmV3bWFwLT5wb2xpY3lbdGhpc1ZmXSkgewotCQkJCQlwcmludGsoS0VSTl9XQVJO
SU5HICJtZWdhc2FzOiBTUi1JT1Y6ICIKLQkJCQkJICAgICAgICJHb3QgbmV3IExEL1ZGIGFmZmls
aWF0aW9uICIKLQkJCQkJICAgICAgICJmb3Igc2NzaSVkLlxuIiwKLQkJCQkJCWluc3RhbmNlLT5o
b3N0LT5ob3N0X25vKTsKLQkJCQkJbWVtY3B5KGluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbiwKLQkJ
CQkJICAgICAgIG5ld19hZmZpbGlhdGlvbiwKLQkJCQkJICAgICAgIG5ld19hZmZpbGlhdGlvbi0+
c2l6ZSk7Ci0JCQkJCXJldHZhbCA9IDE7CisJCQlmb3IgKGkgPSAwIDsgaSA8IG5ld19hZmZpbGlh
dGlvbi0+bGRDb3VudDsgaSsrKSB7CisJCQkJZm91bmQgPSAwOworCQkJCWZvciAoaiA9IDA7CisJ
CQkJICAgICBqIDwgaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLT5sZENvdW50OworCQkJCSAgICAg
aisrKSB7CisJCQkJCWlmIChuZXdtYXAtPnJlZi50YXJnZXRJZCA9PQorCQkJCQkgICAgc2F2ZWRt
YXAtPnJlZi50YXJnZXRJZCkgeworCQkJCQkJZm91bmQgPSAxOworCQkJCQkJaWYgKG5ld21hcC0+
cG9saWN5W3RoaXNWZl0gIT0KKwkJCQkJCSAgICBzYXZlZG1hcC0+cG9saWN5W3RoaXNWZl0pIHsK
KwkJCQkJCQlkb3NjYW4gPSAxOworCQkJCQkJCWdvdG8gb3V0OworCQkJCQkJfQorCQkJCQl9CisJ
CQkJCXNhdmVkbWFwID0KKwkJCQkJICAoc3RydWN0IE1SX0xEX1ZGX01BUCAqKQorCQkJCQkgICgo
dW5zaWduZWQgY2hhciAqKXNhdmVkbWFwICsKKwkJCQkJICAgc2F2ZWRtYXAtPnNpemUpOworCQkJ
CX0KKwkJCQlpZiAoIWZvdW5kICYmIG5ld21hcC0+cG9saWN5W3RoaXNWZl0gIT0KKwkJCQkgICAg
TVJfTERfQUNDRVNTX0hJRERFTikgeworCQkJCQlkb3NjYW4gPSAxOwogCQkJCQlnb3RvIG91dDsK
IAkJCQl9Ci0JCQkJc2F2ZWRtYXAgPSAoc3RydWN0IE1SX0xEX1ZGX01BUCAqKQotCQkJCQkoKHVu
c2lnbmVkIGNoYXIgKilzYXZlZG1hcCArCi0JCQkJCSBzYXZlZG1hcC0+c2l6ZSk7CiAJCQkJbmV3
bWFwID0gKHN0cnVjdCBNUl9MRF9WRl9NQVAgKikKLQkJCQkJKCh1bnNpZ25lZCBjaGFyICopbmV3
bWFwICsKLQkJCQkJIG5ld21hcC0+c2l6ZSk7CisJCQkJICAoKHVuc2lnbmVkIGNoYXIgKiluZXdt
YXAgKyBuZXdtYXAtPnNpemUpOworCQkJfQorCisJCQluZXdtYXAgPSBuZXdfYWZmaWxpYXRpb24t
Pm1hcDsKKwkJCXNhdmVkbWFwID0gaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLT5tYXA7CisKKwkJ
CWZvciAoaSA9IDAgOyBpIDwgaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLT5sZENvdW50OworCQkJ
ICAgICBpKyspIHsKKwkJCQlmb3VuZCA9IDA7CisJCQkJZm9yIChqID0gMCA7IGogPCBuZXdfYWZm
aWxpYXRpb24tPmxkQ291bnQ7CisJCQkJICAgICBqKyspIHsKKwkJCQkJaWYgKHNhdmVkbWFwLT5y
ZWYudGFyZ2V0SWQgPT0KKwkJCQkJICAgIG5ld21hcC0+cmVmLnRhcmdldElkKSB7CisJCQkJCQlm
b3VuZCA9IDE7CisJCQkJCQlpZiAoc2F2ZWRtYXAtPnBvbGljeVt0aGlzVmZdICE9CisJCQkJCQkg
ICAgbmV3bWFwLT5wb2xpY3lbdGhpc1ZmXSkgeworCQkJCQkJCWRvc2NhbiA9IDE7CisJCQkJCQkJ
Z290byBvdXQ7CisJCQkJCQl9CisJCQkJCX0KKwkJCQkJbmV3bWFwID0gKHN0cnVjdCBNUl9MRF9W
Rl9NQVAgKikKKwkJCQkJICAoKHVuc2lnbmVkIGNoYXIgKiluZXdtYXAgKworCQkJCQkgICBuZXdt
YXAtPnNpemUpOworCQkJCX0KKwkJCQlpZiAoIWZvdW5kICYmIHNhdmVkbWFwLT5wb2xpY3lbdGhp
c1ZmXSAhPQorCQkJCSAgICBNUl9MRF9BQ0NFU1NfSElEREVOKSB7CisJCQkJCWRvc2NhbiA9IDE7
CisJCQkJCWdvdG8gb3V0OworCQkJCX0KKwkJCQlzYXZlZG1hcCA9IChzdHJ1Y3QgTVJfTERfVkZf
TUFQICopCisJCQkJICAoKHVuc2lnbmVkIGNoYXIgKilzYXZlZG1hcCArCisJCQkJICAgc2F2ZWRt
YXAtPnNpemUpOwogCQkJfQogCQl9CiAJfQogb3V0OgorCWlmIChkb3NjYW4pIHsKKwkJcHJpbnRr
KEtFUk5fV0FSTklORyAibWVnYXNhczogU1ItSU9WOiBHb3QgbmV3IExEL1ZGICIKKwkJICAgICAg
ICJhZmZpbGlhdGlvbiBmb3Igc2NzaSVkLlxuIiwgaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOwor
CQltZW1jcHkoaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLCBuZXdfYWZmaWxpYXRpb24sCisJCSAg
ICAgICBuZXdfYWZmaWxpYXRpb24tPnNpemUpOworCQlyZXR2YWwgPSAxOworCX0KKwogCWlmIChu
ZXdfYWZmaWxpYXRpb24pIHsKIAkJaWYgKGluc3RhbmNlLT5QbGFzbWFGVzExMSkKIAkJCXBjaV9m
cmVlX2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsCmRpZmYgLU5hdXIgc2NzaS1mb3ItbmV4dC5v
bGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIHNjc2ktZm9yLW5leHQubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gc2NzaS1mb3ItbmV4dC5v
bGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTQtMDYtMTkgMTU6MzE6
NDkuMTEwMTI1NjA0IC0wNzAwCisrKyBzY3NpLWZvci1uZXh0Lm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxNC0wNi0xOSAxNTo0MjozNy4yMjkwNzU2NjQgLTA3MDAK
QEAgLTE2NTksNiArMTY1OSw3IEBACiAvKiBQbGFzbWEgMS4xMSBGVyBiYWNrd2FyZCBjb21wYXRp
YmlsaXR5IHN0cnVjdHVyZXMgKi8KICNkZWZpbmUgSU9WXzExMV9PRkZTRVQgMHg3Q0UKICNkZWZp
bmUgTUFYX1ZJUlRVQUxfRlVOQ1RJT05TIDgKKyNkZWZpbmUgTVJfTERfQUNDRVNTX0hJRERFTiAx
NQogCiBzdHJ1Y3QgSU9WXzExMSB7CiAJdTggbWF4VkZzU3VwcG9ydGVkOwo=
--20cf303635bb2b941e04fc399ffe--
