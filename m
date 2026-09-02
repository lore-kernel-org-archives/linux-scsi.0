Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D33EF67D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 09:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788341342; cv=none; b=LlJ9+l4EBHy9U/U4GAk1MWW5RFjzELedIwEP+Bq80TCQENS2YYnorFH2nc+t2J+Xjb+kT+H++58VNGX/DaaGcUJ28/ZtiJfyylgA4ftDHQESQvKUHChmbgtR5tK0NGjEpP5CzZMUp+0+/uM0v7LW56na9I0GZP1iH+GSI2kozE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788341342; c=relaxed/simple;
	bh=peZnTaKnvDeoh2LG4G9grBL+W1Kp7tQuGWd/KnYr4P4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ny+Lp6roMxlabxQgF1nV9OWDN5LZLtt3dsgXcAEgLaiZ4iBm34W7B3jVyXB7aHHBRaUs9x2O5ruAQwYcWln4w8Yr6Ygyj2BBDreC14MBd3SL12Qwi407FeTWLBrP+f2VzKdR1qZB3TTVlvpHg1A0lOZ91D7zxLX06+tshqnYVxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tYKNDwri; arc=none smtp.client-ip=95.215.58.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tYKNDwri"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=peZnTaKnvDeoh2LG4G9grBL+W1Kp7tQuGWd/KnYr4P4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788341337; v=1; x=1788946137;
 b=tYKNDwrio7EVyw+6PXFyS7UU5KC0QqT/3Mbtd6fAsj4oaOThWF2EM5z+QG+aG8esuhg2cG3R
 O77uaZIIFr/4tZ4Xk5UF2YmzBjLFHwmPp5VWJpFWr1VWO3a8hHNUyRgXasw1X+vVADfmwBVTDjq
 JhwtQGNHoMrKjSvBDn7ItCHg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 50ff65e1dfcd947f;
	Wed, 02 Sep 2026 09:28:57 +0000
X-Mizu-Trace-ID: 50ff65e1dfcd947f
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	fstests@vger.kernel.org,
	bvanassche@acm.org,
	John Garry <john.garry@linux.dev>
Subject: [PATCH] scsi: scsi_debug: default to a higher throughput config
Date: Wed,  2 Sep 2026 10:28:44 +0100
Message-ID: <20260902092844.1741533-1-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the default config goes not give as high a throughput as some
would like.

Give a higher default throughput by modifying the following:
- set completion response delay as 0
- increase shost can_queue to 4096, which aligns better with modern
  high-speed HBAs
- turn on clustering

Signed-off-by: John Garry <john.garry@linux.dev>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3346562275f8..f2afe757c438 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -79,7 +79,7 @@ static const char *sdebug_version_date = "20210520";
  */
 #define DEF_ATO 1
 #define DEF_CDB_LEN 10
-#define DEF_JDELAY   1		/* if > 0 unit is a jiffy */
+#define DEF_JDELAY   0		/* if > 0 unit is a jiffy */
 #define DEF_DEV_SIZE_PRE_INIT   0
 #define DEF_DEV_SIZE_MB   8
 #define DEF_ZBC_DEV_SIZE_MB   128
@@ -106,6 +106,7 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_PTYPE   TYPE_DISK
 #define DEF_RANDOM false
 #define DEF_REMOVABLE false
+#define DEF_CLUSTERING true
 #define DEF_SCSI_LEVEL   7    /* INQUIRY, byte2 [6->SPC-4; 7->SPC-5] */
 #define DEF_SECTOR_SIZE 512
 #define DEF_UNMAP_ALIGNMENT 0
@@ -217,8 +218,7 @@ struct tape_block {
  * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth
  * but cannot exceed SDEBUG_CANQUEUE .
  */
-#define SDEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
-#define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
+#define SDEBUG_CANQUEUE  (4096)
 #define DEF_CMD_PER_LUN  SDEBUG_CANQUEUE
 
 /* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
@@ -850,7 +850,7 @@ static int sdebug_num_hosts;
 static int sdebug_add_host = DEF_NUM_HOST;  /* in sysfs this is relative */
 static int sdebug_ato = DEF_ATO;
 static int sdebug_cdb_len = DEF_CDB_LEN;
-static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
+static int sdebug_jdelay = DEF_JDELAY;
 static int sdebug_dev_size_mb = DEF_DEV_SIZE_PRE_INIT;
 static int sdebug_dif = DEF_DIF;
 static int sdebug_dix = DEF_DIX;
@@ -899,7 +899,7 @@ static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_random = DEF_RANDOM;
 static bool sdebug_per_host_store = DEF_PER_HOST_STORE;
 static bool sdebug_removable = DEF_REMOVABLE;
-static bool sdebug_clustering;
+static bool sdebug_clustering = DEF_CLUSTERING;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
 static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_no_rwlock;
@@ -7373,8 +7373,8 @@ MODULE_VERSION(SDEBUG_VERSION);
 MODULE_PARM_DESC(add_host, "add n hosts, in sysfs if negative remove host(s) (def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(cdb_len, "suggest CDB lengths to drivers (def=10)");
-MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
-MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
+MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=1)");
+MODULE_PARM_DESC(delay, "response delay (def=0 jiffy); 0:imm, -1,-2:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
-- 
2.43.0

