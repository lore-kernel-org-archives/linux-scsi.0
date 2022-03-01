Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59F1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 11:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiCALa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiCALa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 06:30:56 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA9546652
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646134216; x=1677670216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VtTuSOPkcV5UWYKU8irJVaL8BUf1V1/zpRv7QYQhw40=;
  b=io1rHvtxz7ILFi9NwRbSU0xN5CjKUuGKmzybL0hcDTIK9KQrfknZ6zOc
   xJsBcVAZvuhDU+VM7HpUq+iMYewzOBZhSPXZ/N136EKPVk/B7XOUaBikn
   kzeqIIwoVwzzC2Iq5d9wgDmEVnw/jqPn0wHnZXXQpptxYuxT+0syHljSD
   upoqdf30aWsxtKh/cRBXxPKgRtTbDdS4GnaPtPsmBQmp9EtZpCU7iiuSO
   7+xVLNmWK3MyEDpzFVDXEtmArGYGBsLR/rrKz/erUst+7G0hgSpib3IqV
   OEgCXwf+Pq6SDZMAz25bHcohTq/G0BLMvIuGJaVl1chIFY9LWDK7PbIkJ
   g==;
X-IronPort-AV: E=Sophos;i="5.90,145,1643644800"; 
   d="scan'208";a="195162728"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 19:30:15 +0800
IronPort-SDR: DRbGksK7NZdXd+2ttLiU/XSEA3Nralizgr70egSWiTfyadY4VaQBrJSHPlpwib/q7O+grcIs/l
 OotUhZqbvSnSPKxSl+JSpcti5m8skvAwWdthaewvzS5j+/Og5aglXC5Lof/IjGoz+Zwe6HTbZu
 qzEAyhGVGo0rLRZeW5cJyS2yk54UDmFUPrswpKUQiqDQ4WU0YG16vE6shQWbLDwUYX7uq7Hl10
 ou7KyvkpetNzremu5iW/vRtTarORetAHX7j7tij2nB2MnYRNo4udM41CwcB/mp6iGHyFtTv7a0
 MlMNaHtJiKjfsKCHqdt5TR/c
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:02:42 -0800
IronPort-SDR: AzCfl2bCSSJj2/t2lRRz5doALSR6cKB3ImtXcTuY8+1ape1dEEzIypn5ElvAmPkbSYEYfC+74M
 qU4BJTqy1HovRsnECqmGfyIngRrtSXHeOUf2jStnYQXC3bTT7psA3JjNEFvOgILOONhwuwTgMk
 Lc3GvvwFxh6JZtr1BPq4cLmqZ99mR+FqQKc4J+81wMOgf/tbo3SMY7x/9YRRfkzQsYd7gLwKH7
 jebMRBcjlHzTV8SJjZBHWmQZkMjqYN4PthwhxUdO0rHPQXC2pPgWdVjQvsc+YiAb1R60ApLb2M
 YX4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:30:15 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K7FRB5Yr8z1SVnx
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:14 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646134214; x=1648726215; bh=VtTuSOPkcV5UWYKU8i
        rJVaL8BUf1V1/zpRv7QYQhw40=; b=PwUURhTs+mad2nsn405f4e7TerkA4SCJbT
        5YGbI7O/INnrCJ6w4IL7GFUTlMi4YnF1/7qUO+gTxcHiJxCioYwCVwh423knHVv1
        tQerfPMx69HfeSBXsKXMkdfJeTazLUNoafhDeHWmzhxn2Qjmo1NtpZy74/I34sl+
        mC2rtdDbqxshzo+erM/Ogjl2xLBH+jmDkmUVKS/okh7jy1XSQQmjcjUJL4aDVsKh
        6m6alWPPysIbN81gXji+m9qrUGZWB0VmfCxY8cj8G41vMwF1ZT+UIZ3SYVDjSq+G
        FEJYhJ2hmOUbuUnukJI0hMBaRVaRy3qJvaTzuG13nN369GV6YCZg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0E9nKTtqgh28 for <linux-scsi@vger.kernel.org>;
        Tue,  1 Mar 2022 03:30:14 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K7FR965HTz1Rwrw;
        Tue,  1 Mar 2022 03:30:13 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 1/2] scsi: scsi_debug: silence sparse unexpected unlock warnings
Date:   Tue,  1 Mar 2022 20:30:08 +0900
Message-Id: <20220301113009.595857-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
References: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
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
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
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

