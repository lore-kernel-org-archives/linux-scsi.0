From: Ganesh Goudar <ganeshgr@chelsio.com>
Subject: [PATCH net-next 2/2] cxgb4: do L1 config when module is inserted
Date: Wed, 23 May 2018 20:03:33 +0530
Message-ID: <1527086013-9904-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: nirranjan@chelsio.com, indranil@chelsio.com, venkatesh@chelsio.com, linux-scsi@vger.kernel.org, varun@chelsio.com, Ganesh Goudar <ganeshgr@chelsio.com>, Casey Leedom <leedom@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

trigger an L1 configure operation when a transceiver module
is inserted in order to cause current "sticky" options like
Requested Forward Error Correction to be reapplied.

Signed-off-by: Casey Leedom <leedom@chelsio.com>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 26 ++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 11 +++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 40 +++++++++++++++++++++----
 3 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 211086b..0f305d9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -491,6 +491,9 @@ struct link_config {
 
 	unsigned char  link_ok;          /* link up? */
 	unsigned char  link_down_rc;     /* link down reason */
+
+	bool new_module;		 /* ->OS Transceiver Module inserted */
+	bool redo_l1cfg;		 /* ->CC redo current "sticky" L1 CFG */
 };
 
 #define FW_LEN16(fw_struct) FW_CMD_LEN16_V(sizeof(fw_struct) / 16)
@@ -1324,7 +1327,7 @@ static inline unsigned int qtimer_val(const struct adapter *adap,
 extern char cxgb4_driver_name[];
 extern const char cxgb4_driver_version[];
 
-void t4_os_portmod_changed(const struct adapter *adap, int port_id);
+void t4_os_portmod_changed(struct adapter *adap, int port_id);
 void t4_os_link_changed(struct adapter *adap, int port_id, int link_stat);
 
 void t4_free_sge_resources(struct adapter *adap);
@@ -1505,8 +1508,25 @@ void t4_intr_disable(struct adapter *adapter);
 int t4_slow_intr_handler(struct adapter *adapter);
 
 int t4_wait_dev_ready(void __iomem *regs);
-int t4_link_l1cfg(struct adapter *adap, unsigned int mbox, unsigned int port,
-		  struct link_config *lc);
+
+int t4_link_l1cfg_core(struct adapter *adap, unsigned int mbox,
+		       unsigned int port, struct link_config *lc,
+		       bool sleep_ok, int timeout);
+
+static inline int t4_link_l1cfg(struct adapter *adapter, unsigned int mbox,
+				unsigned int port, struct link_config *lc)
+{
+	return t4_link_l1cfg_core(adapter, mbox, port, lc,
+				  true, FW_CMD_MAX_TIMEOUT);
+}
+
+static inline int t4_link_l1cfg_ns(struct adapter *adapter, unsigned int mbox,
+				   unsigned int port, struct link_config *lc)
+{
+	return t4_link_l1cfg_core(adapter, mbox, port, lc,
+				  false, FW_CMD_MAX_TIMEOUT);
+}
+
 int t4_restart_aneg(struct adapter *adap, unsigned int mbox, unsigned int port);
 
 u32 t4_read_pcie_cfg4(struct adapter *adap, int reg);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 130d1ee..513e1d3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -301,14 +301,14 @@ void t4_os_link_changed(struct adapter *adapter, int port_id, int link_stat)
 	}
 }
 
-void t4_os_portmod_changed(const struct adapter *adap, int port_id)
+void t4_os_portmod_changed(struct adapter *adap, int port_id)
 {
 	static const char *mod_str[] = {
 		NULL, "LR", "SR", "ER", "passive DA", "active DA", "LRM"
 	};
 
-	const struct net_device *dev = adap->port[port_id];
-	const struct port_info *pi = netdev_priv(dev);
+	struct net_device *dev = adap->port[port_id];
+	struct port_info *pi = netdev_priv(dev);
 
 	if (pi->mod_type == FW_PORT_MOD_TYPE_NONE)
 		netdev_info(dev, "port module unplugged\n");
@@ -325,6 +325,11 @@ void t4_os_portmod_changed(const struct adapter *adap, int port_id)
 	else
 		netdev_info(dev, "%s: unknown module type %d inserted\n",
 			    dev->name, pi->mod_type);
+
+	/* If the interface is running, then we'll need any "sticky" Link
+	 * Parameters redone with a new Transceiver Module.
+	 */
+	pi->link_cfg.redo_l1cfg = netif_running(dev);
 }
 
 int dbfifo_int_thresh = 10; /* 10 == 640 entry threshold */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 537ed07..704f696 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -4058,14 +4058,16 @@ static inline fw_port_cap32_t cc_to_fwcap_fec(enum cc_fec cc_fec)
  *	- If auto-negotiation is off set the MAC to the proper speed/duplex/FC,
  *	  otherwise do it later based on the outcome of auto-negotiation.
  */
