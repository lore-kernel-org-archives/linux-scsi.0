Return-Path: <SRS0=DHhn=XN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E1DC4CEC9
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 13:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BBA5208C0
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 13:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="n/rCS7xi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfIRNjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Sep 2019 09:39:09 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48820 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfIRNjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2019 09:39:09 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x8IDctu9008971;
        Wed, 18 Sep 2019 08:38:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1568813935;
        bh=UuvDUpX5XT0XAg5ntXHk59+WdiW1NxnKrqyb1xIJJLc=;
        h=From:To:CC:Subject:Date;
        b=n/rCS7xiGeVHFn1vwKukQ6xwpilVGRs2IzQ8tlRrt87OKYZgza93Iy2YFU1OSPGIx
         Ul3l/4AD6RBTAxyXEvUGKGIFmIHjBsqyz0+sFGZETOT1vy1fsHABBtTiED3FjAFo98
         GByttBE6nd4vOvb9mUxNml0mvuhxEL4XagmX88SY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id x8IDctfZ061556;
        Wed, 18 Sep 2019 08:38:55 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 18
 Sep 2019 08:38:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 18 Sep 2019 08:38:52 -0500
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x8IDcocD047879;
        Wed, 18 Sep 2019 08:38:51 -0500
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
Subject: [PATCH 0/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
Date:   Wed, 18 Sep 2019 19:09:19 +0530
Message-ID: <20190918133921.25844-1-vigneshr@ti.com>
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

 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml | 45 ++++++++++
 drivers/scsi/ufs/Kconfig                      | 10 +++
 drivers/scsi/ufs/Makefile                     |  1 +
 drivers/scsi/ufs/ti-j721e-ufs.c               | 90 +++++++++++++++++++
 4 files changed, 146 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
 create mode 100644 drivers/scsi/ufs/ti-j721e-ufs.c

-- 
2.23.0

