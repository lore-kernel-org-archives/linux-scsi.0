From: "jack wang" <jack_wang@usish.com>
Subject: [RFC][PATCH v2] fix wide port hotplug issues
Date: Fri, 17 Jul 2009 16:20:49 +0800
Message-ID: <0CA78CAB92684CE9A090AEB3B871BD20@usish.com.cn>
References: <BB8426D8117A437F9C3D44C89A5E6534@usish.com.cn> <1247776446.6606.393.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001D_01CA06FA.8C7021B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:35739 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934218AbZGQIUy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jul 2009 04:20:54 -0400
In-Reply-To: <1247776446.6606.393.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_001D_01CA06FA.8C7021B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, James
As your comments ,we resend this patch again. All comments & style issue
have fixed.
Best regards!
	
Jack Wang
>From 2b269e6d73fae3a7c83171e97d894fc84798c35a Mon Sep 17 00:00:00 2001
From: Tom Peng <tom_peng@usish.com>
Date: Fri, 17 Jul 2009 16:02:04 +0800
Subject: [PATCH] fix libsas wide port hotplug issue v2

Signed-off-by: Tom Peng <tom_peng@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
Signed-off-by: Kevin Ao <aoqingyun@usish.com>
---
 drivers/scsi/libsas/sas_expander.c |  149
++++++++++++++++++++++++++----------
 1 files changed, 108 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index 54fa1e4..24d108f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -766,6 +766,7 @@ static int sas_ex_join_wide_port(struct domain_device
*parent, int phy_id)
 		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,
 			    SAS_ADDR_SIZE) && ephy->port) {
 			sas_port_add_phy(ephy->port, phy->phy);
+			phy->port = ephy->port;
 			phy->phy_state = PHY_DEVICE_DISCOVERED;
 			return 0;
 		}
@@ -945,10 +946,17 @@ static int sas_ex_discover_dev(struct domain_device
*dev, int phy_id)
 			if (ex->ex_phy[i].phy_state == PHY_VACANT ||
 			    ex->ex_phy[i].phy_state == PHY_NOT_PRESENT)
 				continue;
-
+			/* in before discover process, it does not add the
phy
+			* to wide port, so we add the phy to the wide port
here.
+			*/
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
-			    SAS_ADDR(child->sas_addr))
+			    SAS_ADDR(child->sas_addr)) {
 				ex->ex_phy[i].phy_state=
PHY_DEVICE_DISCOVERED;
+				res = sas_ex_join_wide_port(dev, i);
+				if (!res)
+					SAS_DPRINTK("Add ex phy %d to this "
+						    "wide port.\n", i);
+			}
 		}
 	}
 
@@ -1598,7 +1606,7 @@ static int sas_get_phy_attached_sas_addr(struct
domain_device *dev,
 }
 
 static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
-			      int from_phy)
+			      int from_phy, bool update)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int res = 0;
@@ -1611,7 +1619,9 @@ static int sas_find_bcast_phy(struct domain_device
*dev, int *phy_id,
 		if (res)
 			goto out;
 		else if (phy_change_count != ex->ex_phy[i].phy_change_count)
{
-			ex->ex_phy[i].phy_change_count = phy_change_count;
+			if (update)
+				ex->ex_phy[i].phy_change_count =
+					phy_change_count;
 			*phy_id = i;
 			return 0;
 		}
@@ -1653,31 +1663,52 @@ out:
 	kfree(rg_req);
 	return res;
 }
+/**
+ * sas_find_bcast_dev -  find the device issue BROADCAST(CHANGE).
+ * @dev:domain device to be detect.
+ * @src_dev: the device which originated BROADCAST(CHANGE).
+ *
+ * Add self-configuration expander suport. Suppose two expander cascading,
+ * when the first level expander is self-configuring, hotplug the disks in
+ * second level expander, BROADCAST(CHANGE) will not only be originated
+ * in the second level expander, but also be originated in the first level
+ * expander (see SAS protocol SAS 2r-14, 7.11 for detail), it is to say,
+ * expander changed count in two level expanders will all increment at
least
+ * once, but the phy which chang count has changed is the source device
which
+ * we concerned.
+ */
 
 static int sas_find_bcast_dev(struct domain_device *dev,
 			      struct domain_device **src_dev)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int ex_change_count = -1;
