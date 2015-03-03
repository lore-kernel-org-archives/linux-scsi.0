From: Tao Chen <boby.chen@huawei.com>
Subject: [PATCH] xen-scsiback: use DRV_PFX in the pr macros
Date: Tue, 3 Mar 2015 08:37:12 +0000
Message-ID: <1425371832-55072-1-git-send-email-boby.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:62693 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbbCCJeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2015 04:34:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, boby.chen@huawei.com, wu.wubin@huawei.com, rudy.zhangmin@huawei.com

Replace the string of {xen-pvscsi:} in the pr sentences with DRV_PFX,
it makes the code easier to read.

Signed-off-by: Tao Chen <boby.chen@huawei.com>
---
 drivers/xen/xen-scsiback.c | 67 +++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 9faca6a..307100d 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -69,6 +69,7 @@
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/vscsiif.h>
 
+#define DRV_PFX "xen-pvscsi:"
 #define DPRINTK(_f, _a...)			\
 	pr_debug("(file=%s, line=%d) " _f, __FILE__ , __LINE__ , ## _a)
 
@@ -84,7 +85,7 @@ struct ids_tuple {
 
 struct v2p_entry {
 	struct ids_tuple v;		/* translate from */
-	struct scsiback_tpg *tpg;	/* translate to   */
+	struct scsiback_tpg *tpg;	/* translate to */
 	unsigned int lun;
 	struct kref kref;
 	struct list_head l;
@@ -271,7 +272,7 @@ static void scsiback_print_status(char *sense_buffer, int errors,
 {
 	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
 
-	pr_err("xen-pvscsi[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=%02x\n",
+	pr_err(DRV_PFX "[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=%02x\n",
 	       tpg->tport->tport_name, pending_req->v2p->lun,
 	       pending_req->cmnd[0], status_byte(errors), msg_byte(errors),
 	       host_byte(errors), driver_byte(errors));
@@ -427,7 +428,7 @@ static int scsiback_gnttab_data_map_batch(struct gnttab_map_grant_ref *map,
 	BUG_ON(err);
 	for (i = 0; i < cnt; i++) {
 		if (unlikely(map[i].status != GNTST_okay)) {
-			pr_err("xen-pvscsi: invalid buffer -- could not remap it\n");
+			pr_err(DRV_PFX "invalid buffer -- could not remap it\n");
 			map[i].handle = SCSIBACK_INVALID_HANDLE;
 			err = -ENOMEM;
 		} else {
@@ -449,7 +450,7 @@ static int scsiback_gnttab_data_map_list(struct vscsibk_pend *pending_req,
 	for (i = 0; i < cnt; i++) {
 		if (get_free_page(pg + mapcount)) {
 			put_free_pages(pg, mapcount);
-			pr_err("xen-pvscsi: no grant page\n");
+			pr_err(DRV_PFX "no grant page\n");
 			return -ENOMEM;
 		}
 		gnttab_set_map_op(&map[mapcount], vaddr_page(pg[mapcount]),
@@ -492,7 +493,7 @@ static int scsiback_gnttab_data_map(struct vscsiif_request *ring_req,
 		return 0;
 
 	if (nr_segments > VSCSIIF_SG_TABLESIZE) {
-		DPRINTK("xen-pvscsi: invalid parameter nr_seg = %d\n",
+		DPRINTK(DRV_PFX "invalid parameter nr_seg = %d\n",
 			ring_req->nr_segments);
 		return -EINVAL;
 	}
@@ -516,13 +517,13 @@ static int scsiback_gnttab_data_map(struct vscsiif_request *ring_req,
 			nr_segments += n_segs;
 		}
 		if (nr_segments > SG_ALL) {
-			DPRINTK("xen-pvscsi: invalid nr_seg = %d\n",
+			DPRINTK(DRV_PFX "invalid nr_seg = %d\n",
 				nr_segments);
 			return -EINVAL;
 		}
 	}
 
-	/* free of (sgl) in fast_flush_area()*/
+	/* free of (sgl) in fast_flush_area() */
 	pending_req->sgl = kmalloc_array(nr_segments,
 					sizeof(struct scatterlist), GFP_KERNEL);
 	if (!pending_req->sgl)
@@ -679,7 +680,7 @@ static int prepare_pending_reqs(struct vscsibk_info *info,
 	v2p = scsiback_do_translation(info, &vir);
 	if (!v2p) {
 		pending_req->v2p = NULL;
-		DPRINTK("xen-pvscsi: doesn't exist.\n");
+		DPRINTK(DRV_PFX "doesn't exist.\n");
 		return -ENODEV;
 	}
 	pending_req->v2p = v2p;
@@ -690,14 +691,14 @@ static int prepare_pending_reqs(struct vscsibk_info *info,
 		(pending_req->sc_data_direction != DMA_TO_DEVICE) &&
 		(pending_req->sc_data_direction != DMA_FROM_DEVICE) &&
 		(pending_req->sc_data_direction != DMA_NONE)) {
-		DPRINTK("xen-pvscsi: invalid parameter data_dir = %d\n",
+		DPRINTK(DRV_PFX "invalid parameter data_dir = %d\n",
 			pending_req->sc_data_direction);
 		return -EINVAL;
 	}
 
 	pending_req->cmd_len = ring_req->cmd_len;
 	if (pending_req->cmd_len > VSCSIIF_MAX_COMMAND_SIZE) {
-		DPRINTK("xen-pvscsi: invalid parameter cmd_len = %d\n",
+		DPRINTK(DRV_PFX "invalid parameter cmd_len = %d\n",
 			pending_req->cmd_len);
 		return -EINVAL;
 	}
@@ -721,7 +722,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 
 	if (RING_REQUEST_PROD_OVERFLOW(ring, rp)) {
 		rc = ring->rsp_prod_pvt;
-		pr_warn("xen-pvscsi: Dom%d provided bogus ring requests (%#x - %#x = %u). Halting ring processing\n",
+		pr_warn(DRV_PFX "Dom%d provided bogus ring requests (%#x - %#x = %u). Halting ring processing\n",
 			   info->domid, rp, rc, rp - rc);
 		info->ring_error = 1;
 		return 0;
@@ -772,7 +773,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 			scsiback_device_action(pending_req, TMR_LUN_RESET, 0);
 			break;
 		default:
-			pr_err_ratelimited("xen-pvscsi: invalid request\n");
+			pr_err_ratelimited(DRV_PFX "invalid request\n");
 			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24,
 						    0, pending_req);
 			kmem_cache_free(scsiback_cachep, pending_req);
@@ -874,14 +875,14 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 
 	lunp = strrchr(phy, ':');
 	if (!lunp) {
-		pr_err("xen-pvscsi: illegal format of physical device %s\n",
+		pr_err(DRV_PFX "illegal format of physical device %s\n",
 			phy);
 		return -EINVAL;
 	}
 	*lunp = 0;
 	lunp++;
 	if (kstrtouint(lunp, 10, &lun) || lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
-		pr_err("xen-pvscsi: lun number not valid: %s\n", lunp);
+		pr_err(DRV_PFX "lun number not valid: %s\n", lunp);
 		return -EINVAL;
 	}
 
@@ -909,7 +910,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	mutex_unlock(&scsiback_mutex);
 
 	if (!tpg) {
-		pr_err("xen-pvscsi: %s:%d %s\n", phy, lun, error);
+		pr_err(DRV_PFX "%s:%d %s\n", phy, lun, error);
 		return -ENODEV;
 	}
 
@@ -926,7 +927,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 		if ((entry->v.chn == v->chn) &&
 		    (entry->v.tgt == v->tgt) &&
 		    (entry->v.lun == v->lun)) {
-			pr_warn("xen-pvscsi: Virtual ID is already used. Assignment was not performed.\n");
+			pr_warn(DRV_PFX "Virtual ID is already used. Assignment was not performed.\n");
 			err = -EEXIST;
 			goto out;
 		}
@@ -997,7 +998,7 @@ static void scsiback_do_add_lun(struct vscsibk_info *info, const char *state,
 	if (!scsiback_add_translation_entry(info, phy, vir)) {
 		if (xenbus_printf(XBT_NIL, info->dev->nodename, state,
 				  "%d", XenbusStateInitialised)) {
-			pr_err("xen-pvscsi: xenbus_printf error %s\n", state);
+			pr_err(DRV_PFX "xenbus_printf error %s\n", state);
 			scsiback_del_translation_entry(info, vir);
 		}
 	} else {
@@ -1012,7 +1013,7 @@ static void scsiback_do_del_lun(struct vscsibk_info *info, const char *state,
 	if (!scsiback_del_translation_entry(info, vir)) {
 		if (xenbus_printf(XBT_NIL, info->dev->nodename, state,
 				  "%d", XenbusStateClosed))
-			pr_err("xen-pvscsi: xenbus_printf error %s\n", state);
+			pr_err(DRV_PFX "xenbus_printf error %s\n", state);
 	}
 }
 
@@ -1071,7 +1072,7 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 			/* modify vscsi-devs/dev-x/state */
 			if (xenbus_printf(XBT_NIL, dev->nodename, state,
 					  "%d", XenbusStateConnected)) {
-				pr_err("xen-pvscsi: xenbus_printf error %s\n",
+				pr_err(DRV_PFX "xenbus_printf error %s\n",
 				       str);
 				scsiback_del_translation_entry(info, &vir);
 				xenbus_printf(XBT_NIL, dev->nodename, state,
@@ -1079,7 +1080,7 @@ static void scsiback_do_1lun_hotplug(struct vscsibk_info *info, int op,
 			}
 		}
 		break;
-	/*When it is necessary, processing is added here.*/
+	/* When it is necessary, processing is added here. */
 	default:
 		break;
 	}
@@ -1227,7 +1228,7 @@ static int scsiback_probe(struct xenbus_device *dev,
 	return 0;
 
 fail:
-	pr_warn("xen-pvscsi: %s failed\n", __func__);
+	pr_warn(DRV_PFX "%s failed\n", __func__);
 	scsiback_remove(dev);
 
 	return err;
@@ -1432,7 +1433,7 @@ check_len:
 	}
 	snprintf(&tport->tport_name[0], VSCSI_NAMELEN, "%s", &name[off]);
 
-	pr_debug("xen-pvscsi: Allocated emulated Target %s Address: %s\n",
+	pr_debug(DRV_PFX "Allocated emulated Target %s Address: %s\n",
 		 scsiback_dump_proto_id(tport), name);
 
 	return &tport->tport_wwn;
@@ -1443,7 +1444,7 @@ static void scsiback_drop_tport(struct se_wwn *wwn)
 	struct scsiback_tport *tport = container_of(wwn,
 				struct scsiback_tport, tport_wwn);
 
-	pr_debug("xen-pvscsi: Deallocating emulated Target %s Address: %s\n",
+	pr_debug(DRV_PFX "Deallocating emulated Target %s Address: %s\n",
 		 scsiback_dump_proto_id(tport), tport->tport_name);
 
 	kfree(tport);
@@ -1470,8 +1471,8 @@ static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
 static int scsiback_check_stop_free(struct se_cmd *se_cmd)
 {
 	/*
-	 * Do not release struct se_cmd's containing a valid TMR
-	 * pointer.  These will be released directly in scsiback_device_action()
+	 * Do not release struct se_cmd's containing a valid TMR pointer.
+	 * These will be released directly in scsiback_device_action()
 	 * with transport_generic_free_cmd().
 	 */
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
@@ -1637,7 +1638,7 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 		return -ENOMEM;
 	}
 	/*
-	 *  Initialize the struct se_session pointer
+	 * Initialize the struct se_session pointer
 	 */
 	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
@@ -1708,7 +1709,7 @@ static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
 		return -EBUSY;
 	}
 
-	pr_debug("xen-pvscsi: Removing I_T Nexus to emulated %s Initiator Port: %s\n",
+	pr_debug(DRV_PFX "Removing I_T Nexus to emulated %s Initiator Port: %s\n",
 		scsiback_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 
@@ -1754,7 +1755,7 @@ static ssize_t scsiback_tpg_store_nexus(struct se_portal_group *se_tpg,
 	unsigned char i_port[VSCSI_NAMELEN], *ptr, *port_ptr;
 	int ret;
 	/*
-	 * Shutdown the active I_T nexus if 'NULL' is passed..
+	 * Shutdown the active I_T nexus if 'NULL' is passed.
 	 */
 	if (!strncmp(page, "NULL", 4)) {
 		ret = scsiback_drop_nexus(tpg);
@@ -1925,7 +1926,7 @@ static void scsiback_drop_tpg(struct se_portal_group *se_tpg)
 	 */
 	scsiback_drop_nexus(tpg);
 	/*
-	 * Deregister the se_tpg from TCM..
+	 * Deregister the se_tpg from TCM.
 	 */
 	core_tpg_deregister(se_tpg);
 	kfree(tpg);
@@ -1995,7 +1996,7 @@ static int scsiback_register_configfs(void)
 	struct target_fabric_configfs *fabric;
 	int ret;
 
-	pr_debug("xen-pvscsi: fabric module %s on %s/%s on "UTS_RELEASE"\n",
+	pr_debug(DRV_PFX "fabric module %s on %s/%s on "UTS_RELEASE"\n",
 		 VSCSI_VERSION, utsname()->sysname, utsname()->machine);
 	/*
 	 * Register the top level struct config_item_type with TCM core
@@ -2032,7 +2033,7 @@ static int scsiback_register_configfs(void)
 	 * Setup our local pointer to *fabric
 	 */
 	scsiback_fabric_configfs = fabric;
-	pr_debug("xen-pvscsi: Set fabric -> scsiback_fabric_configfs\n");
+	pr_debug(DRV_PFX "Set fabric -> scsiback_fabric_configfs\n");
 	return 0;
 };
 
@@ -2043,7 +2044,7 @@ static void scsiback_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(scsiback_fabric_configfs);
 	scsiback_fabric_configfs = NULL;
-	pr_debug("xen-pvscsi: Cleared scsiback_fabric_configfs\n");
+	pr_debug(DRV_PFX "Cleared scsiback_fabric_configfs\n");
 };
 
 static const struct xenbus_device_id scsiback_ids[] = {
@@ -2094,7 +2095,7 @@ out_unregister_xenbus:
 	xenbus_unregister_driver(&scsiback_driver);
 out_cache_destroy:
 	kmem_cache_destroy(scsiback_cachep);
-	pr_err("xen-pvscsi: %s: error %d\n", __func__, ret);
+	pr_err(DRV_PFX "%s: error %d\n", __func__, ret);
 	return ret;
 }
 
-- 
1.8.5

