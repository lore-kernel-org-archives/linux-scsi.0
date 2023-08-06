Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEA2C00528
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjHFRIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjHFRIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:08:47 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C41988
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:08:23 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691341702; x=1691348902; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=A782TrwYmIkHVfhZ26Y5dfqSG3A3PGeugjDnAevKJYo=;
 b=OyFh2Jaoajiy1vTqWI7CwMxcrcTC4c2AFf0KyLofX4WSetw8mZYXaTggnGsm7qynTngXFbUKZuPplpIgnQwdZ9jKnuOVsQvN8qpskipk0LQaD0soZqeDkTBTbKhONoW5/8PXnDBXZh7F39I+j8iaPXGAHxk/fRfUrLU2pRQdtOS/FHKou33z/jVWn+zm8NskIlhq4uZnjiJJ5X5yi0fcSy9TEChoXbeq3YiXtPTgSqEr4A1VNMncCAp14pjd5vY6rqTyzzBVKTGFNByr3Qqsni4GHOOSPfK1xeg6FXNLc1V30gv+mzACVOHQAqQ4xLvmSkFICfhtRi3M/bJdy1AC3Q==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 612ac3bab8bf with SMTP id
 64cfd386c57a92cb4d24aa83 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:08:22 GMT
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
Subject: [PATCH v2 07/12] scsi: mpt3sas: Use struct_size() for struct size calculations
Date:   Sun,  6 Aug 2023 10:05:59 -0700
Message-Id: <20230806170604.16143-8-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After converting terminal variable arrays into flexible array
members, use the bounds-checking struct_size() helper when possible
to avoid open-coded arithmetic struct size calculations.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  3 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 18 ++++++------------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  9 +++------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  3 +--
 4 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 53f5492579cb..2ae0185938f3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4876,8 +4876,7 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 	if (!num_phys)
 		return;
 
-	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (num_phys *
-	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sz = struct_size(sas_iounit_pg1, PhyData, num_phys);
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c3c1f466fe01..d5426a520a77 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2431,8 +2431,7 @@ _scsih_get_volume_capabilities(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	raid_device->num_pds = num_pds;
-	sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
-	    sizeof(Mpi2RaidVol0PhysDisk_t));
+	sz = struct_size(vol_pg0, PhysDisk, num_pds);
 	vol_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!vol_pg0) {
 		dfailprintk(ioc,
@@ -5966,8 +5965,7 @@ _scsih_update_vphys_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	/*
 	 * Read SASIOUnitPage0 to get each HBA Phy's data.
 	 */
-	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) +
-	    (ioc->sas_hba.num_phys * sizeof(Mpi2SasIOUnit0PhyData_t));
+	sz = struct_size(sas_iounit_pg0, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -6145,8 +6143,7 @@ _scsih_get_port_table_after_reset(struct MPT3SAS_ADAPTER *ioc,
 	u64 attached_sas_addr;
 	u8 found = 0, port_count = 0, port_id;
 
-	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys
-	    * sizeof(Mpi2SasIOUnit0PhyData_t));
+	sz = struct_size(sas_iounit_pg0, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -6579,8 +6576,7 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		  ioc_info(ioc, "updating handles for sas_host(0x%016llx)\n",
 			   (u64)ioc->sas_hba.sas_address));
 
-	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys
-	    * sizeof(Mpi2SasIOUnit0PhyData_t));
+	sz = struct_size(sas_iounit_pg0, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -6731,8 +6727,7 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	ioc->sas_hba.num_phys = num_phys;
 
 	/* sas_iounit page 0 */
-	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
-	    sizeof(Mpi2SasIOUnit0PhyData_t));
+	sz = struct_size(sas_iounit_pg0, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -6754,8 +6749,7 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	/* sas_iounit page 1 */
-	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (ioc->sas_hba.num_phys *
-	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sz = struct_size(sas_iounit_pg1, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e8a4750f6ec4..421ea511b664 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1792,8 +1792,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	/* handle hba phys */
 
 	/* read sas_iounit page 0 */
-	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
-	    sizeof(Mpi2SasIOUnit0PhyData_t));
+	sz = struct_size(sas_iounit_pg0, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -1833,8 +1832,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	}
 
 	/* read sas_iounit page 1 */
-	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (ioc->sas_hba.num_phys *
-	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sz = struct_size(sas_iounit_pg1, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -1944,8 +1942,7 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	/* handle hba phys */
 
 	/* sas_iounit page 1 */
-	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (ioc->sas_hba.num_phys *
-	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sz = struct_size(sas_iounit_pg1, PhyData, ioc->sas_hba.num_phys);
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index cc07ba41f507..1d64e5056a8a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -141,8 +141,7 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 		return;
 	}
 
-	sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
-	    sizeof(Mpi2RaidVol0PhysDisk_t));
+	sz = struct_size(vol_pg0, PhysDisk, num_pds);
 	vol_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!vol_pg0) {
 		ioc_info(ioc, "WarpDrive : Direct IO is disabled Memory allocation failure for RVPG0\n");
-- 
2.39.2

