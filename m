From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Wed, 21 Aug 2013 18:02:09 -0700
Message-ID: <1377133329.12003.9.camel@joe-AO722>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zwu.kernel@gmail.com
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-22 at 08:44 +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Initialize csum variable to fix the build warning.

Maybe it'd be better to change the variable
scsi_debug_guard type to bool?

Something like:
---
 drivers/scsi/scsi_debug.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..58375c3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -97,7 +97,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_D_SENSE   0
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
-#define DEF_GUARD 0
+#define DEF_GUARD false
 #define DEF_LBPU 0
 #define DEF_LBPWS 0
 #define DEF_LBPWS10 0
@@ -169,7 +169,7 @@ static int scsi_debug_dix = DEF_DIX;
 static int scsi_debug_dsense = DEF_D_SENSE;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
-static int scsi_debug_guard = DEF_GUARD;
+static bool scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
@@ -1735,14 +1735,11 @@ static u16 dif_compute_csum(const void *buf, int len)
 {
 	u16 csum;
 
-	switch (scsi_debug_guard) {
-	case 1:
+	if (scsi_debug_guard)
 		csum = ip_compute_csum(buf, len);
-		break;
-	case 0:
+	else
 		csum = cpu_to_be16(crc_t10dif(buf, len));
-		break;
-	}
+
 	return csum;
 }
 
@@ -2736,7 +2733,7 @@ module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
 module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
-module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(guard, scsi_debug_guard, bool, S_IRUGO);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -3312,11 +3309,6 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (scsi_debug_guard > 1) {
-		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
-		return -EINVAL;
-	}
-
 	if (scsi_debug_ato > 1) {
 		printk(KERN_ERR "scsi_debug_init: ato must be 0 or 1\n");
 		return -EINVAL;
@@ -4028,7 +4020,7 @@ static int sdebug_driver_probe(struct device * dev)
 	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
 	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
 
-	if (scsi_debug_guard == 1)
+	if (scsi_debug_guard)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
 	else
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
