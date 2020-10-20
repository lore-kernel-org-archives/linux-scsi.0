Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A920C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE162240A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="stwK0Ovi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404795AbgJTHFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:05:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52173 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404741AbgJTHF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 03:05:28 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201020070525epoutp02b47d2d4979be0d5b4a313c6df6d5b99f~-oXcjpk6u2907029070epoutp02L
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 07:05:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201020070525epoutp02b47d2d4979be0d5b4a313c6df6d5b99f~-oXcjpk6u2907029070epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603177525;
        bh=lz40hHps79hqNfcnD+cI3oHpIVLgeD6CDqiBeBo/A8M=;
        h=From:To:Cc:Subject:Date:References:From;
        b=stwK0OviaweTFSwolWPfyyffNR3bnL648FfkGNSaVmudvE6NNA+7zYQNO+Qlk6Hi0
         0rnLAdMhoLqd0CGUClyPyAxwH2IY8zc+8dqIcIaq2ern5GKRAgwdsAZ27YITOMT6ka
         m0WrLdgRJd8wPeU2eVbqZlmlVSG+UjnCDpYnkiWk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201020070525epcas2p49eb6cc2621c08aa65df0b14235df06b4~-oXcOPvH21677716777epcas2p4r;
        Tue, 20 Oct 2020 07:05:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CFl4y4DSdzMqYkr; Tue, 20 Oct
        2020 07:05:22 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.9A.09588.13C8E8F5; Tue, 20 Oct 2020 16:05:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d~-oXXbkF4G0868808688epcas2p2C;
        Tue, 20 Oct 2020 07:05:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201020070519epsmtrp11d1d02b0f52fdcfb924fba2933fc18a2~-oXXape6_1391713917epsmtrp1g;
        Tue, 20 Oct 2020 07:05:19 +0000 (GMT)
X-AuditID: b6c32a45-36bff70000002574-c7-5f8e8c311e37
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.32.08745.F2C8E8F5; Tue, 20 Oct 2020 16:05:19 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201020070519epsmtip161a3e009d658aad5260cf63c88ae6d7f~-oXXNZSlV2165121651epsmtip1n;
        Tue, 20 Oct 2020 07:05:19 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Date:   Tue, 20 Oct 2020 16:05:16 +0900
