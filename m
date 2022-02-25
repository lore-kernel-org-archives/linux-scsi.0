Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1446BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 08:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiBYIqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 03:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbiBYIqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 03:46:04 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D398B2255A5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645778731; x=1677314731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oXZZ3axASldY6A7LvbkahaKZgUZG/u6jrhs8Lz4XcJs=;
  b=nyvHLwBG51GrvWYO184WLH0ytO9Yn78Y0OacbAJMJZhsfRdry3tHDUaM
   /u8srCJhaStD4Oi+KfgUDNQW2s0Jp6ZY0Qfd2MVDgeHNeG5ndi6958MFr
   qQsRbDo9ET7PjYa2jpiaVCPpKMi5qZ456nBNjYQesurGMeJuFdjv0d895
   3PU6zKEynipKSpGADEU8VIbnoNamfR1kSOUNmqzSXmgXcNf8/ieNFxuqf
   uuCUJClzegEFLWAAi3ersrtYTtB6g8/8sMih41HqQTJDncIZt72DhGo6h
   wElXRUSzgq+gQA7HdlXAesruBpjmWFVdsUM+lCv1DBCXVyTpVkbYArsh6
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,136,1643644800"; 
   d="scan'208";a="305831615"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 16:45:31 +0800
IronPort-SDR: 05tlH12erVnrRSO7uurTE75WNfUnopFLcmIfwSyYV/efU5QXO2eDpWaQ5C2GW9RzieCFmX2wIh
 vSFWQciASjQk4qItbUFAvS7vamKwf8oFR5gr9j2E9VqznTmzmm9tLTA0VmBw2kgIoHEqTWzOky
 tUhiMBX5S5RBvTgcargvJUmkXXdAb0z75UbEChcfbpjzLJT/JjODt4M6RQgoHfT2zsVmupgLAu
 i/t5MNbKTqRQI5EZqWoCApnLhAXoXwX2sPkXUYodPHPb87u+/k6fWBdaivrAiIe8Qy6pUsxsqo
 M/Xi+OPQFszo76tCCrv4FFsd
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:18:05 -0800
IronPort-SDR: nc7YEFhMZEXI/lpUP06Mxu+bW0FbhsUZpNSFK8kzkd93oURDZ3ipxpCC8DpwIL5d51wxFprEaa
 8tHC+Wjf/JlDFOhjjocrMdFaAhUZV87LcYvfavxC5bDOeg4WyTYZWsaPOgzssinHEc9Zmy4ei8
 qgAprd5R1IF0orrcIeYJ5EOM1kq2kmC9MjLF41KJSd2Jkn3d8aEMIfhLz00mwnsC4eKhIf8+s1
 RBbacmR8KnTlQR2jNiT3/0Ybm/6CT37/wRroYxjs3G8e+zK4lBzosLMwRZG63TBFp5Tm39pt12
 Njw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:45:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4jyz1WjDz1Rwrw
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645778730; x=1648370731; bh=oXZZ3axASldY6A7Lvb
        kahaKZgUZG/u6jrhs8Lz4XcJs=; b=s0I8imI+MOL1+eEPZNcyAILm+xSOeJ80Al
        kSkfvsf7vS9kjDVAM2SJ+umi+cXkzgQQY5oJgMbF/MvNy3CrJ9pDP7CWcTGHXOyY
        1hRwgmW15E42QznYTHQOMH+RKT4EdlZqoH8pOs/IfrGULsWnETPrHuFWo8JFVPgb
        TSioPJZc+8fJn89XE5KUot5FIrU/VkLw6WbHEpLMAXxsmA/PmqCw/j1Wq88645Xf
        1ZMmcKpR7gcXUFwGOVN7t7bp0pkZAMri5A0ek2WyvmehEF34zDDH0WoAZBGBBI70
        4oBdQNqJMGjOdQ2XMLbRHAcaJNUQ/EXAyztI3cg2xuDGC4TLM2IA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nzfLmDCTmw4O for <linux-scsi@vger.kernel.org>;
        Fri, 25 Feb 2022 00:45:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4jyy2MKcz1Rvlx;
        Fri, 25 Feb 2022 00:45:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 2/2] scsi: scsi_debug: fix sparse lock warnings in sdebug_blk_mq_poll()
Date:   Fri, 25 Feb 2022 17:45:27 +0900
Message-Id: <20220225084527.523038-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
References: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The use of the locked boolean variable to control locking and unlocking
of the qc_lock of struct sdebug_queue confuses sparse, leading to a
warning about an unexpected unlock. Simplify the qc_lock lock/unlock
handling code of this function to avoid this warning by removing the
locked boolean variable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_debug.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f4e97f2224b2..acb32f3e38eb 100644
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
@@ -7525,18 +7524,17 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *s=
host, unsigned int queue_num)
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
 				continue;
-		} else {
-			qc_idx =3D find_next_bit(sqp->in_use_bm, sdebug_max_queue, qc_idx + 1=
);
 		}
+
+		qc_idx =3D find_next_bit(sqp->in_use_bm, sdebug_max_queue,
+				       qc_idx + 1);
 		if (qc_idx >=3D sdebug_max_queue)
 			break;
=20
@@ -7586,14 +7584,15 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *s=
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
 			break;	/* if no more then exit without retaking spinlock */
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