-	int res;
+	int phy_id = -1;
+	int res, i = 0;
+	struct domain_device *ch;
 
 	res = sas_get_ex_change_count(dev, &ex_change_count);
 	if (res)
 		goto out;
-	if (ex_change_count != -1 &&
-	    ex_change_count != ex->ex_change_count) {
-		*src_dev = dev;
-		ex->ex_change_count = ex_change_count;
-	} else {
-		struct domain_device *ch;
-
-		list_for_each_entry(ch, &ex->children, siblings) {
-			if (ch->dev_type == EDGE_DEV ||
-			    ch->dev_type == FANOUT_DEV) {
-				res = sas_find_bcast_dev(ch, src_dev);
-				if (src_dev)
-					return res;
-			}
+	if (ex_change_count != -1 && ex_change_count != ex->ex_change_count)
{
+		/* Just detect if this expander phys phy change count
changed,
+		* in order to determine if this expander originate
BROADCAST,
+		* and do not update phy change count field in our structure.
+		*/
+		res = sas_find_bcast_phy(dev, &phy_id, i, FALSE);
+		if (phy_id != -1) {
+			*src_dev = dev;
+			ex->ex_change_count = ex_change_count;
+			SAS_DPRINTK("Expander phy change count has changed
\n");
+			return res;
+		} else
+			SAS_DPRINTK("Expander phys DID NOT changed \n");
+	}
+	list_for_each_entry(ch, &ex->children, siblings) {
+		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV)
{
+			res = sas_find_bcast_dev(ch, src_dev);
+			if (src_dev)
+				return res;
 		}
 	}
 out:
@@ -1700,24 +1731,26 @@ static void sas_unregister_ex_tree(struct
domain_device *dev)
 }
 
 static void sas_unregister_devs_sas_addr(struct domain_device *parent,
-					 int phy_id)
+					int phy_id, bool last)
 {
 	struct expander_device *ex_dev = &parent->ex_dev;
 	struct ex_phy *phy = &ex_dev->ex_phy[phy_id];
 	struct domain_device *child, *n;
-
-	list_for_each_entry_safe(child, n, &ex_dev->children, siblings) {
-		if (SAS_ADDR(child->sas_addr) ==
-		    SAS_ADDR(phy->attached_sas_addr)) {
-			if (child->dev_type == EDGE_DEV ||
-			    child->dev_type == FANOUT_DEV)
-				sas_unregister_ex_tree(child);
-			else
-				sas_unregister_dev(child);
-			break;
+	if (last) {
+		list_for_each_entry_safe(child, n,
+			&ex_dev->children, siblings) {
+			if (SAS_ADDR(child->sas_addr) ==
+				SAS_ADDR(phy->attached_sas_addr)) {
+				if (child->dev_type == EDGE_DEV ||
+					child->dev_type == FANOUT_DEV)
+					sas_unregister_ex_tree(child);
+				else
+					sas_unregister_dev(child);
+				break;
+			}
 		}
+		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
-	sas_disable_routing(parent, phy->attached_sas_addr);
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	sas_port_delete_phy(phy->port, phy->phy);
 	if (phy->port->num_phys == 0)
@@ -1770,15 +1803,31 @@ static int sas_discover_new(struct domain_device
*dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	int res;
+	bool found = FALSE;
+	int res, i = 0;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
 	res = sas_ex_phy_discover(dev, phy_id);
 	if (res)
 		goto out;
+	/* to support the wide port inserted */
+	for (i = 0; i < dev->ex_dev.num_phys; i++) {
+		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
+		if (i == phy_id)
+			continue;
+		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
+		    SAS_ADDR(ex_phy->attached_sas_addr)) {
+			found = TRUE;
+			break;
+		}
+	}
+	if (found == TRUE) {
+		sas_ex_join_wide_port(dev, phy_id);
+		return 0;
+	}
 	res = sas_ex_discover_devices(dev, phy_id);
-	if (res)
+	if (!res)
 		goto out;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
@@ -1793,7 +1842,8 @@ out:
 	return res;
 }
 
-static int sas_rediscover_dev(struct domain_device *dev, int phy_id)
+static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
+				bool last)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
@@ -1804,11 +1854,11 @@ static int sas_rediscover_dev(struct domain_device
*dev, int phy_id)
 	switch (res) {
 	case SMP_RESP_NO_PHY:
 		phy->phy_state = PHY_NOT_PRESENT;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		goto out; break;
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state = PHY_VACANT;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		goto out; break;
 	case SMP_RESP_FUNC_ACC:
 		break;
@@ -1816,7 +1866,7 @@ static int sas_rediscover_dev(struct domain_device
*dev, int phy_id)
 
 	if (SAS_ADDR(attached_sas_addr) == 0) {
 		phy->phy_state = PHY_EMPTY;
-		sas_unregister_devs_sas_addr(dev, phy_id);
+		sas_unregister_devs_sas_addr(dev, phy_id, last);
 	} else if (SAS_ADDR(attached_sas_addr) ==
 		   SAS_ADDR(phy->attached_sas_addr)) {
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter\n",
@@ -1828,12 +1878,28 @@ out:
 	return res;
 }
 
+/**
+ * sas_rediscover -- revalidate the domain.
+ * @dev:domain device to be detect.
+ * @phy_id: the phy id will be detected.
+ * NOTE: this process _must_ quit (return) as soon as any connection
+ * errors are encountered.  Connection recovery is done elsewhere.
+ * Discover process only interrogates devices in order to discover the
+ * domain.For plugging out, we un-register the device only when it is
+ * the last phy in the port, for other phys in this port, we just delete it
+ * from the port.For inserting, we do discovery when it is the
+ * first phy,for other phys in this port, we add it to the port to
+ * forming the wide-port.
+ */
 static int sas_rediscover(struct domain_device *dev, const int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
 	int res = 0;
 	int i;
+	/* To check whether the last phy of a port determining whether or
not
+	delete devices*/
+	bool last = TRUE;
 
 	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
@@ -1848,13 +1914,13 @@ static int sas_rediscover(struct domain_device *dev,
const int phy_id)
 			    SAS_ADDR(changed_phy->attached_sas_addr)) {
 				SAS_DPRINTK("phy%d part of wide port with "
 					    "phy%d\n", phy_id, i);
-				goto out;
+				last = FALSE;
+				break;
 			}
 		}
-		res = sas_rediscover_dev(dev, phy_id);
+		res = sas_rediscover_dev(dev, phy_id, last);
 	} else
 		res = sas_discover_new(dev, phy_id);
-out:
 	return res;
 }
 
