Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED76C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiBAVs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:19958 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiBAVs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752139; x=1675288139;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d4qmYxC+2pSAN2U2kE8TvUuaRcJQTWkrVblstSBcc3Q=;
  b=W4Z9qfdsFz/v0IsOtKiR1FdRLjmkABNiNfXz9EnhrcNkwO/7XklLmqv6
   NEfSh644eWxYnLA9H0w3W5YXYNGSjfjX1yktkTBb2N/ZJKmIxkdWULwV5
   aE9Tk1bXI3xVTGgCh4jWpLv15q8XyfoRLPveB3aQcL8UH3DHSPvKa2YX2
   5KXH16BqIHdePNva7xrHZ1QuMhtKRPLaN60VPJHSr7gfC/4I8mzpLKNwh
   +40Lf0rFE+9GinZkS7nqQN+Llg5iKf5u0ZBlmb103FHDrtaZk02qhuaVw
   ko+CnWdB+zaqP6K82A+d0DpAROsCk8rUWAgeuPwuAk/BnC21Y3CgOnd5y
   w==;
IronPort-SDR: 2GQQFaDxGp414F3VhqnhozMh+mXnREZxOBGtPs/YQZkn5WgiVhVS8YjXb4ESYSoMRvIHGqsjg5
 vn6JyF+MPK4QaSHWiInyYh0e+KomsNeWqHDInM2ZscQ8apFJLF9BFLVI8bwYrEz0YDprtAb6Xz
 DDp7mk3dDQK+n223V+2u6fgqP77QsXyYFC70XJ3tsEhpet/mOQwAwPdrBUAKRgnA1727FXk6OR
 ZzJ3xvtOvum990rP+yYqSTv4dI/RBhkozbOz+kgshgwRQHDajQmH5PBXd5hLncyuQAxksyci/6
 sRV8c9HJXLVWhpG+Zm/GQ0QL
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="152163289"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:58 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:58 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 84AB670236E;
        Tue,  1 Feb 2022 15:48:58 -0600 (CST)
Subject: [PATCH 14/18] smartpqi: fix NUMA node not updated during init
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:58 -0600
Message-ID: <164375213850.440833.5243014942807747074.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Correct NUMA node association when calling pqi_pci_probe().

In the function pqi_pci_probe(), the driver makes an OS call to
get the NUMA node associated with a controller. If the call returns
that there is no associated node, the driver attempts to set it to
node 0. The problem is that a different local variable (cp_node)
was being used to do this, but the original local variable (node)
was still being used in the call to pqi_alloc_ctrl_info().

The value of "node" is not updated if the conditional after
the call to dev_to_node() evaluates to TRUE.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 76ad919b0812..d886a9c860af 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8811,7 +8811,7 @@ static int pqi_pci_probe(struct pci_dev *pci_dev,
 	const struct pci_device_id *id)
 {
 	int rc;
-	int node, cp_node;
+	int node;
 	struct pqi_ctrl_info *ctrl_info;
 
 	pqi_print_ctrl_info(pci_dev, id);
@@ -8830,10 +8830,10 @@ static int pqi_pci_probe(struct pci_dev *pci_dev,
 
 	node = dev_to_node(&pci_dev->dev);
 	if (node == NUMA_NO_NODE) {
-		cp_node = cpu_to_node(0);
-		if (cp_node == NUMA_NO_NODE)
-			cp_node = 0;
-		set_dev_node(&pci_dev->dev, cp_node);
+		node = cpu_to_node(0);
+		if (node == NUMA_NO_NODE)
+			node = 0;
+		set_dev_node(&pci_dev->dev, node);
 	}
 
 	ctrl_info = pqi_alloc_ctrl_info(node);


