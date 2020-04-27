Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83223C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583F6206CD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Yj4D+tAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgD0PIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:08:35 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:44634 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727010AbgD0PIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 11:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588000110; i=@ts.fujitsu.com;
        bh=yDZiskhu2q8Mcsmv/6wKv8QYYiltiqb5ejmNnsFrsD4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Yj4D+tAFgibJAMpBv4A/CgvE16wS9tfZ8OIrBQU8viEmiR4G9K6OJI3rR6rVf//lV
         NKNna+5PiaigUoaVlxjbXZSiBGgIKbA2CSiPvrMXAi7VFF9eIbSbceQ24n6ZZjufgp
         umV/TyTDFNyJxbrEjGV7eLYHsn7/ECXA+gTWBahTS5RhaAjwfuIvmW6FEKEFISr7xW
         EAcr8eB5QMJ+Tum7ahwhIzOhtny9hwYjcW2GsRtyG9qtQXxHStxsclKw4by6Vag1P1
         acFb8JY/oU6kDouTvt1yags2ROHUvGpluwae8KHrZbUScz+SPcBf9neFadkGAFMMgl
         BeA4UqlqJY/DQ==
Received: from [100.113.6.103] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 11/00-40390-E65F6AE5; Mon, 27 Apr 2020 15:08:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRWlGSWpSXmKPExsViZ8MxVTfv67I
  4g993WC2+/p/OYrFy9VEmi+7rO9gslh//x2Sx/sgGRovWpW+ZHNg8dt9sYPP4+PQWi8f7fVfZ
  PDafrvb4vEkugDWKNTMvKb8igTVj+vHLrAXXIivurnnF1sA426+LkZNDSGAyo8TlnxxdjFxA9
  nRGifs397ODJNgEDCRWTLrPAmKLCNhI9B1eygRSxCzQxChx69V6NpCEMFDixL0msCIWAVWJtQ
  t/MoHYvAJ2El3v+sFsCQF5iY4Dk8FqOAXsJc5cvA7UywG0zU7i4wO9CYzcCxgZVjFaJhVlpme
  U5CZm5ugaGhjoGhoa65rpGpoa6CVW6SbppZbqJqfmlRQlAmX1EsuL9Yorc5NzUvTyUks2MQLD
  KqWQbdoOxitr3+sdYpTkYFIS5T25elmcEF9SfkplRmJxRnxRaU5q8SFGGQ4OJQneqZ+BcoJFq
  empFWmZOcAQh0lLcPAoifAmfAFK8xYXJOYWZ6ZDpE4xKkqJ89qBJARAEhmleXBtsLi6xCgrJc
  zLyMDAIMRTkFqUm1mCKv+KUZyDUUmYdxbIdp7MvBK46a+AFjMBLa6SXwyyuCQRISXVwLRxo96
  ylu+7GFM82HKjUyqVRI2n8Omy1m+YfcM8Qk6oabdOScYx3kmHGybHzc+xdFiTa5QzQXfSYR6J
  XRUHZ1//wbDv2ff+KqGpH+4kr9XZzfxs9urfoiscGN/oCivHl8RuT0k8uGft35VdmepHZlc+C
  Fo8ae8kRe/4A+ky3t07Jfg3+rVdvHrK+jhbsZVWquu/ysXB2zae/Ri6N3v1uUdLfqeb993h9n
  /8zs1iT4aIZ+2dJzvLzuz//btW5bTOpOM+8380apu8aendYPrA+QX3naBbxx7HZikK5/uli+g
  EMFoaXVM5xy4o1dRsNCFa8um+zVtiI6cy35vBO9c0cxuf8nKH87PEtgbckmv4uUGJpTgj0VCL
  uag4EQA9WvfUJgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-22.tower-245.messagelabs.com!1588000109!1031667!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5055 invoked from network); 27 Apr 2020 15:08:30 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-22.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Apr 2020 15:08:30 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03RF8Qfu013124;
        Mon, 27 Apr 2020 16:08:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 0E795207E1;
        Mon, 27 Apr 2020 17:08:26 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, ddiss@suse.de, hch@lst.de,
        martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 3/4] target: make transport_flags per device
Date:   Mon, 27 Apr 2020 17:08:22 +0200
Message-Id: <20200427150823.15350-4-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pgr_support and alua_support device attributes show the
inverted value of the transport_flags
 * TRANSPORT_FLAG_PASSTHROUGH_PGR
 * TRANSPORT_FLAG_PASSTHROUGH_ALUA

These attributes are per device, while the flags are per
backend. So we rename the transport_flags in backend/transport
to transport_flags_default and use its value to initialize
the new transport_flags field in the se_device structure.