Message-Id: <20201020070516.129273-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmqa5RT1+8wbsrTBYP5m1js3j58yqb
        xeX92haLbmxjsri8aw6bRff1HWwWy4//Y3Jg95iw6ACjx8ent1g8+rasYvT4vEnOo/1AN1MA
        a1SOTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
        ZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DK
        hJyMD2++sBdcFqyY+PUOYwPjXr4uRk4OCQETiaNPFrF3MXJxCAnsYJTY8vMmK4TziVHi2eqX
        rCBVQgKfGSX2X2OG6Xjx7iFUxy5GiY2n2xghnI+MEgs+trCBVLEJ6Epsef4KKMHBISJgJHFt
        lSdIDbPAdEaJgys/gtUIC7hJ7Nx/DmwDi4CqxNHHC8HqeQXsJV42eEEsk5d42rscbDGvgKDE
        yZlPWEBsZqB489bZzCAzJQTOsUvce93JBtHgInH7Qj/UpcISr45vYYewpSRe9rdB2fUSKx41
        QTX3MEq8nPYPqsFeYubTpUwgRzALaEqs36UPYkoIKEscuQW1l0+i4/Bfdogwr0RHmxBEo7rE
        ge3TWSBsWYnuOZ9ZIWwPidX7TjJBwjBWYsWq6cwTGOVnIflmFpJvZiHsXcDIvIpRLLWgODc9
        tdiowBA5TjcxghOilusOxslvP+gdYmTiYDzEKMHBrCTCO4G1L16INyWxsiq1KD++qDQntfgQ
        oykweCcyS4km5wNTcl5JvKGpkZmZgaWphamZkYWSOK+KXke8kEB6YklqdmpqQWoRTB8TB6dU
        A1OZ4Bzfd3erpl85Nflf3iPJmNCDx5/dPrhXsdDq9MSGIC5dbYlTTzoft8b5F/ouXHZ5cesH
        8TPTuL5w+fzZsar8y/9Lb4vUH03+mVjU1sz5ttivQMdGNsfmTqNai8/3qp6z/kYpp0R+qS02
        WRbb++TWq+OPTlVuO33LhT8sTS6p4YTsP36mJht2/4XVbYvvM1l0u3Zr3FW7KXO0RXGzZ8Sq
        IkUJB3aezSz73cTNA2+Y/Dwr1ffQeheTraJj3WnBJLYJ3Rt5rffumejkcvYhD9ui3Rf2vvp2
        UNdlB0fmMf5rJh2HihZUmi0ITQvceMh1Td2NUx6qk8VtGYtPT6zS6np7LvjirTkKGeqzMnzF
        q5RYijMSDbWYi4oTAeAcpcIRBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSnK5+T1+8wdPjhhYP5m1js3j58yqb
        xeX92haLbmxjsri8aw6bRff1HWwWy4//Y3Jg95iw6ACjx8ent1g8+rasYvT4vEnOo/1AN1MA
        axSXTUpqTmZZapG+XQJXxoc3X9gLLgtWTPx6h7GBcS9fFyMnh4SAicSLdw/Zuxi5OIQEdjBK
        HHy8hhUiISvx7N0OdghbWOJ+yxGwuJDAe0aJd3dFQWw2AV2JLc9fMYLYIkCDZtx6xwoyiFlg
        NqPEnuOLwRLCAm4SO/efA2tmEVCVOPp4IVCcg4NXwF7iZYMXxHx5iae9y5lBbF4BQYmTM5+w
        gNjMQPHmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCI
        amntYNyz6oPeIUYmDsZDjBIczEoivBNY++KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBO
        SCA9sSQ1OzW1ILUIJsvEwSnVwNSo1MhqULM3SeishajfqX0Nr6/cq/bjDirhP9z8aOvh+QzH
        r10sbzhaErheM+0Yv42L1S+f1z38xpujjT5MVuKXFb2SzX5D3izzSOwjpYR9tsnvKxsFrb9w
        O08OvaZe/H9e/cfX6v8dVNlU0hkm+hwobxQW3fRTag2z/4RQvQI+nXsx3W5LphWyqDxXbzzZ
        udl07ocN1ddZbmhKXL5elC34UPXMh/MuEVpF00q9Xoe9DTK5p9q1imcWd7+Njvr3yTN1t1zZ
        vaDr1Jcraru7+T2T+bne8lf5HFrYuHH9wx3b5utuW1cdMInZji/CTCph5pEtW1q4Z2+ecOXu
        rSz3p+37JORuWwWvvvqz/U3/ESWW4oxEQy3mouJEAACj59XAAgAA
X-CMS-MailID: 20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By doing scan as asynchronous way, scsi device scannning can be out of
order execution. It is no problem if there is a ufs host but the scsi
device name of each host can be changed according to the scan sequences.

Ideal Case) host0 scan first
host0 will be started from /dev/sda
 -> /dev/sdb (BootLUN0 of host0)
 -> /dev/sdc (BootLUN1 of host1)
host1 will be started from /dev/sdd

This might be an ideal case and we can easily find the host device by
this mappinng.

However, Abnormal Case) host1 scan first,
host1 will be started from /dev/sda and host0 will be followed later.

To make sure the scan sequences according to the host, we can use a
bitmap which hosts are scanned and wait until previous hosts are
finished to scan.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..1ced5996e988 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -13,6 +13,7 @@
 #include <linux/devfreq.h>
 #include <linux/nls.h>
 #include <linux/of.h>
+#include <linux/bitmap.h>
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
@@ -214,6 +215,10 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+/* Ordered scan host */
+static unsigned long scanned_hosts = 0;
+static wait_queue_head_t scan_wq = __WAIT_QUEUE_HEAD_INITIALIZER(scan_wq);
+
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -7709,8 +7714,13 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
-	/* Probe and add UFS logical units  */
+	/* Probe and add UFS logical units. Sequential scan by host_no */
+	wait_event(scan_wq,
+		   find_first_zero_bit(&scanned_hosts, hba->host->max_id) ==
+		   hba->host->host_no);
 	ret = ufshcd_add_lus(hba);
+	set_bit(hba->host->host_no, &scanned_hosts);
+	wake_up(&scan_wq);
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
-- 
2.28.0