@@ -1881,7 +1947,7 @@ int sas_ex_revalidate_domain(struct domain_device
*port_dev)
 
 		do {
 			phy_id = -1;
-			res = sas_find_bcast_phy(dev, &phy_id, i);
+			res = sas_find_bcast_phy(dev, &phy_id, i, TRUE);
 			if (phy_id == -1)
 				break;
 			res = sas_rediscover(dev, phy_id);
@@ -1946,3 +2012,4 @@ int sas_smp_handler(struct Scsi_Host *shost, struct
sas_rphy *rphy,
 
 	return ret;
 }
+
-- 
1.6.3.msysgit.0


------=_NextPart_000_001D_01CA06FA.8C7021B0
Content-Type: application/octet-stream;
	name="0001-fix-libsas-wide-port-hotplug-issue-v2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-fix-libsas-wide-port-hotplug-issue-v2.patch"

>From 2b269e6d73fae3a7c83171e97d894fc84798c35a Mon Sep 17 00:00:00 2001=0A=
From: Tom Peng <tom_peng@usish.com>=0A=
Date: Fri, 17 Jul 2009 16:02:04 +0800=0A=
Subject: [PATCH] fix libsas wide port hotplug issue v2=0A=
=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
Signed-off-by: Kevin Ao <aoqingyun@usish.com>=0A=
---=0A=
 drivers/scsi/libsas/sas_expander.c |  149 =
++++++++++++++++++++++++++----------=0A=
 1 files changed, 108 insertions(+), 41 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/libsas/sas_expander.c =
b/drivers/scsi/libsas/sas_expander.c=0A=
index 54fa1e4..24d108f 100644=0A=
--- a/drivers/scsi/libsas/sas_expander.c=0A=
+++ b/drivers/scsi/libsas/sas_expander.c=0A=
@@ -766,6 +766,7 @@ static int sas_ex_join_wide_port(struct =
domain_device *parent, int phy_id)=0A=
 		if (!memcmp(phy->attached_sas_addr, ephy->attached_sas_addr,=0A=
 			    SAS_ADDR_SIZE) && ephy->port) {=0A=
 			sas_port_add_phy(ephy->port, phy->phy);=0A=
+			phy->port =3D ephy->port;=0A=
 			phy->phy_state =3D PHY_DEVICE_DISCOVERED;=0A=
 			return 0;=0A=
 		}=0A=
@@ -945,10 +946,17 @@ static int sas_ex_discover_dev(struct =
domain_device *dev, int phy_id)=0A=
 			if (ex->ex_phy[i].phy_state =3D=3D PHY_VACANT ||=0A=
 			    ex->ex_phy[i].phy_state =3D=3D PHY_NOT_PRESENT)=0A=
 				continue;=0A=
-=0A=
+			/* in before discover process, it does not add the phy=0A=
+			* to wide port, so we add the phy to the wide port here.=0A=
+			*/=0A=
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) =3D=3D=0A=
-			    SAS_ADDR(child->sas_addr))=0A=
+			    SAS_ADDR(child->sas_addr)) {=0A=
 				ex->ex_phy[i].phy_state=3D PHY_DEVICE_DISCOVERED;=0A=
+				res =3D sas_ex_join_wide_port(dev, i);=0A=
+				if (!res)=0A=
+					SAS_DPRINTK("Add ex phy %d to this "=0A=
+						    "wide port.\n", i);=0A=
+			}=0A=
 		}=0A=
 	}=0A=
 =0A=