Now data and attribute both are per se_device.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_alua.c      | 10 +++++-----
 drivers/target/target_core_configfs.c  | 14 +++++++-------
 drivers/target/target_core_device.c    |  3 ++-
 drivers/target/target_core_pr.c        |  2 +-
 drivers/target/target_core_pscsi.c     |  6 +++---
 drivers/target/target_core_tpg.c       |  3 +--
 drivers/target/target_core_transport.c |  6 +++---
 drivers/target/target_core_user.c      |  2 +-
 include/target/target_core_backend.h   |  2 +-
 include/target/target_core_base.h      |  1 +
 10 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 385e4cf9cfa6..6b72afee2f8b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -677,7 +677,7 @@ target_alua_state_check(struct se_cmd *cmd)
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
 		return 0;
 
 	/*
@@ -1090,7 +1090,7 @@ int core_alua_do_port_transition(
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int primary, valid_states, rc = 0;
 
-	if (l_dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
+	if (l_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
 		return -ENODEV;
 
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
@@ -1920,7 +1920,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 	int move = 0;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
 	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		return -ENODEV;
 
@@ -2177,7 +2177,7 @@ ssize_t core_alua_store_offline_bit(
 	unsigned long tmp;
 	int ret;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
 	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		return -ENODEV;
 
@@ -2263,7 +2263,7 @@ ssize_t core_alua_store_secondary_write_metadata(
 
 int core_setup_alua(struct se_device *dev)
 {
-	if (!(dev->transport->transport_flags &
+	if (!(dev->transport_flags &
 	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)) {
 		struct t10_alua_lu_gp_member *lu_gp_mem;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index efa92d836946..279989e32e64 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1099,7 +1099,7 @@ static ssize_t block_size_store(struct config_item *item,
 static ssize_t alua_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
-	u8 flags = da->da_dev->transport->transport_flags;
+	u8 flags = da->da_dev->transport_flags;
 
 	return snprintf(page, PAGE_SIZE, "%d\n",
 			flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ? 0 : 1);
@@ -1108,7 +1108,7 @@ static ssize_t alua_support_show(struct config_item *item, char *page)
 static ssize_t pgr_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
-	u8 flags = da->da_dev->transport->transport_flags;
+	u8 flags = da->da_dev->transport_flags;
 
 	return snprintf(page, PAGE_SIZE, "%d\n",
 			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
@@ -1654,7 +1654,7 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
 	if (!dev->dev_attrib.emulate_pr)
 		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "Passthrough\n");
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1796,7 +1796,7 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
 
 	if (!dev->dev_attrib.emulate_pr)
 		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "SPC_PASSTHROUGH\n");
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return sprintf(page, "SPC2_RESERVATIONS\n");
@@ -1810,7 +1810,7 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
 	struct se_device *dev = pr_to_dev(item);
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
@@ -1823,7 +1823,7 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
 	struct se_device *dev = pr_to_dev(item);
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
@@ -1870,7 +1870,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u8 type = 0;
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return count;
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return count;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4cee1138284b..d5800cf22df7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -732,6 +732,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
+	dev->transport_flags = dev->transport->transport_flags_default;
 	dev->prot_length = sizeof(struct t10_pi_tuple);
 	dev->hba_index = hba->hba_index;
 
@@ -1100,7 +1101,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	 * emulate the response, since tcmu does not have the information
 	 * required to process these commands.
 	 */
-	if (!(dev->transport->transport_flags &
+	if (!(dev->transport_flags &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
 		if (cdb[0] == PERSISTENT_RESERVE_IN) {
 			cmd->execute_cmd = target_scsi3_emulate_pr_in;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e931690e697..91e41cc55704 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4086,7 +4086,7 @@ target_check_reservation(struct se_cmd *cmd)
 		return 0;
 	if (!dev->dev_attrib.emulate_pr)
 		return 0;
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..4e37fa9b409d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1070,9 +1070,9 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 static const struct target_backend_ops pscsi_ops = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
-	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH |
-				  TRANSPORT_FLAG_PASSTHROUGH_ALUA |
-				  TRANSPORT_FLAG_PASSTHROUGH_PGR,
+	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH |
+				   TRANSPORT_FLAG_PASSTHROUGH_ALUA |
+				   TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..62aa5fa63ac0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -582,8 +582,7 @@ int core_tpg_add_lun(
 	if (ret)
 		goto out_kill_ref;
 
-	if (!(dev->transport->transport_flags &
-	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
+	if (!(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..e6b448f43071 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1397,7 +1397,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Check if SAM Task Attribute emulation is enabled for this
 	 * struct se_device storage object
 	 */
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return 0;
 
 	if (cmd->sam_task_attr == TCM_ACA_TAG) {
@@ -2012,7 +2012,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return false;
 
 	cmd->se_cmd_flags |= SCF_TASK_ATTR_SET;
@@ -2126,7 +2126,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return;
 
 	if (!(cmd->se_cmd_flags & SCF_TASK_ATTR_SET))
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8adde343182f..264f19ba8453 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2617,7 +2617,7 @@ static struct configfs_attribute *tcmu_action_attrs[] = {
 static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
-	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH,
+	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH,
 	.attach_hba		= tcmu_attach_hba,
 	.detach_hba		= tcmu_detach_hba,
 	.alloc_device		= tcmu_alloc_device,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 8177667eba6d..959163504f82 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -23,7 +23,7 @@ struct target_backend_ops {
 	char inquiry_rev[4];
 	struct module *owner;
 
-	u8 transport_flags;
+	u8 transport_flags_default;
 
 	int (*attach_hba)(struct se_hba *, u32);
 	void (*detach_hba)(struct se_hba *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d4a694f6ea7..18c3f277b770 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -772,6 +772,7 @@ struct se_device {
 #define DF_USING_UDEV_PATH			0x00000008
 #define DF_USING_ALIAS				0x00000010
 #define DF_READ_ONLY				0x00000020
+	u8			transport_flags;
 	/* Physical device queue depth */
 	u32			queue_depth;
 	/* Used for SPC-2 reservations enforce of ISIDs */
-- 
2.12.3

