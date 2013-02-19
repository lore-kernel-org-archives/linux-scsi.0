From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi: use 64-bit value for 'max_luns'
Date: Tue, 19 Feb 2013 09:18:02 +0100
Message-ID: <1361261883-41467-4-git-send-email-hare@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab3BSISJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 03:18:09 -0500
In-Reply-To: <1361261883-41467-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>

Now that we're using 64-bit LUNs internally we need to increase
the size of max_luns to 64 bits, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/i2o/i2o_scsi.c       |    6 +++---
 drivers/scsi/cxgbi/libcxgbi.c        |    2 +-
 drivers/scsi/cxgbi/libcxgbi.h        |    2 +-
 drivers/scsi/dc395x.c                |    3 ++-
 drivers/scsi/eata.c                  |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c       |    4 ++--
 drivers/scsi/lpfc/lpfc_attr.c        |   10 +++++++++-
 drivers/scsi/megaraid.c              |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    4 ++--
 drivers/scsi/qla2xxx/qla_gbl.h       |    2 +-
 drivers/scsi/qla2xxx/qla_os.c        |    6 +++---
 drivers/scsi/scsi_scan.c             |    8 ++++----
 include/linux/moduleparam.h          |    5 +++++
 include/scsi/scsi_host.h             |    6 +++---
 kernel/params.c                      |    1 +
 15 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1d31d72..105dd72 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -73,7 +73,7 @@
 static struct i2o_driver i2o_scsi_driver;
 
 static unsigned int i2o_scsi_max_id = 16;
-static unsigned int i2o_scsi_max_lun = 255;
+static uint64_t i2o_scsi_max_lun = 255;
 
 struct i2o_scsi_host {
 	struct Scsi_Host *scsi_host;	/* pointer to the SCSI host */
@@ -287,8 +287,8 @@ static int i2o_scsi_probe(struct device *dev)
 	}
 
 	if (le64_to_cpu(lun) >= scsi_host->max_lun) {
-		osm_warn("SCSI device lun (%lu) >= max_lun of I2O host (%d)",
-			 (long unsigned int)le64_to_cpu(lun),
+		osm_warn("SCSI device lun (%llu) >= max_lun of I2O host (%llu)",
+			 (long long unsigned int)le64_to_cpu(lun),
 			 scsi_host->max_lun);
 		return -EFAULT;
 	}
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index b44c1cf..95105c0 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -245,7 +245,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 }
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
-int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun,
+int cxgbi_hbas_add(struct cxgbi_device *cdev, uint64_t max_lun,
 		unsigned int max_id, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 80fa99b..d3b27f8 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -692,7 +692,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int, unsigned int);
 void cxgbi_device_unregister(struct cxgbi_device *);
 void cxgbi_device_unregister_all(unsigned int flag);
 struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
