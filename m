Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB29C0015E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjHFRRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjHFRRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:17:31 -0400
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F13CA
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:17:29 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691342248; x=1691349448; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=WM8pRZoSs1w6+2t9XdlAsuyYJygupsdh/CvlPXr0AJ0=;
 b=RQ4dVtoSFr9u3Usy2Ee7UbLX4yCEan1xpC3Fr9jvDkYbcFB7QYUWATBmcEIX8JIFmfrL4B4k4zdS0GJFDHtTdbzUf7ckiBKTSJyb70HFEy2v0wSoNKVW2647bBdUR5mtgXF6522JA/LmLU142MrB0jQJLKo03hMVD3BNWviRRwcwYk1Kle+JcmKk9XTz8DUOdyJCfdpgrQZwsfIOqrK4pD3hvORGB5nwa4cMTniAJEY09yJwcTfRr7Sx/AGur7/6xb7/mNn2gEbe7gWIqQoql9zB0EwGEF5/NrS+V5AZfQltTalmimT8CQcQwdrlxh7ALSTNG+rm1x/fD6p7Ese0ng==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 10149de56625 with SMTP id
 64cfd3509b55128dd850068a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:07:28 GMT
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
Subject: [PATCH v2 02/12] scsi: mpt3sas: Make MPI2_CONFIG_PAGE_IO_UNIT_8::Sensor[] a flexible array
Date:   Sun,  6 Aug 2023 10:05:54 -0700
Message-Id: <20230806170604.16143-3-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This terminal 1-length variable array can be directly converted into
a C99 flexible array member.

As all users of MPI2_CONFIG_PAGE_IO_UNIT_8 (Mpi2IOUnitPage8_t) do not
use Sensor[], no further source changes are required to accommodate
its reduced sizeof():

- mpt3sas_config.c:mpt3sas_config_get_iounit_pg8() fetches a
  Mpi2IOUnitPage8_t into a caller-provided buffer, assuming
  sizeof(Mpi2IOUnitPage8_t) as the buffer size. It has one caller:

  - mpt3sas_base.c:_base_static_config_pages() passes the address of
    the Mpi2IOUnitPage8_t iounit_pg8 member of the per-adapter struct
    (struct MPT3SAS_ADAPTER *ioc) as the buffer. The assumed buffer
    size is therefore correct.

    However, the only subsequent use in mpt3sas of the thus populated
    ioc->iounit_pg8 is a little further on in the same function, and
    this use does not involve ioc->iounit_pg8.Sensor[].

    Note that iounit_pg8 occurs in the middle of the per-adapter
    struct, not at the end. The per-adapter struct is extensively
    used throughout mpt3sas even if its iounit_pg8 member isn't,
    resulting in an especially large amount of noise when comparing
    binary changes attributable to this commit.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 42d820159c44..12b656bd883d 100644
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
-- 
2.39.2

