From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] libsas fixes for 3.1-rc
Date: Wed, 28 Sep 2011 19:10:14 -0700
Message-ID: <1317262215.22593.22.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1I2CKQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 22:10:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

The following changes since commit 96067723e46b0dd24ae7b934085ab4eff4d2=
6a1b:

  [SCSI] 3w-9xxx: fix iommu_iova leak (2011-09-26 09:28:58 -0500)

are available in the git repository at:
  git://github.com/djbw/linux.git libsas-fixes

If there are going to be anymore scsi pulls for 3.1-rc here are some
collected candidates.  All of these have been on the list previously.

Dan Williams (2):
      libsas: fix warnings when checking sata/stp protocol
      libsas: fix port->dev_list locking

Jack Wang (1):
      libsas: set rphy sas_address and device type correctly

Luben Tuikov (1):
      libsas: Allow expander T-T attachments

 drivers/scsi/libsas/sas_discover.c |   13 +++++++----
 drivers/scsi/libsas/sas_expander.c |   37 ++++++++++++++++++++++++----=
-------
 include/scsi/libsas.h              |    5 +++-
 include/scsi/sas.h                 |   15 ++++++++++++-
 4 files changed, 50 insertions(+), 20 deletions(-)

commit 339484f5e5a726a26188ca6cb10dca864d0c4b2f
Author: Jack Wang <jack_wang@usish.com>
Date:   Sat Sep 24 09:47:23 2011 +0000

    libsas: set rphy sas_address and device type correctly
   =20
    Before:
    # cat /sys/class/sas_phy/phy-6\:0\:6/device_type
    none
    # cat /sys/class/sas_phy/phy-6\:0\:6/sas_address
    0x0000000000000000
   =20
    After:
    # cat /sys/class/sas_phy/phy-6\:0\:6/device_type
    end device
    # cat /sys/class/sas_phy/phy-6\:0\:6/sas_address
    0x500000e0191ce732
   =20
    Signed-off-by: Jack Wang <jack_wang@usish.com>
    Tested-by: Crystal Yu <crystal_yu@usish.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0051c3753833995b4e26be70033d9ba8e2e89de9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 07:47:16 2011 +0000

    libsas: fix port->dev_list locking
   =20
    port->dev_list maintains a list of devices attached to a given sas =
root port.
    It needs to be mutated under a lock as contexts outside of the
    single-threaded-libsas-workqueue access the list via sas_find_dev_b=
y_rphy().
    Fixup locations where the list was being mutated without a lock.
   =20
    This is a follow-up to commit 5911e963 "[SCSI] libsas: remove expan=
der
    from dev list on error", where Luben noted [1]:
   =20
        > 2/ We have unlocked list manipulations in sas_ex_discover_end=
_dev(),
        > sas_unregister_common_dev(), and sas_ex_discover_end_dev()
   =20
        Yes, I can see that and that is very unfortunate.
   =20
    [1]: http://marc.info/?l=3Dlinux-scsi&m=3D131480962006471&w=3D2
   =20
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
    Cc: Luben Tuikov <ltuikov@yahoo.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3c6006693b1e5e4a8c7f19623092dee95a377916
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Sep 24 09:07:38 2011 +0000

    libsas: fix warnings when checking sata/stp protocol
   =20
    Several sas drivers legitimately check the protocol against the uni=
on of
    SAS_PROTOCOL_SATA and SAS_PROTOCOL_STP.  Provide a SAS_PROTOCOL_STP=
_ALL
    to silence warnings like:
   =20
    drivers/scsi/pm8001/pm8001_sas.c:438:3: warning: case value =E2=80=98=
5=E2=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [=
-Wswitch]
    drivers/scsi/mvsas/mv_sas.c:798:2: warning: case value =E2=80=985=E2=
=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wsw=
itch]
    drivers/scsi/mvsas/mv_sas.c:1783:2: warning: case value =E2=80=985=E2=
=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wsw=
itch]
    drivers/scsi/mvsas/mv_sas.c:1886:2: warning: case value =E2=80=985=E2=
=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wsw=
itch]
    drivers/scsi/isci/request.c:3565:2: warning: case value =E2=80=985=E2=
=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wsw=
itch]
   =20
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Jack Wang <jack_wang@usish.com>

