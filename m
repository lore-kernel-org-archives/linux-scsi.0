From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] target: Fix typo in drivers/target
Date: Thu, 16 Aug 2012 22:43:13 +0900
Message-ID: <1345124593-24346-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org, trivial@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Correct spelling typo in printk and comment within
drivers/target.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/target/target_core_alua.c       | 2 +-
 drivers/target/target_core_configfs.c   | 2 +-
 drivers/target/target_core_device.c     | 6 +++---
 drivers/target/target_core_fabric_lib.c | 8 ++++----
 drivers/target/target_core_pr.c         | 4 ++--
 drivers/target/target_core_pscsi.c      | 2 +-
 drivers/target/target_core_tpg.c        | 2 +-
 drivers/target/target_core_transport.c  | 4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 9179997..91b84d3 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -337,7 +337,7 @@ int target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 */
 			rtpi = get_unaligned_be16(ptr + 2);
 			/*
-			 * Locate the matching relative target port identifer
+			 * Locate the matching relative target port identifier
 			 * for the struct se_device storage object.
 			 */
 			spin_lock(&dev->se_port_lock);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 801efa8..1ee2c99 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1208,7 +1208,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 		" Target Node Endpoint: %s\n", tfo->get_fabric_name(),
 		tfo->tpg_get_wwn(se_tpg));
 	len += sprintf(page+len, "SPC-3 Reservation: Relative Port"
-		" Identifer Tag: %hu %s Portal Group Tag: %hu"
+		" Identifier Tag: %hu %s Portal Group Tag: %hu"
 		" %s Logical Unit: %u\n", lun->lun_sep->sep_rtpi,
 		tfo->get_fabric_name(), tfo->tpg_get_tag(se_tpg),
 		tfo->get_fabric_name(), lun->unpacked_lun);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cf2c66f..97b47ab 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -531,7 +531,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 	}
 again:
 	/*
-	 * Allocate the next RELATIVE TARGET PORT IDENTIFER for this struct se_device
+	 * Allocate the next RELATIVE TARGET PORT IDENTIFIER for this struct se_device
 	 * Here is the table from spc4r17 section 7.7.3.8.
 	 *
 	 *    Table 473 -- RELATIVE TARGET PORT IDENTIFIER field
@@ -548,7 +548,7 @@ again:
 
 	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
 		/*
-		 * Make sure RELATIVE TARGET PORT IDENTIFER is unique
+		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
 		 * for 16-bit wrap..
 		 */
 		if (port->sep_rtpi == port_tmp->sep_rtpi)
@@ -595,7 +595,7 @@ static void core_export_port(
 	}
 
 	dev->dev_port_count++;
-	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFER */
+	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFIER */
 }
 
 /*
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 283a36e..e460d62 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -338,7 +338,7 @@ u32 iscsi_get_pr_transport_id_len(
 	 * 00b: iSCSI Initiator device TransportID format
 	 */
 	if (pr_reg->isid_present_at_reg) {
-		len += 5; /* For ",i,0x" ASCII seperator */
+		len += 5; /* For ",i,0x" ASCII separator */
 		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
 		*format_code = 1;
 	} else
@@ -415,20 +415,20 @@ char *iscsi_parse_pr_out_transport_id(
 			*out_tid_len = (add_len + 4);
 	}
 	/*
-	 * Check for ',i,0x' seperator between iSCSI Name and iSCSI Initiator
+	 * Check for ',i,0x' separator between iSCSI Name and iSCSI Initiator
 	 * Session ID as defined in Table 390 - iSCSI initiator port TransportID
 	 * format.
 	 */
 	if (format_code == 0x40) {
 		p = strstr(&buf[4], ",i,0x");
 		if (!p) {
-			pr_err("Unable to locate \",i,0x\" seperator"
+			pr_err("Unable to locate \",i,0x\" separator"
 				" for Initiator port identifier: %s\n",
 				&buf[4]);
 			return NULL;
 		}
 		*p = '\0'; /* Terminate iSCSI Name */
-		p += 5; /* Skip over ",i,0x" seperator */
+		p += 5; /* Skip over ",i,0x" separator */
 
 		*port_nexus_ptr = p;
 		/*
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1e94650..702dfe0 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1612,7 +1612,7 @@ static int core_scsi3_decode_spec_i_port(
 				goto out;
 			}
 			/*
-			 * Locate the desination initiator ACL to be registered
+			 * Locate the destination initiator ACL to be registered
 			 * from the decoded fabric module specific TransportID
 			 * at *i_str.
 			 */
@@ -4249,7 +4249,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
 			buf[off++] = (port->sep_rtpi & 0xff);
 		} else
-			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFER */
+			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFIER */
 
 		/*
 		 * Now, have the $FABRIC_MOD fill in the protocol identifier
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6e32ff6..5ff2d92 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -264,7 +264,7 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 					" length zero!\n");
 			break;
 		}
-		pr_debug("T10 VPD Identifer Length: %d\n", ident_len);
+		pr_debug("T10 VPD Identifier Length: %d\n", ident_len);
 
 		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
 		if (!vpd) {
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b8628a5..a531fe2 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -303,7 +303,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	}
 	/*
 	 * Here we only create demo-mode MappedLUNs from the active
-	 * TPG LUNs if the fabric is not explictly asking for
+	 * TPG LUNs if the fabric is not explicitly asking for
 	 * tpg_check_demo_mode_login_only() == 1.
 	 */
 	if ((tpg->se_tpg_tfo->tpg_check_demo_mode_login_only == NULL) ||
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0eaae23..434c697 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -941,7 +941,7 @@ int
 transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 {
 	static const char hex_str[] = "0123456789abcdef";
-	int j = 0, i = 4; /* offset to start of the identifer */
+	int j = 0, i = 4; /* offset to start of the identifier */
 
 	/*
 	 * The VPD Code Set (encoding)
@@ -2796,7 +2796,7 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
 
-	pr_debug("wait_for_tasks: Stopped wait_for_compltion("
+	pr_debug("wait_for_tasks: Stopped wait_for_completion("
 		"&cmd->t_transport_stop_comp) for ITT: 0x%08x\n",
 		cmd->se_tfo->get_task_tag(cmd));
 
-- 
1.7.12.rc3
