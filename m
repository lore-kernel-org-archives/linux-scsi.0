From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V2 1/2] scsi_debug: unify scsi_level in proc and sysfs
Date: Wed, 22 Jan 2014 16:19:18 +0800
Message-ID: <1390378758-3359-1-git-send-email-handai.szj@taobao.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45567 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaAVITm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 03:19:42 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so66328pab.21
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 00:19:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, martin.petersen@oracle.com, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

There're severel interfaces to show scsi_level value of scsi_debug,
but they're not in consistent, e.g.:

1)
#cat /sys/bus/pseudo/drivers/scsi_debug/scsi_level
5

2)
#cat /proc/scsi/scsi_debug/7
scsi_debug adapter driver, version 1.82 [20100324]
num_tgts=1, shared (ram) size=1024 MB, opts=0x0, every_nth=0(curr:0)
delay=1, max_luns=1, scsi_level=5
sector_size=512 bytes, cylinders=130, heads=255, sectors=63
number of aborts=0, device_reset=0, bus_resets=0, host_resets=0
dix_reads=0 dix_writes=0 dif_errors=0

3)
#cat /sys/bus/scsi/devices/7\:0\:0\:0/scsi_level (or lsscsi -l)
6

According to the description in scsi.h, "struct scsi_device::scsi_level
values. For SCSI devices other than those prior to SCSI-2 (i.e. over
12 years old) this value is (resp[2] + 1) where 'resp' is a byte array
of the response to an INQUIRY". For scsi_debug, the resp[2] of INQUIRY
is 5 which indicates using SPC-3, but the sysfs's scsi_level should show 6.

So introduce a new scsi_debug_inquiry_vers to only represent the version
vaule, and correct the scsi_debug_scsi_level to be resp[2] + 1.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---

v2:
 - introduce a new variable to represent resp[2] of INQUIRY. [Doug Gilbert]


 drivers/scsi/scsi_debug.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 80b8b10..210bd10 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -110,7 +110,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_PHYSBLK_EXP 0
 #define DEF_PTYPE   0
 #define DEF_REMOVABLE false
-#define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
+#define DEF_INQUIRY_VERS   5    /* INQUIRY VERSION, byte2 [5->SPC-3] */
 #define DEF_SECTOR_SIZE 512
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
@@ -181,7 +181,8 @@ static int scsi_debug_opt_blks = DEF_OPT_BLKS;
 static int scsi_debug_opts = DEF_OPTS;
 static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
-static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
+static int scsi_debug_inquiry_vers = DEF_INQUIRY_VERS;
+static int scsi_debug_scsi_level = DEF_INQUIRY_VERS + 1; /* scsi_level is resp[2]+1 */
 static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
 static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
@@ -927,7 +928,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 	}
 	/* drops through here for a standard inquiry */
 	arr[1] = scsi_debug_removable ? 0x80 : 0;	/* Removable disk */
-	arr[2] = scsi_debug_scsi_level;
+	arr[2] = scsi_debug_inquiry_vers;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
 	arr[5] = scsi_debug_dif ? 1 : 0; /* PROTECT bit */
@@ -2811,7 +2812,7 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err...
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
-MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
+MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-3])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
-- 
1.7.9.5

