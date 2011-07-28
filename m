From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 28 Jul 2011 14:46:04 +0800
Message-ID: <53763DE9A1F742C9A192F448132FCBD4@usish.com.cn>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39940 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1G1GqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 02:46:14 -0400
In-Reply-To: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Luben Tuikov' <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@Parallels.com

>=20
> Allow expander table-to-table attachments for
> expanders that support it.
>=20
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c |=A0=A0 20 ++++++++++++++------
> =A0include/scsi/libsas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=
=A0 3 +++
> =A0include/scsi/sas.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=A0=A0 14 ++++++++++++--
> =A03 files changed, 29 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index f84084b..e8d0115 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct
domain_device
> *dev,
> =A0=A0=A0=A0 dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_c=
ount);
> =A0=A0=A0=A0 dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_=
indexes);
> =A0=A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPAN=
DER_PHYS);
> +=A0=A0=A0 dev->ex_dev.t2t_supp =3D rg->t2t_supp;
> =A0=A0=A0=A0 dev->ex_dev.conf_route_table =3D rg->conf_route_table;
> =A0=A0=A0=A0 dev->ex_dev.configuring =3D rg->configuring;
> =A0=A0=A0=A0 memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_l=
ogical_id,
> 8);
> @@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(str=
uct
> domain_device *child,
> =A0=A0=A0=A0 };
> =A0=A0=A0=A0 struct domain_device *parent =3D child->parent;
>=20
> -=A0=A0=A0 sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy =
0x%x "
> -=A0=A0=A0 =A0=A0=A0 =A0=A0 "has %c:%c routing link!\n",
> +=A0=A0=A0 sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s e=
x %016llx "
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 "(T2T supp:%d) phy 0x%x has %c:%c routing=
 link!\n",
>=20
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[parent->dev_type],
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(parent->sas_addr),
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 parent->ex_dev.t2t_supp,
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 parent_phy->phy_id,
>=20
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ex_type[child->dev_type],
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 SAS_ADDR(child->sas_addr),
> +=A0=A0=A0 =A0=A0=A0 =A0=A0 child->ex_dev.t2t_supp,
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->phy_id,
>=20
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0 ra_char[parent_phy->routing_attr],
> @@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct
> domain_device *child)
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent=
_topology_bug(child, parent_phy,
> child_phy);
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D TABLE_ROUTING &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_at=
tr !=3D SUBTRACTIVE_ROUTING) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_bu=
g(child, parent_phy,
> child_phy);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D TABLE_ROUTING) {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (child_phy->routing_attr =
=3D=3D SUBTRACTIVE_ROUTING ||
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (child_phy->routin=
g_attr =3D=3D TABLE_ROUTING &&
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0 child_ex->t2t_s=
upp && parent_ex->t2t_supp)) {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* All good */;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_t=
opology_bug(child, parent_phy,
> child_phy);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> =A0=A0=A0=A0 =A0=A0=A0 case FANOUT_DEV:
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ee86606..793f80b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -142,8 +142,11 @@ struct expander_device {
> =A0=A0=A0=A0 u16=A0=A0=A0 ex_change_count;
> =A0=A0=A0=A0 u16=A0=A0=A0 max_route_indexes;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 num_phys;
> +
> +=A0=A0=A0 u8=A0=A0=A0=A0 t2t_supp:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 configuring:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 conf_route_table:1;
> +
> =A0=A0=A0=A0 u8=A0=A0=A0=A0 enclosure_logical_id[8];
>=20
> =A0=A0=A0=A0 struct ex_phy *ex_phy;
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index e9fd022..f59f182 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -341,7 +341,12 @@ struct report_general_resp {
>=20
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
> -=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
> +=A0=A0=A0 u8=A0=A0=A0 config_others:1;
> +=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
> +=A0=A0=A0 u8=A0=A0=A0 self_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
>=20
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_c;
>=20
> @@ -528,7 +533,12 @@ struct report_general_resp {
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_a;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 num_phys;
>=20
> -=A0=A0=A0 u8=A0=A0=A0=A0=A0 _r_b:6;
> +=A0=A0=A0 u8=A0=A0=A0 t2t_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 zone_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 self_config:1;
> +=A0=A0=A0 u8=A0=A0=A0 stp_cont_awt:1;
> +=A0=A0=A0 u8=A0=A0=A0 orej_retry_supp:1;
> +=A0=A0=A0 u8=A0=A0=A0 config_others:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 configuring:1;
> =A0=A0=A0=A0 u8=A0=A0=A0=A0=A0 conf_route_table:1;
>=20

[Jack Wang] Looks nice to me ,thanks for doing this.
Reviewed-by: Jack Wang <jack_wang@usish.com>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
