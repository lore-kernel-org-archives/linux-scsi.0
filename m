Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EBD13B5AF
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127535; cv=none; b=SSabPuuN9dDl+KQoyiGVgjfrezRivQ2Y3QXS74lnQZIFaevXSWWavRuzYzzVbLApwPTbMUPqjG2izPUBALr1+7O2TSsrkgZrsQYonypjUs2EOTtNCuv65IpwmK/0gfUvfrV1GOUFeq/QILHKY3e3EakWylcNOmnJAm0Gr2WtulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127535; c=relaxed/simple;
	bh=qOOW9nLFWUmYEQTA8ZNSEXIFIlJYoJPsUasv7zcSurM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEm/XnPcV4gqsmtJnoHRqNGze0pAF6iQj1YtdEGEEze5H9kfGmdgY6piZCk8S9weVH8+NFQIw3nOh8wnTgWDkCe58H90FD40kYVGWzFt+qGlzDgfKB/4s4CfwTP6cztrEMGAag/L069zCGp9TShMrIDLYQCIUooU1vSauDIrrjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HHuFh31Z; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHuFh31Z"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94JLP7014056
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=n5uA1
	6y+/niKduHBsbFinbFKEhvTKbcKZTdT1a52Mrs=; b=HHuFh31ZxXz0STV4JDf/V
	4RhPe+ges9aWJjFZfnBpyQ8RWs5qDIFKfFFucu5H46asa1L7qfl+dLmRUhWePSPu
	RasgSdZbU0IHUofaw1vW9TXwzkzedffaDjYWJJ1JpEg9+GM/zHubsFpVZtbGc2qt
	ZaggITEwvt0+AcJlW7+GC18jJH5PVkbZgyyCxvHFOgECXf7l/BABPrMwWHHJlIW9
	+NCj3dIUI3XgEOI0zTT6web4M/eyt995umh1coGPCu82GfD7MxB9ef8U+NTvnDoC
	+b6AOSW7vLiyiZeNR8VrrdiZivDYAn3gDQXMF/QVph9pLMMOHUneb/1jCNw3eB37
	g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k580a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XYb7034280
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65ajam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdc001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-9;
	Sat, 09 Nov 2024 04:45:31 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 8/8] scsi_debug: Add module parameter for ALUA multipath
Date: Sat,  9 Nov 2024 04:45:29 +0000
Message-ID: <20241109044529.992935-9-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-ORIG-GUID: LD_iM0lHVJdmqOOOpIsMOZ7Xc0TMmiN0
X-Proofpoint-GUID: LD_iM0lHVJdmqOOOpIsMOZ7Xc0TMmiN0

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9be2a6a00530..811d3005c0a5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -167,6 +167,7 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_TUR_MS_TO_READY 0
 #define DEF_UUID_CTL 0
 #define JDELAY_OVERRIDDEN -9999
+#define DEF_ALUA_MPATH	0
 
 /* Default parameters for ZBC drives */
 #define DEF_ZBC_ZONE_SIZE_MB	128
@@ -884,6 +885,8 @@ static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
 static bool sdebug_allow_restart;
+static unsigned int sdebug_alua_mpath = DEF_ALUA_MPATH;
+
 static enum {
 	BLK_ZONED_NONE	= 0,
 	BLK_ZONED_HA	= 1,
@@ -2070,8 +2073,14 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
 	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
-	if (sdebug_vpd_use_hostno == 0)
-		arr[5] |= 0x10; /* claim: implicit TPGS */
+	if (sdebug_vpd_use_hostno == 0) {
+		 arr[5] |= 0x10;
+	} else {
+		if (sdebug_alua_mpath == 1)
+			arr[5] |= 0x11;
+		else
+			arr[5] |= 0x10;
+	}
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
@@ -6643,6 +6652,7 @@ module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 module_param_named(allow_restart, sdebug_allow_restart, bool, S_IRUGO | S_IWUSR);
+module_param_named(alua_mpath, sdebug_alua_mpath, int, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -6722,6 +6732,8 @@ MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 MODULE_PARM_DESC(allow_restart, "Set scsi_device's allow_restart flag(def=0)");
+MODULE_PARM_DESC(alua_mpath,
+	"\t 1 = implicit alua \n \t 2 = Explicit & Implicit ALUA, \n \t 0 = No ALUA Support (Default) \n");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.41.0.rc2