-int cxgbi_hbas_add(struct cxgbi_device *, unsigned int, unsigned int,
+int cxgbi_hbas_add(struct cxgbi_device *, uint64_t, unsigned int,
 			struct scsi_host_template *,
 			struct scsi_transport_template *);
 void cxgbi_hbas_remove(struct cxgbi_device *);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index dfe90ce..9acdb9c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4648,7 +4648,8 @@ static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
 	SPRINTF("irq_level 0x%04x, ", acb->irq_level);
 	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
 
-	SPRINTF("MaxID %i, MaxLUN %i, ", host->max_id, host->max_lun);
+	SPRINTF("MaxID %i, MaxLUN %i, ", host->max_id,
+		(unsigned int)host->max_lun);
 	SPRINTF("AdapterID %i\n", host->this_id);
 
 	SPRINTF("tag_max_num %i", acb->tag_max_num);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d20c8dd..20238a4 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1399,7 +1399,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 
 	if (shost->max_id > 8 || shost->max_lun > 8)
 		printk
-		    ("%s: wide SCSI support enabled, max_id %u, max_lun %u.\n",
+		    ("%s: wide SCSI support enabled, max_id %u, max_lun %llu.\n",
 		     ha->board_name, shost->max_id, shost->max_lun);
 
 	for (i = 0; i <= shost->max_channel; i++)
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index cc82d0f..615edfa 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -46,7 +46,7 @@
 
 static unsigned int init_timeout = IBMVFC_INIT_TIMEOUT;
 static unsigned int default_timeout = IBMVFC_DEFAULT_TIMEOUT;
-static unsigned int max_lun = IBMVFC_MAX_LUN;
+static uint64_t max_lun = IBMVFC_MAX_LUN;
 static unsigned int max_targets = IBMVFC_MAX_TARGETS;
 static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
@@ -71,7 +71,7 @@ MODULE_PARM_DESC(default_timeout,
 module_param_named(max_requests, max_requests, uint, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. "
 		 "[Default=" __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
-module_param_named(max_lun, max_lun, uint, S_IRUGO);
+module_param_named(max_lun, max_lun, ulong, S_IRUGO);
 MODULE_PARM_DESC(max_lun, "Maximum allowed LUN. "
 		 "[Default=" __stringify(IBMVFC_MAX_LUN) "]");
 module_param_named(max_targets, max_targets, uint, S_IRUGO);
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a364cae..afaae2a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1967,6 +1967,14 @@ lpfc_vport_param_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
+#define LPFC_VPORT_ULL_ATTR_R(name, defval, minval, maxval, desc) \
+static uint64_t lpfc_##name = defval;\
+module_param(lpfc_##name, ullong, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
+
 #define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
 module_param(lpfc_##name, uint, S_IRUGO);\
@@ -3926,7 +3934,7 @@ LPFC_VPORT_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands "
 # Value range is [0,65535]. Default value is 255.
 # NOTE: The SCSI layer might probe all allowed LUN on some old targets.
 */
-LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
+LPFC_VPORT_ULL_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
 
 /*
 # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7a4e68f..1d98dee 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1881,7 +1881,7 @@ megaraid_info(struct Scsi_Host *host)
 		 "LSI Logic MegaRAID %s %d commands %d targs %d chans %d luns",
 		 adapter->fw_version, adapter->product_info.max_commands,
 		 adapter->host->max_id, adapter->host->max_channel,
-		 adapter->host->max_lun);
+		 (unsigned int)adapter->host->max_lun);
 	return buffer;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index dcbf7c8..48773aa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -112,8 +112,8 @@ MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
 
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT3SAS_MAX_LUN (16895)
-static int max_lun = MPT3SAS_MAX_LUN;
-module_param(max_lun, int, 0);
+static uint64_t max_lun = MPT3SAS_MAX_LUN;
+module_param(max_lun, ullong, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3be592d..909bd5d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -109,7 +109,7 @@ extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
 extern int ql2xtargetreset;
 extern int ql2xdontresethba;
-extern unsigned int ql2xmaxlun;
+extern uint64_t ql2xmaxlun;
 extern int ql2xmdcapmask;
 extern int ql2xmdenable;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 71e6ddf..5d78022 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -201,8 +201,8 @@ MODULE_PARM_DESC(ql2xdontresethba,
 		" 0 (Default) -- Reset on failure.\n"
 		" 1 -- Do not reset on failure.\n");
 
-uint ql2xmaxlun = MAX_LUNS;
-module_param(ql2xmaxlun, uint, S_IRUGO);
+uint64_t ql2xmaxlun = MAX_LUNS;
+module_param(ql2xmaxlun, ullong, S_IRUGO);
 MODULE_PARM_DESC(ql2xmaxlun,
 		"Defines the maximum LU number to register with the SCSI "
 		"midlayer. Default is 65535.");
@@ -2449,7 +2449,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ql_dbg(ql_dbg_init, base_vha, 0x0033,
 	    "max_id=%d this_id=%d "
 	    "cmd_per_len=%d unique_id=%d max_cmd_len=%d max_channel=%d "
-	    "max_lun=%d transportt=%p, vendor_id=%llu.\n", host->max_id,
+	    "max_lun=%llu transportt=%p, vendor_id=%llu.\n", host->max_id,
 	    host->this_id, host->cmd_per_lun, host->unique_id,
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e860a3..dd25df7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -82,14 +82,14 @@ static const char *scsi_null_device_strs = "nullnullnullnull";
 #define MAX_SCSI_LUNS	512
 
 #ifdef CONFIG_SCSI_MULTI_LUN
-static unsigned int max_scsi_luns = MAX_SCSI_LUNS;
+static uint64_t max_scsi_luns = MAX_SCSI_LUNS;
 #else
-static unsigned int max_scsi_luns = 1;
+static uint64_t max_scsi_luns = 1;
 #endif
 
-module_param_named(max_luns, max_scsi_luns, uint, S_IRUGO|S_IWUSR);
+module_param_named(max_luns, max_scsi_luns, ullong, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
-		 "last scsi LUN (should be between 1 and 2^32-1)");
+		 "last LUN for sequential scan (should be between 1 and 2^64-1)");
 
 #ifdef CONFIG_SCSI_SCAN_ASYNC
 #define SCSI_SCAN_TYPE_DEFAULT "async"
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 137b419..4ea8904 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -372,6 +372,11 @@ extern int param_set_ulong(const char *val, const struct kernel_param *kp);
 extern int param_get_ulong(char *buffer, const struct kernel_param *kp);
 #define param_check_ulong(name, p) __param_check(name, p, unsigned long)
 
+extern struct kernel_param_ops param_ops_ullong;
+extern int param_set_ullong(const char *val, const struct kernel_param *kp);
+extern int param_get_ullong(char *buffer, const struct kernel_param *kp);
+#define param_check_ullong(name, p) __param_check(name, p, unsigned long long)
+
 extern struct kernel_param_ops param_ops_charp;
 extern int param_set_charp(const char *val, const struct kernel_param *kp);
 extern int param_get_charp(char *buffer, const struct kernel_param *kp);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..7cd0d07 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -603,11 +603,11 @@ struct Scsi_Host {
 	 * These three parameters can be used to allow for wide scsi,
 	 * and for host adapters that support multiple busses
 	 * The first two should be set to 1 more than the actual max id
-	 * or lun (i.e. 8 for normal systems).
+	 * or lun (e.g. 8 for SCSI parallel systems).
 	 */
-	unsigned int max_id;
-	unsigned int max_lun;
 	unsigned int max_channel;
+	unsigned int max_id;
+	uint64_t max_lun;
 
 	/*
 	 * This is a unique identifier that must be assigned so that we
diff --git a/kernel/params.c b/kernel/params.c
index ed35345..fe60ee9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -259,6 +259,7 @@ STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
 STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
 STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
 STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(ullong, unsigned long long, "%llu", unsigned long long, strict_strtoull);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-- 
1.7.4.2

