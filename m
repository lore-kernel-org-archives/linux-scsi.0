Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ACAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiBRDP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E666F8B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154119; x=1676690119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=goRnkkeqxKTUbei8qtQZ6iOM0R/J7gkprYGYQUTWsug=;
  b=ZQjvWR5tRCNMyFrukWnCsIPO6+dwVewrX/y9/kl0xXgB9Yv0pBr+U1ml
   wYFG/Z2eH7fQTQULYLlfYzvimcJbmC4dWDxcTU6v2zlKwbd7BIFLkwtHF
   K8a1pGfw/7a+cecXWtDNy/WJXpFyjDKn5PiabG6P7pFqLnI+gc6ExEHEW
   hBP2fCO6l678XrOAI0Lf6o0k3YGdtZ+Nc1+6dKnoQ6QIhhCsEMxmtEXg3
   DGo3M3z691n1H+IBvALXC0km+d3yASivaUrt9VznABwA5qp7n/GH4HBS2
   7+7hsWLrCzuZXdYs9WBgAOjdC0vrSj6yXyNhsl242GaIpMRz17av6lXjg
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074193"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:19 +0800
IronPort-SDR: UMZD1WRXamDQU/s/4clc8hz/n1rH4ZgFDAq7pCmURiDfFOxJynyS/SGLdiQyBXYSe8WB76uc+X
 9LPHUFTb2p8zhBf36+ASToKtSM9bvS38RXlt2lqcwhsowC7J3HmrHgM5OssVIfFzkohZiICz+9
 Vpw/H+HyK3vkyFiWIrVwqUzqB2ewlb0gRzFd0sPCX4/P8j5RerKEIAby4KowWI+3SQf0EF2oGv
 SksQrM5xZ+YRWVXVwsFy0LDKIODNKdjJSZmMFWJeW0BQEgkSpIwCacLqvhHlrMk6YGv9OgpzKc
 LsqsfmgE+QRcWJf2Hev/aiwV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:58 -0800
IronPort-SDR: /P9BknsobdSmZH0tD/o7+VPmtoXKgBGpv/l4XM5gFHr3okW3GJ3pY9uj0xoZb9zSKJNn78xcVK
 p21cIXCOQ9KiCF7i9POGq/QoM0ywcPyHiW8gdafFEicZdBzxRBMNhweOmEXcbnjspffqxoDmtZ
 u3jjrxDwdN02li1TWF3inFlXNz+TADXU2QHIMLuMb0mNU6QiOTgPWmpJd3uxwWB5BCKQuwFr3f
 Ae8Rae0+TofiOLcHXWNWkw588geK977UhI3tvs9sGQicI3kWBBNlCw9J8xP/odd7b4turiaJrD
 3TA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzD1GlRz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154119; x=1647746120; bh=goRnkkeqxKTUbei8qt
        QZ6iOM0R/J7gkprYGYQUTWsug=; b=hriRh8hi/YK5tQhS8yLfLU/iso9VaSPpp4
        J7DT5OmlN3xgLnkHn56LeUPSuus4Xtg2GtAgEIhnQw3n8gczVUgTvfjTogLSIA8j
        Xk0rF/rHZ1YBC2cK0WOWA4XW1Ma5FhqNJMpWjjlD4/ttuNj+1zTBwqwc2p38TSN9
        f2rd4Yw1X8m8IkqtkVrkaKw+ApeGmGPjBKLLnCyrLGWo8qmewuSLf/X4HM4oSRMz
        Q8J1B3GpBp23Dk2qr09zuhuytKMhtsmJETTmy7JesHBlFH3SZ4ySCLsu5N3XpgF9
        NOIFumq5a8Q3ZsylwVi7ZtdNiZkpXyBnUXmzfqjHKqUr0aMVS8iQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6aFrIxK6SVeQ for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:19 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzB4qkjz1Rwrw;
        Thu, 17 Feb 2022 19:15:18 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 22/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Fri, 18 Feb 2022 12:14:36 +0900
Message-Id: <20220218031445.548767-23-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_fw_flash_update_build(), if
pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
allocated must be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 431fc9160637..41077c84eec9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4873,8 +4873,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_=
info *pm8001_ha,
 	ccb->ccb_tag =3D tag;
 	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
+	}
=20
 	return rc;
 }
--=20
2.34.1

