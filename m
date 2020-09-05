Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F70C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DB12137B
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 06:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RYzUqtwJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgIEGP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 02:15:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41679 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEGP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 02:15:56 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200905061554epoutp02a391380d5ca969c55a53fc00ee5ba4d2~xzqXBascj2144921449epoutp02f
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 06:15:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200905061554epoutp02a391380d5ca969c55a53fc00ee5ba4d2~xzqXBascj2144921449epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599286554;
        bh=bY5HPZ6KUVgZQzbpmndQlSwrROu7+JPKJ7q2qrajB3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=RYzUqtwJEgb40LicuDBBjunlp1t2etOXS/5Aa0ZAfJ6fTEhIANyiXQfmLQ10NmEln
         VKNpoi58g+yF6h1q1StseR/LaN2gpMlvWed/t5VyQxEd+8oCu4br4KfTD9rbxceQYN
         AxZFsyWBxr/4wx1+gU/fZCAMuiIRnACmxI1qQD1c=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200905061552epcas2p2c9020c7caa7a4c755549b2410c178484~xzqVx2J0l1088310883epcas2p2q;
        Sat,  5 Sep 2020 06:15:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Bk46Z3mpGzMqYkV; Sat,  5 Sep
        2020 06:15:50 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.68.18874.61D235F5; Sat,  5 Sep 2020 15:15:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a~xzqTPOJLy1024910249epcas2p3b;
        Sat,  5 Sep 2020 06:15:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200905061549epsmtrp1b9d9dc11be9202deb75a8e3fac238e34~xzqTLmTYk1722117221epsmtrp1S;
        Sat,  5 Sep 2020 06:15:49 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-05-5f532d162295
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.EE.08303.51D235F5; Sat,  5 Sep 2020 15:15:49 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905061549epsmtip1ea7875d68d86142d54fa934adabdd9f7~xzqS9l43-1143111431epsmtip1P;
        Sat,  5 Sep 2020 06:15:49 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 1/2] ufs: introduce skipping manual flush for wb
Date:   Sat,  5 Sep 2020 15:06:51 +0900
Message-Id: <3cf3e93696510922b775d8887ca8408dd384648b.1599285983.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqa6YbnC8wf4p0hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIzHHy4wFVzkrfh+YxVLA+N27i5GTg4JAROJ85O2soHYQgI7GCWev87tYuQCsj8xSmyddIId
        wvkM5Nzdyw7TMfXVDVaIxC5GieY1BxkhnB+MEjP7XjGBVLEJaEo8vTmVCSQhIrCZSeLVgvvM
        IAlmAXWJXRNOgBUJCzhLLFxwDCzOIqAqMenNKrBDeAWiJT69XsgGsU5O4ua5TrAaTgFLiW+d
        q9lQ2VxANRM5JG6t3gM0lAPIcZFYPd0ToldY4tXxLVBnS0m87G+Dsusl9k1tYIXo7WGUeLrv
        HyNEwlhi1rN2RpA5zEAfrN+lDzFSWeLILRaI8/kkOg7/ZYcI80p0tAlBNCpL/Jo0GWqIpMTM
        m3egNnlIXP5+Fxo+QJuWrtrCOIFRfhbCggWMjKsYxVILinPTU4uNCoyQY28TIziRarntYJzy
        9oPeIUYmDsZDjBIczEoivB7nAuOFeFMSK6tSi/Lji0pzUosPMZoCw3Eis5Rocj4wleeVxBua
        GpmZGViaWpiaGVkoifPWK16IExJITyxJzU5NLUgtgulj4uCUamByeKIVs+h1m9s/hnnWfVry
        W5vm3+CevuHeAxbf/A8H2hv3z4lp+G3ws3yHEq+1aly7jVHDp3Mntf4enBl7+cNm/oAzxveD
        j5bOYtE+uV1SVeChzdkP+ak5TVaPluYveTLPauLitxIh1p6epVYzBRwE263YFOI40ytFll7e
        9TTIzb15z9siyw1b5O8kPnzt3SVhLn3Uyj9t6Wl9a+Ynr6yZSuoSGFuuO1bOMjfyjvloWcjm
        cdT76JYjrvPizikyTb53NOru5w8Hck/5m5cJPHBLl8z4KRxjkPErpz1q8pWCR5s75csm8WTs
        PaEzMXF9m79zScb+M++0Ww1vRjCFfVh8ZR9v7UI37S2xastMhZRYijMSDbWYi4oTAcwGrZYt
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnK6obnC8Qfs1PYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        issmJTUnsyy1SN8ugSvj8YcLTAUXeSu+31jF0sC4nbuLkZNDQsBEYuqrG6xdjFwcQgI7GCXu
        LJ7OCJGQlDix8zmULSxxv+UIVNE3RonjN5eCJdgENCWe3pzKBJIQETjMJPF/63N2kASzgLrE
        rgknmEBsYQFniYULjjGD2CwCqhKT3qxiA7F5BaIlPr1eyAaxQU7i5rlOsBpOAUuJb52rgeIc
        QNssJD4+UcUhPIFRYAEjwypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOA40NLawbhn
        1Qe9Q4xMHIyHGCU4mJVEeD3OBcYL8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6Yklq
        dmpqQWoRTJaJg1OqgWl7jWXnrATXDdzO1xpn7KhLa/cW1H5Q0XYtWPhOw1/DkhvOrw+vN/yq
        s06tKc5T5rSYekJUqm7GxducpZNst5m+8QltrFk59wTTma6NUTr3U54I/JlhnrVJnceNUUr7
        ycZaq+NLje/Ommd/8lTO5AkTgmx0PSp/9/ybdXhdZ/lWq2k1stVf3qn23r8yS3i17AHxZauV
        /Xil5O9zfP6reVNLzK22KbT0rJfTcYPixS4x6/kdDnUI3+i5xN/7X8DLeVpI5aqzkly3pXZl
        B3Gf4RUv+ynsm27HYvcw3Js73C1ubfYJJ0GpKhNv7rVn5TnvC4jwJyjfvqZRtob/WIYN/5I4
        neje90HaB6t6jRWVWIozEg21mIuKEwGJkWqb8gIAAA==
X-CMS-MailID: 20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a
References: <cover.1599285983.git.kwmad.kim@samsung.com>
        <CGME20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have two knobs to flush for write booster, i.e.
fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushDuringHibernate,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterBufferFlushEn
could lead to raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn
operations. For those case, this quirk will allow to avoid manual flush

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 64bd59c..54a2259 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5307,6 +5307,9 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
+	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
+		return;
+
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 02bd405..e99efee 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -531,6 +531,11 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to disable manual flush for write booster
+	 */
+	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,
 };
 
 enum ufshcd_caps {
-- 
2.7.4