commit ef6be00f9fc3351beb3ceb9e7117f6f036f0f64e
Author: Luben Tuikov <ltuikov@yahoo.com>
Date:   Sat Sep 24 09:02:13 2011 +0000

    libsas: Allow expander T-T attachments
   =20
    Allow expander table-to-table attachments for
    expanders that support it.
   =20
    Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
    Acked-by: Jack Wang <jack_wang@usish.com>


diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/s=
as_discover.c
index f583193..54a5199 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -219,17 +219,20 @@ out_err2:
=20
 /* ---------- Device registration and unregistration ---------- */
=20
-static inline void sas_unregister_common_dev(struct domain_device *dev=
)
+static void sas_unregister_common_dev(struct asd_sas_port *port, struc=
t domain_device *dev)
 {
 	sas_notify_lldd_dev_gone(dev);
 	if (!dev->parent)
 		dev->port->port_dev =3D NULL;
 	else
 		list_del_init(&dev->siblings);
+
+	spin_lock_irq(&port->dev_list_lock);
 	list_del_init(&dev->dev_list_node);
+	spin_unlock_irq(&port->dev_list_lock);
 }
=20
-void sas_unregister_dev(struct domain_device *dev)
+void sas_unregister_dev(struct asd_sas_port *port, struct domain_devic=
e *dev)
 {
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
@@ -241,15 +244,15 @@ void sas_unregister_dev(struct domain_device *dev=
)
 		kfree(dev->ex_dev.ex_phy);
 		dev->ex_dev.ex_phy =3D NULL;
 	}
-	sas_unregister_common_dev(dev);
+	sas_unregister_common_dev(port, dev);
 }
=20
 void sas_unregister_domain_devices(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
=20
-	list_for_each_entry_safe_reverse(dev,n,&port->dev_list,dev_list_node)
-		sas_unregister_dev(dev);
+	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_no=
de)
+		sas_unregister_dev(port, dev);
=20
 	port->port->rphy =3D NULL;
=20
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/s=
as_expander.c
index c9e3dc0..7fbb7c5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -199,6 +199,8 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
 	phy->virtual =3D dr->virtual;
 	phy->last_da_index =3D -1;
=20
+	phy->phy->identify.sas_address =3D SAS_ADDR(phy->attached_sas_addr);
+	phy->phy->identify.device_type =3D phy->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols =3D phy->attached_iproto;
 	phy->phy->identify.target_port_protocols =3D phy->attached_tproto;
 	phy->phy->identify.phy_identifier =3D phy_id;
@@ -329,6 +331,7 @@ static void ex_assign_report_general(struct domain_=
device *dev,
 	dev->ex_dev.ex_change_count =3D be16_to_cpu(rg->change_count);
 	dev->ex_dev.max_route_indexes =3D be16_to_cpu(rg->route_indexes);
 	dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
+	dev->ex_dev.t2t_supp =3D rg->t2t_supp;
 	dev->ex_dev.conf_route_table =3D rg->conf_route_table;
 	dev->ex_dev.configuring =3D rg->configuring;
 	memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_logical_id, 8)=
;
@@ -751,7 +754,10 @@ static struct domain_device *sas_ex_discover_end_d=
ev(
  out_list_del:
 	sas_rphy_free(child->rphy);
 	child->rphy =3D NULL;
+
+	spin_lock_irq(&parent->port->dev_list_lock);
 	list_del(&child->dev_list_node);
+	spin_unlock_irq(&parent->port->dev_list_lock);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
@@ -1133,15 +1139,17 @@ static void sas_print_parent_topology_bug(struc=
t domain_device *child,
 	};
 	struct domain_device *parent =3D child->parent;
=20
-	sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x "
-		   "has %c:%c routing link!\n",
+	sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx "
+		   "(T2T supp:%d) phy 0x%x has %c:%c routing link!\n",
=20
 		   ex_type[parent->dev_type],
 		   SAS_ADDR(parent->sas_addr),
+		   parent->ex_dev.t2t_supp,
 		   parent_phy->phy_id,
=20
 		   ex_type[child->dev_type],
 		   SAS_ADDR(child->sas_addr),
+		   child->ex_dev.t2t_supp,
 		   child_phy->phy_id,
=20
 		   ra_char[parent_phy->routing_attr],
@@ -1238,10 +1246,15 @@ static int sas_check_parent_topology(struct dom=
ain_device *child)
 					sas_print_parent_topology_bug(child, parent_phy, child_phy);
 					res =3D -ENODEV;
 				}
