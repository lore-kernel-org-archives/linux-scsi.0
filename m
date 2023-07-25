Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77168C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 16:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjGYQTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjGYQTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 12:19:36 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Jul 2023 09:19:16 PDT
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8291F211E
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 09:19:16 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690301955; x=1690309155; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=avo5xe4Pqri3QKvhXLzLD38y0Dqn60fjqqehGSBb2TI=;
 b=ifHIMIliVUejypO+B7r58O9P7mb9Em9wlYKeKqAvE4LpVycRD5TUchNmFPn167aDM2o94xxys1Ao0eRap6uligTyhvQfSbkCAOqpFC9JDezlm7AvgqfYTqZHYf13MOoEv4G/8DIj0s43QNPKSKWpfl4FrxOhOljXBiXJ6ShsvuHCXFPK0I+vEj0EPPJ579q487QG0KZHlO1+IsZq7FHXEBDZGOJeurIp0qfIaN4yPoPQzPWp78ms0XeHQsH5OmRCNjVlIv5E3W6XToKeorlA19QEgVk0LBCEVLXzalQFsmsOqgUYslvI1REgrHR/DwmlGgC6p1VRQOkoeHaa2jtuRQ==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by c69f01ada9c4 with SMTP id
 64bff4d66f49ebc4e506a65b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 Jul 2023 16:14:14 GMT
Sender: james@equiv.tech
From:   James Seo <james@equiv.tech>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     James Seo <james@equiv.tech>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] scsi: mpt3sas: Use flexible arrays when less obviously possible
Date:   Tue, 25 Jul 2023 09:13:27 -0700
Message-Id: <20230725161331.27481-3-james@equiv.tech>
In-Reply-To: <20230725161331.27481-1-james@equiv.tech>
References: <20230725161331.27481-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These old-style 1-length variable arrays can be directly converted
into C99 flexible array members without any further source changes
and without any meaningful binary changes. All uses of the affected
structs were investigated, and the existing code somehow manages to
weather the reduced sizeof() the affected structs in every case.

For example, we may have previously requested 26 bytes from the
device to fill a 26-byte buffer for a struct, and we are now dealing
with 12 bytes due to sizeof() reduction. However, either we never use
the variable array anyway, or we follow up with a subsequent request
for the same struct in its entirety after using its variable element
count (usually taken from one of the struct fields) to allocate a
larger buffer.

