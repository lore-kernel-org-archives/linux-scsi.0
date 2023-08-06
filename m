Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A0DC0015E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjHFRIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjHFRIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:08:49 -0400
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45156172E
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:08:32 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691341712; x=1691348912; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=lrC3BRW2HPgNfMPuOWpzvvknvBP4zyYNWUpu3nNDYr8=;
 b=bVCs/yQX0xkej1H8CbM8E5njVXcfjAcMhBt4ZtTKtfsnRZa9rVyqZqBoasr/zeygnMIPFsfyr/gFHjtyn1E9W/M7PMnPUQL/kclqaq/yJ5xWOkO6QyZiDVv2hSgqqzTB1qjLurpPlanSzAZEA+E1vkME2Hjv2AFzshWnUvyhWPDlXgepRGz2GokNUqzb6U5OEolCAL1rSWzDdI4cisENUl2RxfykX1otseJdnbTAGdDNDgMUrb9dNDxo1DCwMMAZ6ejqCOUvew5Zdk/heB8MmzuE8abtAaVc+IyoWuHHfchujMQfBGck3Q45Db/USWU9knaEBNRc8AUuBfPRxwQ7Dg==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 1df4b02de713 with SMTP id
 64cfd3907c3063b7c0fa1ac2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:08:32 GMT
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
Subject: [PATCH v2 08/12] scsi: mpt3sas: Remove the iounit_pg8 member of the per-adapter struct
Date:   Sun,  6 Aug 2023 10:06:00 -0700
Message-Id: <20230806170604.16143-9-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The per-adapter struct (struct MPT3SAS_ADAPTER) contains a
MPI2_CONFIG_PAGE_IO_UNIT_8 (Mpi2IOUnitPage8_t) iounit_pg8 member that
is populated by mpt3sas_base.c:_base_static_config_pages().

As the name of that function indicates, the iounit_pg8 member
represents a static configuration page data structure that rarely
changes, and is among several such static config pages that are
currently being fetched once per adapter per init (or reset) and
copied to the per-adapter struct for later use.

However, unlike the other static config pages, the iounit_pg8 member
is never actually used outside of _base_static_config_pages(). Also,
Mpi2IOUnitPage8_t has a flexible array member, making its presence in
the _middle_ of the per-adapter struct rather strange.

Remove this member from the per-adapter struct and fix up the portion
of _base_static_config_pages() that uses it.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2ae0185938f3..f76a546d949f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5570,6 +5570,7 @@ mpt3sas_atto_init(struct MPT3SAS_ADAPTER *ioc)
 static int
 _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 {
+	Mpi2IOUnitPage8_t iounit_pg8;
 	Mpi2ConfigReply_t mpi_reply;
 	u32 iounit_pg1_flags;
 	int tg_flags = 0;
@@ -5666,7 +5667,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	rc = mpt3sas_config_get_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
 	if (rc)
 		return rc;
-	rc = mpt3sas_config_get_iounit_pg8(ioc, &mpi_reply, &ioc->iounit_pg8);
+	rc = mpt3sas_config_get_iounit_pg8(ioc, &mpi_reply, &iounit_pg8);
 	if (rc)
 		return rc;
 	_base_display_ioc_capabilities(ioc);
@@ -5688,8 +5689,8 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (rc)
 		return rc;
 
-	if (ioc->iounit_pg8.NumSensors)
-		ioc->temp_sensors_count = ioc->iounit_pg8.NumSensors;
+	if (iounit_pg8.NumSensors)
+		ioc->temp_sensors_count = iounit_pg8.NumSensors;
 	if (ioc->is_aero_ioc) {
 		rc = _base_update_ioc_page1_inlinewith_perf_mode(ioc);
 		if (rc)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 05364aa15ecd..879f0dcb530e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1237,7 +1237,6 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @ioc_pg8: static ioc page 8
  * @iounit_pg0: static iounit page 0
  * @iounit_pg1: static iounit page 1
- * @iounit_pg8: static iounit page 8
  * @sas_hba: sas host object
  * @sas_expander_list: expander object list
  * @enclosure_list: enclosure object list
@@ -1465,7 +1464,6 @@ struct MPT3SAS_ADAPTER {
 	Mpi2IOCPage8_t ioc_pg8;
 	Mpi2IOUnitPage0_t iounit_pg0;
 	Mpi2IOUnitPage1_t iounit_pg1;
-	Mpi2IOUnitPage8_t iounit_pg8;
 	Mpi2IOCPage1_t	ioc_pg1_copy;
 
 	struct _boot_device req_boot_device;
-- 
2.39.2

