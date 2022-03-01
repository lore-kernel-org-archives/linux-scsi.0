Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00CDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 11:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiCALbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiCALa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 06:30:57 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02FD4617C
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646134217; x=1677670217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HQTJ3hFf5JF9NvHGCqug7VPmGgRxRZtmNGm+PZyOjyM=;
  b=RApAdM0ueDGrnCeX4aKCDWbmhiPJBpwJrGamUXCNQK0cWqm8h+owqJko
   eKXvrNTB0PayVON6G++emTBlJb9Rk4DcZ10pdXcUDHcgw/UrYpE5TeP33
   gKdqEDTaQwhdxR/F+lbn4wWvlXBM5PU4CujdTawas3tlODPk7hJcGpxgW
   mh9JCSM4h3VUpElItYCnYbi7GWmmBIpjQ/pjh8PLJSA2yA7JHHnyXr3ti
   3wa0nynC0PxjVdR9KjPzfWEpEYDrx83eqk7Mh/hg749leunDRQwoqlb5B
   CIBXTzIDNQefIWbmv+3uBb0op3H425/NQUCBXJmd942QVq1LVxS1fd/zJ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,145,1643644800"; 
   d="scan'208";a="195162732"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 19:30:16 +0800
IronPort-SDR: 0n0rPiefaEcvh8x3x3X1JY6tHXqw32usNgdEEEyUOKHZFeCuy2lSZVq+RxkygJgdbWM5FtCbzK
 A8i0keAanDOxfMbcFz2InfeENm+ETecyxXQzVi6erATmeReFF8veclwmRzmfWj2YFiuLXw62qb
 rY870fhY43GnEQsnPZoG81F1OfXsO+i38qp3XkLT+LBjJRfSCYwCjajnTh9eURLHl9hMHeprME
 kwzXImyvFh4RTPtPguOoCe1daQ9yRdy4pkcdpIhfjsSFVg/sSw18SSMwGAIQhwDDAo1wRgd2lV
 GzVwsGFWS4c483//IWgY31cB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:02:43 -0800
IronPort-SDR: TAxgC6ipGs+rUcM0fWLLmpZVzB4tZ/oHqohKaImvu4nvFnra2qcIfmFgcDrvvUYZkNCM57aLUo
 qHovw7qzL/YHQsH1y3ib+qdyU88F0nTwdwJoTW5Rc6oBT+FrNErqgv28xpKcjwKksXsrS0xbp3
 EQwQiOBeH7KV1VbrG63UZVy7Eq4EJrIHeWdXdkaGVHZCCeNlZ1sS4S11Msw9zWKFxMKcW9TLAd
 dmA9k2He9FqR9AyZJs95+3mnq11VsJrXfUvQSbJqQ6xg382VLRjvJxDGx3HTff2tfQswdEfa2m
 b5w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:30:16 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K7FRC3tDrz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:15 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646134215; x=1648726216; bh=HQTJ3hFf5JF9NvHGCq
        ug7VPmGgRxRZtmNGm+PZyOjyM=; b=ggIC6GRIzVvr5Oy82an5EGgtgniZ4bxSX1
        kRTVTDXYcptMtZO22LPJmr9li8ZBC3Se9bVUyQ3BdNO3K369KnA+GqASt9yDuxR/
        /Jgb3n3Io3666GCzFYf5ByhFMsyAwWgLrs18TpdBRfrHZl/jkW1asTJNTVKV/o+j
        l86EZJcHl+kqXAR2U8UUvu9MlS7jJ7tBuNhx6dWB/yfGsnnH99eFCvzk1fuoVHcH
        cD8eIhXfDiBpLtJBplkDabn+xEr+4R1vzmnlkRj2x5P+owEH+w4YgE1zIVsgj0CS
        JRRRfGKGJuTol0KwLDqpRCbaR5zoU7r0qReEztqYskak0ppEvVcQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wRAHQfWguUfd for <linux-scsi@vger.kernel.org>;
        Tue,  1 Mar 2022 03:30:15 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K7FRB4nqnz1Rvlx;
        Tue,  1 Mar 2022 03:30:14 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 2/2] scsi: scsi_debug: fix qc_lock use in sdebug_blk_mq_poll()
Date:   Tue,  1 Mar 2022 20:30:09 +0900
Message-Id: <20220301113009.595857-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
References: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The use of the locked boolean variable to control locking and unlocking
of the qc_lock spinlock of struct sdebug_queue confuses sparse, leading
to a warning about an unexpected unlock. Simplify the qc_lock lock/unlock
handling code of this function to avoid this warning by removing the
locked boolean variable. This change also fixes unlocked access to
the in_use_bm bitmap with the find_first_bit() function.

Fixes: b05d4e481eff ("scsi: scsi_debug: Refine sdebug_blk_mq_poll()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_debug.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f4e97f2224b2..25fa8e93f5a8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7509,7 +7509,6 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *sho=
st, unsigned int queue_num)
 {
 	bool first;
 	bool retiring =3D false;
-	bool locked =3D false;
 	int num_entries =3D 0;
 	unsigned int qc_idx =3D 0;
 	unsigned long iflags;
@@ -7525,11 +7524,9 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *sh=
ost, unsigned int queue_num)
 	if (qc_idx >=3D sdebug_max_queue)
 		return 0;
=20
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
+
 	for (first =3D true; first || qc_idx + 1 < sdebug_max_queue; )   {
-		if (!locked) {
-			spin_lock_irqsave(&sqp->qc_lock, iflags);
-			locked =3D true;
-		}
 		if (first) {
 			first =3D false;
 			if (!test_bit(qc_idx, sqp->in_use_bm))
@@ -7586,14 +7583,15 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *s=
host, unsigned int queue_num)
 		}
 		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-		locked =3D false;
 		scsi_done(scp); /* callback to mid level */
 		num_entries++;
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		if (find_first_bit(sqp->in_use_bm, sdebug_max_queue) >=3D sdebug_max_q=
ueue)
-			break;	/* if no more then exit without retaking spinlock */
+			break;
 	}
-	if (locked)
-		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+
+	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+
 	if (num_entries > 0)
 		atomic_add(num_entries, &sdeb_mq_poll_count);
 	return num_entries;
--=20
2.35.1

