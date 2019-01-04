From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] scsi: libsas: Fix some indentation in libsas.h
Date: Sat, 5 Jan 2019 00:01:26 +0800
Message-ID: <1546617688-240623-2-git-send-email-john.garry@huawei.com>
References: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently much indentation in this file is done with whitespaces instead
of tabs, which can make reading difficult, so fix this up.

Some other little minor tidy-up is done, but this file still has many
other checkpatch warnings (generally linelength > 80 or function
arguments have no identifier names).

All libsas code can be audited for checkpatch issues later.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/scsi/libsas.h | 56 +++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3de3b10..857086c 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -52,8 +52,8 @@ enum sas_phy_role {
 };
 
 enum sas_phy_type {
-        PHY_TYPE_PHYSICAL,
-        PHY_TYPE_VIRTUAL
+	PHY_TYPE_PHYSICAL,
+	PHY_TYPE_VIRTUAL
 };
 
 /* The events are mnemonically described in sas_dump.c
@@ -91,7 +91,7 @@ enum discover_event {
 
 #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
 #define to_dev_attr(_attr)  container_of(_attr, struct domain_dev_attribute,\
-                                         attr)
+					 attr)
 
 enum routing_attribute {
 	DIRECT_ROUTING,
@@ -184,37 +184,37 @@ struct domain_device {
 	spinlock_t done_lock;
 	enum sas_device_type dev_type;
 
-        enum sas_linkrate linkrate;
-        enum sas_linkrate min_linkrate;
-        enum sas_linkrate max_linkrate;
+	enum sas_linkrate linkrate;
+	enum sas_linkrate min_linkrate;
+	enum sas_linkrate max_linkrate;
 
-        int  pathways;
+	int  pathways;
 
-        struct domain_device *parent;
-        struct list_head siblings; /* devices on the same level */
-        struct asd_sas_port *port;        /* shortcut to root of the tree */
+	struct domain_device *parent;
+	struct list_head siblings; /* devices on the same level */
+	struct asd_sas_port *port;        /* shortcut to root of the tree */
 	struct sas_phy *phy;
 
-        struct list_head dev_list_node;
+	struct list_head dev_list_node;
 	struct list_head disco_list_node; /* awaiting probe or destruct */
 
-        enum sas_protocol    iproto;
-        enum sas_protocol    tproto;
+	enum sas_protocol    iproto;
+	enum sas_protocol    tproto;
 
-        struct sas_rphy *rphy;
+	struct sas_rphy *rphy;
 
-        u8  sas_addr[SAS_ADDR_SIZE];
-        u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
+	u8  sas_addr[SAS_ADDR_SIZE];
+	u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
 
-        u8  frame_rcvd[32];
+	u8  frame_rcvd[32];
 
-        union {
-                struct expander_device ex_dev;
-                struct sata_device     sata_dev; /* STP & directly attached */
+	union {
+		struct expander_device ex_dev;
+		struct sata_device     sata_dev; /* STP & directly attached */
 		struct ssp_device      ssp_dev;
-        };
+	};
 
-        void *lldd_dev;
+	void *lldd_dev;
 	unsigned long state;
 	struct kref kref;
 };
@@ -512,10 +512,10 @@ enum exec_status {
 
 /* When a task finishes with a response, the LLDD examines the
  * response:
- * 	- For an ATA task task_status_struct::stat is set to
+ *	- For an ATA task task_status_struct::stat is set to
  * SAS_PROTO_RESPONSE, and the task_status_struct::buf is set to the
  * contents of struct ata_task_resp.
- * 	- For SSP tasks, if no data is present or status/TMF response
+ *	- For SSP tasks, if no data is present or status/TMF response
  * is valid, task_status_struct::stat is set.  If data is present
  * (SENSE data), the LLDD copies up to SAS_STATUS_BUF_SIZE, sets
  * task_status_struct::buf_valid_size, and task_status_struct::stat is
@@ -671,15 +671,13 @@ struct sas_domain_function_template {
 extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
 extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 
-int sas_set_phy_speed(struct sas_phy *phy,
-		      struct sas_phy_linkrates *rates);
+int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
-extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
+extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_configure(struct scsi_device *);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
-extern int sas_bios_param(struct scsi_device *,
-			  struct block_device *,
+extern int sas_bios_param(struct scsi_device *, struct block_device *,
 			  sector_t capacity, int *hsc);
 extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
-- 
1.9.1
