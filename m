Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4B8C001DF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjHFRIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjHFRIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:08:44 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE94E1BE9
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:08:14 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691341693; x=1691348893; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=rs2vUvjhVdTF56kmQzCuN3DgtP3YDle2zb+6Jr5tNsM=;
 b=JFyuzOnvWXQBNF74K+0Be8+Y0U9ONJE/4+X2KPyAyq3NDFNltUqL1CThI4oz3t7UhrVq7CUZQMRkthhPpxEEiK8GOZAqX4dqi9eM7UEsWtNp02tU9y2de3b88L1uwBG0scWLJ7JYi0tttHpbTSa/kgCfAx/hbycwRQayXEFJ/AIahpfpheqayz/J+OhZ7KzieDv+k2/6pSMv9zy0/CEhBFZiZ5AaFVLFxwQoVkTU4qEKo3t9tu/00imngtAD2215UEXhydo+O39ylqeeJ33dSHNlCwEqm6B/W92yN+xHDnM2TiTeMZC5i2fPSTKA+QwXCTpWbTXCttY0RgophpMKwg==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 1df4b02de713 with SMTP id
 64cfd37d7c3063b7c0f9c927 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:08:13 GMT
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
Subject: [PATCH v2 06/12] scsi: mpt3sas: Make MPI26_CONFIG_PAGE_PIOUNIT_1::PhyData[] a flexible array
Date:   Sun,  6 Aug 2023 10:05:58 -0700
Message-Id: <20230806170604.16143-7-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This terminal 1-length variable array can be directly converted into
a C99 flexible array member.

As all users of MPI26_CONFIG_PAGE_PIOUNIT_1 (Mpi26PCIeIOUnitPage1_t)
do not use PhyData[], no further source changes are required to
accommodate its reduced sizeof():

- mpt3sas_config.c:mpt3sas_config_get_pcie_iounit_pg1() fetches a
  Mpi26PCIeIOUnitPage1_t into a caller-provided buffer, and may fetch
  and write PhyData[] into that buffer depending on its sz argument.
  It has one caller:

  - mpt3sas_base.c:_base_assign_fw_reported_qd() passes
    sizeof(Mpi26PCIeIOUnitPage1_t) as sz, but does not use PhyData[].

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 138f31def81d..84b167d49e34 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -3668,12 +3668,9 @@ typedef struct _MPI26_PCIE_IO_UNIT1_PHY_DATA {
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
@@ -3685,7 +3682,7 @@ typedef struct _MPI26_CONFIG_PAGE_PIOUNIT_1 {
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

