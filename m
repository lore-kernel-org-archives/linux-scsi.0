From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 09:41:36 -0700 (PDT)
Message-ID: <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-2111177108-1316709696=:61028"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316691000.10571.6.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--0-2111177108-1316709696=:61028
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Allow expander table-to-table attachments for=0Aexpanders that support it.=
=0A=0ASigned-off-by: Luben Tuikov <ltuikov@yahoo.com>=0A---=0A=A0drivers/sc=
si/libsas/sas_expander.c |=A0=A0 20 ++++++++++++++------=0A=A0include/scsi/=
libsas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 3 +++=0A=A0inclu=
de/scsi/sas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 14 ++=
++++++++++--=0A=A03 files changed, 29 insertions(+), 8 deletions(-)=0A=0Adi=
ff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_exp=
ander.c=0Aindex f84084b..e8d0115 100644=0A--- a/drivers/scsi/libsas/sas_exp=
ander.c=0A+++ b/drivers/scsi/libsas/sas_expander.c=0A@@ -329,6 +329,7 @@ st=
atic void ex_assign_report_general(struct domain_device *dev,=0A=A0=A0=A0=
=A0 dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_count);=0A=A0=A0=
=A0=A0 dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_indexes);=0A=
=A0=A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER_PH=
YS);=0A+=A0=A0=A0 dev->ex_dev.t2t_supp =3D rg->t2t_supp;=0A=A0=A0=A0=A0 dev=
->ex_dev.conf_route_table =3D rg->conf_route_table;=0A=A0=A0=A0=A0 dev->ex_=
dev.configuring =3D rg->configuring;=0A=A0=A0=A0=A0 memcpy(dev->ex_dev.encl=
osure_logical_id, rg->enclosure_logical_id, 8);=0A@@ -1133,15 +1134,17 @@ s=
tatic void sas_print_parent_topology_bug(struct domain_device *child,=0A=A0=
=A0=A0=A0 };=0A=A0=A0=A0=A0 struct domain_device *parent =3D child->parent;=
=0A=A0=0A-=A0=A0=A0 sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx p=
hy 0x%x "=0A-=A0=A0=A0 =A0=A0=A0 =A0=A0 "has %c:%c routing link!\n",=0A+=A0=
=A0=A0 sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx =
"=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0 "(T2T supp:%d) phy 0x%x has %c:%c routing l=
ink!\n",=0A=A0=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[parent->dev_type],=
=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(parent->sas_addr),=0A+=A0=A0=A0 =
=A0=A0=A0 =A0=A0 parent->ex_dev.t2t_supp,=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 p=
arent_phy->phy_id,=0A=A0=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[child->dev=
_type],=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(child->sas_addr),=0A+=A0=
=A0=A0 =A0=A0=A0 =A0=A0 child->ex_dev.t2t_supp,=0A=A0=A0=A0=A0 =A0=A0=A0 =
=A0=A0 child_phy->phy_id,=0A=A0=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ra_char[par=
ent_phy->routing_attr],=0A@@ -1238,10 +1241,15 @@ static int sas_check_pare=
nt_topology(struct domain_device *child)=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=
 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_bug(child, parent_phy, child=
_phy);=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENOD=
EV;=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }=0A-=A0=A0=A0 =A0=A0=A0 =
=A0=A0=A0 } else if (parent_phy->routing_attr =3D=3D TABLE_ROUTING &&=0A-=
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_attr !=3D=
 SUBTRACTIVE_ROUTING) {=0A-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_prin=
t_parent_topology_bug(child, parent_phy, child_phy);=0A-=A0=A0=A0 =A0=A0=A0=
 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } el=
