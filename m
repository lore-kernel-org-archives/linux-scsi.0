Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2325CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF5F22AED
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgLVCSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:18:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38724 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVCSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:18:24 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222021741epoutp01012dc5fbbd4d2ab50189ccefa4929898~S6FNOmGO81804918049epoutp01Y
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:17:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222021741epoutp01012dc5fbbd4d2ab50189ccefa4929898~S6FNOmGO81804918049epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608603461;
        bh=6otfCUScQsQqUhT8MT7TE9t5Yf/LoIlk1bakCNDOfgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=kKSE00OyrdZ/y6rYy7OoUaRs57XeD8zndDo/FP5oTKTTSJv2jRCpBsrw2kLzSIUaQ
         +ifQiU0+jZbsp4UvQM00oWL8kVUPaWVBcxLXY9x32SYOiBx9HP/8SvtZOX5YR/XZLK
         aaAdrTMwfEnsdMTbB0Zf5gcWeqsiHrKfvCrhaOcc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201222021740epcas2p40768d6d079dcea6fd6f2b05779b8d9ce~S6FMmtC9z1254512545epcas2p4v;
        Tue, 22 Dec 2020 02:17:40 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D0Kjv4M2Jz4x9Q6; Tue, 22 Dec
        2020 02:17:39 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.52.05262.34751EF5; Tue, 22 Dec 2020 11:17:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201222021738epcas2p2e7527ad5ab8a7af8149574516bc1209f~S6FK8FRC53122631226epcas2p26;
        Tue, 22 Dec 2020 02:17:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222021738epsmtrp28368c0e665a19bdd1d82de6b91335c4a~S6FK63mLD0835108351epsmtrp2J;
        Tue, 22 Dec 2020 02:17:38 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-f8-5fe15743a44f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.9C.13470.24751EF5; Tue, 22 Dec 2020 11:17:38 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222021738epsmtip1482ceb54fcce53641be8a6e0708cdb75~S6FKu4zeV0722807228epsmtip1F;
        Tue, 22 Dec 2020 02:17:38 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/2] ufs: add a vops to configure block parameter
Date:   Tue, 22 Dec 2020 11:06:46 +0900
Message-Id: <dad43ff87d34cea599e35eed46762f87f4af939d.1608602725.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608602725.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608602725.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmha5z+MN4g+VtChYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZGx5eYGp4At3xcwtb9gbGN9zdjFycEgImEhsfM/dxcjFISSwg1Hi58WbzBDOJ0aJ
        WwumMEE43xglehq+snUxcoJ1tLVsY4dI7GWU6Hy+lhHC+cEosevAerAqNgFNiac3p4K1iwic
        YZK41nqWFSTBLKAusWvCCSYQW1jAReLK5f3sIDaLgKrEtdczWEBsXoFoibV7OqDWyUncPNfJ
        DGJzClhKXL2/hhWVzQVUs5BDovdoHxNEg4vEk3cnWCBsYYlXx7ewQ9hSEp/f7YUaWi+xb2oD
        VHMPo8TTff8YIRLGErOetTOCgoYZ6IX1u/QhoaQsceQWC8T9fBIdh/+yQ4R5JTrahCAalSV+
        TZoMNURSYubNO1BbPSTWvZwPDUagTavmvGScwCg/C2HBAkbGVYxiqQXFuempxUYFxsjRt4kR
        nFS13Hcwznj7Qe8QIxMH4yFGCQ5mJRFeM6n78UK8KYmVValF+fFFpTmpxYcYTYEBOZFZSjQ5
        H5jW80riDU2NzMwMLE0tTM2MLJTEeYsNHsQLCaQnlqRmp6YWpBbB9DFxcEo1MEmUPjrbGzPz
        7hbR6d8cc7SPTYx3izHd2T/D4TPHkbYOkwuTnA/ErS+f/ST5/YVJbC++98+NCF750MPHr2rh
        q5QyLY7/VzjPSqy0ym//8H/vCl1pzqsyARMVbc5bOwhwy6f4v7y0I0gjfpn1HG/tAz23nLvq
        Hy5Jn3lzvR6zUeSdG/yiOum5gdc5yjZtehy3J/PcUmErd86cB0HaDQxz9ef0MxZaZMj0SMkd
        sVggor6Gy+P3u/fskSf5Xu78FSdWdM/oxjcVr5z8U2cZG2UnO7F06VekMhVy7Pb2ZV5+sk5V
        sUGie0Vw96+AaO+deQY1CyvlknzWPTySv9mphVFW2t7W34pNRTM6/3lX1W0lluKMREMt5qLi
        RAAGp8AXMwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnK5T+MN4g7uLTS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVseXmBqeALd8XMLW/YGxjfc3YxcnJICJhItLVsY+9i5OIQ
        EtjNKDFx8ix2iISkxImdzxkhbGGJ+y1HWCGKvjFKzG+8wgaSYBPQlHh6cyoTSEJE4B6TxKUJ
        c5lBEswC6hK7JpxgArGFBVwkrlzeDzaVRUBV4trrGSwgNq9AtMTaPR1sEBvkJG6e6wTr5RSw
        lLh6fw0riC0kYCGxdtFENlziExgFFjAyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93E
        CI4KLc0djNtXfdA7xMjEwXiIUYKDWUmE10zqfrwQb0piZVVqUX58UWlOavEhRmkOFiVx3gtd
        J+OFBNITS1KzU1MLUotgskwcnFINTLOlKh/1nu9l+b3d5HKw9JrnPJ2pzUcuLZR193A6d1vW
        9f+x05mrD8n52p86+vk2S9X1mBT7x4diHz90qG2dKSGUcq1rnejHzHcyGb/l9qyfvWnZp6jj
        nLc5+u5lW+1Vnzb9zS3X+W6aPvxGM7eZb/TdO3/R4Q7b3fN+fXy+2Gz+CrX0CY6rkq9r7ZrK
        zL8mhTfChf/TjuupLt/WcHT7xxhst3vzUSOqpzdS9LyERfoBZskHQvJ/zn9kj5k1deaSf48l
        XvOXvbS20cg45G65/8hL+6aAKAcBfyvrv0W7j1xJkO/4f9Od1+p7R9qeUydur5hyleXtXJOg
        V7+9ntvnz7FR5N8e0N59himem1st10+JpTgj0VCLuag4EQAFFI7d+QIAAA==
X-CMS-MailID: 20201222021738epcas2p2e7527ad5ab8a7af8149574516bc1209f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222021738epcas2p2e7527ad5ab8a7af8149574516bc1209f
References: <cover.1608602725.git.kwmad.kim@samsung.com>
        <CGME20201222021738epcas2p2e7527ad5ab8a7af8149574516bc1209f@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There could be some cases to set block paramters
per host, because of its own dma structure or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..5f89b0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	ufshcd_vops_slave_configure(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..4bf4fed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	void	(*slave_configure)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -1228,6 +1229,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_slave_configure(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->slave_configure)
+		hba->vops->slave_configure(sdev);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

