From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 14/17] cxlflash: Support AFU debug
Date: Wed, 21 Jun 2017 21:16:22 -0500
Message-ID: <1498097782-9187-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752380AbdFVCQa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:16:30 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EXMI075398
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:30 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7r1ncxp2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:29 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:16:29 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Adopt the SISLite AFU debug capability to allow future CXL Flash
adapters the ability to better debug AFU issues. Update the SISLite
header with the changes necessary to support AFU debug operations
and create a host ioctl interface for user debug software. Also
update the cxlflash documentation to describe this new host ioctl.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt | 14 ++++++
 drivers/scsi/cxlflash/common.h     |  5 ++
 drivers/scsi/cxlflash/main.c       | 96 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h       |  1 +
 drivers/scsi/cxlflash/sislite.h    |  2 +
 include/uapi/scsi/cxlflash_ioctl.h | 37 +++++++++++++--
 6 files changed, 152 insertions(+), 3 deletions(-)

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
index 2d6297b..a64bdaa 100644
--- a/Documentation/powerpc/cxlflash.txt
+++ b/Documentation/powerpc/cxlflash.txt
@@ -413,3 +413,17 @@ HT_CXLFLASH_LUN_PROVISION
 
     With this information, the number of available LUNs and capacity can be
     can be calculated.
+
+HT_CXLFLASH_AFU_DEBUG
+---------------------
+    This ioctl is used to debug AFUs by supporting a command pass-through
+    interface. It is only valid when used with AFUs that support the AFU
+    debug capability.
+
+    With exception of buffer management, AFU debug commands are opaque to
+    cxlflash and treated as pass-through. For debug commands that do require
+    data transfer, the user supplies an adequately sized data buffer and must
+    specify the data transfer direction with respect to the host. There is a
+    maximum transfer size of 256K imposed. Note that partial read completions
+    are not supported - when errors are experienced with a host read data
+    transfer, the data buffer is not copied back to the user.
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 5810724..a91151c 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -262,6 +262,11 @@ static inline bool afu_has_cap(struct afu *afu, u64 cap)
 	return afu_cap & cap;
 }
 
+static inline bool afu_is_afu_debug(struct afu *afu)
+{
+	return afu_has_cap(afu, SISL_INTVER_CAP_AFU_DEBUG);
+}
+
 static inline bool afu_is_lun_provision(struct afu *afu)
 {
 	return afu_has_cap(afu, SISL_INTVER_CAP_LUN_PROVISION);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 1279293..d3ad52e 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3326,6 +3326,99 @@ static int cxlflash_lun_provision(struct cxlflash_cfg *cfg,
 }
 
 /**
+ * cxlflash_afu_debug() - host AFU debug handler
+ * @cfg:	Internal structure associated with the host.
+ * @arg:	Kernel copy of userspace ioctl data structure.
+ *
+ * For debug requests requiring a data buffer, always provide an aligned
+ * (cache line) buffer to the AFU to appease any alignment requirements.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_afu_debug(struct cxlflash_cfg *cfg,
+			      struct ht_cxlflash_afu_debug *afu_dbg)
+{
+	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
+	struct sisl_ioarcb rcb;
+	struct sisl_ioasa asa;
+	char *buf = NULL;
+	char *kbuf = NULL;
+	void __user *ubuf = (__force void __user *)afu_dbg->data_ea;
+	u16 req_flags = SISL_REQ_FLAGS_AFU_CMD;
+	u32 ulen = afu_dbg->data_len;
+	bool is_write = afu_dbg->hdr.flags & HT_CXLFLASH_HOST_WRITE;
+	int rc = 0;
+
+	if (!afu_is_afu_debug(afu)) {
+		rc = -ENOTSUPP;
+		goto out;
+	}
+
+	if (ulen) {
+		req_flags |= SISL_REQ_FLAGS_SUP_UNDERRUN;
+
+		if (ulen > HT_CXLFLASH_AFU_DEBUG_MAX_DATA_LEN) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (unlikely(!access_ok(is_write ? VERIFY_READ : VERIFY_WRITE,
+					ubuf, ulen))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		buf = kmalloc(ulen + cache_line_size() - 1, GFP_KERNEL);
+		if (unlikely(!buf)) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		kbuf = PTR_ALIGN(buf, cache_line_size());
+
+		if (is_write) {
+			req_flags |= SISL_REQ_FLAGS_HOST_WRITE;
+
+			rc = copy_from_user(kbuf, ubuf, ulen);
+			if (unlikely(rc))
+				goto out;
+		}
+	}
+
+	memset(&rcb, 0, sizeof(rcb));
+	memset(&asa, 0, sizeof(asa));
+
+	rcb.req_flags = req_flags;
+	rcb.msi = SISL_MSI_RRQ_UPDATED;
+	rcb.timeout = MC_AFU_DEBUG_TIMEOUT;
+	rcb.ioasa = &asa;
+
+	if (ulen) {
+		rcb.data_len = ulen;
+		rcb.data_ea = (uintptr_t)kbuf;
+	}
+
+	rcb.cdb[0] = SISL_AFU_CMD_DEBUG;
+	memcpy(&rcb.cdb[4], afu_dbg->afu_subcmd,
+	       HT_CXLFLASH_AFU_DEBUG_SUBCMD_LEN);
+
+	rc = send_afu_cmd(afu, &rcb);
+	if (rc) {
+		dev_err(dev, "%s: send_afu_cmd failed rc=%d asc=%08x afux=%x\n",
+			__func__, rc, asa.ioasc, asa.afu_extra);
+		goto out;
+	}
+
+	if (ulen && !is_write)
+		rc = copy_to_user(ubuf, kbuf, ulen);
+out:
+	kfree(buf);
+	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
  * cxlflash_chr_ioctl() - character device IOCTL handler
  * @file:	File pointer for this device.
  * @cmd:	IOCTL command.
@@ -3363,6 +3456,8 @@ static long cxlflash_chr_ioctl(struct file *file, unsigned int cmd,
 	} ioctl_tbl[] = {	/* NOTE: order matters here */
 	{ sizeof(struct ht_cxlflash_lun_provision),
 		(hioctl)cxlflash_lun_provision },
+	{ sizeof(struct ht_cxlflash_afu_debug),
+		(hioctl)cxlflash_afu_debug },
 	};
 
 	/* Hold read semaphore so we can drain if needed */
