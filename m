Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBAEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbiBQNbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240933AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505572AF919
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104627; x=1676640627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MrC1fw2nz70gALcx2cH4uiSlZsu3d6xxykw4zEymJrs=;
  b=rf5bq2jQvipXV55ydyuu+m4SFRE/sSuflrq9BkQEwL2HwmGTWMW1F3rO
   nDyzXNsIYinXTaH0hUVwvcdIii6qQHCDiCwBPpwQFx+9MkIwpTQA5ANvo
   yH4v0zYmI595KL7DQtNHPw1yGt/5Mhu8cGKae3Kb7qLxiE21C+q6fD/4d
   mZfL6/sb8xfy/2djUBaPqtAZBVE52KN+2oPCbIcBVzPgF4hPe9xnkd7TM
   PvZ10n97b1otEgtK9TdOqKS4+6ytRFl07bCK0ipNuAkKtm0WHeWzPOXbQ
   bPwyRP7jnlSzWgNw9ZLjOjHhWm9HHW/9xtz4wXlfB3CGKvmajh/T1Gyhk
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303217"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:26 +0800
IronPort-SDR: 9CbMo/kNn1+3ZhLhwt2cEKxYGdIj3lTrXL4UuqSRMm/G05f87v5mgx21+1htGXhzMIKvO5KZEN
 5ODBm+gWM3UjCpmh4zITwSxywJLMR3cCcgUJ1N/eqM/Ny5jUHOJdc6sXigdit1XJ7Chfy+kpmR
 HJRmn5SCbiuYDZMyVUpAWdR1TdGGCj+krMC/JrYlEkmg1iateybKTWuX5tMqrjsUstB8iCBKwa
 RFz05gW+69leblRR/dW9U8fSpF4AuWUbzEWZz18fe5RseldVpqe4rdvk81qGJI7wl/jlbADZhI
 mJRHeVz6ce+1Rm7bWgOfP/bi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:05 -0800
IronPort-SDR: 0NUVtoEfZ1ycfwzJhai7kvpsCnvz9fZzdTD0ByiS6++PCvrdUK9AAmvvcJA9ieDXZ2AxdzktAY
 0TczVwKw/LeKM1ootYmW02LAb+AOHikmWulQDv2EoZgYvrU0AznCbV0WGpWAANp1jz/8vq92m0
 tpD/tNMQXj7wPlHfFfZ/0MLE2m9TcFISrXFN3pIhTPdVMcGLjXcIDKKFGV1yZjlcgLmf5mj95s
 4F/3fTnkXXkdVMf6H8YcIeY1ZQVKgOyzX3Liqc4hOqV5f5bjX5+mlTIMupvHUU42XTC1CzYl6g
 Jtc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgQ51Qtz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:26 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104626; x=1647696627; bh=MrC1fw2nz70gALcx2c
        H4uiSlZsu3d6xxykw4zEymJrs=; b=ElGbYGwiMjVYEE+2WhYmJNWy6ewyJjeqgr
        xThkv1OSGGEnYEBOw/FrlMAVjsyLnPGCY+61esW/31hmmp5nXB+/zG+6N1oIqeLs
        Ba4tgRMcJRJOGUBia+HyBTsIJW2BB2KuOIqstoFIpOhXDL6E3HlxbFBonX9dpdVD
        bPytvHBmjzkli/YrLkBqMJtdEgnu91dezvLN+JgtJP6sJvKx+stl7MjdGIy0veJB
        x0XVO4OX8HS3CMo5gdMfFgO25UU4DEsNDyRrR9tAG/cswvSmserw/lk2W7m63EGY
        np93aL1kuzVSENyhptaiO2K1O6kPScUJ1wNmhy5VyY6hM7akDqrg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id O4R_HNtcEZcR for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:26 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgP1Lc5z1Rwrw;
        Thu, 17 Feb 2022 05:30:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 19/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Thu, 17 Feb 2022 22:29:44 +0900
Message-Id: <20220217132956.484818-20-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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

