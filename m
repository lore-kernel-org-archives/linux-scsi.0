Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A03FC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD1121882
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QtANlRoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfKHQyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:54:38 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50264 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHQyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 11:54:37 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA8GmRRQ052691;
        Fri, 8 Nov 2019 10:48:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573231707;
        bh=4A4O5I7pwI/p0i8/yVVFwm2hJ5HkTiFhKi6/rXJSUUw=;
        h=From:To:CC:Subject:Date;
        b=QtANlRoK8Wi271mYRcJwNxC0JxEQigLC2P2SuVnOWIZuOpcnrJdUjUd2Tj8L5S52h
         qPQBUiwbgUD2KtDqp1aHgLr0jeOTDliBvnBClxLgFmAm6XF5QHxY/i9DhMaikAJKdJ
         dasuGsg35kyMrlephdT//rLLE4nvFAo2Y7uJKeLo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA8GmRGp106711
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 Nov 2019 10:48:27 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 8 Nov
 2019 10:48:11 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 8 Nov 2019 10:48:11 -0600
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA8GmNLW117597;
        Fri, 8 Nov 2019 10:48:24 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 0/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
Date:   Fri, 8 Nov 2019 22:18:55 +0530
Message-ID: <20191108164857.11466-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.24.0
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
2.24.0

