Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE61BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 04:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377227AbiDDE5r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 00:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377210AbiDDE5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 00:57:46 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50DB27CC6
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 21:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649048150; x=1680584150;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kVSuz160RwiOCUvZluXAysTBvef/HGRUbN3g2/hO3Mo=;
  b=kuF+FmNxzNQLqVAZ4UChgvul7EKMzXuyU9+rhFYz69UPzGLobvMcueqS
   wT3D5o8kkOvcqRR4PWav7yl9mRfEDfoFsKI2tpFvF7dqdw0nGBymFrbIe
   bi1XjQenWwnJ14GhnyMvC1NjleeBUEMpMYRKgi/Oy3I7oyiaRzJDxqNOK
   yOg0/MOkTLHEv2am61Pi5i2DclK65ceD6D64QC7k5NLFoNYOjs2wlrGgN
   4BT3FQYmPrXOg5RGSD+IxRMUpYRagJbBpPENxf/XMZXKhEPcU4M/Ukkvq
   RCiosVLHBRW7Pn9amfhvS+DqBafi8BZMEXPp7MH+LIpUy3ImCFpvo3WQo
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,233,1643644800"; 
   d="scan'208";a="201848802"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Apr 2022 12:55:49 +0800
IronPort-SDR: l/JwefS3cT8Nvs8vHcwmseOd+DmKM8pTH+7ivrBfh9oTO4pT55WfXXj+NmrO9jzNfgNYY69wdJ
 F3NbqD0XhQmZbuSMfULId3ZyCMDn/DBBOhQ6ohAsFMllsvBSqbXHyMQ+mXpK7du7FGqarltP2U
 ilCBIpWz7iI1AkBpnoGXG0YUBEkDAINvGbJVaGEL+hPDRUoQdgZBofBYPZZoBPZYUFf2P/y/6w
 AWGiV4tRoXDtghdh2zX8XS4O62P2ASgMdfEjLwLJAru8fIqu6S3BSmh7k1BiKp0FYkIIFCflKR
 fLj2rgTVBQeI5MjdCUo53A4n
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 21:26:34 -0700
IronPort-SDR: F4W6euNER1n5ewXoIBRWKzMCAGeMaSHbPDUCGPXyxggZIbnBPLWGJ6qoiwM6ORDDaNnE4+KNJF
 TelA2U11NVll/mIWTuwo4cOwlA5OwQOCzjOdPGdBdNM1CbxAZRahptw6LOdyNFx8ru7zDMaTI1
 XazgHyU0kkXVxIplVL2I3EdZ7mEGkkZH6PHpJb4A95gxGHBPoihclFrUNeoVlM6VRY0nXomsgr
 JYS8k1HbX1APIgpEQ4Bm0dkfF+QjH410xDApNXC3kX3Jw5FMIBSuVS94YbP2HTBvXnUad8ZVYR
 k+E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 21:55:51 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KWz4P4SG6z1SHwl
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 21:55:49 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1649048149;
         x=1651640150; bh=kVSuz160RwiOCUvZluXAysTBvef/HGRUbN3g2/hO3Mo=; b=
        FkwtglIpAh6p7aKljaW8gZC6Yk4Bv/STzIzpzkXpXsXT/Z7eziWw7k1ZScwrbiTe
        SXTCaWutbpKwOYluZ3w6LuyhoW3QWNr5nCKOB/KAlB0c6mmDlpiQtQeWp8EQQeII
        ECgxJ+w9Ssd+iEgeIsoDWL0+pPyKOyoZ7Q/FYmPVfIvEwiUt3oCYGPXhZp83ydkK
        iVrHQq4jWUFuwdA4qkzuMoApHXGNF5geVxh4CtqA1NhvdXZoIMUcAHkOa6GvzrEK
        ygVrdALwm5es8YWheuS64l+179nPfzFwl7Pw8NpF1SUtFD9eWtaxMjzkinX7Tvsz
        hwbWWhdgKhAj1C8DmLyVEQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0S7qSG4EsQNv for <linux-scsi@vger.kernel.org>;
        Sun,  3 Apr 2022 21:55:49 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KWz4N54khz1Rvlx;
        Sun,  3 Apr 2022 21:55:48 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi: scsi_debug: Fix sdebug_blk_mq_poll() in_use_bm bitmap use
Date:   Mon,  4 Apr 2022 13:55:47 +0900
Message-Id: <20220404045547.579887-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The in_use_bm bitmap of struct sdebug_queue should be accessed under
protection of the qc_lock spinlock. Make sure that this lock is taken
before calling find_first_bit() at the beginning of the function
sdebug_blk_mq_poll().

Fixes: 3fd07aecb750 ("scsi: scsi_debug: Fix qc_lock use in sdebug_blk_mq_=
poll()")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_debug.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c607755cce00..ff78ef702f22 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7519,12 +7519,13 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *s=
host, unsigned int queue_num)
 	struct sdebug_defer *sd_dp;
=20
 	sqp =3D sdebug_q_arr + queue_num;
-	qc_idx =3D find_first_bit(sqp->in_use_bm, sdebug_max_queue);
-	if (qc_idx >=3D sdebug_max_queue)
-		return 0;
=20
 	spin_lock_irqsave(&sqp->qc_lock, iflags);
=20
+	qc_idx =3D find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+	if (qc_idx >=3D sdebug_max_queue)
+		goto unlock;
+
 	for (first =3D true; first || qc_idx + 1 < sdebug_max_queue; )   {
 		if (first) {
 			first =3D false;
@@ -7589,6 +7590,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *sho=
st, unsigned int queue_num)
 			break;
 	}
=20
+unlock:
 	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
=20
 	if (num_entries > 0)
--=20
2.35.1

