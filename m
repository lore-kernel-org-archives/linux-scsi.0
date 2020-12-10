Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9764C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A91723E24
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393043AbgLJUiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:38:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404553AbgLJUhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632675; x=1639168675;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mdKXDSS4s0qU/OTwA/wKpDcsEwV2nnPx7wcI7bjVMdk=;
  b=L3EuD8LGZZZNK+TfwZYRriAer7NhsWnCBz/z3+UDtc7Ybqx4W8/bFpv/
   HC+i06Kwai3ydr+L13MkKlPPOthxfqrN2Z/9mdO26kVEj+p1xmNnF3Rkt
   ddvM72Bu1N0ZXzN+SL52ddjklMMYi3ZmOynzjZFVoocJwI7gJO2et1Dat
   K/CPm3ecZZhjG1wjOIkvvcSlGkiK+1qRQfQcW6eK73FqoGTNjWTVjAb15
   GVkMqUrNZRx/JdyZAuAcPru02o0Hqb57Fjasmrl05LFuV8FBvASgHGzs2
   MBSfM6FhQNWV4nxqKDY3P2557JHtACIhsRRbm3nRlqBMrVsxZzeF1+02P
   g==;
IronPort-SDR: rUXcOx9gtZSSuHc99sNV4g5IrPsff78grwY60CtzO5e7FflwusUEnqeeKxAHikJmcBvYibWw9O
 0KaLOZlsoviuq40P2KDvTgcxmIobymdiC24iO4BggRvpnCm0KYB4pSssbAYvrR3RSUIXJ34rdQ
 pzjbIAiPYfb8EYaGe/EKzKrG2zMjTJ/UVAsrNKikMm0oyqItQ4MHWATEgdKlDw+mIY5JmOb7CA
 Fa7/uzVkosfDJd0bEgV/jRQJ/C9QWglg6fNyY1Bcqg09BFm0JErd1BF8OFbAyilhIUrghDM68Z
 uPU=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325338"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:34 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:34 -0700
Subject: [PATCH V3 23/25] smartpqi: correct system hangs when resuming from
 hibernation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:34 -0600
Message-ID: <160763259402.26927.11602719287229380898.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Correct system hangs when resuming from hibernation after
  first successful hibernation/resume cycle.
  * Rare condition involving OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 40ae82470d8c..5ca265babaa2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8688,6 +8688,11 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 