-			} else if (parent_phy->routing_attr =3D=3D TABLE_ROUTING &&
-				   child_phy->routing_attr !=3D SUBTRACTIVE_ROUTING) {
-				sas_print_parent_topology_bug(child, parent_phy, child_phy);
-				res =3D -ENODEV;
+			} else if (parent_phy->routing_attr =3D=3D TABLE_ROUTING) {
+				if (child_phy->routing_attr =3D=3D SUBTRACTIVE_ROUTING ||
+				    (child_phy->routing_attr =3D=3D TABLE_ROUTING &&
+				     child_ex->t2t_supp && parent_ex->t2t_supp)) {
+					/* All good */;
+				} else {
+					sas_print_parent_topology_bug(child, parent_phy, child_phy);
+					res =3D -ENODEV;
+				}
 			}
 			break;
 		case FANOUT_DEV:
@@ -1729,7 +1742,7 @@ out:
 	return res;
 }
=20
-static void sas_unregister_ex_tree(struct domain_device *dev)
+static void sas_unregister_ex_tree(struct asd_sas_port *port, struct d=
omain_device *dev)
 {
 	struct expander_device *ex =3D &dev->ex_dev;
 	struct domain_device *child, *n;
@@ -1738,11 +1751,11 @@ static void sas_unregister_ex_tree(struct domai=
n_device *dev)
 		child->gone =3D 1;
 		if (child->dev_type =3D=3D EDGE_DEV ||
 		    child->dev_type =3D=3D FANOUT_DEV)
-			sas_unregister_ex_tree(child);
+			sas_unregister_ex_tree(port, child);
 		else
-			sas_unregister_dev(child);
+			sas_unregister_dev(port, child);
 	}
-	sas_unregister_dev(dev);
+	sas_unregister_dev(port, dev);
 }
=20
 static void sas_unregister_devs_sas_addr(struct domain_device *parent,
@@ -1759,9 +1772,9 @@ static void sas_unregister_devs_sas_addr(struct d=
omain_device *parent,
 				child->gone =3D 1;
 				if (child->dev_type =3D=3D EDGE_DEV ||
 				    child->dev_type =3D=3D FANOUT_DEV)
-					sas_unregister_ex_tree(child);
+					sas_unregister_ex_tree(parent->port, child);
 				else
-					sas_unregister_dev(child);
+					sas_unregister_dev(parent->port, child);
 				break;
 			}
 		}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ee86606..67be7f5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -142,8 +142,11 @@ struct expander_device {
 	u16    ex_change_count;
 	u16    max_route_indexes;
 	u8     num_phys;
+
+	u8     t2t_supp:1;
 	u8     configuring:1;
 	u8     conf_route_table:1;
+
 	u8     enclosure_logical_id[8];
=20
 	struct ex_phy *ex_phy;
@@ -652,7 +655,7 @@ int  sas_discover_event(struct asd_sas_port *, enum=
 discover_event ev);
 int  sas_discover_sata(struct domain_device *);
 int  sas_discover_end_dev(struct domain_device *);
=20
-void sas_unregister_dev(struct domain_device *);
+void sas_unregister_dev(struct asd_sas_port *port, struct domain_devic=
e *);
=20
 void sas_init_dev(struct domain_device *);
=20
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index e9fd022..3a00297 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -108,6 +108,7 @@ enum sas_protocol {
 	SAS_PROTOCOL_STP		=3D 0x04,
 	SAS_PROTOCOL_SSP		=3D 0x08,
 	SAS_PROTOCOL_ALL		=3D 0x0E,
+	SAS_PROTOCOL_STP_ALL		=3D SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA,
 };
=20
 /* From the spec; local phys only */
@@ -341,7 +342,12 @@ struct report_general_resp {
=20
 	u8      conf_route_table:1;
 	u8      configuring:1;
-	u8      _r_b:6;
+	u8      config_others:1;
+	u8      orej_retry_supp:1;
+	u8      stp_cont_awt:1;
+	u8      self_config:1;
+	u8      zone_config:1;
+	u8      t2t_supp:1;
=20
 	u8      _r_c;
=20
@@ -528,7 +534,12 @@ struct report_general_resp {
 	u8      _r_a;
 	u8      num_phys;
=20
-	u8      _r_b:6;
+	u8      t2t_supp:1;
+	u8      zone_config:1;
+	u8      self_config:1;
+	u8      stp_cont_awt:1;
+	u8      orej_retry_supp:1;
+	u8      config_others:1;
 	u8      configuring:1;
 	u8      conf_route_table:1;
=20


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
