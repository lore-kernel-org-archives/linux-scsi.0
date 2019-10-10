Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CEDC10F14
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBF72190F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ygWd8wTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbfJJIdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:33:53 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36716 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731959AbfJJIdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 04:33:53 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9A8Xf31125164;
        Thu, 10 Oct 2019 03:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570696421;
        bh=tW8o9gxC95fgEDnTV9WdqRE00YYAAn4u4FGFLXvP/Ss=;
        h=From:To:CC:Subject:Date;
        b=ygWd8wTj4BOfn9mmSo6TD3b1PFBgiC0x67zavLb/yckCeyEIXACNi01rKz1WoXvF6
         rptPDKqy5M/a2YXytXAmcl3ZkcSz2Nbkz2+sox65jUta5sBgPpjnxBhZXiKMlnmSrA
         6xPhdCQBEnrCbdGWahd1oiczW+Nx39erMMepQ2+o=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9A8XfCe043929
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Oct 2019 03:33:41 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 10
 Oct 2019 03:33:37 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 10 Oct 2019 03:33:40 -0500
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9A8XaSZ019061;
        Thu, 10 Oct 2019 03:33:37 -0500
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, <nsekhar@ti.com>
Subject: [PATCH v2 0/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
Date:   Thu, 10 Oct 2019 14:03:55 +0530
Message-ID: <20191010083357.28982-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series add DT bindings and driver for TI wrapper for Cadence UFS
IP that is present on TI's J721e SoC

Vignesh Raghavendra (2):
  dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for TI UFS wrapper
  scsi: ufs: Add driver for TI wrapper for Cadence UFS IP

 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml | 68 ++++++++++++++
 drivers/scsi/ufs/Kconfig                      | 10 +++
 drivers/scsi/ufs/Makefile                     |  1 +
 drivers/scsi/ufs/ti-j721e-ufs.c               | 90 +++++++++++++++++++
 4 files changed, 169 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
 create mode 100644 drivers/scsi/ufs/ti-j721e-ufs.c

-- 
2.23.0

