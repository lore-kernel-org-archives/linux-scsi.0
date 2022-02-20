Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F239C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243119AbiBTDTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbiBTDSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:54 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE36340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327113; x=1676863113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+0OrtXq+6naR0bB1OGjcvN2Cz9hw+Zu3eTf+q2N6Z9w=;
  b=JgnamMF7pBxN9LkHDWkMZmYV1kyiH0a6rGFkRQsAwNuXlLTpMlahVjnM
   zwDNN3YX//lEi0RL0gk+yoEkzj9pJ9AH+lQ2VafZkdJzNPvKgOBElyjlj
   i6ICOYM1F2F1LvKu9cev+ZZVTa5003QjkVYdHkPutFylI9WOFzApq4eM9
   Dj+O4fKexkhBlcNsakG0W4B6yZG4EGkVmLc7qotu3caQbynEv7KlTGqlP
   lzKc8FcfdIlfeIskAW8iTidr3I+5alq1ileDSGC5ve7h9BeHuh7jsUBSk
   72wOmhkNoStUVSrEpHmzr7Y50JBHyZ5IBB73F9oitgtCLyLc3hp/YFqGk
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405769"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:32 +0800
IronPort-SDR: w6T7ipiOkPf2YQPQEyL3yalnr5FMTA//Ejp0MTETzVm3ApIPQuUF0qSJjU/WAzfaReZFQe6Rvh
 cd7gob3zTCoFcFwKdcvilkX8jEx5cc4QcK4ymumioyjKvl8/RGJQBYN2CjbvKMbTj+6L3sFIXX
 +VRGDKZL19INoDfIDLEQUq5Hexc4EFy3vHzxxdChNoAPDaPrTd1Vj2dYd6It9aOX1hIhHglQUj
 CyNNLInlVVuKg1vjUuc0Fa0JzaU5VFE19DJVSnibBlQmglW2XcVLJ1E48PPLuNZ2EO90j3zdvQ
 tRvEcCnNb9K5l58VsEz10DS4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:09 -0800
IronPort-SDR: zoaMauOO5/hV7IDeMBLKKkkwm80DeD1nxj4764X4it6OpxyA6gFkXtJhbDn1ZDorxYz7ywfZ72
 SV+yNffCqNlSINIov0DtLx350TTFPxoRN9kJ/QA38U2pruFt//YYdv35DhRHWw8qg7axRdND0O
 H1dRamBQlCrysvXDRQN+Z/XCMyiW/5ZBej5e8VUpVHkC28mTeqsLE35cNPjvcM4d8fB8fNPGtj
 T+lUudupfpE7QemIqFm1xeQIfHxNWjmdXmWYu8wdj4bQ8ZMbhRxNBh4f6fCr/zvMJfDDBHr55A
 x00=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy139hBz1SVp4
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327112; x=1647919113; bh=+0OrtXq+6naR0bB1OG
        jcvN2Cz9hw+Zu3eTf+q2N6Z9w=; b=E+aDquTbyWFg4tSJAawYa03gzJgEx3/yfH
        gF2Y6jaACTTdiROff2o59RTpt2uvwmmlDx7HzF0Hfr9V7W+8nvxa1B5tO0SYPvJN
        nB5CFk/5qq+ta27ABN8uH9PyO4mf+/t7QkU0Ma/IXtglzmIm918LmMtz/lHtM/dr
        TISxie+qvB71PmHHoPEdAorIiLx8+txL1/AkCzAEoCn51XpkhYFbGGkZ+TDy/VXi
        lljvGimtOTyLiqZrDY8ZpA4l66JZ508NUkyM1eKk7Gf0hmyD6swUEnmhO2cg08n9
        BRru+4tFwA64KrFqsNjwzIUZCQaboAnQpMe3KoWz5KSdilE9mgfA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sbhdRSgDuyT6 for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:32 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxz6DRHz1Rwrw;
        Sat, 19 Feb 2022 19:18:31 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Sun, 20 Feb 2022 12:17:52 +0900
Message-Id: <20220220031810.738362-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_pci_resume(), the use of the u32 type for the local variable
device_state causes a sparse warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] device_state
    got restricted pci_power_t [usertype] current_state

Since this variable is used only once in the function, remove it and
use pdev->current_state directly. While at it, also add a blank line
after the last local variable declaration.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
index d7b95ad4533e..381105286953 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1336,13 +1336,13 @@ static int __maybe_unused pm8001_pci_resume(struc=
t device *dev)
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
 	u8 i =3D 0, j;
-	u32 device_state;
 	DECLARE_COMPLETION_ONSTACK(completion);
+
 	pm8001_ha =3D sha->lldd_ha;
-	device_state =3D pdev->current_state;
=20
-	pm8001_info(pm8001_ha, "pdev=3D0x%p, slot=3D%s, resuming from previous =
operating state [D%d]\n",
-		      pdev, pm8001_ha->name, device_state);
+	pm8001_info(pm8001_ha,
+		    "pdev=3D0x%p, slot=3D%s, resuming from previous operating state [D=
%d]\n",
+		    pdev, pm8001_ha->name, pdev->current_state);
=20
 	rc =3D pci_go_44(pdev);
 	if (rc)
--=20
2.34.1

