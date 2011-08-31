From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
Date: Wed, 31 Aug 2011 06:44:56 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC67E4.2C062CEA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:36528 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453Ab1HaNpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2011 09:45:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20110730002509.28735.82590.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <ltuikov@yahoo.com>, Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC67E4.2C062CEA
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Since Luben's patch on July 28th 2011 went nowhere, as there was an
unanswered question regarding the future-proofing that Luben added in. I
decided to submit a simplified focussed patch we have been using for the
past year testing with the Xyratex enclosures (5U84, 2U24, chained with
*many* peered expanders with Table to Table routing) that should
hopefully expedite things and will be on hot standby to refactor as
requested (including tossing this baby and refactoring Luben's patch
should he be too busy, no hair off my back)

Please note, as I am *stuck* on Outlook as per company policy, the
following inline content will likely not patch clean even emailed as
'Plain Text', the enclosed attached file should do the job. I have Cc'd
all the folks that originated the files in libsas, as there was no
listed MAINTAINERs.

NB: this patch (and Luben's independent patch) results in an ABI break
as the structures change 'shape' and thus result in a different set of
libsas export signatures. I have an internal patch I use that preserves
the structure shapes and thus the ABI; but would be considered
inappropriate for the pristine trees. Said alternate patch would work
fine for a Distribution tree where ABI concerns are an issue.

Checkpatch.pl reports clean.

Sincerely -- Mark Salyzyn

Cc: Luben Tuikov <tuikov@yahoo.com>
Cc: Darrick J Wong <djwong@us.ibm.com>
Cc: James Bottomley <jbottomley@parallels.com>

Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>

 drivers/scsi/libsas/sas_expander.c |    6 +++++-
 include/scsi/libsas.h              |    1 +
 include/scsi/sas.h                 |    6 ++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
--- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c	2011-08-31
08:32:21.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
2011-08-31 09:07:31.000000000 -0400
@@ -331,6 +331,7 @@
 	dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
 	dev->ex_dev.conf_route_table =3D rg->conf_route_table;
 	dev->ex_dev.configuring =3D rg->configuring;
+	dev->ex_dev.table_to_table =3D rg->table_to_table;
 	memcpy(dev->ex_dev.enclosure_logical_id,
rg->enclosure_logical_id, 8);
 }
=20
@@ -1239,7 +1240,10 @@
 					res =3D -ENODEV;
 				}
 			} else if (parent_phy->routing_attr =3D=3D
TABLE_ROUTING &&
-				   child_phy->routing_attr !=3D
SUBTRACTIVE_ROUTING) {
+				   child_phy->routing_attr !=3D
+					SUBTRACTIVE_ROUTING &&
+				   (child_ex->table_to_table =3D=3D 0 ||
+				    child_phy->routing_attr !=3D
TABLE_ROUTING)) {
 				sas_print_parent_topology_bug(child,
parent_phy, child_phy);
 				res =3D -ENODEV;
 			}
diff -ru scsi-misc-2.6/include/scsi/libsas.h
scsi-misc-2.6.new/include/scsi/libsas.h
--- scsi-misc-2.6/include/scsi/libsas.h	2011-08-31 08:32:22.000000000
-0400
+++ scsi-misc-2.6.new/include/scsi/libsas.h	2011-08-31
09:07:31.000000000 -0400
@@ -144,6 +144,7 @@
 	u8     num_phys;
 	u8     configuring:1;
 	u8     conf_route_table:1;
+	u8     table_to_table:1;
 	u8     enclosure_logical_id[8];
=20
 	struct ex_phy *ex_phy;
diff -ru scsi-misc-2.6/include/scsi/sas.h
scsi-misc-2.6.new/include/scsi/sas.h
--- scsi-misc-2.6/include/scsi/sas.h	2011-08-31 08:32:22.000000000
-0400
+++ scsi-misc-2.6.new/include/scsi/sas.h	2011-08-31
09:07:31.000000000 -0400
@@ -341,7 +341,8 @@
=20
 	u8      conf_route_table:1;
 	u8      configuring:1;
-	u8      _r_b:6;
+	u8      _r_b:5;
+	u8      table_to_table:1;
=20
 	u8      _r_c;
=20
@@ -528,7 +529,8 @@
 	u8      _r_a;
 	u8      num_phys;
=20
-	u8      _r_b:6;
+	u8      table_to_table:1;
+	u8      _r_b:5;
 	u8      configuring:1;
 	u8      conf_route_table:1;
=20

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D
------_=_NextPart_001_01CC67E4.2C062CEA
Content-Type: application/octet-stream;
	name="table_to_table.patch"
Content-Transfer-Encoding: base64
Content-Description: table_to_table.patch
Content-Disposition: attachment;
	filename="table_to_table.patch"