se if (parent_phy->routing_attr =3D=3D TABLE_ROUTING) {=0A+=A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 =A0=A0=A0 if (child_phy->routing_attr =3D=3D SUBTRACTIVE_ROUT=
ING ||=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (child_phy->rou=
ting_attr =3D=3D TABLE_ROUTING &&=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0=A0 child_ex->t2t_supp && parent_ex->t2t_supp)) {=0A+=A0=A0=A0=
 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* All good */;=0A+=A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 =A0=A0=A0 } else {=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 sas_print_parent_topology_bug(child, parent_phy, child_phy);=
=0A+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;=0A+=
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 }=0A=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;=0A=A0=A0=A0=A0 =A0=A0=A0 ca=
se FANOUT_DEV:=0Adiff --git a/include/scsi/libsas.h b/include/scsi/libsas.h=
=0Aindex ee86606..793f80b 100644=0A--- a/include/scsi/libsas.h=0A+++ b/incl=
ude/scsi/libsas.h=0A@@ -142,8 +142,11 @@ struct expander_device {=0A=A0=A0=
=A0=A0 u16=A0=A0=A0 ex_change_count;=0A=A0=A0=A0=A0 u16=A0=A0=A0 max_route_=
indexes;=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0 num_phys;=0A+=0A+=A0=A0=A0 u8=A0=A0=
=A0=A0 t2t_supp:1;=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0 configuring:1;=0A=A0=A0=A0=
=A0 u8=A0=A0=A0=A0 conf_route_table:1;=0A+=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0 en=
closure_logical_id[8];=0A=A0=0A=A0=A0=A0=A0 struct ex_phy *ex_phy;=0Adiff -=
-git a/include/scsi/sas.h b/include/scsi/sas.h=0Aindex e9fd022..f59f182 100=
644=0A--- a/include/scsi/sas.h=0A+++ b/include/scsi/sas.h=0A@@ -341,7 +341,=
12 @@ struct report_general_resp {=0A=A0=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 c=
onf_route_table:1;=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;=0A-=A0=
=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;=0A+=A0=A0=A0 u8=A0=A0=A0 config_others:1;=
=0A+=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;=0A+=A0=A0=A0 u8=A0=A0=A0 stp_c=
ont_awt:1;=0A+=A0=A0=A0 u8=A0=A0=A0 self_config:1;=0A+=A0=A0=A0 u8=A0=A0=A0=
 zone_config:1;=0A+=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;=0A=A0=0A=A0=A0=A0=A0 u=
8=A0=A0=A0=A0=A0 _r_c;=0A=A0=0A@@ -528,7 +533,12 @@ struct report_general_r=
esp {=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_a;=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0=
=A0 num_phys;=0A=A0=0A-=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;=0A+=A0=A0=A0 u8=
=A0=A0=A0 t2t_supp:1;=0A+=A0=A0=A0 u8=A0=A0=A0 zone_config:1;=0A+=A0=A0=A0 =
u8=A0=A0=A0 self_config:1;=0A+=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;=0A+=A0=
=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;=0A+=A0=A0=A0 u8=A0=A0=A0 config_other=
s:1;=0A=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;=0A=A0=A0=A0=A0 u8=A0=
=A0=A0=A0=A0 conf_route_table:1;=0A=A0=0A-- =0A1.7.2.2.165.gbc382
--0-2111177108-1316709696=:61028
Content-Type: application/octet-stream; name="0001-SCSI-libsas-Allow-expander-T-T-attachments.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0001-SCSI-libsas-Allow-expander-T-T-attachments.patch"

RnJvbSA3Y2Q3MzMwNDMxNzYxMjdkNTg5MTExNjUzNjlmNGE4OTE0YWM0ZWRk
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMdWJlbiBUdWlrb3Yg
PGx0dWlrb3ZAeWFob28uY29tPgpEYXRlOiBXZWQsIDI3IEp1bCAyMDExIDIx
OjAyOjEyIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gW1NDU0ldIGxpYnNhczog
QWxsb3cgZXhwYW5kZXIgVC1UIGF0dGFjaG1lbnRzCgpBbGxvdyBleHBhbmRl
ciB0YWJsZS10by10YWJsZSBhdHRhY2htZW50cyBmb3IKZXhwYW5kZXJzIHRo
YXQgc3VwcG9ydCBpdC4KClNpZ25lZC1vZmYtYnk6IEx1YmVuIFR1aWtvdiA8
bHR1aWtvdkB5YWhvby5jb20+Ci0tLQogZHJpdmVycy9zY3NpL2xpYnNhcy9z
YXNfZXhwYW5kZXIuYyB8ICAgMjAgKysrKysrKysrKysrKystLS0tLS0KIGlu
Y2x1ZGUvc2NzaS9saWJzYXMuaCAgICAgICAgICAgICAgfCAgICAzICsrKwog
aW5jbHVkZS9zY3NpL3Nhcy5oICAgICAgICAgICAgICAgICB8ICAgMTQgKysr
KysrKysrKysrLS0KIDMgZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygr
KSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
bGlic2FzL3Nhc19leHBhbmRlci5jIGIvZHJpdmVycy9zY3NpL2xpYnNhcy9z
YXNfZXhwYW5kZXIuYwppbmRleCBmODQwODRiLi5lOGQwMTE1IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jCisrKyBi
L2RyaXZlcnMvc2NzaS9saWJzYXMvc2FzX2V4cGFuZGVyLmMKQEAgLTMyOSw2
ICszMjksNyBAQCBzdGF0aWMgdm9pZCBleF9hc3NpZ25fcmVwb3J0X2dlbmVy
YWwoc3RydWN0IGRvbWFpbl9kZXZpY2UgKmRldiwKIAlkZXYtPmV4X2Rldi5l
eF9jaGFuZ2VfY291bnQgPSBiZTE2X3RvX2NwdShyZy0+Y2hhbmdlX2NvdW50
KTsKIAlkZXYtPmV4X2Rldi5tYXhfcm91dGVfaW5kZXhlcyA9IGJlMTZfdG9f
Y3B1KHJnLT5yb3V0ZV9pbmRleGVzKTsKIAlkZXYtPmV4X2Rldi5udW1fcGh5
cyA9IG1pbihyZy0+bnVtX3BoeXMsICh1OClNQVhfRVhQQU5ERVJfUEhZUyk7
CisJZGV2LT5leF9kZXYudDJ0X3N1cHAgPSByZy0+dDJ0X3N1cHA7CiAJZGV2
LT5leF9kZXYuY29uZl9yb3V0ZV90YWJsZSA9IHJnLT5jb25mX3JvdXRlX3Rh
YmxlOwogCWRldi0+ZXhfZGV2LmNvbmZpZ3VyaW5nID0gcmctPmNvbmZpZ3Vy
aW5nOwogCW1lbWNweShkZXYtPmV4X2Rldi5lbmNsb3N1cmVfbG9naWNhbF9p
ZCwgcmctPmVuY2xvc3VyZV9sb2dpY2FsX2lkLCA4KTsKQEAgLTExMzMsMTUg
KzExMzQsMTcgQEAgc3RhdGljIHZvaWQgc2FzX3ByaW50X3BhcmVudF90b3Bv
bG9neV9idWcoc3RydWN0IGRvbWFpbl9kZXZpY2UgKmNoaWxkLAogCX07CiAJ
c3RydWN0IGRvbWFpbl9kZXZpY2UgKnBhcmVudCA9IGNoaWxkLT5wYXJlbnQ7
CiAKLQlzYXNfcHJpbnRrKCIlcyBleCAlMDE2bGx4IHBoeSAweCV4IDwtLT4g
JXMgZXggJTAxNmxseCBwaHkgMHgleCAiCi0JCSAgICJoYXMgJWM6JWMgcm91
dGluZyBsaW5rIVxuIiwKKwlzYXNfcHJpbnRrKCIlcyBleCAlMDE2bGx4IChU
MlQgc3VwcDolZCkgcGh5IDB4JXggPC0tPiAlcyBleCAlMDE2bGx4ICIKKwkJ
ICAgIihUMlQgc3VwcDolZCkgcGh5IDB4JXggaGFzICVjOiVjIHJvdXRpbmcg
bGluayFcbiIsCiAKIAkJICAgZXhfdHlwZVtwYXJlbnQtPmRldl90eXBlXSwK
IAkJICAgU0FTX0FERFIocGFyZW50LT5zYXNfYWRkciksCisJCSAgIHBhcmVu
dC0+ZXhfZGV2LnQydF9zdXBwLAogCQkgICBwYXJlbnRfcGh5LT5waHlfaWQs
CiAKIAkJICAgZXhfdHlwZVtjaGlsZC0+ZGV2X3R5cGVdLAogCQkgICBTQVNf
QUREUihjaGlsZC0+c2FzX2FkZHIpLAorCQkgICBjaGlsZC0+ZXhfZGV2LnQy
dF9zdXBwLAogCQkgICBjaGlsZF9waHktPnBoeV9pZCwKIAogCQkgICByYV9j
aGFyW3BhcmVudF9waHktPnJvdXRpbmdfYXR0cl0sCkBAIC0xMjM4LDEwICsx
MjQxLDE1IEBAIHN0YXRpYyBpbnQgc2FzX2NoZWNrX3BhcmVudF90b3BvbG9n
eShzdHJ1Y3QgZG9tYWluX2RldmljZSAqY2hpbGQpCiAJCQkJCXNhc19wcmlu
dF9wYXJlbnRfdG9wb2xvZ3lfYnVnKGNoaWxkLCBwYXJlbnRfcGh5LCBjaGls
ZF9waHkpOwogCQkJCQlyZXMgPSAtRU5PREVWOwogCQkJCX0KLQkJCX0gZWxz
ZSBpZiAocGFyZW50X3BoeS0+cm91dGluZ19hdHRyID09IFRBQkxFX1JPVVRJ
TkcgJiYKLQkJCQkgICBjaGlsZF9waHktPnJvdXRpbmdfYXR0ciAhPSBTVUJU
UkFDVElWRV9ST1VUSU5HKSB7Ci0JCQkJc2FzX3ByaW50X3BhcmVudF90b3Bv
bG9neV9idWcoY2hpbGQsIHBhcmVudF9waHksIGNoaWxkX3BoeSk7Ci0JCQkJ
cmVzID0gLUVOT0RFVjsKKwkJCX0gZWxzZSBpZiAocGFyZW50X3BoeS0+cm91
dGluZ19hdHRyID09IFRBQkxFX1JPVVRJTkcpIHsKKwkJCQlpZiAoY2hpbGRf
cGh5LT5yb3V0aW5nX2F0dHIgPT0gU1VCVFJBQ1RJVkVfUk9VVElORyB8fAor
CQkJCSAgICAoY2hpbGRfcGh5LT5yb3V0aW5nX2F0dHIgPT0gVEFCTEVfUk9V
VElORyAmJgorCQkJCSAgICAgY2hpbGRfZXgtPnQydF9zdXBwICYmIHBhcmVu
dF9leC0+dDJ0X3N1cHApKSB7CisJCQkJCS8qIEFsbCBnb29kICovOworCQkJ
CX0gZWxzZSB7CisJCQkJCXNhc19wcmludF9wYXJlbnRfdG9wb2xvZ3lfYnVn
KGNoaWxkLCBwYXJlbnRfcGh5LCBjaGlsZF9waHkpOworCQkJCQlyZXMgPSAt
RU5PREVWOworCQkJCX0KIAkJCX0KIAkJCWJyZWFrOwogCQljYXNlIEZBTk9V
VF9ERVY6CmRpZmYgLS1naXQgYS9pbmNsdWRlL3Njc2kvbGlic2FzLmggYi9p
bmNsdWRlL3Njc2kvbGlic2FzLmgKaW5kZXggZWU4NjYwNi4uNzkzZjgwYiAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9zY3NpL2xpYnNhcy5oCisrKyBiL2luY2x1
ZGUvc2NzaS9saWJzYXMuaApAQCAtMTQyLDggKzE0MiwxMSBAQCBzdHJ1Y3Qg
ZXhwYW5kZXJfZGV2aWNlIHsKIAl1MTYgICAgZXhfY2hhbmdlX2NvdW50Owog
CXUxNiAgICBtYXhfcm91dGVfaW5kZXhlczsKIAl1OCAgICAgbnVtX3BoeXM7
CisKKwl1OCAgICAgdDJ0X3N1cHA6MTsKIAl1OCAgICAgY29uZmlndXJpbmc6
MTsKIAl1OCAgICAgY29uZl9yb3V0ZV90YWJsZToxOworCiAJdTggICAgIGVu
Y2xvc3VyZV9sb2dpY2FsX2lkWzhdOwogCiAJc3RydWN0IGV4X3BoeSAqZXhf
cGh5OwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9zY3NpL3Nhcy5oIGIvaW5jbHVk
ZS9zY3NpL3Nhcy5oCmluZGV4IGU5ZmQwMjIuLmY1OWYxODIgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvc2NzaS9zYXMuaAorKysgYi9pbmNsdWRlL3Njc2kvc2Fz
LmgKQEAgLTM0MSw3ICszNDEsMTIgQEAgc3RydWN0IHJlcG9ydF9nZW5lcmFs
X3Jlc3AgewogCiAJdTggICAgICBjb25mX3JvdXRlX3RhYmxlOjE7CiAJdTgg
ICAgICBjb25maWd1cmluZzoxOwotCXU4ICAgICAgX3JfYjo2OworCXU4CWNv
bmZpZ19vdGhlcnM6MTsKKwl1OAlvcmVqX3JldHJ5X3N1cHA6MTsKKwl1OAlz
dHBfY29udF9hd3Q6MTsKKwl1OAlzZWxmX2NvbmZpZzoxOworCXU4CXpvbmVf
Y29uZmlnOjE7CisJdTgJdDJ0X3N1cHA6MTsKIAogCXU4ICAgICAgX3JfYzsK
IApAQCAtNTI4LDcgKzUzMywxMiBAQCBzdHJ1Y3QgcmVwb3J0X2dlbmVyYWxf
cmVzcCB7CiAJdTggICAgICBfcl9hOwogCXU4ICAgICAgbnVtX3BoeXM7CiAK
LQl1OCAgICAgIF9yX2I6NjsKKwl1OAl0MnRfc3VwcDoxOworCXU4CXpvbmVf
Y29uZmlnOjE7CisJdTgJc2VsZl9jb25maWc6MTsKKwl1OAlzdHBfY29udF9h
d3Q6MTsKKwl1OAlvcmVqX3JldHJ5X3N1cHA6MTsKKwl1OAljb25maWdfb3Ro
ZXJzOjE7CiAJdTggICAgICBjb25maWd1cmluZzoxOwogCXU4ICAgICAgY29u
Zl9yb3V0ZV90YWJsZToxOwogCi0tIAoxLjcuMi4yLjE2NS5nYmMzODIKCg==


--0-2111177108-1316709696=:61028--
