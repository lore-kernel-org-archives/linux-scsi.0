Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062E3C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF44823A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgLHU2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:28:43 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbgLHU2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:28:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459322; x=1638995322;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iuo+vdKbhQj5CQUZmefFc4JBBcNNIpPbZxWWjjdw0sg=;
  b=V6TLh289sox+Q1YucrNtohUBj72s3t6BmjyKUdXgpJUHEBrtZxoEd5Ym
   jFCrC3f6pUYdW7kaB6nfng/Z+dngkGxjFHx3Mna8GUDjrZ+s6b7jHaCuM
   QjLsh5to9y50tqLGDE1SUuAYQgEYGO+HtG/SUlckTfdZXxo21mYfFqJqD
   EQgNPE3ipN7wMcOq5QdzpVvfeX9GqfRN08LfnrWESvnLolACSjv+rYcxL
   fd3KFZEr/dfjZZu/wukG8dcEWkhOsPTzbIYnDtNdDovTgcftNKLD/yn2Y
   eisW7SaKLPoP28xY6KQPjchLmtgC+M4h/tTlYZQt7s+COnHhgZLf6oxG0
   A==;
IronPort-SDR: ewcnerP/DzxfQReoRsdmbo4F6DOsUH63zXtrAoOjGA2EW0/VAUQ+1KF3ONY2ltU+8gL/bfdrvq
 3rwsPQNWYWCWiZWed7tbW/UGJ2nVxQYr0MnNPRTOm8vhKsa/jRelb8MKBzyyUEnZdtiyh1GDGZ
 R5gV/jl+X+B/ov4rwNiXosZnIaTIz97B25irGQi9ogIxJWZlDqIPym8fh1EGNSnql/va7Q6CgL
 pF/ZA2Bx2uV2LVq79U4CjEnlGKLPPdQLA4dB4/hmn+QjSgUEknb0XGK8lUgEtIaCxRGsYdmhbS
 k8s=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012346"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:49 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:49 -0700
Subject: [PATCH V2 23/25] smartpqi: correct system hangs when resuming from
 hibernation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:48 -0600
Message-ID: <160745632894.13450.6243855763573886460.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index e7526eb27060..e5d0352ac68b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8682,6 +8682,11 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 

