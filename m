Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6937BC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F55A207B6
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL3Ets (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26778 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgL3Ets (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:48 -0500
IronPort-SDR: QXGagpAioL+WmwbxE5zv/sQslB3G7Hu5WfHI387qBEV1z92VZi4tOS7nGHBwiA/BXzTRa4003u
 LzSuWU+FsY+mVjK7/Zw1kIFzUwk3madcV3IMSy4fGRM28mgNf0e0lfFk1h9X6fD9/SMmzW8d6e
 4kbo3fzVh8k4O6Gk2h+HwnogSyYDtVE0vFpEVAhyzsWD4paFCS6tKAHFvGWZISnP/tvtn3MtwV
 j6GkKY1OL14V+CM11gOiNv8IMktTtpHhww6/vSqQckffGALppyX+chnUVi0Q1h7WIvZV2nytxU
 DOs=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="109308285"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:55 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 5/8] pm80xx: fix driver fatal dump failure.
Date:   Wed, 30 Dec 2020 10:27:40 +0530
Message-ID: <20201230045743.14694-6-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

The fatal dump function pm80xx_get_fatal_dump() has two issues that
result in the fatal dump not being completed successfully.

1. When trying collect fatal_logs from the application it is getting
failed, because we are not shifting MEMBASE-II register properly.
Once we read 64K region of data we have to shift the MEMBASE-II register
and read the next chunk of data, then only we would be able to get
complete data.

2. If timeout occurs our application will get stuck because we are not
handling this case. In this patch it resolves all these issues.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7d0eada11d3c..407c0cf6ab5f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -349,10 +349,15 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 				sprintf(
 				pm8001_ha->forensic_info.data_buf.direct_data,
 				"%08x ", 0xFFFFFFFF);
-				pm8001_cw32(pm8001_ha, 0,
+				return((char *)pm8001_ha->forensic_info.data_buf.direct_data -
+						(char *)buf);
+			}
+	/* reset fatal_forensic_shift_offset back to zero and reset MEMBASE 2 register to zero */
+			pm8001_ha->fatal_forensic_shift_offset = 0; /* location in 64k region */
+			pm8001_cw32(pm8001_ha, 0,
 					MEMBASE_II_SHIFT_REGISTER,
 					pm8001_ha->fatal_forensic_shift_offset);
-			}
+		}
 			/* Read the next block of the debug data.*/
 			length_to_read = pm8001_mr32(fatal_table_address,
 			MPI_FATAL_EDUMP_TABLE_ACCUM_LEN) -
@@ -373,13 +378,12 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 								= 0;
 				pm8001_ha->forensic_info.data_buf.read_len = 0;
 			}
-		}
 	}
 	offset = (int)((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
 	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: return4 0x%x\n", offset);
-	return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
-		(char *)buf;
+	return ((char *)pm8001_ha->forensic_info.data_buf.direct_data -
+		(char *)buf);
 }
 
 /* pm80xx_get_non_fatal_dump - dump the nonfatal data from the dma
-- 
2.16.3

