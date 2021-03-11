Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32898C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA50E64F89
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCKUPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:63181 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhCKUPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493709; x=1647029709;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uctky9EkB2d4SYpQGrVLids7YPzyLIIV2KMGUTrBut4=;
  b=iqrPc2YuhLUuKFwF3gGAF9qOlnw23Gnmnd+HBlfZcklQ2maIQjtRPRWD
   JZpSvBTqi7roH39Dtcw71gsA6IpSWis8tb/27A4XqzPWptVG7BAeRBLys
   HdZ/Bvidr2kkvX5is8NDNCmEAsiGmgTM8jAaK/cL03o9XGXeJNO43XAr9
   Xp6xgfsEXzyF/E0aA9uHXcd8LtEsUwcHvAI2vo3gMpJUnLlFASYHhjuMu
   oOxn9OYCnmglPmsBdxnmemuJGTDt1asssAvZT2ycTIlASomMI55JXbjMW
   iuGU0onHXlYpN2NgCtq/2A+8Yajj1hcXYmnjC1wCJ3oqyOA1KYp6qzera
   A==;
IronPort-SDR: z8VVbDL0kzKs+NFxwEm9nc5UchPuHzOeqcATUUXcYGI9d0PnUzkKZaLVMWK+AkYmvAOI8erPYW
 jlymU3zGdzf38yoso3cNb8gutGVTTkUToTErkVMnK5Ux0mJlhG1WSk4PaXHTUJefFEF8d+KKIq
 6xUYhJelUho0EnUX3Gjyi4+tVlEU9aXHcgvf7OTtXkBcKB7UdlsYXssrQR132zV2gZr+DyN4Ub
 OEc2F/pj7TPoND9JU8FDRjAq6uSUQWXHtIOJL0UrXAoGvnklQy/wj0H7KDx1OSGvL9Kzk5eT98
 jHo=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112405943"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:04 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:03 -0700
Subject: [PATCH V5 02/31] smartpqi: fix request leakage
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:03 -0600
Message-ID: <161549370379.25025.12793264112620796062.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Correct request leakage during reset operations.
 * While failing queued IOs in TMF path, there was a request
   leak and hence stale entries in request pool with ref
   count being nonzero. In shutdown path, we have a BUG_ON
   to catch stuck IO either in f/w or in the driver.

   The stale requests caused a system crash.
   The IO request pool leakage also lead to a significant
   performance drop.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 61e3a5afaf07..4533085c4de6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5489,6 +5489,8 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
@@ -5525,6 +5527,8 @@ static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 

