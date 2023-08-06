Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F14C001DF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjHFRSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjHFRR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:17:57 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38720CF
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:17:55 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691342274; x=1691349474; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=1Ux0AJYfL7GZoZq3tCyFoXrVwyN+ZroothmdbliMyww=;
 b=V2tDjMR1qCHtXGPrenYVp8x5WgYWjhqHY2o9FXyr05F+xoQei8ePEx1sPo+YMemIjQ2KLyOFjBtSK+cyh875X6k+DZSIYazx2CA//NpfAP8UW371zftKHJ+PYPuF0AKq5TDmN0CdWgCKZHzcuONOMZGAvgaxTS+SzbtZLhLbtK/s0NDTapuguNGcY0IYnREwheQrG0fPj4T4ZkjwDjoJiFIMq25fWZDxpj0v1AGaiNsUwUJ3pF+bRbQ6LCTUMovQnZnoBHjhanLkGsYvJBxhMPSX/cK8Uv52rxVIGf/YEMX5k5jMmCq66gIJW0hbuB0ZVjppmdzZa9dZgIaVqmE/Fw==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 612ac3bab8bf with SMTP id
 64cfd36ac57a92cb4d247c89 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:07:54 GMT
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
Subject: [PATCH v2 04/12] scsi: mpt3sas: Make MPI2_CONFIG_PAGE_SASIOUNIT_0::PhyData[] a flexible array
Date:   Sun,  6 Aug 2023 10:05:56 -0700
Message-Id: <20230806170604.16143-5-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This terminal 1-length variable array can be directly converted into
a C99 flexible array member.

As all users of MPI2_CONFIG_PAGE_SASIOUNIT_0 (Mpi2SasIOUnitPage0_t)
either calculate its size without depending on its sizeof() or do not
use PhyData[], no further source changes are required:

- mpt3sas_config.c:mpt3sas_config_get_number_hba_phys() fetches a
  Mpi2SasIOUnitPage0_t for itself, but does not use PhyData[].

- mpt3sas_config.c:mpt3sas_config_get_sas_iounit_pg0() fetches a
  Mpi2SasIOUnitPage0_t into a caller-provided buffer, and may fetch
  and write PhyData[] into that buffer depending on its sz argument.
  Its callers:

  - mpt3sas_scsih.c:_scsih_update_vphys_after_reset(),
    mpt3sas_scsih.c:_scsih_get_port_table_after_reset(),
    mpt3sas_scsih.c:_scsih_sas_host_refresh(),
    mpt3sas_scsih.c:_scsih_sas_host_add(), and
    mpt3sas_transport.c:_transport_phy_enable() all calculate sz
    independently of sizeof(Mpi2SasIOUnitPage0_t) and allocate a
    suitable buffer before calling mpt3sas_config_get_sas_iounit_pg0()
    and using PhyData[].

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 55abfc00301e..07a8d7646b6d 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -2178,12 +2178,9 @@ typedef struct _MPI2_SAS_IO_UNIT0_PHY_DATA {
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
@@ -2191,8 +2188,7 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_0 {
 	U8                                  NumPhys;  /*0x0C */
 	U8                                  Reserved2;/*0x0D */
 	U16                                 Reserved3;/*0x0E */
-	MPI2_SAS_IO_UNIT0_PHY_DATA
-		PhyData[MPI2_SAS_IOUNIT0_PHY_MAX];    /*0x10 */
+	MPI2_SAS_IO_UNIT0_PHY_DATA          PhyData[];/*0x10 */
 } MPI2_CONFIG_PAGE_SASIOUNIT_0,
 	*PTR_MPI2_CONFIG_PAGE_SASIOUNIT_0,
 	Mpi2SasIOUnitPage0_t, *pMpi2SasIOUnitPage0_t;
-- 
2.39.2

