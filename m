Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EEFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiBNCTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbiBNCTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:48 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497BB54FBD
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805180; x=1676341180;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=NED7TbeMhfuFfImpTHjjdM3/ALr1ocTrAkJX4NcdYvQ=;
  b=ORz/BNYvYRtelvFUqB24f73eIKIJNbhYNnRLVii8yTn85NwDjznUCa5y
   c2JMhPAvcXQ7/09qnVtPz7O+8jisVmadXvF5nEfyWWOw3mCnFj/ubcvSj
   i0S5G4yJ+/lNLpuWEDytuQwzw5p2MB15cLr/QJHfpWT1d2vVXYbiA4EqL
   y47YZzOHZ/Fm9H1SQuRzzRzfDX/WudAmdDLd0EW+XOtuxtORsgK1tFoqK
   Y673z8jqqt7T24jI5U9Y2kdzswZ/8r/LDjhDkTl2+OH/96QcHE/SCFn15
   9U8Ut2tSfzfYJSjJIVbNgq4LqaocZAoGvtI4+cqzs7hk0H/AzGF8AqJlF
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819773"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:40 +0800
IronPort-SDR: uG6yx7W3pcUFTklRtaUebzgPMHdmBRSSHvLIJxgBE0UowYmmLh8z0B1jEv2s6WlnadSi5V5RJz
 IcqBb5uk4mZvD1LynkpSZaiO6FKMx7Hdx5m7NFTflwz6hMG8B66uZPQ44THl6EDTCB6moln/+A
 3SlpVgTw59AfQw7M1MUSoCVQWnHlvqlQkzFgX24ydBT0oNa3KdyYrix7lAEIpg1wHjvRtV6TKP
 igy84Jx6RMFJUjJSXvHu+FOIyGIjVHzpja8T4/0TLjk0PVgWPARaomZO+nUQEHXvwpDMRrpCXQ
 7mo0VHv0hkqNAsWbRi9ISIgY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:33 -0800
IronPort-SDR: luUdkZcgsEYLczcJ1V7fn07ZFGMn17Y3af8xrJGiob+7bSH4/4jkarGsqgwX5mKdhER6yyMJKz
 PLtPoATM7qDvUxe5MmGF7POupC8hsOtqul4LXkaWexEXCrHflDmtvyQnhHlc3VDcjxbX7j5p7w
 vVKhBrFWUD8ghiXXdj9wBMVAjdkPtkfTebFaL81DPMSGWWYqPShgn6M8CFKb9/MVpXXwFdeE0r
 Ywq2V7OsXKK0/yDLJFs2h0oUFLn0yXPwqs4yEqwdt6jNcUxaJpKOXlyJv21UuPvA87GcNQ0sKL
 EwI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnws6WgLz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805181; x=1647397182; bh=NED7TbeMhfuFfImpTH
        jjdM3/ALr1ocTrAkJX4NcdYvQ=; b=DHym5d1P38n1A7IjCOpmBy+rcnv/okWif9
        6FBSlVE774DNiIkQHrKhtzGi/aCNVBNLmFyOBVWGIVvR2lrqZNE3gWBNEzSMQdel
        3oVVOy+oaAV5C8vEhFA/0qYQT/CCcdaBZEjdrPLMc6nrJgNDdOEbdU1ds8IGL+NJ
        KCbEG0nXLXd0TSMwhN8tCwWXwLWA1UxiguB4BBLqen4H9Bj6C1/1tAhb5GvN2dDy
        V9ZVjEboFW6G7KPJim4b46eZKt/W637pCCVgjHGEhba2jc0v9URKxpNudMWFv+tt
        2IEfe5gHzusBcFqxurZitzoG0ZsEr6BFy+II6vsuP+u0KbsrhgBg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ytC-AyBDA657 for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:41 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwr3T1hz1SHwl;
        Sun, 13 Feb 2022 18:19:40 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Mon, 14 Feb 2022 11:17:25 +0900
Message-Id: <20220214021747.4976-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All fields of the kek_mgmt_req structure have the type __le32. So make
sure to use cpu_to_le32() to initialize them. This suppresses the sparse
warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] new_cur=
idx_ksop
   got int

Fixes: 5860992db55c ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 108e4743fe81..8e4c515f54f4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1405,12 +1405,13 @@ static int pm80xx_encrypt_update(struct pm8001_hb=
a_info *pm8001_ha)
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
 	 */
-	payload.new_curidx_ksop =3D ((1 << 24) | (1 << 16) | (1 << 8) |
-					KEK_MGMT_SUBOP_KEYCARDUPDATE);
+	payload.new_curidx_ksop =3D
+		cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
+			     KEK_MGMT_SUBOP_KEYCARDUPDATE));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Saving Encryption info to flash. payload 0x%x\n",
-		   payload.new_curidx_ksop);
+		   le32_to_cpu(payload.new_curidx_ksop));
=20
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
--=20
2.34.1