-int t4_link_l1cfg(struct adapter *adapter, unsigned int mbox,
-		  unsigned int port, struct link_config *lc)
+int t4_link_l1cfg_core(struct adapter *adapter, unsigned int mbox,
+		       unsigned int port, struct link_config *lc,
+		       bool sleep_ok, int timeout)
 {
 	unsigned int fw_caps = adapter->params.fw_caps_support;
-	struct fw_port_cmd cmd;
-	unsigned int fw_mdi = FW_PORT_CAP32_MDI_V(FW_PORT_CAP32_MDI_AUTO);
 	fw_port_cap32_t fw_fc, cc_fec, fw_fec, rcap;
+	struct fw_port_cmd cmd;
+	unsigned int fw_mdi;
 
+	fw_mdi = (FW_PORT_CAP32_MDI_V(FW_PORT_CAP32_MDI_AUTO) & lc->pcaps);
 	/* Convert driver coding of Pause Frame Flow Control settings into the
 	 * Firmware's API.
 	 */
@@ -4087,7 +4089,7 @@ int t4_link_l1cfg(struct adapter *adapter, unsigned int mbox,
 	/* Figure out what our Requested Port Capabilities are going to be.
 	 */
 	if (!(lc->pcaps & FW_PORT_CAP32_ANEG)) {
-		rcap = (lc->pcaps & ADVERT_MASK) | fw_fc | fw_fec;
+		rcap = lc->acaps | fw_fc | fw_fec;
 		lc->fc = lc->requested_fc & ~PAUSE_AUTONEG;
 		lc->fec = cc_fec;
 	} else if (lc->autoneg == AUTONEG_DISABLE) {
@@ -4113,7 +4115,8 @@ int t4_link_l1cfg(struct adapter *adapter, unsigned int mbox,
 		cmd.u.l1cfg.rcap = cpu_to_be32(fwcaps32_to_caps16(rcap));
 	else
 		cmd.u.l1cfg32.rcap32 = cpu_to_be32(rcap);
-	return t4_wr_mbox(adapter, mbox, &cmd, sizeof(cmd), NULL);
+	return t4_wr_mbox_meat_timeout(adapter, mbox, &cmd, sizeof(cmd), NULL,
+				       sleep_ok, timeout);
 }
 
 /**
@@ -8335,6 +8338,9 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 	fc = fwcap_to_cc_pause(linkattr);
 	speed = fwcap_to_speed(linkattr);
 
+	lc->new_module = false;
+	lc->redo_l1cfg = false;
+
 	if (mod_type != pi->mod_type) {
 		/* With the newer SFP28 and QSFP28 Transceiver Module Types,
 		 * various fundamental Port Capabilities which used to be
@@ -8369,6 +8375,8 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 		pi->port_type = port_type;
 
 		pi->mod_type = mod_type;
+
+		lc->new_module = t4_is_inserted_mod_type(mod_type);
 		t4_os_portmod_changed(adapter, pi->port_id);
 	}
 
@@ -8401,6 +8409,26 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 
 		t4_os_link_changed(adapter, pi->port_id, link_ok);
 	}
+
+	if (lc->new_module && lc->redo_l1cfg) {
+		struct link_config old_lc;
+		int ret;
+
+		/* Save the current L1 Configuration and restore it if an
+		 * error occurs.  We probably should fix the l1_cfg*()
+		 * routines not to change the link_config when an error
+		 * occurs ...
+		 */
+		old_lc = *lc;
+		ret = t4_link_l1cfg_ns(adapter, adapter->mbox, pi->lport, lc);
+		if (ret) {
+			*lc = old_lc;
+			dev_warn(adapter->pdev_dev,
+				 "Attempt to update new Transceiver Module settings failed\n");
+		}
+	}
+	lc->new_module = false;
+	lc->redo_l1cfg = false;
 }
 
 /**
-- 
2.1.0
