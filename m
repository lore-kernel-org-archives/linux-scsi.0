Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD97C4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A52C601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbhHFLMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:07 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhHFLMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248312; x=1659784312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T5iQtR+m8wm/ph6xRjNe4reIj5HsO8pLsUVsDBnawno=;
  b=F6DZtJM8uL+UU2ntH0EgLrejaoFz8w8WDaK2O6pf/aGb4toebd3aER49
   hjlANpYw6llPFzi0KKUlezah4cMttRcM1qW4UYPyH8vbXHEWKz4Xqbe5Q
   zJZGlg/y+4bCA8tYD9Dywx1uEjLnGAVpjTQ8TPezL8R483CWLJaV4nWCt
   qzi1glXCor2wlM5sTL6R0Gwpz5oxh6r6SIcLz/8/BRx1AKCgylUOzr1nk
   4Ws9sdBbfQEq6rdAeSEIkCLy+lkJstsQD64+sclvOdrQli7SjR8sPLduJ
   UEzPTDfmAj3mJkZMlAX4nYsl+bQ8Hd6CZSzwdXMryWMQ2IzTnRAS79AGr
   w==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055539"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:51 +0800
IronPort-SDR: UnJhJ08Wi/rXK4bsnbmQpO1D8MdQNO37wksJk3hSOY8iVS74fWEEdGp1+vLsuenpOz8IWKLjDD
 3Tjr/KKCUsXWU51P0Q8pOhV1jm/FwcKXlsV5s0wtu8VCaATBHt3r5MkLu3Q1yzrmi4AFye8OIO
 vt3L/rFTnoCrCLkTKLRZ99DUDOJScSlDOh19Rosi8fa1Hbc/LVDMTdJO9/zYRUM6yk7RVGlVnS
 m182VBgHyeJ1LHR8e1IcUgPahosFHT7uPO/bWoRARDv8X5lXiyB15rbogqJDEY0MXdYvftPzbg
 Kgp8VAIjYQUruoqY0re6Ib1t
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:26 -0700
IronPort-SDR: Se+NN54bWB7PzSZkzW28YlNJP6Cl+N3Tt2KVvwFk39RdRPrGUmEbOvzoZC8GEBwSRS+5iXxoQy
 3wOl/yZ0t/T56RBfR76UqVK7fhaDW8E3KuX3FXI1MvmK+D3XP5ggwQ/xZN0i8DjHA38SxJEz62
 Eco/HeirkpKGjPTsxXdggfkFNb9rMcOC0j0ToSofiFK0wBZvTRQG3bHdnktq1Wv8FqpG6lyDNd
 /nTDCdaZDcxiB/RBV4z5QTpehSD6kb1haGP1jn87AhB6BLBafRgNq+ye6V+6By5V1f86rCS9QE
 Jvw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 1/9] libata: fix ata_host_alloc_pinfo()
Date:   Fri,  6 Aug 2021 20:11:37 +0900
Message-Id: <20210806111145.445697-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid a potential NULL pointer dereference by testing that the ATA port
info variable "pi".

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..ea8b91297f12 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5458,7 +5458,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 		ap->link.flags |= pi->link_flags;
 		ap->ops = pi->port_ops;
 
-		if (!host->ops && (pi->port_ops != &ata_dummy_port_ops))
+		if (!host->ops && pi && pi->port_ops != &ata_dummy_port_ops)
 			host->ops = pi->port_ops;
 	}
 
-- 
2.31.1

