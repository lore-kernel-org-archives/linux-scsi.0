Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58537C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiBRDP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:58 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FA61BBF40
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154115; x=1676690115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iR4rqyNUe2jk5VIFUb8waldi+JGvDb0b3u7gvNVRma4=;
  b=GxxtjOlADT0VZ6yqfaE9eM4Q6KTYhwRSSAd8vjkNh7M8o3YtIG40ll5U
   5H80aZixV5T2316O5NhvgQ7OS9R5LR5n56LCQkF7tvJLWkJNQD1OnnqoN
   pTB7mXUAXAgl3klrhsoPq/o3bLJDt9UdPGZ2TTA0Oj8V6mUDkBN84oy3O
   XkPkNJulfcJgcN7iPsatMtkkF8yF0pDRA2j5SKR6v4IjOfnfVxMjQct2Z
   kM/Z8pK++yfx8YXAzH5G/IZzwNcnCNGLCaR2SSs8n5GxM857IrMNiMXxp
   Q8se8YbIWqg7va4c4HucrjEHvkYszcI9Cle8ipEwxzAIVCrNJMR8qOHvu
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225808"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:14 +0800
IronPort-SDR: WT5cUmZ1tSjIs20xhMRdgIgmO19F9gRhidk8Aem+7ZNkqsZ8pY23ycW7rPWzA6Z9Audc2fjmp/
 L9uMGshu7KNmKp6Ny79LS+lLBfZK+jfj6TovI7UoY5u2g08ebPz19QcuYMouO4uGcqqI9M9ImE
 cVqBIsQ2KUTZW2wd/D4GK7b0eHxxF2fRhwJturmnzyHx8rp+ilo+xDXOaFV3aWKCTvpz6npRMj
 0tzISl/RMcaO2v0m1Q1AUBLS3i2aouYgLqyvbMHZxaqTfTqX/E+ybQuXzkyb34axnBT/qXk2Py
 gznQAN+gDQuIcEZAmH9v/qLX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:52 -0800
IronPort-SDR: ZE4N5f79ECm5mh9o3FcAiP0CuF3MJ7Zp3rD7XMOopweKJZEZwh1jlatfklbzvaTVtIHU9Yzk0/
 0SaySQJWuNhTM2p5nM9s42J4GwJV92sHcb80fOOtZI9pzM+di9IfziuVEV+xebxyb8UKm2NLZE
 OLTgldJ+aBTBEJt/VkZBiY17mUTsjsgr4LPJcxNoBtZT8O/48FOqQWaOMP9TzyiWasrno1VcXf
 ZzupNza9PE/VBmHNcnwlQRS7FC0gVxM6zVsNmuE9Vk8nWCpI7ljtN/niPqN374vpXB9mUOXiLf
 UF8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz60bssz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:14 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154113; x=1647746114; bh=iR4rqyNUe2jk5VIFUb
        8waldi+JGvDb0b3u7gvNVRma4=; b=aS92PXMDfJqvIH5j8QW+o2M17FjpAt4apB
        kKlzDMBXqKbR76cjONkBCMI8UcURbH7N/5dHW+Queb90xO5xUMLa8AGyO2ABD4La
        ka3wheuwggJ6cAqCy2MEwnvgCUEkBEmjaZkeCfn+uQJu0iZqZEPJP9KcYNFi2at7
        iO9BD/a0mPNW6rV5K6SGrG7MWGKkz3cP0G/DD2Mp0h6eK6IaHadDYJzXlS+OCqD0
        1XDM0hSgzd+izkAlbdWXEP2tDt5Ww4/LQXq4m5Ar7BsSR0dQs3Nv77GU4tx4joiw
        bQTyzfBID9saGD8uQLOCMsnZVCCJKJOOVxx3e4cbA5XTvaXONSUg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XJn0DN1gA7NT for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:13 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz44WzWz1SHwl;
        Thu, 17 Feb 2022 19:15:12 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 18/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Fri, 18 Feb 2022 12:14:32 +0900
Message-Id: <20220218031445.548767-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The call to pm8001_ccb_task_free() at the end of
pm8001_mpi_task_abort_resp() already frees the ccb tag. So when the
device NCQ_ABORT_ALL_FLAG is set, the tag should not be freed again.
Also change the hardcoded 0xBFFFFFFF value to ~NCQ_ABORT_ALL_FLAG as it
ought to be.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 35d62e5c9200..5cad5504301e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3700,12 +3700,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_=
info *pm8001_ha, void *piomb)
 	mb();
=20
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &=3D 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &=3D ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
=20
 	return 0;
 }
--=20
2.34.1

