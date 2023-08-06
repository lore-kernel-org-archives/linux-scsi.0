Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309B1C0015E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjHFRID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjHFRIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:08:02 -0400
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCCC1BC2
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:07:43 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691341661; x=1691348861; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=CB44tAmEE1clF9a0tXsLbz/dAmYwfrlleBbQtyUMsN8=;
 b=estTfglN1JOOl6TYkqc2Wi25OSFX41eIAg455C9Zzn07YtoaFHXh6b/DJsT0ZaNQgOG054K6MkLfv3+SAFT7QlJW6qBbssQM4S4fiq5qRphDDsMDCpOEtQSdF9uXXB3oKxMG2uTntEbUEOznm9XKV0QY7FQTbZJGOQRUH47og4ZQ6SV9o7ZYe3wOGQygX/O5Vlh6wXeszg1pjIOv6jdgY5k+TKMFp2s5OK8XITC1E3GqBykVmSTaXORSITE0x6YgDCNiVyrTRDB4tiy/X4m1QTdk899Kz2huaX0mggXCivbc8oHoCyoBY9RLsybsPDFgdbqBZuYrmaNb2dOl4iww1w==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 95bab117a771 with SMTP id
 64cfd35df85b1f0c8f86a423 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:07:41 GMT
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
Subject: [PATCH v2 03/12] scsi: mpt3sas: Make MPI2_CONFIG_PAGE_RAID_VOL_0::PhysDisk[] a flexible array
Date:   Sun,  6 Aug 2023 10:05:55 -0700
Message-Id: <20230806170604.16143-4-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This terminal 1-length variable array can be directly converted into
a C99 flexible array member.

As all users of MPI2_CONFIG_PAGE_RAID_VOL_0 (Mpi2RaidVolPage0_t)
either calculate its size without depending on its sizeof() or do not
use PhysDisk[], no further source changes are required:

- mpt3sas_config.c:mpt3sas_config_get_number_pds() fetches a
  Mpi2RaidVolPage0_t for itself, but does not use PhysDisk[].

- mpt3sas_config.c:mpt3sas_config_get_raid_volume_pg0() fetches a
  Mpi2RaidVolPage0_t into a caller-provided buffer, and may fetch and
  write PhysDisk[] into that buffer depending on its sz argument.
  Its callers:

  - mpt3sas_scsih.c:scsih_get_resync(),
    mpt3sas_scsih.c:scsih_get_state(),
    mpt3sas_scsih.c:_scsih_search_responding_raid_devices(), and
    mpt3sas_scsih.c:_scsih_scan_for_devices_after_reset() all pass
    sizeof(Mpi2RaidVolPage0_t) as sz, but do not use PhysDisk[].

  - mpt3sas_scsih.c:_scsih_get_volume_capabilities() and
    mpt3sas_warpdrive.c:mpt3sas_init_warpdrive_properties()
    both calculate sz independently of sizeof(Mpi2RaidVolPage0_t)
    and allocate a suitable buffer before calling
    mpt3sas_config_get_raid_volume_pg0() and using PhysDisk[].

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 12b656bd883d..55abfc00301e 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -1801,12 +1801,9 @@ typedef struct _MPI2_RAIDVOL0_SETTINGS {
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
@@ -1826,8 +1823,7 @@ typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0 {
 	U8                      Reserved2;         /*0x25 */
 	U8                      Reserved3;         /*0x26 */
 	U8                      InactiveStatus;    /*0x27 */
-	MPI2_RAIDVOL0_PHYS_DISK
-	PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /*0x28 */
+	MPI2_RAIDVOL0_PHYS_DISK PhysDisk[];        /*0x28 */
 } MPI2_CONFIG_PAGE_RAID_VOL_0,
 	*PTR_MPI2_CONFIG_PAGE_RAID_VOL_0,
 	Mpi2RaidVolPage0_t, *pMpi2RaidVolPage0_t;
-- 
2.39.2

