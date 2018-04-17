From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/6] scsi: devinfo: warn on undefined blist flags
Date: Wed, 18 Apr 2018 01:35:09 +0200
Message-ID: <20180417233511.6573-5-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Janusz Dziemidowicz <rraptorr@nails.eu.org>
List-Id: linux-scsi@vger.kernel.org

Warn if a device (or the user) sets blist flags which are unknown
or have been removed. This should enable us to reuse freed blist
bits in later releases.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/Makefile       |  2 +-
 drivers/scsi/scsi_devinfo.c |  6 ++++++
 include/scsi/scsi_devinfo.h | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index d5135ef..fd901a5 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -190,7 +190,7 @@ $(obj)/53c700.o $(MODVERDIR)/$(obj)/53c700.ver: $(obj)/53c700_d.h
 $(obj)/scsi_sysfs.o: $(obj)/scsi_devinfo_tbl.c
 
 quiet_cmd_bflags = GEN     $@
-	cmd_bflags = sed -n 's/.*BLIST_\([A-Z0-9_]*\) *.*/BLIST_FLAG_NAME(\1),/p' $< > $@
+	cmd_bflags = sed -n 's/.*define *BLIST_\([A-Z0-9_]*\) *.*/BLIST_FLAG_NAME(\1),/p' $< > $@
 
 $(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h
 	$(call if_changed,bflags)
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index fc6b755..c05843a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -371,6 +371,12 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 		}
 		flags = (__force blist_flags_t)val;
 	}
+	if (flags & __BLIST_UNUSED_MASK) {
+		pr_err("scsi_devinfo (%s:%s): unsupported flags 0x%llx",
+		       vendor, model, flags & __BLIST_UNUSED_MASK);
+		kfree(devinfo);
+		return -EINVAL;
+	}
 	devinfo->flags = flags;
 	devinfo->compatible = compatible;
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index e206d29..3434e14 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -28,8 +28,13 @@
 #define BLIST_LARGELUN		((__force blist_flags_t)(1ULL << 9))
 /* override additional length field */
 #define BLIST_INQUIRY_36	((__force blist_flags_t)(1ULL << 10))
+#define __BLIST_UNUSED_11	((__force blist_flags_t)(1ULL << 11))
 /* do not do automatic start on add */
 #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
+#define __BLIST_UNUSED_13	((__force blist_flags_t)(1ULL << 13))
+#define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
+#define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
+#define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
 #define BLIST_REPORTLUN2	((__force blist_flags_t)(1ULL << 17))
 /* don't try REPORT_LUNS scan (SCSI-3 devs) */
@@ -44,10 +49,12 @@
 #define BLIST_RETRY_HWERROR	((__force blist_flags_t)(1ULL << 22))
 /* maximum 512 sector cdb length */
 #define BLIST_MAX_512		((__force blist_flags_t)(1ULL << 23))
+#define __BLIST_UNUSED_24	((__force blist_flags_t)(1ULL << 24))
 /* Disable T10 PI (DIF) */
 #define BLIST_NO_DIF		((__force blist_flags_t)(1ULL << 25))
 /* Ignore SBC-3 VPD pages */
 #define BLIST_SKIP_VPD_PAGES	((__force blist_flags_t)(1ULL << 26))
+#define __BLIST_UNUSED_27	((__force blist_flags_t)(1ULL << 27))
 /* Attempt to read VPD pages */
 #define BLIST_TRY_VPD_PAGES	((__force blist_flags_t)(1ULL << 28))
 /* don't try to issue RSOC */
@@ -57,4 +64,18 @@
 /* Use UNMAP limit for WRITE SAME */
 #define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1ULL << 31))
 
+#define __BLIST_LAST_USED BLIST_UNMAP_LIMIT_WS
+
+#define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
+			       (__force blist_flags_t) \
+			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
+#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_11 | \
+			     __BLIST_UNUSED_13 | \
+			     __BLIST_UNUSED_14 | \
+			     __BLIST_UNUSED_15 | \
+			     __BLIST_UNUSED_16 | \
+			     __BLIST_UNUSED_24 | \
+			     __BLIST_UNUSED_27 | \
+			     __BLIST_HIGH_UNUSED)
+
 #endif
-- 
2.16.1
