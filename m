Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29304C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbiBQNbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbiBQNaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:52 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5EC2AED8F
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104630; x=1676640630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q1XJZOgtboqh9FiddO0t3IN9iQ7iOxHQjbmGMCT7eDA=;
  b=PmJYPuWR8NF1kW8nmSYNEQH7wNC4VoneXZID8lWL8KzxzPz48vytU/i/
   DQmgnOHFYtja+fdxxIPq+AbciUq5cO4mWjd9C2T5H/2jRkf3E/bU6jgQY
   TGKRZYG1cYQz8atSae6zVHFlh7RwMxfJD3rtRG/Yys5jnus4WMQoUoHO2
   mDlkDXt6KlUlp+T8z6ivvmxGttpyBLbQEcFKmD1n+ytCe0IU89G5rJnKt
   QdPZEQilNurKYW9Dt7ni9rp41w60QXp3dqcYnST2ZtLK9FPNAVdlGKVma
   SHI4NjOgMuvbNP05L4YgNKPBvdHv7kewULkZi1Tg/NZiKSOVQZXVxO4og
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303220"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:29 +0800
IronPort-SDR: H69YLGFWSfEYQQWyVLfESdMW9pgS/Jxt8NJnUb/GEJ+8fmCwr9HvyfXsMaTVeK57/RFx9dDuSA
 +3tFJcQctoTDNqWexyDSDSUD0al8EylePkuBgr3/8dwxxj8ebrDfpTmSBKPFqbpaqIrEfFnAP2
 Z21FkTSrxe6lm82jOot9/YpROYXlDo46XhEpMI0FfzGVb97/K9uTQOq6HyW8oFFTBiib1lMMEE
 l3Fsoy95xsGRJ9BFKO2T5FFd9wuXVccSY4BkeeJzaEPKrVbfw4uGveh/3TFkdhqN/UwuV3XDib
 IbQjImUtK5fyrIMBi65kPwoT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:08 -0800
IronPort-SDR: JWRnjmEilBMzF5bd/wft0x0dJqi22bu+YXWNvz+rIT/jV7hJPEjymIirlTuQ/k2mdEEKEfYM7W
 tYZMomasH4N0FUsOdiMMfqy+FJ7h9l4wPKgwWYepFN02DLto+o11cXl9G8JBkfsMWEEWhmJOK3
 uSIEIKPV+sqb0KpEl2qkl4zBT9LdLM0umz1dJd/csSSHhdyIRayqEttgpAdlpxvDXmDQuNttaS
 WFEux1q8O7/hTjN6NKQldaNySYODF/KYsiPcZMdz9G5ThLwdyk+FRby2KibGvSYWDwWIAAV0vG
 vSY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgT4fkHz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104629; x=1647696630; bh=Q1XJZOgtboqh9FiddO
        0t3IN9iQ7iOxHQjbmGMCT7eDA=; b=oJywAAOtVQtuvV73mLSFPHZVPOLp9a798q
        6jqZn5hpsLLxR1NYoMwlYFhBGt7+OIssVDqPJ4195BoDeUfSJ6iy/D9Fah63DUqx
        cSCs9F/NywrKl/Y/OQzc0/0UDfach7ON063iCs6vd/6oFJE+lyaiKjqH/THfRxBg
        3eLLPDCzWd9+zRcyANsSQ/wou2eXOQ6Sk9yV4TU/UYFO3WWCFHVIQ6etdBB9UBMY
        iFdxFCBauK49Bli+4WzX39j6xMSASOOFg5CcePgG4zuxqNEGt8oJADDiusMwAC6t
        GqzN1we3TAFvIHmB5WcBMJ8AHjnhx1Shd4PXpyUCg0BHxZ9u3+Zw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jhFfvVNg96EL for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgR6PvPz1Rwrw;
        Thu, 17 Feb 2022 05:30:27 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 21/31] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
Date:   Thu, 17 Feb 2022 22:29:46 +0900
Message-Id: <20220217132956.484818-22-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_send_abort_all(), make sure to free the allocated sas task
if pm8001_tag_alloc() or pm8001_mpi_build_cmd() fail.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 3dc628b0384d..cc96e58454c8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1764,7 +1764,6 @@ static void pm8001_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	}
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
@@ -1773,8 +1772,10 @@ static void pm8001_send_abort_all(struct pm8001_hb=
a_info *pm8001_ha,
 	task->task_done =3D pm8001_task_done;
=20
 	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
=20
 	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device =3D pm8001_ha_dev;
@@ -1791,8 +1792,10 @@ static void pm8001_send_abort_all(struct pm8001_hb=
a_info *pm8001_ha,
=20
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	if (ret)
+	if (ret) {
+		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
=20
 }
=20
--=20
2.34.1

