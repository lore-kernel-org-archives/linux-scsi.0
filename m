Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B93AC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiBTDSt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiBTDSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:43 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D71340D3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327102; x=1676863102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NJqzc6YUpP+vwggbsF6cTeLSsRgTfL3XgaR3agxzlg=;
  b=SKK+DS+76IHupnprDrmfN/qDk4B7G3M/x48LyolRSH9R3GsYqChDUu76
   vn/wud695v72+Q8cvgb+JL/zPFocMtVkrUjXus7uEJW4s5BPTcBBO9k5i
   EBNgv4TIqNxkHdl92gtKngBnesbxhOIMngW7MQLj6EHLlobju+J+V8DAz
   db436N9gSdr3AVOUkEeJC4arGfGFQ3OmIKS1+xa0kiYv1OSdZPoTiZu7s
   mDdSqErf1cciXKoJf97DPgJxcJR1ngOZpLQD74EB7BTrSazbdsc1Ms11R
   qViydL/ZnJEZW3GHyjJjbctIFKAv3oLHIp82Zqx2a7F6YRQiMR0pWUPwF
   A==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405746"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:22 +0800
IronPort-SDR: zFDcJKavhOmJCOUzmLHEynt1gpz8sGpwLmla97IaVKqjQwACGND8lpHpjtbxTqmtHRvIeSvcs/
 DbCcsiQIPB0m63JQPHZjIxbwLXl/S8WcVG79Xrm/uG4womKhTzBYeJhBqc3/bYbFkK1kJbb22E
 hVamLv4ItD9XZiy35vyh33Hna7tiY1dJFhcf4x5ozoZo85/jTLRAj4Ni6+4FWLtIcxuYhgYmWY
 BdDMfyBttPZaC/HzZWY1ZiMje2rHn+SNG87wEjd7yB62umsFMi1ryTyQITvD+GV43rNl5IU3cJ
 LUDbDA5FRqRPmNHiXZ3/oR71
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:59 -0800
IronPort-SDR: 1IvnYAmWNy33TcUOcK/T9KMsOPFBWoDk1m11JfrDJ2lduLsQjU9z96XtOBGQ+inxcW9JeydnLj
 N/hcSh57Ouz8YVWyo55uSbnXRZqp1NXieOGffkgpON7mDse3s+LkoF2uV9x9lL4ygfgu1l5yJz
 B3ayFCLS4dSERNaRgm1nX+jeaHbwWjB+yCDgcoArzzxqA17JoMBFPvIj6ogVXG9k1kU+Co0F8O
 ewkyyQvFa0Etux3/RDSyfztjGPgnzLTHVfyZKH/CQ7WUpx3Y1uKG7potjM0eZsCVQV7lameRvh
 JKw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxq1sPdz1SVnx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327102; x=1647919103; bh=+NJqzc6YUpP+vwggbs
        F6cTeLSsRgTfL3XgaR3agxzlg=; b=kl9PzeWgFbOtmicwKn7Trxqbln1kPgJNgf
        ox+R6hBpumS2txZnkPbABvQBslH+p//1gdT6mrZ05rsrJplmn2NAM2CcZshFvlRf
        jb4B7x3z0fHdvvmpqs2wOg4pyPjhRSDwCqvEsfelSLUUdI8WOfzfFdD+w4jOG6Y3
        I9OS3+VpAdAqF22azWdgreKkg+CgUOaar8cMQRPPgvNbx92MbiJDVvfjfgiuyCc8
        o/v4YgHEvhwE6bflNW6q7hzK1K+2lYGtvONFPtW9V9CKaZGIFUWREbS/uflaG9S+
        o0G5cR7of/HspNQ9b4og9cqf4Z63DJBL5gn9uMOXlM1SYD/F2byw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1_qNkagE6yt8 for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:22 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxn5B9Qz1Rvlx;
        Sat, 19 Feb 2022 19:18:21 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
Date:   Sun, 20 Feb 2022 12:17:45 +0900
Message-Id: <20220220031810.738362-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index dab75b481618..d80b48e0e41b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4619,7 +4619,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *=
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

