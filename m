From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Wed, 27 Jul 2011 21:19:52 -0700 (PDT)
Message-ID: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

Allow expander table-to-table attachments for
expanders that support it.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
=A0drivers/scsi/libsas/sas_expander.c |=A0=A0 20 ++++++++++++++------
=A0include/scsi/libsas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=
=A0 3 +++
=A0include/scsi/sas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 14 ++++++++++++--
=A03 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/s=
as_expander.c
index f84084b..e8d0115 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -329,6 +329,7 @@ static void ex_assign_report_general(struct domain_=
device *dev,
=A0=A0=A0=A0 dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_cou=
nt);
=A0=A0=A0=A0 dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_in=
dexes);
=A0=A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDE=
R_PHYS);
+=A0=A0=A0 dev->ex_dev.t2t_supp =3D rg->t2t_supp;
=A0=A0=A0=A0 dev->ex_dev.conf_route_table =3D rg->conf_route_table;
=A0=A0=A0=A0 dev->ex_dev.configuring =3D rg->configuring;
=A0=A0=A0=A0 memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_log=
ical_id, 8);
@@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(struc=
t domain_device *child,
=A0=A0=A0=A0 };
=A0=A0=A0=A0 struct domain_device *parent =3D child->parent;
=A0
-=A0=A0=A0 sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x=
%x "
-=A0=A0=A0 =A0=A0=A0 =A0=A0 "has %c:%c routing link!\n",
+=A0=A0=A0 sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex =
%016llx "
+=A0=A0=A0 =A0=A0=A0 =A0=A0 "(T2T supp:%d) phy 0x%x has %c:%c routing l=
ink!\n",
=A0
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[parent->dev_type],
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(parent->sas_addr),
+=A0=A0=A0 =A0=A0=A0 =A0=A0 parent->ex_dev.t2t_supp,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 parent_phy->phy_id,
=A0
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[child->dev_type],
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(child->sas_addr),
+=A0=A0=A0 =A0=A0=A0 =A0=A0 child->ex_dev.t2t_supp,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->phy_id,
=A0
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ra_char[parent_phy->routing_attr],
@@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct dom=
ain_device *child)
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_t=
opology_bug(child, parent_phy, child_phy);
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=3D=
 TABLE_ROUTING &&
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_attr=
 !=3D SUBTRACTIVE_ROUTING) {
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_bug(=
child, parent_phy, child_phy);
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=3D=
 TABLE_ROUTING) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (child_phy->routing_attr =3D=
=3D SUBTRACTIVE_ROUTING ||
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (child_phy->routing_=
attr =3D=3D TABLE_ROUTING &&
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0 child_ex->t2t_sup=
p && parent_ex->t2t_supp)) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* All good */;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_top=
ology_bug(child, parent_phy, child_phy);
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
=A0=A0=A0=A0 =A0=A0=A0 case FANOUT_DEV:
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ee86606..793f80b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -142,8 +142,11 @@ struct expander_device {
=A0=A0=A0=A0 u16=A0=A0=A0 ex_change_count;
=A0=A0=A0=A0 u16=A0=A0=A0 max_route_indexes;
=A0=A0=A0=A0 u8=A0=A0=A0=A0 num_phys;
+
+=A0=A0=A0 u8=A0=A0=A0=A0 t2t_supp:1;
=A0=A0=A0=A0 u8=A0=A0=A0=A0 configuring:1;
=A0=A0=A0=A0 u8=A0=A0=A0=A0 conf_route_table:1;
+
=A0=A0=A0=A0 u8=A0=A0=A0=A0 enclosure_logical_id[8];
=A0
=A0=A0=A0=A0 struct ex_phy *ex_phy;
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index e9fd022..f59f182 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -341,7 +341,12 @@ struct report_general_resp {
=A0
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
-=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
+=A0=A0=A0 u8=A0=A0=A0 config_others:1;
+=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
+=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
+=A0=A0=A0 u8=A0=A0=A0 self_config:1;
+=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
+=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
=A0
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_c;
=A0
@@ -528,7 +533,12 @@ struct report_general_resp {
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_a;
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 num_phys;
=A0
-=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
+=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
+=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
+=A0=A0=A0 u8=A0=A0=A0 self_config:1;
+=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
+=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
+=A0=A0=A0 u8=A0=A0=A0 config_others:1;
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
=A0
--=20
1.7.2.2.165.gbc382
