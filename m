Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00432C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 08:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiBYIqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 03:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbiBYIqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 03:46:02 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427AA22323A
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645778731; x=1677314731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3BXTpLwW6enbyI6SqOzI53k+uPSfm0gdABqmZpONjuw=;
  b=KQ0S2Ylq6LfJDcZf58MICQWB/Zdg82izB1PQW9axSktzl4HBGeAS2YsS
   S2DHVMY8K5ifXwurrTogtwQ2NaDRdndAOm8c6zC8Xd3Swr2TC2ZFZgwmA
   5p5SRyFehnb3fZ0e5hciWO6OVz5OqD3NslOIF0klG2TmMDxtShiTsB2v5
   B9doLaWhlQAp09FfXCP29ml1WVDEFj+OjYAtWdVfz5r3mhflTdcj4GXkJ
   3oxYP7VzHejvH5JfoXuL4CJLCd7k1pd6S8lwYBwh82QXqOkVpK9j0G1l+
   LaBVCVqLZza6LmKCzz3mWk9bNr1yFnMnwNWoZ0XZMiXCJld6JLHiNbDZf
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,136,1643644800"; 
   d="scan'208";a="305831613"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 16:45:30 +0800
IronPort-SDR: dX5YZkTkYfnEYmN27FWT6guS50rk6mhzf5ktF2nQqUqOZvqll9flyA2jAYV8DZPOeCGWLanr0A
 k70iVYgZES7SdFPAi646c7WfKlTcZih0sts6UI24uepUIkBD14iKdLSHbofCBFWumxGh+uUSgo
 KP/tRo2PFFxJHKXEtJH6yYaIkyHqquPVJ9bUN48jLoXCKsm6wlYi2nczMxlPDwJDjqo/GTW7Tl
 KV0Nz3ZGlzEgrMaL3fs7OzZN3GGfcfWdR5BnnSgPegtC7mRxCMCaVLRJlhVewAk8/6AMHW4B7Q
 /Vfmqdw3vvAD6Ox8qZcNBBjx
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:18:05 -0800
IronPort-SDR: f3AJOQ1xHCz16nT2PZFq5KHvQFa8GZcUdlT1I15Q2VjtcbK41s1bBxQWIbfThIrVMfw8DQmNWO
 XTiWQGZCIRX8XezyEUtl7vKeHzjtzxQZ4J14KUWhHx2ixrbMIXizGTSJa559hthyc1cKxyaocX
 s2a76SKNpLvl/z74dDA5od/mtXMXVSP2rBqEO0qzpwEwkllhSQha4/upNRelLDTH9I8QvmGElg
 QANi7rPm/90tJXob9QAtgXy29ykQ7TX2idq5S8MJKG4DBDE8a1I3WKQKENdifAYOqja0Gu5/5G
 kX4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:45:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4jyy3Hvjz1SVny
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645778730; x=1648370731; bh=3BXTpLwW6enbyI6SqO
        zI53k+uPSfm0gdABqmZpONjuw=; b=l9eT5Llfz62ykr/SZKmU2PbEMlonkyXdCF
        D5L/XOtfeL9LG+3t+uP5EPqYpr7ghwZ8bUwwnE9Xy3XX5SCmA+mj98xeoIC20ewq
        YMcOyR6UbBdFP+ude5BLrg13qTk4W0AI+5MuXPl3qcxBhH7z3BDbpCrrKkpRZqpz
        ulU/lcBmymdqxiEmof+cGT/oMol9yAj/haaf/V7TJI4nBiGQP3DYPwBSR8eKKAFQ
        bgzQhijrzEF1/4H7wP0apctZH1h1E/zLDFVtYWHVVdcNz5f8+9QL7ygNCJl/c/qE
        D+bYEgXdV/AJ1UIZGUboW+dfqrxfAOmh4v34YQChJ9iY1Z2JSqqg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mb14ioM0eeM6 for <linux-scsi@vger.kernel.org>;
        Fri, 25 Feb 2022 00:45:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4jyx3dWYz1Rwrw;
        Fri, 25 Feb 2022 00:45:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 1/2] scsi: scsi_debug: silence sparse unexpected unlock warnings
Date:   Fri, 25 Feb 2022 17:45:26 +0900
Message-Id: <20220225084527.523038-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
References: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The return statement inside the sdeb_read_lock(), sdeb_read_unlock(),
sdeb_write_lock() and sdeb_write_unlock() confuse sparse, leading to
many warnings about unexpected unlocks in the resp_xxx() functions.

Modify the lock/unlock functions using the __acquire() and __release()
inline annotations for the sdebug_no_rwlock =3D=3D true case to avoid the=
se
warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_debug.c | 68 +++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0d25b30922ef..f4e97f2224b2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3167,45 +3167,65 @@ static int prot_verify_read(struct scsi_cmnd *scp=
, sector_t start_sec,
 static inline void
 sdeb_read_lock(struct sdeb_store_info *sip)
 {
-	if (sdebug_no_rwlock)
-		return;
-	if (sip)
-		read_lock(&sip->macc_lck);
-	else
-		read_lock(&sdeb_fake_rw_lck);
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__acquire(&sip->macc_lck);
+		else
+			__acquire(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			read_lock(&sip->macc_lck);
+		else
+			read_lock(&sdeb_fake_rw_lck);
+	}
 }
=20
 static inline void
 sdeb_read_unlock(struct sdeb_store_info *sip)
 {
-	if (sdebug_no_rwlock)
-		return;
-	if (sip)
-		read_unlock(&sip->macc_lck);
-	else
-		read_unlock(&sdeb_fake_rw_lck);
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__release(&sip->macc_lck);
+		else
+			__release(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			read_unlock(&sip->macc_lck);
+		else
+			read_unlock(&sdeb_fake_rw_lck);
+	}
 }
=20
 static inline void
 sdeb_write_lock(struct sdeb_store_info *sip)
 {
-	if (sdebug_no_rwlock)
-		return;
-	if (sip)
-		write_lock(&sip->macc_lck);
-	else
-		write_lock(&sdeb_fake_rw_lck);
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__acquire(&sip->macc_lck);
+		else
+			__acquire(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			write_lock(&sip->macc_lck);
+		else
+			write_lock(&sdeb_fake_rw_lck);
+	}
 }
=20
 static inline void
 sdeb_write_unlock(struct sdeb_store_info *sip)
 {
-	if (sdebug_no_rwlock)
-		return;
-	if (sip)
-		write_unlock(&sip->macc_lck);
-	else
-		write_unlock(&sdeb_fake_rw_lck);
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__release(&sip->macc_lck);
+		else
+			__release(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			write_unlock(&sip->macc_lck);
+		else
+			write_unlock(&sdeb_fake_rw_lck);
+	}
 }
=20
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *=
devip)
--=20
2.35.1

