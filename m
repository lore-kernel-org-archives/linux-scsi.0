Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0F1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiBJLmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbiBJLme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:34 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357C4FF0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493355; x=1676029355;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=QxFaq4u/ltI4EXOZN0EExZT+6BlFEgHRDm4Mn9uwkNU=;
  b=o4wdWYRvkaSEvSZ22+FZAS+8ajTNDyoI7SjsA1elQII0GFHSFO/JCdVT
   e6e+3ILSYwmqNBYBnbM7ATT424EC5EFWT0dulzHhTzGTxke71KhfPJgvR
   DS9uJfI/VvlIn0JiwG1KsimjCTqqbuyYCXavDY04OgFtKSgzV3lZd1g9J
   gQaYGTuqGKMySi+NQctNa8sZAuonFiaF1NdgxfB7VNI61+RJxCef5FEIQ
   EZwESXt5/02CtlI3QJLGxtsdTdyppK1cBRQAuwCyrCkTToJ0PAnbZGIgk
   U3ZnE9/mAdzHzqxSQ1Oe5b32aoxOm5FAnqsTFakDh9EhvC2pzGApzdkfs
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575642"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:35 +0800
IronPort-SDR: a/jZxFmbjGpwonQks8SQHYoEUFTWOZ3K+UgChkuyykYAADGqbGBDUC6Rchqf4uhEy4cjcpI+S+
 4rWWR53WmptMf0e03wyQQY8OwUOd+FfC3RtVoAMpe5adJ54x8aZD/0UA+PqLMPG8AU1wXxk5Ek
 d2H0OVNKlFxfG4ETUNbcsDG5VUTtJH2HsRP1rpgQlM9KZEQOCAuCwSy2OMMMFzrEMOM297nmLI
 t4WySQy50HGlF12K5ybrGP44tBhaT5EIIFnQLxBghWIPOXTcZH0g+B32TmeE0KJ9B8wl/ML+bY
 kEkXnELXcLH5rGqDGphz+IPh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:32 -0800
IronPort-SDR: INrMcJrOncbAnR8Rbtv0mPPz/aFUgW5H4pCmU4i19A+pkvqDYsMd2vc8Pz2AVbnVw8WspOHA4J
 Mjv1JwUS1IGnJm0YC1hTNlf5RSPlCMabXK1bOwd8N+byWltalsbddEYtwoWz2YqgnP5EmggtMx
 3EpQd/Zni7THhNaO6bB62OVzVvCV3saank+yfh7N2Hvq4LBNXj6H3znZ3iZs45tKYKsUUKdMZF
 Bjlzbv7joFNv3AJLg0QQlVK/8ju4sHEx2FXIKspWYaV4KM6DfUFKnu33dz7T2zkQKSYiv/tTJu
 t/8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcB4WXQz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493354; x=1647085355; bh=QxFaq4u/ltI4EXOZN0
        EExZT+6BlFEgHRDm4Mn9uwkNU=; b=rKRyeJV6+rWaVyw+ZVNknTrClNKHehMRry
        vwbkEBL9s9HPJr+ZOnx8sP86QiyFqbrr+a1fSbUUpTfSDXnO0JrrL2yedkXuKDg3
        isYiy+l7p4X89JXfP2u3ZDNvfl5vVGN4CMobl5YtDAbY/iT215WTlzhszxe3NFvz
        wuAkUzZfc6gmijvsy0Aq88ul46v5LJcRaaJ9gh9VCKyCVMN5qKJ5FytMeJHf0mYo
        VhTtXpSZ3T4pz3lgdBp/kmEH54WoOTfa8yoeHhmnc8vc7cGdLbPBXricSnzdW2AK
        tfxaKtrSCsNYW1p5sWaIhUjennI4BFrcSq1E3ytcKqAGA8xbu8tA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QOzqrEdIHWt3 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc91n9zz1SHwl;
        Thu, 10 Feb 2022 03:42:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 09/20] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Thu, 10 Feb 2022 20:42:07 +0900
Message-Id: <20220210114218.632725-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ds_ads_m field of struct ssp_ini_tm_start_req has the type __le32.
Assigning a value to it should thus use cpu_to_le32(). This fixes the
sparse warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] ds_ads_=
m
   got int

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index d978f7226206..43c2ab90f711 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4626,7 +4626,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
pm8001_ha,
 	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
 	sspTMCmd.tag =3D cpu_to_le32(ccb->ccb_tag);
 	if (pm8001_ha->chip_id !=3D chip_8001)
-		sspTMCmd.ds_ads_m =3D 0x08;
+		sspTMCmd.ds_ads_m =3D cpu_to_le32(0x08);
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
 			sizeof(sspTMCmd), 0);
--=20
2.34.1

