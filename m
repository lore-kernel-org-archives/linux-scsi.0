Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3AAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbiBNCUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiBNCUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:09 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2872D54F9C
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805201; x=1676341201;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=G72px9zteVEyav9xzEEG21fzNpn0jSxqg6FF7e4Vh/0=;
  b=hPvfotPh3JEU/u0kfU/NE2e2+hwhiY3KWqYZObQ3ZLOf/eLoEATVBd0X
   iz3cAlr8UGjy4uNsMYK8q/mo4bEHOhrydhXifhUfZlQsdNLg2EnzTVIJn
   xys4/9dptuUgofLmBNY3moDndUQhqAmeXkWJuWR+A1F0yCBbPJ63DiM7E
   A6S/QgpTYDxE1Zx+VpV6covxEhGOkaiUBqoyBkht1wZ8KcHjRzS3KBZAp
   9SlZa24icBETSfpEQMIB7JuIiDvrYdQpsdMX5PWtq7LNKIGHRfxdxEZMU
   gX5/xF2F8Q34rJjIaOXzWIO7iAPRy/0S2iYyDV5+iXPreV12F1WIx3AAq
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819818"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:01 +0800
IronPort-SDR: q4jpOBZZKkFsk4YnIKC5GOLVfs1JSO7Tpefz/X+9bKJOXoJ+EZhuR2/Ip233hDsF5VZhffQvyo
 5+NAckfYlrXpptR5QUaY1IVeBw13e2MPHD657PZFnBy/pY1Z6ydWV7pvnX3VgbJQaSvap64ZbS
 h2gm7l1v0wzGNP2l9Q89AzWPhN/5K699/N0qGHK5IwG/aXLpPUhILX6vqqmxuTVF++dAQC/Pmo
 5YV3A7B/PNktjaedFaCKZ3gl/jXkqCRDK388ciBS4/TvJeBr30MsZyUNR4/gMTgsn2LTKBeDwG
 ZcEPwtdG+VfCqj0UHqQtQO9A
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:54 -0800
IronPort-SDR: 7K0mQDzqWMJfroTqcn3+bL2JqI1DaxRGd6F7f/IepQjZ7pWc1sWZBm7uxLoyNuRzqx6ImvcHFE
 VI0c9omzTMT34j8XeecemM9fZSgdaIL4HAE1C5wqkYVXvCoXIni5fz5NsfFsSWpy7QcEWfGKKs
 tPQ/IZlPccTen9RtA/SubPGf2RjkWP3MBwxQ9tdGWk+ZcCmQtO8L+xJdPeSCpnq05jwXUC2s6z
 hy6MMzL+7iE+94H1IYh+Gc+c3mYfgc3ELGCeUrNgWUG57barx+yCXQftySxKEtXjCe1sklzk+i
 /9c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxG51Qlz1SVp5
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:02 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805202; x=1647397203; bh=G72px9zteVEyav9xzE
        EG21fzNpn0jSxqg6FF7e4Vh/0=; b=CxOcdHUfFZnHQmFA2muZZ09m4qvY1ltsTp
        TMnQuDLvf0r+3svcERZJHmQhSy4lQ3RbthxrEWYOJ8fjzN+FCvzCnt/6ZlbCmgls
        7GadkiKJE+cmkZKSY/FKMG3Hy9CIxHE/FnRUNwNKGV/APqwjW9uJ7sMpkMYoaPAn
        oHUxp7CtWS/QUT6sKgb2moLuOnT2AFL4CvvIEt1UZzIak+jtnUvjrKxzdXvaDLe2
        No6BJra0Ly0erfw6HN+P9xUD3M9rBncIAtzOJUaRRLNAItXOWmMlIT+UH7INDn/W
        b+qYHqZjLjPeZ6p2yctXmuS2iFzS6+C7cFJax8D00jDEnZLw+7oQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6Y2QTFpuYmsK for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:02 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxF2LTdz1Rwrw;
        Sun, 13 Feb 2022 18:20:01 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 25/31] scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Mon, 14 Feb 2022 11:17:41 +0900
Message-Id: <20220214021747.4976-26-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 50f779088b6e..fcfc8fd4b14f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -181,14 +181,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queu=
ed_cmd *qc)
 	task->task_proto =3D SAS_PROTOCOL_STP;
 	task->task_done =3D sas_ata_task_done;
=20
-	if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_READ ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_RECV ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_SEND ||
-	    qc->tf.command =3D=3D ATA_CMD_NCQ_NON_DATA) {
-		/* Need to zero out the tag libata assigned us */
+	/* For NCQ commands, zero out the tag libata assigned us */
+	if (ata_is_ncq(qc->tf.protocol))
 		qc->tf.nsect =3D 0;
-	}
=20
 	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis=
);
 	task->uldd_task =3D qc;
--=20
2.34.1

