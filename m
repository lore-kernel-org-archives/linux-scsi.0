From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 16/24] mpt fusion: [2.6.30-rc6] Deleted functions for SAS topology scan changes, expander events, link status events added
Date: Fri, 22 May 2009 16:36:50 +0530
Message-ID: <20090522110641.GJ16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:39584 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZEVL1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:27:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Fuctions which are not used are removed by this patch.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 556f2f9..107fae5 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -348,20 +348,6 @@ static inline MPT_ADAPTER *rphy_to_ioc(struct sas_rphy *rphy)
 	return ((MPT_SCSI_HOST *)shost->hostdata)->ioc;
 }
 
-static struct mptsas_portinfo *
-mptsas_get_hba_portinfo(MPT_ADAPTER *ioc)
-{
-	struct list_head	*head = &ioc->sas_topology;
-	struct mptsas_portinfo	*pi = NULL;
-
-	/* always the first entry on sas_topology list */
-
-	if (!list_empty(head))
-		pi = list_entry(head->next, struct mptsas_portinfo, list);
-
-	return pi;
-}
-
 /*
  * mptsas_find_portinfo_by_handle
  *
@@ -2816,182 +2802,6 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 	return error;
 }
 
-static int
-mptsas_probe_expander_phys(MPT_ADAPTER *ioc, u32 *handle)
-{
-	struct mptsas_portinfo *port_info, *p, *ex;
-	struct device *parent;
-	struct sas_rphy *rphy;
-	int error = -ENOMEM, i, j;
-
-	ex = kzalloc(sizeof(*port_info), GFP_KERNEL);
-	if (!ex)
-		goto out;
-
-	error = mptsas_sas_expander_pg0(ioc, ex,
-	    (MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
-	     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), *handle);
-	if (error)
-		goto out_free_port_info;
-
-	*handle = ex->phy_info[0].handle;
-
-	mutex_lock(&ioc->sas_topology_mutex);
-	port_info = mptsas_find_portinfo_by_handle(ioc, *handle);
-	if (!port_info) {
-		port_info = ex;
-		list_add_tail(&port_info->list, &ioc->sas_topology);
-	} else {
-		for (i = 0; i < ex->num_phys; i++) {
-			port_info->phy_info[i].handle =
-				ex->phy_info[i].handle;
-			port_info->phy_info[i].port_id =
-				ex->phy_info[i].port_id;
-		}
-		kfree(ex->phy_info);
-		kfree(ex);
-		ex = NULL;
-	}
-	mutex_unlock(&ioc->sas_topology_mutex);
-
-	for (i = 0; i < port_info->num_phys; i++) {
-		mptsas_sas_expander_pg1(ioc, &port_info->phy_info[i],
-			(MPI_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM <<
-			 MPI_SAS_EXPAND_PGAD_FORM_SHIFT), (i << 16) + *handle);
-
-		if (port_info->phy_info[i].identify.handle) {
-			mptsas_sas_device_pg0(ioc,
-				&port_info->phy_info[i].identify,
-				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
-				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-				port_info->phy_info[i].identify.handle);
-			port_info->phy_info[i].identify.phy_id =
-			    port_info->phy_info[i].phy_id;
-		}
-
-		if (port_info->phy_info[i].attached.handle) {
-			mptsas_sas_device_pg0(ioc,
-				&port_info->phy_info[i].attached,
-				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
-				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-				port_info->phy_info[i].attached.handle);
-			port_info->phy_info[i].attached.phy_id =
-			    port_info->phy_info[i].phy_id;
-		}
-	}
-
-	parent = &ioc->sh->shost_gendev;
-	for (i = 0; i < port_info->num_phys; i++) {
-		mutex_lock(&ioc->sas_topology_mutex);
-		list_for_each_entry(p, &ioc->sas_topology, list) {
-			for (j = 0; j < p->num_phys; j++) {
-				if (port_info->phy_info[i].identify.handle !=
-						p->phy_info[j].attached.handle)
-					continue;
-				rphy = mptsas_get_rphy(&p->phy_info[j]);
-				parent = &rphy->dev;
-			}
-		}
-		mutex_unlock(&ioc->sas_topology_mutex);
-	}
-
-	mptsas_setup_wide_ports(ioc, port_info);
-
-	for (i = 0; i < port_info->num_phys; i++, ioc->sas_index++)
-		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
-		    ioc->sas_index, 0);
-
-	return 0;
-
- out_free_port_info:
-	if (ex) {
-		kfree(ex->phy_info);
-		kfree(ex);
-	}
- out:
-	return error;
-}
-
-/*
- * mptsas_delete_expander_phys
- *
- *
- * This will traverse topology, and remove expanders
- * that are no longer present
- */
-static void
-mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
-{
-	struct mptsas_portinfo buffer;
-	struct mptsas_portinfo *port_info, *n, *parent;
-	struct mptsas_phyinfo *phy_info;
-	struct sas_port * port;
-	int i;
-	u64	expander_sas_address;
-
-	mutex_lock(&ioc->sas_topology_mutex);
-	list_for_each_entry_safe(port_info, n, &ioc->sas_topology, list) {
-
-		if (!(port_info->phy_info[0].identify.device_info &
-		    MPI_SAS_DEVICE_INFO_SMP_TARGET))
-			continue;
-
-		if (mptsas_sas_expander_pg0(ioc, &buffer,
-		     (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
-		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
-		     port_info->phy_info[0].handle)) {
-
-			/*
-			 * Obtain the port_info instance to the parent port
-			 */
-			parent = mptsas_find_portinfo_by_handle(ioc,
-			    port_info->phy_info[0].identify.handle_parent);
-
-			if (!parent)
-				goto next_port;
-
-			expander_sas_address =
-				port_info->phy_info[0].identify.sas_address;
-
-			/*
-			 * Delete rphys in the parent that point
-			 * to this expander.  The transport layer will
-			 * cleanup all the children.
-			 */
-			phy_info = parent->phy_info;
-			for (i = 0; i < parent->num_phys; i++, phy_info++) {
-				port = mptsas_get_port(phy_info);
-				if (!port)
-					continue;
-				if (phy_info->attached.sas_address !=
-					expander_sas_address)
-					continue;
-				dsaswideprintk(ioc,
-				    dev_printk(KERN_DEBUG, &port->dev,
-				    MYIOC_s_FMT "delete port (%d)\n", ioc->name,
-				    port->port_identifier));
-				sas_port_delete(port);
-				mptsas_port_delete(ioc, phy_info->port_details);
-			}
- next_port:
-
-			phy_info = port_info->phy_info;
-			for (i = 0; i < port_info->num_phys; i++, phy_info++)
-				mptsas_port_delete(ioc, phy_info->port_details);
-
-			list_del(&port_info->list);
-			kfree(port_info->phy_info);
-			kfree(port_info);
-		}
-		/*
-		* Free this memory allocated from inside
-		* mptsas_sas_expander_pg0
-		*/
-		kfree(buffer.phy_info);
-	}
-	mutex_unlock(&ioc->sas_topology_mutex);
-}
-
 static void
 mptsas_expander_refresh(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 {
@@ -3484,43 +3294,6 @@ mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 	}
 }
 
-/*
- * Work queue thread to handle Runtime discovery
- * Mere purpose is the hot add/delete of expanders
- *(Mutex UNLOCKED)
- */
-static void
-__mptsas_discovery_work(MPT_ADAPTER *ioc)
-{
-	u32 handle = 0xFFFF;
-
-	ioc->sas_discovery_runtime=1;
-	mptsas_delete_expander_phys(ioc);
-	mptsas_probe_hba_phys(ioc);
-	while (!mptsas_probe_expander_phys(ioc, &handle))
-		;
-	ioc->sas_discovery_runtime=0;
-}
-
-/*
- * Work queue thread to handle Runtime discovery
- * Mere purpose is the hot add/delete of expanders
- *(Mutex LOCKED)
- */
-static void
-mptsas_discovery_work(struct work_struct *work)
-{
-	struct mptsas_discovery_event *ev =
-		container_of(work, struct mptsas_discovery_event, work);
-	MPT_ADAPTER *ioc = ev->ioc;
-
-	mutex_lock(&ioc->sas_discovery_mutex);
-	__mptsas_discovery_work(ioc);
-	mutex_unlock(&ioc->sas_discovery_mutex);
-	kfree(ev);
-}
-
-
 static struct mptsas_phyinfo *
 mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
 {
@@ -4051,33 +3824,6 @@ mptsas_send_raid_event(struct fw_event_work *fw_event)
 		mptsas_free_fw_event(ioc, fw_event);
 }
 
-static void
-mptsas_send_discovery_event(MPT_ADAPTER *ioc,
-	EVENT_DATA_SAS_DISCOVERY *discovery_data)
-{
-	struct mptsas_discovery_event *ev;
-	u32 discovery_status;
-
-	/*
-	 * DiscoveryStatus
-	 *
-	 * This flag will be non-zero when firmware
-	 * kicks off discovery, and return to zero
-	 * once its completed.
-	 */
-	discovery_status = le32_to_cpu(discovery_data->DiscoveryStatus);
-	ioc->sas_discovery_quiesce_io = discovery_status ? 1 : 0;
-	if (discovery_status)
-		return;
-
-	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-	if (!ev)
-		return;
-	INIT_WORK(&ev->work, mptsas_discovery_work);
-	ev->ioc = ioc;
-	schedule_work(&ev->work);
-};
-
 /*
  * mptsas_send_ir2_event - handle exposing hidden disk when
  * an inactive raid volume is added
