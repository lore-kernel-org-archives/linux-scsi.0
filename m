Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC360C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 21:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4069208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 21:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGTVw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 17:52:59 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:18946 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgGTVw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 17:52:59 -0400
IronPort-SDR: b32ShKgfaR2LCai+SsW9dJvQu5bCPcXUnTbQeQi+QFSiMvuMDp0X1qJ8LAgyo2yR58YmNJpXOV
 TuHngtCUQy1qtEQz4MJtP2oNpPprnKXYfFOHW34hO00hq7qpasJUIiglmgsAmPoJ5nNf0Ue/Sn
 5FlHfHDdVSSFBsf5q5h5dqhMlvc0ntDdgFbstMYqLdHSKeVr0qJbUHw84a5OMISGtZ3JVz/6CF
 m2E8b3aiKCEYkBFSkeZov+ZQeG5HJ1ko42ZPtVnyMH9rVaUYGPKC0Rqy0jOT3SQhYJdMzCVaaX
 1pQ=
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="19897244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 14:52:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 14:52:58 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 20 Jul 2020 14:52:20 -0700
Subject: [PATCH 2/4] hpsa: increase qd for external luns
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 20 Jul 2020 16:52:57 -0500
Message-ID: <159528197765.24772.15623281371636788406.stgit@brunhilda>
In-Reply-To: <159528193513.24772.2142294136346611232.stgit@brunhilda>
References: <159528193513.24772.2142294136346611232.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 - increase queue_depth for PTRAID devices
   - improves performance.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index f8c88fc7b80a..6b87d9815b35 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -57,7 +57,7 @@ struct hpsa_sas_phy {
 	bool added_to_port;
 };
 
-#define EXTERNAL_QD 7
+#define EXTERNAL_QD 128
 struct hpsa_scsi_dev_t {
 	unsigned int devtype;
 	int bus, target, lun;		/* as presented to the OS */

