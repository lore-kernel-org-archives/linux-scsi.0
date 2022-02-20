Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E60C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243408AbiBTDTJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiBTDTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38618340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327120; x=1676863120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bEKyvJPR+/aaT0vvGkpCE94GOQCxPwoiIcR1hUfldWU=;
  b=MV+IesEb0YMPJOsbdwkRjn/W8D7ez29u1Mtz+LNh2Y9zpBD6g0Ma2t/d
   Crc5wZ2EVlaNh/mmn+TwWTvElicBVj9b6PFgQPu5MtFFKoCBRTr7PfB2u
   s2l6utTxapE1VGSJsLMQu6KNRu/YsrGcwX+ISpF9F03/XxT8uxu5h16pY
   UK12bple6fxvQ/CWDq2y/9XDIo4v4K32bHFu1YKh51rHLPiTReU1Ow1hw
   +2XESDprodX19yO3tuJETZxDp7mJqh03EO+lJZnk3gonjWs2u0IYuvwFG
   BHWaQJG9ZDhb9hYUcNzOS1df+6yq/R5nWFGy/Qwip8kU/f3ofQcvAnb+n
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405785"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:40 +0800
IronPort-SDR: ILBbuELqpCp+xJqwFBnYt+BFtCWGnQkff42jWeP2GeRpbQTKbI+54pfNIpQ+I92Lumi4iZub73
 WtaDiww95mvIqphCvLdzMiK/OFKMOiRMPN3CrtIToi05mihD2Qj6HekpfKAKIuF8+evxJFS5s2
 3drW0lz5/IeVhK1SH3EOsHdgSuaMtjqXMo96Md102NMOvrr3jfEn27XBIDkmArTb5fuqMcWnH+
 hctoDMsuyawgoLMH3WQ97i3QQ4Owwni4qd46B6bLwgw/S52TJt1m2X55tkmbadRU92sZ3eYWfu
 p3PkbGbNFN5DFyDxhxSw0DIf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:16 -0800
IronPort-SDR: IfeGivujH583M5RD8lLX6LNoAucE6NyhJCawFV310ghLvCzEoVZIJVx7iSsHdQIX3Bh0x84hJ0
 PKNIyFDr3grq+IDi9/XRzlQUoaAPvmRip3TfFSFMpYnGMRfZoaLaigwxm5W119yQoae6TDGbVn
 lWh+GWeLNAPKl4SsnxlsH9HzGvuAO7s4YVqxWl5ZwB5Nz0V5vUux303116Wa1f9COPGpJqurvo
 OIsi73ejeD5GHfDLd23z7J4qcApLDy9e4N9/0uv+Dq8xs106ZHSpA4MnBWnRzzuoSw/fqkqBR2
 EG8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy83nMKz1SVp4
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327120; x=1647919121; bh=bEKyvJPR+/aaT0vvGk
        pCE94GOQCxPwoiIcR1hUfldWU=; b=CbwMWPh5jXpAUgmEZqNliqCrs8vVZNEfgL
        hkOowVvxnBFUqHATMFOO2KTqFxA9iUG+6BMJBLgJrBIwrvj3oxWe+92R5ADXNdzx
        XhbDpsJAqY/Ie7m/1uGj3lzU0NidPTqtWQ6fsug+N2l3MYlkvvycnf43wFhKtsAW
        elgHsY5VraNByQJ54GVAFWJYR2U7D0VhgUE8SCoPOcVNeaPJ83JtY6AL4H8rZaVI
        gAqlD9eDumQEp3RlAOjKdZvLFdXzat0AZ9gDUsKkEMAi7tQEf7HGhsKupj8KnnbC
        nI4U1PZ4LZiPG6hnt2gi8oUfvxAgBq/N56+wyP3MJeRdo/wGB3TQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fIrXij0goZcO for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:40 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy672Wwz1Rvlx;
        Sat, 19 Feb 2022 19:18:38 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 18/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Sun, 20 Feb 2022 12:17:57 +0900
Message-Id: <20220220031810.738362-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The call to pm8001_ccb_task_free() at the end of
pm8001_mpi_task_abort_resp() already frees the ccb tag. So when the
device NCQ_ABORT_ALL_FLAG is set, the tag should not be freed again.
Also change the hardcoded 0xBFFFFFFF value to ~NCQ_ABORT_ALL_FLAG as it
ought to be.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index cfeefdf26f5d..be57b9ae5486 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3700,12 +3700,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_=
info *pm8001_ha, void *piomb)
 	mb();
=20
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &=3D 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &=3D ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
=20
 	return 0;
 }
--=20
2.34.1

