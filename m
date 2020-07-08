Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305F0C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B62E20774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Wjv2BPl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgGHCcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:32:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16348 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgGHCcC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:32:02 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200708023158epoutp0399f168c071cc761a82257b5d3567601c~fpi-35Po91210712107epoutp03X
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 02:31:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200708023158epoutp0399f168c071cc761a82257b5d3567601c~fpi-35Po91210712107epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594175518;
        bh=riS21KbjlfpteIdZH0R/LAgbQCa5vxQyYRDqz1ap0RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Wjv2BPl8gnKu3aea5fDrOnimd17vnLXLN/up9KcEZLTIuup0jrcj84s+Mdhb0RT6+
         4DTvPloNhlDxeKlhvfPnpLroVcpWY7v6RvdUHHPBAmC0zU7RHib4rQIf2ht1z4h3Kv
         r0VHqi6JWvSrgfAy80br8dxOs2dLW5AdC1kl6cbc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200708023157epcas2p3d71c2d210d3bcce78a64246bc3b6f974~fpi-XSMP73009030090epcas2p3m;
        Wed,  8 Jul 2020 02:31:57 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B1jxR3TvwzMqYlx; Wed,  8 Jul
        2020 02:31:55 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.ED.27441.B10350F5; Wed,  8 Jul 2020 11:31:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612~fpi9EjT3-0881908819epcas2p3j;
        Wed,  8 Jul 2020 02:31:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708023155epsmtrp265733bac2f81dcc47416c494c954ce0e~fpi9Ds2XG2368623686epsmtrp2u;
        Wed,  8 Jul 2020 02:31:55 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-16-5f05301bfb3d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.82.08303.A10350F5; Wed,  8 Jul 2020 11:31:54 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200708023154epsmtip2c78f5ee2f7883a409bd2120932074008~fpi80-WSR0606906069epsmtip2O;
        Wed,  8 Jul 2020 02:31:54 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND RFC PATCH v4 1/3] ufs: introduce a callback to get info of
 command completion
Date:   Wed,  8 Jul 2020 11:23:59 +0900
Message-Id: <89b90646c310fb0048701f219eb23c4b35ef7dcf.1594174981.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmqa60AWu8wellohYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIxJ3TEFf4Qqpra/ZmxgvMjfxcjJISFgIrGu5Rh7FyMXh5DADkaJ39famCCcT4wSU1+2sYBU
        CQl8ZpR49cEKpuPM0S9QRbsYJf4t3s8G4fxglNhyYhc7SBWbgKbE05tTwapEBDYzSbxacJ8Z
        JMEsoC6xa8IJJhBbWCBB4viih2ANLAKqEpseH2MEsXkFoiUuH9jCArFOTuLmuU6wXk4BS4mX
        P7rY0dkSAlM5JJY8ioOwXSQuXuhmhLCFJV4d3wJVIyXx+d1eNgi7XmLf1AZWkOMkBHoYJZ7u
        +wfVYCwx61k7kM0BdKimxPpd+iCmhICyxJFbLBDn80l0HP7LDhHmlehoE4JoVJb4NWky1BBJ
        iZk370CVeEjc36gICR6gRT/XNbFMYJSfhTB/ASPjKkax1ILi3PTUYqMCY+S428QITqJa7jsY
        Z7z9oHeIkYmD8RCjBAezkgivgSJrvBBvSmJlVWpRfnxRaU5q8SFGU2AwTmSWEk3OB6bxvJJ4
        Q1MjMzMDS1MLUzMjCyVx3mKrC3FCAumJJanZqakFqUUwfUwcnFINTB1f67ffmxIYm7yc4Vrx
        5kv3otY/527adGvW3VQWl7uM/VuVOdaf+2GfKPKx92Dviz8h6yVl9bleLdimpXH69Czxz+85
        zY//WJFkZ6i2bkth4Y6/cZeu/gtcGuE10ea285EpMpz1c4vqmjPfz58T9Dt0jfjLnCM6eo1v
        Ji3jOM01/dRJ+93LP8YqR/e4b2cTcQ50E2HReLz1+sxfRutOX87+Lmb5nld989S70TmpB6du
        2XymbV3Xf+eibS/36/73eX7JRf3lnM83j71lm6v41e/z1eN/jOa16t3ufeZgt1XdQHbP8913
        67P/pb3iOjrnC3uTXcicH5PsyveF7/Hknl5oHCzE82ad41bFBfsEL+SsUmIpzkg01GIuKk4E
        AMJQnc4rBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK6UAWu8wcQWC4sH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        issmJTUnsyy1SN8ugStjUndMwR+hiqntrxkbGC/ydzFyckgImEicOfqFqYuRi0NIYAejxLmO
        9SwQCUmJEzufM0LYwhL3W46wQhR9Y5Ro+vucGSTBJqAp8fTmVLBuEYHDTBL/tz5nB0kwC6hL
        7JpwggnEFhaIk9j55RAbiM0ioCqx6fExsKm8AtESlw9sgdomJ3HzXCfYUE4BS4mXP7rA5ggJ
        WEjc29/PhEt8AqPAAkaGVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwZGgpbWDcc+q
        D3qHGJk4GA8xSnAwK4nwGiiyxgvxpiRWVqUW5ccXleakFh9ilOZgURLn/TprYZyQQHpiSWp2
        ampBahFMlomDU6qByWpO6pGT02TCum9sSzLNfDc1gze8aMXiVK4le35sT09u3sBrdtE6Y7Zy
        t0nLvrW3X6r7rrkTt3C38T7Z/nKf5Ld9AtGTlnmkzbhzZ+HGR4fuHF5y4cblR2XvTURfiB1e
        a8+2rnt7eXNcftvrWR9UXs7Yl/IhiVcgWW7Ot8eTFA7oPTywdW+Nkn3JRCU16y87ZBxZFjxM
        TVOz9am7UTbj1d+2zOXzf1ky8c//uat4H4Os5qynBxZ92pfLcZ4/Ply92W975r5a/+0TKySZ
        +R7Vbvvy+kLYr0SLsivZCnySzev+LEufxpygm3Y4+A6L1ePQvz9evlvhrV4gVSJydWPkCc9X
        AZuCA56a9ymt2MF6/Y8SS3FGoqEWc1FxIgDYPEse8wIAAA==
X-CMS-MailID: 20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Acked-By: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..3326236 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4882,6 +4882,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
@@ -4890,6 +4891,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
+
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..e5353d6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -294,6 +294,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1070,6 +1071,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
2.7.4

