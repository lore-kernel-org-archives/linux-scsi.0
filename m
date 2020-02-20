Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6174CC11D20
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F3BF208CD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgBTUJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:09:03 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47277 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgBTUJC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 15:09:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5BE38204269;
        Thu, 20 Feb 2020 21:09:00 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v24uuyNwLMcx; Thu, 20 Feb 2020 21:08:54 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 9493D20425B;
        Thu, 20 Feb 2020 21:08:53 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v3 09/15] scsi_debug: zbc module parameter
Date:   Thu, 20 Feb 2020 15:08:32 -0500
Message-Id: <20200220200838.15809-10-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220200838.15809-1-dgilbert@interlog.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add zbc module parameter (a boolean) as a synonym for the more
obscure ptype=0x14 . The zbc attribute is also available in
/sys/bus/pseudo/drivers/scsi_debug/zbc and is modifiable.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 42 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 10f8698031aa..be3597805b08 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -763,6 +763,7 @@ static bool have_dif_prot;
 static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
+static bool sdebug_zbc;
 
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
@@ -5443,6 +5444,7 @@ module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
+module_param_named(zbc, sdebug_zbc, bool, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5483,9 +5485,9 @@ MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
+MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
-MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
@@ -5504,6 +5506,7 @@ MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
+MODULE_PARM_DESC(zbc, "Emulate ZBC device(s) (def=false) [same action as ptype=0x14]");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
@@ -6225,6 +6228,42 @@ static ssize_t cdb_len_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(cdb_len);
 
+static ssize_t zbc_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_ptype == TYPE_ZBC);
+}
+static ssize_t zbc_store(struct device_driver *ddp, const char *buf,
+			 size_t count)
+{
+	bool want_zbc;
+	int ret, n;
+	int prev_pdt = sdebug_ptype;
+
+	ret = kstrtoint(buf, 0, &n);
+	if (ret)
+		return ret;
+	want_zbc = !!n;
+	if (prev_pdt == TYPE_ZBC || want_zbc) {
+		if (prev_pdt == TYPE_ZBC && want_zbc)
+			return count;
+		sdeb_zbc_in_use = want_zbc;
+		if (sdeb_zbc_in_use) {
+			struct sdeb_zone_state *zsp = sdeb_zstate_a;
+
+			sdebug_ptype = TYPE_ZBC;
+			zbc_swrz_start = sdebug_capacity >> 1;
+			zsp->write_pointer = zbc_swrz_start;
+			zsp->z_cond = zc1_empty;
+			++zsp;
+			zsp->write_pointer = zbc_swrz_start;
+			zsp->z_cond = zc1_empty;
+		} else {
+			sdebug_ptype = DEF_PTYPE;	/* a disk ? ? */
+		}
+	}
+	return count;
+}
+static DRIVER_ATTR_RW(zbc);
 
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -6267,6 +6306,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_strict.attr,
 	&driver_attr_uuid_ctl.attr,
 	&driver_attr_cdb_len.attr,
+	&driver_attr_zbc.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
-- 
2.25.0

