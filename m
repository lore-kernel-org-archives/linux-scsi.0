Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C75C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC16F61152
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhGMVFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMVFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210164; x=1657746164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hXxOvXw4eeJpjDBFqXC+wHjs9TywmXrN9BduamjpANo=;
  b=ZTBfYZsFMDQx2qAZvO+c1M5k+fGNS8gCmHFhwVBosHctbZkv2BCNCGfJ
   b5QfSf+aygW8gwvXiMfYbAnhkjLAwfByJCqYCDNJks+mMBxHeqhQcrxoT
   V2MkzVZW6C/J69xSBBEJe4fwgJZKE8GLAb65/E3dE7MT1RKobWnB6BC4/
   Lowf7c8k8WLetozIkF/R3NTdCSEE/a8NU1jh5ZSV6agEPQBE+iR52MN09
   dQ2T5rgqqdpvDR/sAIPwGJaLLjVjMNMrgF4LbAJuMsZlhz60+q78BAB/A
   B0Kao0gbD+BxQkFtbHXsagcHJGJiWwONR3/eKO26SZPk+cYiAkJO03gI2
   Q==;
IronPort-SDR: IhsL5cQhikQeaQ8DZnSaerswgEfwS6AOAthUx9lAbBbyE4vVY4Tu1sSR8+R/uC0BG+VjfUbBfR
 Mn/d1cl21NxswkXXIm56wsqBBR2naE2/hp8H6wbr3GYfqrI1amP12qzostnrADhVaCvrts6YYF
 Yi9I+8xk5SXiRwL9JlPaIvims0CDPSFOGv9CFmH7CfT/YBdOEjX44u3p6aJrYrs1N37PDwpMVt
 VKMlq5AgdoMYfuAwnNoi/E0uhk2lwY5fi3rYeGU+PjmrlT9oxU4ELpNP4j6DmzpwuGJ6TESJif
 vcY=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="121925986"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:43 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 782A470349B; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates V2 PATCH 4/9] smartpqi: change Kconfig menu entry to microchip
Date:   Tue, 13 Jul 2021 16:02:38 -0500
Message-ID: <20210713210243.40594-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change Microsemi to Microchip
---
 drivers/scsi/smartpqi/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index eac7baecf42f..6f83e2df4d64 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -38,14 +38,14 @@
 # HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
 
 config SCSI_SMARTPQI
-	tristate "Microsemi PQI Driver"
+	tristate "Microchip PQI Driver"
 	depends on PCI && SCSI && !S390
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
 	help
-	This driver supports Microsemi PQI controllers.
+	This driver supports Microchip PQI controllers.
 
-	<http://www.microsemi.com>
+	<http://www.microchip.com>
 
 	To compile this driver as a module, choose M here: the
 	module will be called smartpqi.
-- 
2.28.0.rc1.9.ge7ae437ac1