@@ -1598,7 +1606,7 @@ static int sas_get_phy_attached_sas_addr(struct =
domain_device *dev,=0A=
 }=0A=
 =0A=
 static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,=0A=
-			      int from_phy)=0A=
+			      int from_phy, bool update)=0A=
 {=0A=
 	struct expander_device *ex =3D &dev->ex_dev;=0A=
 	int res =3D 0;=0A=
@@ -1611,7 +1619,9 @@ static int sas_find_bcast_phy(struct domain_device =
*dev, int *phy_id,=0A=
 		if (res)=0A=
 			goto out;=0A=
 		else if (phy_change_count !=3D ex->ex_phy[i].phy_change_count) {=0A=
-			ex->ex_phy[i].phy_change_count =3D phy_change_count;=0A=
+			if (update)=0A=
+				ex->ex_phy[i].phy_change_count =3D=0A=
+					phy_change_count;=0A=
 			*phy_id =3D i;=0A=
 			return 0;=0A=
 		}=0A=
@@ -1653,31 +1663,52 @@ out:=0A=
 	kfree(rg_req);=0A=
 	return res;=0A=
 }=0A=
+/**=0A=
+ * sas_find_bcast_dev -  find the device issue BROADCAST(CHANGE).=0A=
+ * @dev:domain device to be detect.=0A=
+ * @src_dev: the device which originated BROADCAST(CHANGE).=0A=
+ *=0A=
+ * Add self-configuration expander suport. Suppose two expander =
cascading,=0A=
+ * when the first level expander is self-configuring, hotplug the disks =
in=0A=
+ * second level expander, BROADCAST(CHANGE) will not only be originated=0A=
+ * in the second level expander, but also be originated in the first =
level=0A=
+ * expander (see SAS protocol SAS 2r-14, 7.11 for detail), it is to say,=0A=
+ * expander changed count in two level expanders will all increment at =
least=0A=
+ * once, but the phy which chang count has changed is the source device =
which=0A=
+ * we concerned.=0A=
+ */=0A=
 =0A=
 static int sas_find_bcast_dev(struct domain_device *dev,=0A=
 			      struct domain_device **src_dev)=0A=
 {=0A=
 	struct expander_device *ex =3D &dev->ex_dev;=0A=
 	int ex_change_count =3D -1;=0A=
-	int res;=0A=
+	int phy_id =3D -1;=0A=
+	int res, i =3D 0;=0A=
+	struct domain_device *ch;=0A=
 =0A=
 	res =3D sas_get_ex_change_count(dev, &ex_change_count);=0A=
 	if (res)=0A=
 		goto out;=0A=
-	if (ex_change_count !=3D -1 &&=0A=
-	    ex_change_count !=3D ex->ex_change_count) {=0A=
-		*src_dev =3D dev;=0A=
-		ex->ex_change_count =3D ex_change_count;=0A=
-	} else {=0A=
-		struct domain_device *ch;=0A=
-=0A=
-		list_for_each_entry(ch, &ex->children, siblings) {=0A=
-			if (ch->dev_type =3D=3D EDGE_DEV ||=0A=
-			    ch->dev_type =3D=3D FANOUT_DEV) {=0A=
-				res =3D sas_find_bcast_dev(ch, src_dev);=0A=
-				if (src_dev)=0A=
-					return res;=0A=
-			}=0A=
+	if (ex_change_count !=3D -1 && ex_change_count !=3D =
ex->ex_change_count) {=0A=
+		/* Just detect if this expander phys phy change count changed,=0A=
+		* in order to determine if this expander originate BROADCAST,=0A=
+		* and do not update phy change count field in our structure.=0A=
+		*/=0A=
+		res =3D sas_find_bcast_phy(dev, &phy_id, i, FALSE);=0A=
+		if (phy_id !=3D -1) {=0A=
+			*src_dev =3D dev;=0A=
+			ex->ex_change_count =3D ex_change_count;=0A=
+			SAS_DPRINTK("Expander phy change count has changed \n");=0A=
+			return res;=0A=
+		} else=0A=
+			SAS_DPRINTK("Expander phys DID NOT changed \n");=0A=
+	}=0A=
+	list_for_each_entry(ch, &ex->children, siblings) {=0A=
+		if (ch->dev_type =3D=3D EDGE_DEV || ch->dev_type =3D=3D FANOUT_DEV) {=0A=
+			res =3D sas_find_bcast_dev(ch, src_dev);=0A=
+			if (src_dev)=0A=
+				return res;=0A=
 		}=0A=
 	}=0A=
 out:=0A=
@@ -1700,24 +1731,26 @@ static void sas_unregister_ex_tree(struct =
domain_device *dev)=0A=
 }=0A=
 =0A=
 static void sas_unregister_devs_sas_addr(struct domain_device *parent,=0A=
-					 int phy_id)=0A=
+					int phy_id, bool last)=0A=
 {=0A=
 	struct expander_device *ex_dev =3D &parent->ex_dev;=0A=
 	struct ex_phy *phy =3D &ex_dev->ex_phy[phy_id];=0A=
 	struct domain_device *child, *n;=0A=
-=0A=
-	list_for_each_entry_safe(child, n, &ex_dev->children, siblings) {=0A=
-		if (SAS_ADDR(child->sas_addr) =3D=3D=0A=
-		    SAS_ADDR(phy->attached_sas_addr)) {=0A=
-			if (child->dev_type =3D=3D EDGE_DEV ||=0A=
-			    child->dev_type =3D=3D FANOUT_DEV)=0A=
-				sas_unregister_ex_tree(child);=0A=
-			else=0A=
-				sas_unregister_dev(child);=0A=
-			break;=0A=
+	if (last) {=0A=
+		list_for_each_entry_safe(child, n,=0A=
+			&ex_dev->children, siblings) {=0A=
+			if (SAS_ADDR(child->sas_addr) =3D=3D=0A=
+				SAS_ADDR(phy->attached_sas_addr)) {=0A=
+				if (child->dev_type =3D=3D EDGE_DEV ||=0A=
+					child->dev_type =3D=3D FANOUT_DEV)=0A=
+					sas_unregister_ex_tree(child);=0A=
+				else=0A=
+					sas_unregister_dev(child);=0A=
+				break;=0A=
+			}=0A=
 		}=0A=
+		sas_disable_routing(parent, phy->attached_sas_addr);=0A=
 	}=0A=
-	sas_disable_routing(parent, phy->attached_sas_addr);=0A=
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);=0A=
 	sas_port_delete_phy(phy->port, phy->phy);=0A=
 	if (phy->port->num_phys =3D=3D 0)=0A=
@@ -1770,15 +1803,31 @@ static int sas_discover_new(struct domain_device =
*dev, int phy_id)=0A=
 {=0A=
 	struct ex_phy *ex_phy =3D &dev->ex_dev.ex_phy[phy_id];=0A=
 	struct domain_device *child;=0A=
-	int res;=0A=
+	bool found =3D FALSE;=0A=
+	int res, i =3D 0;=0A=
 =0A=
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",=0A=
 		    SAS_ADDR(dev->sas_addr), phy_id);=0A=
 	res =3D sas_ex_phy_discover(dev, phy_id);=0A=
 	if (res)=0A=
 		goto out;=0A=
+	/* to support the wide port inserted */=0A=
+	for (i =3D 0; i < dev->ex_dev.num_phys; i++) {=0A=
+		struct ex_phy *ex_phy_temp =3D &dev->ex_dev.ex_phy[i];=0A=
+		if (i =3D=3D phy_id)=0A=
+			continue;=0A=
+		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) =3D=3D=0A=
+		    SAS_ADDR(ex_phy->attached_sas_addr)) {=0A=
+			found =3D TRUE;=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	if (found =3D=3D TRUE) {=0A=
+		sas_ex_join_wide_port(dev, phy_id);=0A=
+		return 0;=0A=
+	}=0A=
 	res =3D sas_ex_discover_devices(dev, phy_id);=0A=
-	if (res)=0A=
+	if (!res)=0A=
 		goto out;=0A=
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {=0A=
 		if (SAS_ADDR(child->sas_addr) =3D=3D=0A=
@@ -1793,7 +1842,8 @@ out:=0A=
 	return res;=0A=
 }=0A=
 =0A=
-static int sas_rediscover_dev(struct domain_device *dev, int phy_id)=0A=
+static int sas_rediscover_dev(struct domain_device *dev, int phy_id,=0A=
+				bool last)=0A=
 {=0A=
 	struct expander_device *ex =3D &dev->ex_dev;=0A=
 	struct ex_phy *phy =3D &ex->ex_phy[phy_id];=0A=
@@ -1804,11 +1854,11 @@ static int sas_rediscover_dev(struct =
domain_device *dev, int phy_id)=0A=
 	switch (res) {=0A=
 	case SMP_RESP_NO_PHY:=0A=
 		phy->phy_state =3D PHY_NOT_PRESENT;=0A=
-		sas_unregister_devs_sas_addr(dev, phy_id);=0A=
+		sas_unregister_devs_sas_addr(dev, phy_id, last);=0A=
 		goto out; break;=0A=
 	case SMP_RESP_PHY_VACANT:=0A=
 		phy->phy_state =3D PHY_VACANT;=0A=
-		sas_unregister_devs_sas_addr(dev, phy_id);=0A=
+		sas_unregister_devs_sas_addr(dev, phy_id, last);=0A=
 		goto out; break;=0A=
 	case SMP_RESP_FUNC_ACC:=0A=
 		break;=0A=
@@ -1816,7 +1866,7 @@ static int sas_rediscover_dev(struct domain_device =
*dev, int phy_id)=0A=
 =0A=
 	if (SAS_ADDR(attached_sas_addr) =3D=3D 0) {=0A=
 		phy->phy_state =3D PHY_EMPTY;=0A=
-		sas_unregister_devs_sas_addr(dev, phy_id);=0A=
+		sas_unregister_devs_sas_addr(dev, phy_id, last);=0A=
 	} else if (SAS_ADDR(attached_sas_addr) =3D=3D=0A=
 		   SAS_ADDR(phy->attached_sas_addr)) {=0A=
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter\n",=0A=
@@ -1828,12 +1878,28 @@ out:=0A=
 	return res;=0A=
 }=0A=
 =0A=
+/**=0A=
+ * sas_rediscover -- revalidate the domain.=0A=
+ * @dev:domain device to be detect.=0A=
+ * @phy_id: the phy id will be detected.=0A=
+ * NOTE: this process _must_ quit (return) as soon as any connection=0A=
+ * errors are encountered.  Connection recovery is done elsewhere.=0A=
+ * Discover process only interrogates devices in order to discover the=0A=
+ * domain.For plugging out, we un-register the device only when it is=0A=
+ * the last phy in the port, for other phys in this port, we just =
delete it=0A=
+ * from the port.For inserting, we do discovery when it is the=0A=
+ * first phy,for other phys in this port, we add it to the port to=0A=
+ * forming the wide-port.=0A=
+ */=0A=
 static int sas_rediscover(struct domain_device *dev, const int phy_id)=0A=
 {=0A=
 	struct expander_device *ex =3D &dev->ex_dev;=0A=
 	struct ex_phy *changed_phy =3D &ex->ex_phy[phy_id];=0A=
 	int res =3D 0;=0A=
 	int i;=0A=
+	/* To check whether the last phy of a port determining whether or not=0A=
+	delete devices*/=0A=
+	bool last =3D TRUE;=0A=
 =0A=
 	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",=0A=
 		    SAS_ADDR(dev->sas_addr), phy_id);=0A=
@@ -1848,13 +1914,13 @@ static int sas_rediscover(struct domain_device =
*dev, const int phy_id)=0A=
 			    SAS_ADDR(changed_phy->attached_sas_addr)) {=0A=
 				SAS_DPRINTK("phy%d part of wide port with "=0A=
 					    "phy%d\n", phy_id, i);=0A=
-				goto out;=0A=
+				last =3D FALSE;=0A=
+				break;=0A=
 			}=0A=
 		}=0A=
-		res =3D sas_rediscover_dev(dev, phy_id);=0A=
+		res =3D sas_rediscover_dev(dev, phy_id, last);=0A=
 	} else=0A=
 		res =3D sas_discover_new(dev, phy_id);=0A=
-out:=0A=
 	return res;=0A=
 }=0A=
 =0A=
@@ -1881,7 +1947,7 @@ int sas_ex_revalidate_domain(struct domain_device =
*port_dev)=0A=
 =0A=
 		do {=0A=
 			phy_id =3D -1;=0A=
-			res =3D sas_find_bcast_phy(dev, &phy_id, i);=0A=
+			res =3D sas_find_bcast_phy(dev, &phy_id, i, TRUE);=0A=
 			if (phy_id =3D=3D -1)=0A=
 				break;=0A=
 			res =3D sas_rediscover(dev, phy_id);=0A=
@@ -1946,3 +2012,4 @@ int sas_smp_handler(struct Scsi_Host *shost, =
struct sas_rphy *rphy,=0A=
 =0A=
 	return ret;=0A=
 }=0A=
+=0A=
-- =0A=
1.6.3.msysgit.0=0A=
=0A=

------=_NextPart_000_001D_01CA06FA.8C7021B0--

