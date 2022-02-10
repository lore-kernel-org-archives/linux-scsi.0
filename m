Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16438C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiBJLma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241058AbiBJLm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:26 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E761019
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493348; x=1676029348;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=++Jen2Z7eE/Z+IcddaXljZMWolo9K9TW92C06sjcO7M=;
  b=lT6Zk7KU2YEgDXh3lLLaax8PAVcS/jKoYo3vW/dNud/owxu2Jl4IrcYC
   UH/nL4Mh7WoTNZPwPmcNqSa2rX6upjrG0i2Z7bLveIXeFpWVqj/UlJcPU
   NgSkBgA2gU9iCeTtDIewml0KyILMtActnVyQsPJYrciyBBNqn5F+in5yr
   9YiS7/gkuTGB+fPuzXGd5eQkePoHdjYEBWOjMh3M7yof3ncZvcFTVxbnz
   sHYfsvX7/e2Hapy+8LwIpBhY62BtokKNgWmMtSJgA+qXBehUo6tI3dPxm
   wMxLpafmhbahWiOeiewqEfWt9+8/zfx6dAJt53iY+Rj6wRh6dPBOdJtbb
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575622"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:28 +0800
IronPort-SDR: cPBH/oAPqHgSgf04xPuql3lXy9o17gdnYYFpDIOaF79L7MEzbq4EmtzCyba5ClZohUwLpW19+k
 F95aEP2ttDEr3PUYbRXZBK12iNT74l1JU4gyk9kJPeZpSbWJAbHEfG2MgKzNNMu2DIczJabxpa
 2Uy/pfSGfEIid2N6oupSFI/YdlCWe98dLwYACTcUWzB3Qi3wLje9rBSQH9V5cHhqVE1Whvz1bB
 AUyoa3UgfAj5kBQDMiPbC8ygeAUy0qHXRpdUs/nqVCunPPtckxMp5VrwQh+aRSYrhRSp+DWbgP
 avIVfnZRfr+Fjp8DKKsikU4i
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:24 -0800
IronPort-SDR: BZv6e8WyEFPb/k7RxLTdZ66a0SnXGifeohAqtnE/YwLnWw5hJffpQIozwYsm2tL5AxdljzjDAG
 FFIozvEMpshe2hgSq93uE8l8cVjtvWcO2QdfBGwQ9TZEW3U3wwNBoU7Wye5X/U/DjLuPXHEbgJ
 fjzmTkrmD4+VjdtdmT4sl4HhQ7G8LBypMZJw+P0abmc4maWM++PJQRrQ6i4BNw6LuMe9LGdkIE
 vqk9gy3p8ACN+COdp7rdPlWSb8pr0n8mRAX1TjHTOF4QVubg60Hf3FMTeBi2XdAm5qslM17Jbu
 fjM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc32GH2z1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493346; x=1647085347; bh=++Jen2Z7eE/Z+Icdda
        XljZMWolo9K9TW92C06sjcO7M=; b=eUjJ3NF7nLrA93E51AqVSJQ3DhFYxPoL6h
        BIAzY8lIrGrxqRTowvLTwzujeEn7mGgOznUvJBvL/GjuXTBhKQT2uE1JZeR9dV0T
        DVPhB3WhdFXqkVzEkHYq00tQlVsJ5v/8f/j9MKqfqBh++nEUZObX18Aj0MJJXeDL
        dfF8RCkWePRqZbSgAvnSSKk1FG0pN0+5Hk2KG0z7S1ZZ4qgHi2SVQGNw5/Im81OY
        rKGShXhjo3TFiI1eREaVEsXw/evHOVM+6rc+ottUIphBo8JnRCXr0VbcUtd3G0Mf
        xGdRH/61gk7n06nME6Udwyi9z1iw3HZ6gMVSaavO0qj1jilEgHmQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XquKJPMUtS0U for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:26 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc15xSQz1SHwl;
        Thu, 10 Feb 2022 03:42:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 03/20] scsi: libsas: Remove unnecessary initialization in sas_ata_qc_issue()
Date:   Thu, 10 Feb 2022 20:42:01 +0900
Message-Id: <20220210114218.632725-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_task_alloc() sets the state flag SAS_TASK_STATE_PENDING for any
new task allocated. So there is no need to set this flag again in
sas_ata_qc_issue() after the task allocation.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 99549862c9c7..a03a841921db 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -204,7 +204,6 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
 	}
 	task->scatter =3D qc->sg;
 	task->ata_task.retry_count =3D 1;
-	task->task_state_flags =3D SAS_TASK_STATE_PENDING;
 	qc->lldd_task =3D task;
=20
 	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
--=20
2.34.1

