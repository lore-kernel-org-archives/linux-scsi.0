Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C303C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiBRDPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiBRDPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:09 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85654CA0E5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154094; x=1676690094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qwEC/HAHMVugj2YgjUkTAgDhC0DdmBvV/+2YVPjh/G0=;
  b=EooV5h6aGbqmhBkFTx6H3oxFlVC0h6RHGw0Fukx1hf/pm++H0xQPJiqN
   yL5PdnllULTGtzIcq+xmBcA5jwMOTgsGxHdkjOJFdPT0daeF6kGqQGvxd
   J0iKaQLqX93i+MnvUmLYjklOAwosX2BdzvaHvxusyLbYqN7sBR3kKzPTg
   xVVIhpAWExINzemzBoMLRRC7wiihQbDk/BZqHh28t9ihYip0hU+V4eee2
   wZnVw3idwTDcU+M6j1MLH4vcVvRBIkc1NJJpcsbe2Evm6hAxnV61h7BhF
   pZrMKQTbiiNwCISLbxtJrCZKKI2F11Je7ccmffXbn4rtl7l77sFxNcRuX
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225708"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:54 +0800
IronPort-SDR: 7GACDYuXP3oeTskFUikOWQh8YMkmmDq9WrNibi5UYnzFpXhOzL0y8WuJa/Y9xcoPLcJySAFyMi
 9GmVo1r/5mIWQfOM2KGutD4J9P/4u+TWsJMA3I3EA5CXtQs2JSEdTlTzeggfYDKHKhHXqDUTC4
 CmxdXPMAgxlfrxwwVF2i0/zwS+asgYrcPzxCCtJ2hIer7HPpIffdRUwTDBSni3RDmVYykcUdQq
 9gbp+GV/E4/HjF38Gep+DYVNF7VjmM0cWMZ5VtoLOXCYtTqiLk6Oc/x19eFGKB0if1JRrZjAco
 BY9rSEspR61riLM1MGKzTZrh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:31 -0800
IronPort-SDR: W9o9SEdq/uudVCM7eYLFXI+/aOXup5YbFu2VF8tN+EjB7axviY7Lj4zfeb5UYkNPQkRXg+lLNS
 2uK5Wpb/B+eI87xxX6JkrufX+BQcia9239y1scauN2/ONVhCYCDJ2CHjbmeWuZLktCJDX/Jnac
 TUHN5NuqboF4e7ijpvinRZltsdeyVx3AxRyAYc0ct21j+Qmh82w0E/BZWatq41SMWei7RhGYI7
 g/+qz5waNjBQnkmPfliwKBqzkfKHXH4zdx2l/aPigIGbQaXhD/qSGnPXEPhB4m+yjovsE06/Gb
 BC8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:53 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyj0qKMz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154092; x=1647746093; bh=qwEC/HAHMVugj2YgjU
        kTAgDhC0DdmBvV/+2YVPjh/G0=; b=YF5u5Z3Q3kPwHuowQO45ZH3YYe5mpBG2Mp
        UmfjQuP42QOnBe9yMavYsscO/DxekGGmMpPJ+7pc6FkX22LQXKyU2F9flz/U5TsY
        nLyrTMQaj4FBA8E9EIb+KsHFpNNf6JvjosMCJxTmu1wntiedP/ySupORgvndF6LV
        oIhWniUuewIPoWxe7yIDIZE03QtTvurg05lZOrK9ewfJhmmbyy4mDoqjZJMFPFeO
        RqKt3QGofbV2htLcybuXZMR+aZtoYr2444t1C6+JgmEFGAJKP9diHW8F9lMEv7Wo
        qsc2SKYUjfcjagq8Yr2SSZKoFxw/sPrVHi+bKcvCcBks7f8hS8zQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id O5GGzwnMDQwv for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:52 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyg47zKz1SHwl;
        Thu, 17 Feb 2022 19:14:51 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 03/31] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Fri, 18 Feb 2022 12:14:17 +0900
Message-Id: <20220218031445.548767-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
index 66307783c73c..73f036bed128 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -721,7 +721,8 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
 	struct fw_control_info	*fwControl;
-	u32		partitionSize, partitionSizeTmp;
+	__be32		partitionSizeTmp;
+	u32		partitionSize;
 	u32		loopNumber, loopcount;
 	struct pm8001_fw_image_header *image_hdr;
 	u32		sizeRead =3D 0;
@@ -742,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	image_hdr =3D (struct pm8001_fw_image_header *)pm8001_ha->fw_image->dat=
a;
 	while (sizeRead < pm8001_ha->fw_image->size) {
 		partitionSizeTmp =3D
-			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
+			*(__be32 *)((u8 *)&image_hdr->image_length + sizeRead);
 		partitionSize =3D be32_to_cpu(partitionSizeTmp);
 		loopcount =3D DIV_ROUND_UP(partitionSize + HEADER_LEN,
 					IOCTL_BUF_SIZE);
--=20
2.34.1