U2lnbmVkLW9mZi1ieTogTWFyayBTYWx5enluIDxtc2FseXp5bkB1cy54eXJhdGV4LmNvbT4KCiBk
cml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jIHwgICAgNiArKysrKy0KIGluY2x1ZGUv
c2NzaS9saWJzYXMuaCAgICAgICAgICAgICAgfCAgICAxICsKIGluY2x1ZGUvc2NzaS9zYXMuaCAg
ICAgICAgICAgICAgICAgfCAgICA2ICsrKystLQogMyBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtcnUgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19leHBhbmRlci5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9s
aWJzYXMvc2FzX2V4cGFuZGVyLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL2xpYnNh
cy9zYXNfZXhwYW5kZXIuYwkyMDExLTA4LTMxIDA4OjMyOjIxLjAwMDAwMDAwMCAtMDQwMAorKysg
c2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYwkyMDEx
LTA4LTMxIDA5OjA3OjMxLjAwMDAwMDAwMCAtMDQwMApAQCAtMzMxLDYgKzMzMSw3IEBACiAJZGV2
LT5leF9kZXYubnVtX3BoeXMgPSBtaW4ocmctPm51bV9waHlzLCAodTgpTUFYX0VYUEFOREVSX1BI
WVMpOwogCWRldi0+ZXhfZGV2LmNvbmZfcm91dGVfdGFibGUgPSByZy0+Y29uZl9yb3V0ZV90YWJs
ZTsKIAlkZXYtPmV4X2Rldi5jb25maWd1cmluZyA9IHJnLT5jb25maWd1cmluZzsKKwlkZXYtPmV4
X2Rldi50YWJsZV90b190YWJsZSA9IHJnLT50YWJsZV90b190YWJsZTsKIAltZW1jcHkoZGV2LT5l
eF9kZXYuZW5jbG9zdXJlX2xvZ2ljYWxfaWQsIHJnLT5lbmNsb3N1cmVfbG9naWNhbF9pZCwgOCk7
CiB9CiAKQEAgLTEyMzksNyArMTI0MCwxMCBAQAogCQkJCQlyZXMgPSAtRU5PREVWOwogCQkJCX0K
IAkJCX0gZWxzZSBpZiAocGFyZW50X3BoeS0+cm91dGluZ19hdHRyID09IFRBQkxFX1JPVVRJTkcg
JiYKLQkJCQkgICBjaGlsZF9waHktPnJvdXRpbmdfYXR0ciAhPSBTVUJUUkFDVElWRV9ST1VUSU5H
KSB7CisJCQkJICAgY2hpbGRfcGh5LT5yb3V0aW5nX2F0dHIgIT0KKwkJCQkJU1VCVFJBQ1RJVkVf
Uk9VVElORyAmJgorCQkJCSAgIChjaGlsZF9leC0+dGFibGVfdG9fdGFibGUgPT0gMCB8fAorCQkJ
CSAgICBjaGlsZF9waHktPnJvdXRpbmdfYXR0ciAhPSBUQUJMRV9ST1VUSU5HKSkgewogCQkJCXNh
c19wcmludF9wYXJlbnRfdG9wb2xvZ3lfYnVnKGNoaWxkLCBwYXJlbnRfcGh5LCBjaGlsZF9waHkp
OwogCQkJCXJlcyA9IC1FTk9ERVY7CiAJCQl9CmRpZmYgLXJ1IHNjc2ktbWlzYy0yLjYvaW5jbHVk
ZS9zY3NpL2xpYnNhcy5oIHNjc2ktbWlzYy0yLjYubmV3L2luY2x1ZGUvc2NzaS9saWJzYXMuaAot
LS0gc2NzaS1taXNjLTIuNi9pbmNsdWRlL3Njc2kvbGlic2FzLmgJMjAxMS0wOC0zMSAwODozMjoy
Mi4wMDAwMDAwMDAgLTA0MDAKKysrIHNjc2ktbWlzYy0yLjYubmV3L2luY2x1ZGUvc2NzaS9saWJz
YXMuaAkyMDExLTA4LTMxIDA5OjA3OjMxLjAwMDAwMDAwMCAtMDQwMApAQCAtMTQ0LDYgKzE0NCw3
IEBACiAJdTggICAgIG51bV9waHlzOwogCXU4ICAgICBjb25maWd1cmluZzoxOwogCXU4ICAgICBj
b25mX3JvdXRlX3RhYmxlOjE7CisJdTggICAgIHRhYmxlX3RvX3RhYmxlOjE7CiAJdTggICAgIGVu
Y2xvc3VyZV9sb2dpY2FsX2lkWzhdOwogCiAJc3RydWN0IGV4X3BoeSAqZXhfcGh5OwpkaWZmIC1y
dSBzY3NpLW1pc2MtMi42L2luY2x1ZGUvc2NzaS9zYXMuaCBzY3NpLW1pc2MtMi42Lm5ldy9pbmNs
dWRlL3Njc2kvc2FzLmgKLS0tIHNjc2ktbWlzYy0yLjYvaW5jbHVkZS9zY3NpL3Nhcy5oCTIwMTEt
MDgtMzEgMDg6MzI6MjIuMDAwMDAwMDAwIC0wNDAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9pbmNs
dWRlL3Njc2kvc2FzLmgJMjAxMS0wOC0zMSAwOTowNzozMS4wMDAwMDAwMDAgLTA0MDAKQEAgLTM0
MSw3ICszNDEsOCBAQAogCiAJdTggICAgICBjb25mX3JvdXRlX3RhYmxlOjE7CiAJdTggICAgICBj
b25maWd1cmluZzoxOwotCXU4ICAgICAgX3JfYjo2OworCXU4ICAgICAgX3JfYjo1OworCXU4ICAg
ICAgdGFibGVfdG9fdGFibGU6MTsKIAogCXU4ICAgICAgX3JfYzsKIApAQCAtNTI4LDcgKzUyOSw4
IEBACiAJdTggICAgICBfcl9hOwogCXU4ICAgICAgbnVtX3BoeXM7CiAKLQl1OCAgICAgIF9yX2I6
NjsKKwl1OCAgICAgIHRhYmxlX3RvX3RhYmxlOjE7CisJdTggICAgICBfcl9iOjU7CiAJdTggICAg
ICBjb25maWd1cmluZzoxOwogCXU4ICAgICAgY29uZl9yb3V0ZV90YWJsZToxOwogCg==

------_=_NextPart_001_01CC67E4.2C062CEA--
