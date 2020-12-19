Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75873C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 06:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5E222DD3
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 06:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgLSGjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 01:39:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52523 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLSGjC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 01:39:02 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201219063819epoutp02643ffad6d53f6762429dbfb1441b3f80~SCs6TRuD22808928089epoutp02r
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 06:38:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201219063819epoutp02643ffad6d53f6762429dbfb1441b3f80~SCs6TRuD22808928089epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608359899;
        bh=/wfoeapVFuGbJwHW34iEMSd+TIgVEfXtV4lC7V9X5f4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=vHuH8K1+P0QgXHr+SSKWg80MyD8ewvmuVAGcrO20dw/rLD3KdJVWRQh2Q3pT7M62J
         PlaDPq15OI2YYTG1NiRLDhya0m/2fr29ZGUfkOwNoPObuDe89CSsr4VYrQQj89YMR9
         icYGZ5hmhiXrmutHkonoEPeGmrKxvM5vKshytYoQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201219063818epcas2p30f23bcef9dbaf5ff1d9b6397a0e4800c~SCs5MYRIY0409504095epcas2p3P;
        Sat, 19 Dec 2020 06:38:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Cybf02MK3zMqYkV; Sat, 19 Dec
        2020 06:38:16 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.54.10621.8DF9DDF5; Sat, 19 Dec 2020 15:38:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599~SCs24DB_S3106831068epcas2p13;
        Sat, 19 Dec 2020 06:38:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201219063815epsmtrp15773a7c10476e9d20dfc33db3c24395f~SCs2z-BMy0989209892epsmtrp1E;
        Sat, 19 Dec 2020 06:38:15 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-b4-5fdd9fd8ea30
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.F3.08745.7DF9DDF5; Sat, 19 Dec 2020 15:38:15 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201219063815epsmtip1be12d9c088381f271721c6da6955e631~SCs2i4oAh2887428874epsmtip1R;
        Sat, 19 Dec 2020 06:38:15 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1] ufs: relocate turning off device power sources
Date:   Sat, 19 Dec 2020 15:27:28 +0900
Message-Id: <1608359248-16079-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTVPfG/LvxBusOc1s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk9F6fTJTwVG+igUzPrM0ML7i7mLk5JAQMJG4cHw7K4gtJLCDUeLO0aguRi4g+xOj
        ROPK78wQzmdGiZ5dfxlhOu5/38AEkdjFKHHq/AdWCOcHo8TmywfBZrEJaEo8vTkVrEpE4AyT
        xLXWs2AJZgF1iV0TTgAlODiEBdwkvm3UAAmzCKhKrFr6mhnE5hVwlfgw5RULxDY5iZvnOsHO
        kBBo5JB43tDKDpFwkVi0+BRUkbDEq+NboOJSEi/726Dseol9UxtYIZp7GCWe7vsH9YOxxKxn
        7YwgRzADXbp+lz6IKSGgLHHkFgvEmXwSHYf/skOEeSU62oQgGpUlfk2aDDVEUmLmzTtQmzwk
        Pm49zgIJxliJuwsXMU9glJ2FMH8BI+MqRrHUguLc9NRiowJD5EjaxAhOkFquOxgnv/2gd4iR
        iYPxEKMEB7OSCG/og9vxQrwpiZVVqUX58UWlOanFhxhNgeE1kVlKNDkfmKLzSuINTY3MzAws
        TS1MzYwslMR5Q1f2xQsJpCeWpGanphakFsH0MXFwSjUwqUsWn0xOashZFx8h/btNcoe2prb8
        y9vl5X3fnLssZTfpm4uyKF39NlvY/ItBYEfc6thN+9W9Hn6S/FipUftV493SwiWthWVPXZy4
        Zn7c0cqxWfA5z5MrNfXta7bHX1/w7ciae8qBDu/zjnc8+9h1j0+47vb1ay5ZwqIZubKqyxkS
        dD7u/vxdJuntnc3tEjedZkx4OU1R+fsODesTTlL+4v6vMmoOTUzKuyqVNy15mXGim63Nr/9f
        t7kcdp+hdu9hR3Pp375zB9bWVs7YFnP46gLetMv1CxKLFsh2JvF6PPXYV3Y8OGDh97VzuQs2
        Cyg81F8w1fWcRr7zO+FdR3V1pk+5nRY7S+fZ9NOLSsIOKLEUZyQaajEXFScCAKPKwGIZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnO71+XfjDV6sFrN4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARxWWTkpqTWZZapG+XwJXRen0yU8FRvooFMz6zNDC+4u5i5OSQEDCRuP99A1MXIxeH
        kMAORonbC5exQyQkJU7sfM4IYQtL3G85wgpR9I1R4sXSbrAiNgFNiac3p4J1iwjcY5K4NGEu
        M0iCWUBdYteEE0AJDg5hATeJbxs1QMIsAqoSq5a+BivhFXCV+DDlFQvEAjmJm+c6mScw8ixg
        ZFjFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcslpaOxj3rPqgd4iRiYPxEKMEB7OS
        CG/og9vxQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTAd
        ELJhLM/6G26dv+j+30N7eZz2+6auj9wREP5vl5n7gqS73f1NvS5v/PwKpk2Z5pHTtqJQTYb7
        7O8t5vstat0ZNpbq1fQGabSe6HfYzW4sPe/Y711L4txnndlq5LOm8e48PdHjQU0tKyZV31Q4
        I3bHypur8lbq4z3RCf0Gaxg63luJdLxckpl58fHEBe7zjaOtTkyqnfdz/ZEevs37u9YFr074
        0/2gtJT/sPzXm9ohCa3h14uy+z3NHr1TqJHpFOq9r/dtX++6g076y9Y82v+QW/Ec+3f7J1tS
        7ES/7vr51vZoaYtf/Zpna43Ln+9R5tgfmbyDOYmjVbjVcDrzhrcZeSqf3Dq5Wpcc1T153FeJ
        pTgj0VCLuag4EQBlLS+XyAIAAA==
X-CMS-MailID: 20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599
References: <CGME20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS specification says that while powering off the device,
RST_n signal and REF_CLK signal should be between VSS and VCCQ.
One of ways to make it is to drive both RST_n and REF_CLK to low.

However, the current location of turning off them doesn't
guarantee that. ufshcd_link_state_transition make enter hibern8
but it's not supposed to adjust the level of REF_CLK. Adding
ufshcd_vops_device_reset isn't proper because it just drives the
level of RST_n to low and then to high, not keep low.
In this situation, it could make those levels be
diverged from those proper ranges with actual hardware situations,
especially right when the driver turns off power.

The easist way to make it is just to move the location of turning
off because lowering the levels can be enabled through
the callbacks named suspend and setup_clocks.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..dab9840 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8633,8 +8633,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto set_dev_active;
 
-	ufshcd_vreg_set_lpm(hba);
-
 disable_clks:
 	/*
 	 * Call vendor specific suspend callback. As these callbacks may access
@@ -8662,6 +8660,13 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 					hba->clk_gating.state);
 	}
 
+	/*
+	 * It should follows driving RST_n and REF_CLK
+	 * in the range specified in UFS specification
+	 */
+	if (!ufshcd_is_ufs_dev_active(hba))
+		ufshcd_vreg_set_lpm(hba);
+
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
 	goto out;
-- 
2.7.4

