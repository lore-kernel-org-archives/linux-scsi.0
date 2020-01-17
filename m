Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63940C33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E33B2073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgAQHKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:31 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35597 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAQHKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:30 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: wmgOhlgqpIoZvx6wo22xhpS/fZfAHQFg8r24uo0KA21UQgGGIrfm9fO9uZo253H/JyjgQEnAs1
 38YbuIrve74bg0UWQX5dXUqwVO7KP4/XjpqkBEzMZ0vU2LQYRLpfXeYQa6Uh5w/LLjenX28fF0
 KU5p1gHXbT//wiFnjIeA7ogyg1dAKF9kA7sTUaMlv2kpRvoyUKbpDE1PNYsWGLVxyNCeZBNLCZ
 JVg/zrkCm+SA9aSCAHb3DADIhQAQlo9tMAjpFyGSKtQNj5Xe7f+KqL63MMJqFVI4bOcNeT8P6H
 L9M=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="63598475"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:29 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:28 -0800
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:28 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 01/13] pm80xx : Increase request sg length.
Date:   Fri, 17 Jan 2020 12:49:11 +0530
Message-ID: <20200117071923.7445-2-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Chang <dpf@google.com>

Increasing the per-request size maximum (max_sectors_kb) runs into
the per-device dma scatter gather list limit (max_segments) for
users of the io vector system calls (eg, readv and writev). This is
because the kernel combines io vectors into dma segments when
possible, but it doesn't work for our user because the vectors in the
buffer cache get scrambled.
This change bumps the advertised max scatter gather length to 528 to
cover 2M w/ x86's 4k pages and some extra for the user checksum.
It trims the size of some of the tables we don't care about and
exposes all of the command slots upstream to the scsi layer

Signed-off-by: Peter Chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/scsi/pm8001/pm8001_defs.h | 5 +++--
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 48e0624ecc68..1c7f15fd69ce 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -75,7 +75,7 @@ enum port_type {
 };
 
 /* driver compile-time configuration */
-#define	PM8001_MAX_CCB		 512	/* max ccbs supported */
+#define	PM8001_MAX_CCB		 256	/* max ccbs supported */
 #define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
 #define	PM8001_MAX_INB_NUM	 1
 #define	PM8001_MAX_OUTB_NUM	 1
@@ -99,7 +99,8 @@ enum port_type {
 #define OB			(CI + PM8001_MAX_SPCV_INB_NUM)
 #define PI			(OB + PM8001_MAX_SPCV_OUTB_NUM)
 #define USI_MAX_MEMCNT		(PI + PM8001_MAX_SPCV_OUTB_NUM)
-#define PM8001_MAX_DMA_SG	SG_ALL
+#define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
+#define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
 	IOP,	    /* IO processor */
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index ff618ad80ebd..3f1e755c52c6 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -95,7 +95,7 @@ static struct scsi_host_template pm8001_sht = {
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= PM8001_MAX_DMA_SG,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
-- 
2.16.3

