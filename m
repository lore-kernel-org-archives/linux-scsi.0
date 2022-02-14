Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA4CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiBNCUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbiBNCUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:08 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF64254BF2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805200; x=1676341200;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=PIfDTjlErIm0Ykd9p/VcCUrV6cd20fMAmosk0+slmG4=;
  b=A90trD039MHc0lRk2vJv6T25dXiJT2etQiGGgUm1F8UIgKoHmdj3DGWN
   PTnWgiIJa3HNKMimI59mnmRpxNiprD++wGIj9yz10oHTd9N24/ssBLn/b
   72xT9t9pZ0mdE7SDnDWDtQqTN06RmoScB6S4QlGnCU72Ky4mLrKdaAyQU
   NWVW4iNk4NEe6rF7dY5/XVYEz7welxPI1CYONAgq8zLZ57Amk7kfB6YKC
   CV5FitcqvBIRyKg9VACukEXH1D+/aUGTx+j5YnJebM1UypI7JFUAiKcuf
   9e72TkQn+wShNu+AC7dLO8DeGjyz86GgeYnCM/UhUeJqkugovd+6Cmwd/
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819814"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:00 +0800
IronPort-SDR: QXquiZvWXe4N77r/+GGjKu0oCZDxoWuSRymoAn0FSU8ER9PLotGNTNj8nf66mJpwCYnr8QC6v4
 UIaCnOYIgZlnFqirqDnA4vW+IPfBFfM2xr85/rU6anhIONnMHJef1hsiixuGIzDTk9gPjarGZn
 zLUE3uukmh3Bd4FYI0Feq3OlvfW+deXRP9RugCvTbJcjoi/km4gAjeZcqQE6gN1hC42BFqQXiN
 AfE8qOXPTJ/mOcsxCkIme86OEIU8pWtqVhVVD3EigIUnDZorQuOmlXTEhDu2jjMMR1izQmPF0v
 YKXSF7K52oqLKk/k1kce4Ubj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:53 -0800
IronPort-SDR: tDOVQyF/VzWUfOvFBnfOOOQkkdXeUKHiQfQQQz91iHCWL3FwknObErS28yXwWgye+Ino46SAaA
 USO/ymaQr+LxNR/lohbFpm/i6L8ZL2cTCY4dRNGMClQMfGUDb1JGVyLEpCiTTf7zIp0+5PTfwY
 slUoaV6Xafbrr3H1yfq8lzR25X8TJ3W1jj3vtwWtILElPbw/SVjOv2JnEl/fCfsfd5iFjv624a
 kG7czFhPcPRKWhXTvW0rjg6hv9HSdVhla9JmYH94dSUj/aE4kbxACyZIi12IEHe+oRL3WJA/sv
 q74=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:02 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxF2t5dz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805201; x=1647397202; bh=PIfDTjlErIm0Ykd9p/
        VcCUrV6cd20fMAmosk0+slmG4=; b=WreBekZ9p8RAOLpSqShNbP5N9MtqBGF60l
        voWvKAskDlbvPzQnMTRPZbciAGbbI/Qsd/2pfCV2KRhF8G0J0zhSGJkAaG0glgjb
        CDDVluUWQvSSGRsJDJXPFzaWygoXozJL6hfgTCsGqNqLV8W4r05Nq8Q8uCvv73Xz
        H+PAZxTAoShLm61ElAnQkLEdOjO+SqUSHTcwbmAWjjps+epBSt304pbLWCwjsZL5
        aocF5Nit8QQlcd2n56lrwGKr2r9aqwYja/7a8LRYNg3KoqOgOYGEHRZqLbT+KV34
        sY0jsMoZgbpxlHilydpO2ZAEOq9o3WJaWI/tXlK37q6cMJq6/m+g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Q38e71KWmN4C for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:01 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxD0661z1SVnx;
        Sun, 13 Feb 2022 18:19:59 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 24/31] scsi: pm8001: Fix process_one_iomb() kdoc comment
Date:   Mon, 14 Feb 2022 11:17:40 +0900
Message-Id: <20220214021747.4976-25-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing description of the circularQ argument.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 9cea0a27f1a1..e74cd02a5c08 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3922,6 +3922,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
 /**
  * process_one_iomb - process one outbound Queue memory block
  * @pm8001_ha: our hba card information
+ * @circularQ: the outbound queue table.
  * @piomb: IO message buffer
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
--=20
2.34.1

