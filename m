Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA69C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbiBJLm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbiBJLmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:43 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6328A13A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493365; x=1676029365;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=DJmm9qwWl1xzoMpoCIv+1lIuCBbSqqCn4azkj1DgYrw=;
  b=aHErv7Wkjmm2aAg4clC6zFVtpFuhoQTr8g8KzqqlbP6nRpz9JsOgW7BZ
   ZhN8oq6FPnjKtIxZv03aR79p4rB7w6+NaGC2MnH28hbfAZISju3xT60ON
   PvS+VRsQ4qTlO60qT2/NEBMX8OEYPjHfFy15m0nQ9Wk2sI+HvTLCFfnfa
   W21q5b4z6Va0BgSR/tFDmrinMEayEOp2m/8TpvFni4ukm9P5B4Qu7IHWv
   ykGfhv78iEcOm44HmqU27PBZnAVdTmqEZvJLtTxf88ZzR7uhpIo7aNVJS
   d1foMFkxDz0mDlGCKzW+DCGLaCZ1dQHS8w0rquKcOn5IQixg+5T2qpMGz
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575660"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:44 +0800
IronPort-SDR: 8ihg0tqI/e1sBotdqKdLJmOJO+gHmt7IKh4/6k+u7NeTpexJjQkPkL1p5BV506xQrEnjW0Szkb
 Uj1xJ1azZQyHwnO8Q05/78uX0KU019W4Z8IM03lLs1Jiep/Uu7tUsZxiWmYAC13WpAKjH/OZLg
 mBqOtN1fnh6mU0nt2OJWHJp0wXq7zMOZFIiSLkhLx1bd1QeCtK4QphuJ/708IJgpJwmJtQ1mBG
 QNNrtNocZOWon2CPVEzBAL+llDpsrkmsdv3fmfNgw7i3BWGzQAcrONHHJNKEYmC+2USDvVQGcD
 itArvi5nlh7EKVtZJKQsLzTG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:41 -0800
IronPort-SDR: CpQae64Gg1w8NIhjgp71ISXV9hxFiZYlYFJxlSAhML/L/WSgGWK2LNdjx/JMOOwBJUecBychm6
 13ATxVL9TjvFWGKnrBkm8oy/ohoS9P/ADQgFcRh7iae8Wem65BuynZq0BRLhek+yF0ViUOUJ6K
 C2Z7Rc6cFtyrdGZ+Jl4s7RqvePL3x3zw6vlpNCg1n+DemOWgIpz8Oym8RctI2X/PmSZm+5rvEA
 qJ3heNkq5FU33U3kv6rtjeCMQzxw1CfEkAja+EcB8y+i8ZApF3VgUlF+rmCkTJcD3aI/KuGCQJ
 CEU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcM6QbFz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493363; x=1647085364; bh=DJmm9qwWl1xzoMpoCI
        v+1lIuCBbSqqCn4azkj1DgYrw=; b=nP5I/DNAchVUvTtRv2A0N7nsgP9mK4LPUI
        1GVi/Q1kUW7+HRWSoluf11BK53945BOhzq3JHoFGS0Ac+wlxjetf1S/JIc/7kZP8
        zzQhzSYSJdHTvmexjCJ2a0FUBBQIhgZLcbFpji/vUInDU3fdvfTjXMdhCbhRbAas
        fVn1lPGtnJbCCGbE68+RyC3GsZZHr/bMmtMECVCFnfl9/zxcXJAYJQylLQbqse4J
        cPt22R0Q/1QaNpZ0tRllpTB7UijiFjIwzy8Z2zzjHFbyXzXQZOHGKH5gxwDDk7Bf
        m2HRtWSNgdQacL5cZ/QCD0qORFzY7hLN+nec7DOfdEevcK8WBpoQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mkVqFc704fpo for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:43 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcL3t48z1SHwl;
        Thu, 10 Feb 2022 03:42:42 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 16/20] scsi: pm8001: simplify pm8001_get_ncq_tag()
Date:   Thu, 10 Feb 2022 20:42:14 +0900
Message-Id: <20220210114218.632725-17-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 6805c7f43e41..711eaf81f546 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -306,16 +306,12 @@ static int pm8001_task_prep_smp(struct pm8001_hba_i=
nfo *pm8001_ha,
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)
 {
 	struct ata_queued_cmd *qc =3D task->uldd_task;
-	if (qc) {
-		if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_READ ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_RECV ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_SEND ||
-		    qc->tf.command =3D=3D ATA_CMD_NCQ_NON_DATA) {
-			*tag =3D qc->tag;
-			return 1;
-		}
+
+	if (qc && ata_is_ncq(qc->tf.protocol)) {
+		*tag =3D qc->tag;
+		return 1;
 	}
+
 	return 0;
 }
=20
--=20
2.34.1