It also turns out that size calculations are always performed as e.g.
"offsetof(struct foo, arr_of_bar) + n * sizeof(bar)" instead of
"sizeof(struct foo) + (n - 1) * sizeof(bar)", and are therefore
already correct.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 48 +++++++++-------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 42d820159c44..f07215fbc140 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -1200,12 +1200,9 @@ typedef struct _MPI2_IOUNIT8_SENSOR {
 #define MPI2_IOUNIT8_SENSOR_FLAGS_T0_ENABLE         (0x0001)
 
 /*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for NumSensors at runtime.
+ *Host code (drivers, BIOS, utilities, etc.) should check the value returned
+ *for NumSensors at runtime before using Sensor[].
  */
-#ifndef MPI2_IOUNITPAGE8_SENSOR_ENTRIES
-#define MPI2_IOUNITPAGE8_SENSOR_ENTRIES     (1)
-#endif
 
 typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_8 {
 	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
@@ -1214,8 +1211,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_8 {
 	U8                      NumSensors;             /*0x0C */
 	U8                      PollingInterval;        /*0x0D */
 	U16                     Reserved3;              /*0x0E */
-	MPI2_IOUNIT8_SENSOR
-		Sensor[MPI2_IOUNITPAGE8_SENSOR_ENTRIES];/*0x10 */
+	MPI2_IOUNIT8_SENSOR     Sensor[];               /*0x10 */
 } MPI2_CONFIG_PAGE_IO_UNIT_8,
 	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_8,
 	Mpi2IOUnitPage8_t, *pMpi2IOUnitPage8_t;
@@ -1805,12 +1801,9 @@ typedef struct _MPI2_RAIDVOL0_SETTINGS {
 #define MPI2_RAIDVOL0_SETTING_ENABLE_WRITE_CACHING      (0x0002)
 
 /*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for NumPhysDisks at runtime.
+ *Host code (drivers, BIOS, utilities, etc.) should check the value returned
+ *for NumPhysDisks at runtime before using PhysDisk[].
  */
-#ifndef MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX
-#define MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX       (1)
-#endif
 
 typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0 {
 	MPI2_CONFIG_PAGE_HEADER Header;            /*0x00 */
@@ -1830,8 +1823,7 @@ typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0 {
 	U8                      Reserved2;         /*0x25 */
 	U8                      Reserved3;         /*0x26 */
 	U8                      InactiveStatus;    /*0x27 */
-	MPI2_RAIDVOL0_PHYS_DISK
-	PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /*0x28 */
+	MPI2_RAIDVOL0_PHYS_DISK PhysDisk[];        /*0x28 */
 } MPI2_CONFIG_PAGE_RAID_VOL_0,
 	*PTR_MPI2_CONFIG_PAGE_RAID_VOL_0,
 	Mpi2RaidVolPage0_t, *pMpi2RaidVolPage0_t;
@@ -2186,12 +2178,9 @@ typedef struct _MPI2_SAS_IO_UNIT0_PHY_DATA {
 	*pMpi2SasIOUnit0PhyData_t;
 
 /*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for NumPhys at runtime.
+ *Host code (drivers, BIOS, utilities, etc.) should check the value returned
+ *for NumPhys at runtime before using PhyData[].
  */
-#ifndef MPI2_SAS_IOUNIT0_PHY_MAX
-#define MPI2_SAS_IOUNIT0_PHY_MAX        (1)
-#endif
 
 typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_0 {
 	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;   /*0x00 */
@@ -2199,8 +2188,7 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_0 {
 	U8                                  NumPhys;  /*0x0C */
 	U8                                  Reserved2;/*0x0D */
 	U16                                 Reserved3;/*0x0E */
-	MPI2_SAS_IO_UNIT0_PHY_DATA
-		PhyData[MPI2_SAS_IOUNIT0_PHY_MAX];    /*0x10 */
+	MPI2_SAS_IO_UNIT0_PHY_DATA          PhyData[];/*0x10 */
 } MPI2_CONFIG_PAGE_SASIOUNIT_0,
 	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_0,
 	Mpi2SasIOUnitPage0_t, *pMpi2SasIOUnitPage0_t;
@@ -2261,12 +2249,9 @@ typedef struct _MPI2_SAS_IO_UNIT1_PHY_DATA {
 	*pMpi2SasIOUnit1PhyData_t;
 
 /*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for NumPhys at runtime.
+ *Host code (drivers, BIOS, utilities, etc.) should check the value returned
+ *for NumPhys at runtime before using PhyData[].
  */
-#ifndef MPI2_SAS_IOUNIT1_PHY_MAX
-#define MPI2_SAS_IOUNIT1_PHY_MAX        (1)
-#endif
 
 typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_1 {
 	MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header; /*0x00 */
@@ -2287,7 +2272,7 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_1 {
 	U8
 		IODeviceMissingDelay;               /*0x13 */
 	MPI2_SAS_IO_UNIT1_PHY_DATA
-		PhyData[MPI2_SAS_IOUNIT1_PHY_MAX];  /*0x14 */
+		PhyData[];                          /*0x14 */
 } MPI2_CONFIG_PAGE_SASIOUNIT_1,
 	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_1,
 	Mpi2SasIOUnitPage1_t, *pMpi2SasIOUnitPage1_t;
@@ -3683,12 +3668,9 @@ typedef struct _MPI26_PCIE_IO_UNIT1_PHY_DATA {
 #define MPI26_PCIEIOUNIT1_LINKFLAGS_SRNS_EN                 (0x02)
 
 /*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for NumPhys at runtime.
+ *Host code (drivers, BIOS, utilities, etc.) should check the value returned
+ *for NumPhys at runtime before using PhyData[].
  */
-#ifndef MPI26_PCIE_IOUNIT1_PHY_MAX
-#define MPI26_PCIE_IOUNIT1_PHY_MAX      (1)
-#endif
 
 typedef struct _MPI26_CONFIG_PAGE_PIOUNIT_1 {
 	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/*0x00 */
@@ -3700,7 +3682,7 @@ typedef struct _MPI26_CONFIG_PAGE_PIOUNIT_1 {
 	U8	DMDReportPCIe;                      /*0x11 */
 	U16	Reserved2;                          /*0x12 */
 	MPI26_PCIE_IO_UNIT1_PHY_DATA
-		PhyData[MPI26_PCIE_IOUNIT1_PHY_MAX];/*0x14 */
+		PhyData[];                          /*0x14 */
 } MPI26_CONFIG_PAGE_PIOUNIT_1,
 	*PTR_MPI26_CONFIG_PAGE_PIOUNIT_1,
 	Mpi26PCIeIOUnitPage1_t, *pMpi26PCIeIOUnitPage1_t;
-- 
2.39.2

