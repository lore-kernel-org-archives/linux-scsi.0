Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5B1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiBRDPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1234770841
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154121; x=1676690121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G72px9zteVEyav9xzEEG21fzNpn0jSxqg6FF7e4Vh/0=;
  b=rU+wzXRIvPDQU02/q68DTLVJ2ZJ43T8uYB3sS82N6UhLIEQk5Mk8gbIg
   1VT9qsHWMEbXNv+rJPVYlVl2AF78Dh5Oj8BenDhcFSfPhyC8qzDEX4JNG
   1tOHNWnIP2VgrNB2gSLf8vfiQOLVYXHwxLIOU8TGhAI0x404/ff2JF6C5
   8s+mZZ7y3jKXmmJwTk6pukX/++6Tn8amzgbbSdzyfjaKB/SmZFUEi9pn5
   yT5bJcTW0yQ0wWsULWmIuZwNpOTWcPNmsnrbDQguUTVSpEgwwdjAiTh6h
   b6AQeDv9mMQzFp1nYuzhwkQDbGHCLIGk15GyTdx+R2XQDgmrCTnejzXWJ
   A==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074196"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:20 +0800
IronPort-SDR: aI7Mz7KhwDSmGfcCrwKyJcEnhOTiPwdfBfqI/R+n3kG0GyRTSHixewiuaL4cmhIMgY69ryrNQk
 GdlHaP+fggtR/FAzU4SxTkIDXVtwb1hzdx2FGeL1MoZahHAIsQTj30yz+iEzmF3ZbSI9cEQipt
 BrbFm1gd6AwNEsOY9eprO5S4RL+QVAR6NiLme4/HbIFLMZMCQjyq0FIe5V6Q5HllAI6e7Fe5GR
 qd3WwgTQpPuFVcHrt/uxPEphsNk/Utr02ZrTlVz/uyPkYiMftp99yR3ecj3VYvp1e4MpilhIoy
 /+gAAOpBmqbvbI77x6ItnnYc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:59 -0800
IronPort-SDR: uLklHmgwEaF8tBN3auOHR4MVZL+V87EEWho4Gtf4ymQxEWywmJV9/68vwR3vSP6OFcptpJhbMF
 j/DLY9gXq6lhYbLZAxwFmi9+IbX0GpyxWJkXt0SYdTRZ/SoqmGAlmjmLLS0+p12SjUy8yDNFGN
 I2mX3DAXAlFb/QFCuch0TyI65IC5CHfCxoZtPj8PbY36D83NxeOQAKq1eTBnm1MM6O/jXO1k6U
 qIiJP0mltybLUDJndpRS9Wd0Kw7Ae5HCA0b+YpBWNUQH5r9d7Jq1XPtbsAqK7xS10aagF2Wn+9
 Zc4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzF4F2Fz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154121; x=1647746122; bh=G72px9zteVEyav9xzE
        EG21fzNpn0jSxqg6FF7e4Vh/0=; b=iY8Ia2N8CSjmc9igHRfipGnP8f0LHn54OG
        +VbyjNXFvLUitPgH4j0dfqqpZpSBIh1FF0GLFxAEWMUk/ZqvdcUxPwe4dzhlRmax
        fPlllRVPJDj6ujGMloR3msH9G9V5kwRlDGGhLEezb4tuVYmX27Amk3mLXyzU7sG4
        Umeg9ntHoGxSIx5AA1dUqwLwU4IfTJYVTR6zA72Ejncg90GijdWv7vTg+U3Xrwuj
        llV/slOHygZE1WI1SHnCoYnXWt/gwtQFWgaa98ogqWqiCCOsp/5uuJQ2P1Tf91Di
        +EVt9fDS/AJzd5Fe5nftcrzHip5uOWxQvaTLMNS1tM9vK272gsQQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pg1nhreGmMtu for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:21 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzD0Dszz1SHwl;
        Thu, 17 Feb 2022 19:15:19 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 23/31] scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Fri, 18 Feb 2022 12:14:37 +0900
Message-Id: <20220218031445.548767-24-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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

