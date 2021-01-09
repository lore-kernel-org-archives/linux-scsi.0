Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B1AC433E6
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFB023A63
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbhAIMag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:63795 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195436; x=1641731436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5ya5BFz+18adfq5rPPGG4XfJwN2WDmPc77XTVR5z2IE=;
  b=qAnl2qfRSx3gBw/wlEadcWFBo0mFQ3bXOajQqVehrUI23xfqz+17kUAS
   qVS0weXKAYoeUqV9GW8gSL9ccuC30DIXgFALJnjlaX2gwu3ObqSv89opk
   mfipmmFynZIjISWcmLZJLvqPlk1IKhI6Tk4FaYHDYon8f1Lcj1Jze+/Qv
   oPBayJ1Z46A42yCZ64MV11fw2vgMMJI2MFtGU/A3vnJqKL2RwhSz6Vd4C
   Oo/KzhOxmneDRLfjeJ2xj0Ll/2zy44UA/3bZM6kCuIb7gFDLy68hqLVVN
   bdwEmQ6v0nAsZP/X8c8118gEEkWATJ4Dzi8GobuUfRgDqjFW870KHrtGH
   A==;
IronPort-SDR: FyLFuRIztOx7o/IBCP4A/oCbKZkxjWC+Mp4Fth29UXYabh+CSeLL1Q+pd4VUZxIx1/Aw5h5pHo
 KKXIXXNSurtLtwL6J8o4DZmRYAm0jZvYpd+IavDInCZ2BTCLAYEezR0hFKK0bH7De9LMaOTCsS
 Dnfoohjum0KFP8E5bF5hz9WUlvbi6WO11zMRphLruK0JB/ghwUcPTC4QaCb+kaSa+Tls8boAEd
 wAyLGpVbk5Glhm4cs1xvxZbRtRt11uMQKOgaZtQp47djc9Wdqf9FtjGVkrL1JfsLoBS2rLafAv
 dIg=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="39871685"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:29:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:29:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:29:02 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 5/8] pm80xx: fix driver fatal dump failure.
Date:   Sat, 9 Jan 2021 18:08:46 +0530
Message-ID: <20210109123849.17098-6-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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

