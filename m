Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4220EC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F423122C7C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgLUBgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:36:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22069 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgLUBgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:36:19 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201221013537epoutp02be70fa6cf720416ee367ebbaef4031f1~Sl3Mw7szi0698206982epoutp02C
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201221013537epoutp02be70fa6cf720416ee367ebbaef4031f1~Sl3Mw7szi0698206982epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608514537;
        bh=oAZkt8d/EzEdD6gm9i+kuwRAAhZpY0ps41OxDiNtdgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=sOFCK3RToZZhp3uFP7dIHmXvL4lqw/OEXA7IHGndpN6027HJgxKLLrFyDNWYSVV0x
         p3VuhLVoXzrbzWvoVdNCk2iuuJh0nIUi80z73Z+PzYKWlLUQcv+HU6LLq/Rq7quGGP
         l9wsHYSmOhybapKJhhnELohSZCOSKtQDy8v8SXO0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201221013536epcas2p47a179a3dc850681aecfa5eed6ca59941~Sl3L3GXxa0233802338epcas2p4v;
        Mon, 21 Dec 2020 01:35:36 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Czhqp6rDvz4x9Q3; Mon, 21 Dec
        2020 01:35:34 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.26.05262.6EBFFDF5; Mon, 21 Dec 2020 10:35:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201221013533epcas2p39a17300dc5e1659acdea849bea1322e0~Sl3JAviWb1421414214epcas2p3O;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201221013533epsmtrp1de168209ba526e26603102a067c5d994~Sl3I-vkVn0617006170epsmtrp1e;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-33-5fdffbe6c801
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.43.08745.5EBFFDF5; Mon, 21 Dec 2020 10:35:33 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013533epsmtip2be4e7d9b835a19b2bb81e197d2d97c74~Sl3IzDaNO2619126191epsmtip2I;
        Mon, 21 Dec 2020 01:35:33 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 2/2] ufs: ufs-exynos: apply vendor specifics for three
 timeouts
Date:   Mon, 21 Dec 2020 10:24:41 +0900
Message-Id: <a0ff44f665a4f31d2f945fd71de03571204c576c.1608513782.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmqe6z3/fjDfY/FLN4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
        A3S8kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDA
        wMgUqDIhJ+P2hQ+sBTe5KqZ1P2JpYPzA0cXIySEhYCLx9e5vti5GLg4hgR2MEs/P/WaCcD4x
        SizcO4EFwvnMKLHz2ls2mJZn/w8wQiR2MUr8b3gKVfWDUWLT3itgVWwCmhJPb04FmyUicIZJ
        4lrrWVaQBLOAusSuCSeAEhwcwgIhEkfv14CEWQRUJQ5+f8oIYvMKREt0dB9mhdgmJ3HzXCcz
        iM0pYCnROm0dEyqbC6hmLofE7q3r2EBmSgi4SOxus4PoFZZ4dXwLO4QtJfGyvw3KrpfYN7WB
        FaK3h1Hi6b5/jBAJY4lZz9oZQeYwAz2wfpc+xEhliSO3WCCu55PoOPyXHSLMK9HRJgTRqCzx
        a9JkqCGSEjNv3oHa5CExa/sHaPAAbfr86zLLBEb5WQgLFjAyrmIUSy0ozk1PLTYqMEaOvU2M
        4JSq5b6DccbbD3qHGJk4GA8xSnAwK4nwmkndjxfiTUmsrEotyo8vKs1JLT7EaAoMx4nMUqLJ
        +cCknlcSb2hqZGZmYGlqYWpmZKEkzhu6si9eSCA9sSQ1OzW1ILUIpo+Jg1OqgWmnSOpxscBl
        /ptK9XYYsIQsTBXbxVn08cgMx+crFt1e+WXO6sqt/06wLr0Up/9rVlOtgPJ95qYrPYJPZ0pu
        nMSanr/aRGFK+GpVjct9LOnnxJ/M2SKg95d1x7XyuicGJ1tjd7P8XvxaaZfrpRybRYx5867H
        V7x/zThh/U3L++t7Qp9uepYu5Hc1T10u6M3UJ4ef6qr+muvQG9a8JZrXf/Hiq7sqW/mn16S0
        8G8Jf+b6LUK3RO7lVefaG11CHwUfBh5Z4fL10sdjhY0RRVGejqe5OKae//4we9qd5tcTl+r/
        TJ04MzL2vuxJwx3Nu2clPQoPfLry3/4Jke+nVBgW+x9RUOzaOUfvCZ9DyMrEZSuNlViKMxIN
        tZiLihMBz0EDCjIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvO7T3/fjDd5sNLB4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARxWWTkpqTWZZapG+XwJVx+8IH1oKbXBXTuh+xNDB+4Ohi5OSQEDCRePb/AGMXIxeH
        kMAORomWM70sEAlJiRM7nzNC2MIS91uOsEIUfWOUOPp6JlgRm4CmxNObU5lAEiIC95gkLk2Y
        ywySYBZQl9g14QQTiC0sECSxYc42sAYWAVWJg9+fgk3lFYiW6Og+zAqxQU7i5rlOsF5OAUuJ
        1mnrwHqFBCwk7h16yoRLfAKjwAJGhlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMFR
        oaW1g3HPqg96hxiZOBgPMUpwMCuJ8JpJ3Y8X4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8
        kEB6YklqdmpqQWoRTJaJg1OqgenIgffzjh12NeYQm8eiHHv6xIfjvYW7PW4+mV3np6yl2Xvu
        e0X+/olWr/rLysJnrmBO3v2e9QL7/de+qxbMWCw1d5po//ztvw6fvvl1+pxFXhrKm+85GD57
        uWpWK/f0H/ujmsN1q/5W1tnPFQ2ecduW9dpxT22pzHX/9x0U/OtTu6lB5dP79zt4VPRtJ0//
        vNp3wYGjKW2+dX90Lucvj0v6yjLr95JZm/5cd+FVOShnOu3MzPdvf7o+ncbKInIjnyWcdVPQ
        xHaX2nc3cjecrL35WkzYf8v2FVJZgUs3HfW7dmOXuNeF1ZYb2Ce8lUk5eNvM+1xm0htxGfbk
        CgvmylUTbtt6RpxhuJuo8M1DftWG5UosxRmJhlrMRcWJAFar56f5AgAA
X-CMS-MailID: 20201221013533epcas2p39a17300dc5e1659acdea849bea1322e0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221013533epcas2p39a17300dc5e1659acdea849bea1322e0
References: <cover.1608513782.git.kwmad.kim@samsung.com>
        <CGME20201221013533epcas2p39a17300dc5e1659acdea849bea1322e0@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set optimized values for those timeouts
- FC0_PROTECTION_TIMER
- TC0_REPLAY_TIMER
- AFC0_REQUEST_TIMER

Exynos doesn't yet use traffic class #1.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..5ca21d1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -640,6 +640,11 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		}
 	}
 
+	/* setting for three timeout values for traffic class #0 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+
 	return 0;
 out:
 	return ret;
@@ -1236,7 +1241,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