@@ -3373,6 +3468,7 @@ static long cxlflash_chr_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case HT_CXLFLASH_LUN_PROVISION:
+	case HT_CXLFLASH_AFU_DEBUG:
 		known_ioctl = true;
 		idx = _IOC_NR(HT_CXLFLASH_LUN_PROVISION) - _IOC_NR(cmd);
 		size = ioctl_tbl[idx].size;
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 6ae8a11..880e348 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -68,6 +68,7 @@
 /* AFU command timeout values */
 #define MC_AFU_SYNC_TIMEOUT	5	/* 5 secs */
 #define MC_LUN_PROV_TIMEOUT	5	/* 5 secs */
+#define MC_AFU_DEBUG_TIMEOUT	5	/* 5 secs */
 
 /* AFU command room retry limit */
 #define MC_ROOM_RETRY_CNT	10
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index c216fee..d671fae 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -74,6 +74,7 @@ struct sisl_ioarcb {
 	u8 cdb[16];		/* must be in big endian */
 #define SISL_AFU_CMD_SYNC		0xC0	/* AFU sync command */
 #define SISL_AFU_CMD_LUN_PROVISION	0xD0	/* AFU LUN provision command */
+#define SISL_AFU_CMD_DEBUG		0xE0	/* AFU debug command */
 
 #define SISL_AFU_LUN_PROVISION_CREATE	0x00	/* LUN provision create type */
 #define SISL_AFU_LUN_PROVISION_DELETE	0x01	/* LUN provision delete type */
@@ -412,6 +413,7 @@ struct sisl_global_regs {
 #define SISL_INTVER_CAP_RESERVED_CMD_MODE_A	0x200000000000ULL
 #define SISL_INTVER_CAP_RESERVED_CMD_MODE_B	0x100000000000ULL
 #define SISL_INTVER_CAP_LUN_PROVISION		0x080000000000ULL
+#define SISL_INTVER_CAP_AFU_DEBUG		0x040000000000ULL
 };
 
 #define CXLFLASH_NUM_FC_PORTS_PER_BANK	2	/* fixed # of ports per bank */
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
index ad79c34..48d107e 100644
--- a/include/uapi/scsi/cxlflash_ioctl.h
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -18,6 +18,11 @@
 #include <linux/types.h>
 
 /*
+ * Structure and definitions for all CXL Flash ioctls
+ */
+#define CXLFLASH_WWID_LEN		16
+
+/*
  * Structure and flag definitions CXL Flash superpipe ioctls
  */
 
@@ -151,7 +156,7 @@ struct dk_cxlflash_recover_afu {
 	__u64 reserved[8];		/* Reserved for future use */
 };
 
-#define DK_CXLFLASH_MANAGE_LUN_WWID_LEN			16
+#define DK_CXLFLASH_MANAGE_LUN_WWID_LEN			CXLFLASH_WWID_LEN
 #define DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE		0x8000000000000000ULL
 #define DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE	0x4000000000000000ULL
 #define DK_CXLFLASH_MANAGE_LUN_ALL_PORTS_ACCESSIBLE	0x2000000000000000ULL
@@ -209,10 +214,20 @@ struct ht_cxlflash_hdr {
 	__u64 return_flags;	/* Returned flags */
 };
 
+/*
+ * Input flag definitions available to all host ioctls
+ *
+ * These are grown from the bottom-up with the intention that ioctl-specific
+ * input flag definitions would grow from the top-down, allowing the two sets
+ * to co-exist. While not required/enforced at this time, this provides future
+ * flexibility.
+ */
+#define HT_CXLFLASH_HOST_READ				0x0000000000000000ULL
+#define HT_CXLFLASH_HOST_WRITE				0x0000000000000001ULL
+
 #define HT_CXLFLASH_LUN_PROVISION_SUBCMD_CREATE_LUN	0x0001
 #define HT_CXLFLASH_LUN_PROVISION_SUBCMD_DELETE_LUN	0x0002
 #define HT_CXLFLASH_LUN_PROVISION_SUBCMD_QUERY_PORT	0x0003
-#define HT_CXLFLASH_LUN_PROVISION_WWID_LEN		16
 
 struct ht_cxlflash_lun_provision {
 	struct ht_cxlflash_hdr hdr; /* Common fields */
@@ -220,7 +235,7 @@ struct ht_cxlflash_lun_provision {
 	__u16 reserved16[3];	    /* Reserved for future use */
 	__u64 size;		    /* Size of LUN (4K blocks) */
 	__u64 lun_id;		    /* SCSI LUN ID */
-	__u8 wwid[HT_CXLFLASH_LUN_PROVISION_WWID_LEN]; /* Page83 WWID, NAA-6 */
+	__u8 wwid[CXLFLASH_WWID_LEN];/* Page83 WWID, NAA-6 */
 	__u64 max_num_luns;	    /* Maximum number of LUNs provisioned */
 	__u64 cur_num_luns;	    /* Current number of LUNs provisioned */
 	__u64 max_cap_port;	    /* Total capacity for port (4K blocks) */
@@ -228,8 +243,23 @@ struct ht_cxlflash_lun_provision {
 	__u64 reserved[8];	    /* Reserved for future use */
 };
 
+#define	HT_CXLFLASH_AFU_DEBUG_MAX_DATA_LEN		262144	/* 256K */
+#define HT_CXLFLASH_AFU_DEBUG_SUBCMD_LEN		12
+struct ht_cxlflash_afu_debug {
+	struct ht_cxlflash_hdr hdr; /* Common fields */
+	__u8 reserved8[4];	    /* Reserved for future use */
+	__u8 afu_subcmd[HT_CXLFLASH_AFU_DEBUG_SUBCMD_LEN]; /* AFU subcommand,
+							    * (pass through)
+							    */
+	__u64 data_ea;		    /* Data buffer effective address */
+	__u32 data_len;		    /* Data buffer length */
+	__u32 reserved32;	    /* Reserved for future use */
+	__u64 reserved[8];	    /* Reserved for future use */
+};
+
 union cxlflash_ht_ioctls {
 	struct ht_cxlflash_lun_provision lun_provision;
+	struct ht_cxlflash_afu_debug afu_debug;
 };
 
 #define MAX_HT_CXLFLASH_IOCTL_SZ	(sizeof(union cxlflash_ht_ioctls))
@@ -239,6 +269,7 @@ union cxlflash_ht_ioctls {
  * region (0xBF) and grow downwards.
  */
 #define HT_CXLFLASH_LUN_PROVISION CXL_IOWR(0xBF, ht_cxlflash_lun_provision)
+#define HT_CXLFLASH_AFU_DEBUG	  CXL_IOWR(0xBE, ht_cxlflash_afu_debug)
 
 
 #endif /* ifndef _CXLFLASH_IOCTL_H */
-- 
2.1.0
