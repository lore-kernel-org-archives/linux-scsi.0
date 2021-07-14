Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C734C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673C5613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbhGNHPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31544 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbhGNHPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:15:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071204epoutp04d01163388ceb8f8e2b9d50389c443fd2~Rlsd9nJN-0822208222epoutp04J
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071204epoutp04d01163388ceb8f8e2b9d50389c443fd2~Rlsd9nJN-0822208222epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246724;
        bh=B/muAc9TRv4pSpc80ShCQZ82fhjl/jURU5rQKCwXimc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm5FHdubuDB8IKbEzHy44Wq/B2vCLoucGRwQyUlKTvnW+DPz8ckI5SaRSQDUz5YpY
         8dMqEohLb0Aq6R+nkHzD6KcDQ9upGaUkVtBjfZ0aGwFbr0GDX/4HfoCLWZvzx9JGnS
         fxK9Vfoha9PpgwGtofmi9XCT2yYKQn8///QxygNU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714071203epcas2p4d6495da02ba438ea6fd600e298bb2275~RlsdGfXH02506525065epcas2p40;
        Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbM6SSpz4x9QS; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.42.09921.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epcas2p29900b577a489b760a1e67eba976fb815~RlsZNvzb_0402804028epcas2p2B;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071158epsmtrp1149b3eac8fe7d996561530c0ccbfc7ae~RlsZKIKKk1240112401epsmtrp1c;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-0d-60ee8e3f51a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.17.08289.E3E8EE06; Wed, 14 Jul 2021 16:11:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip2e80bd3368cfbcda389312564ef389bee~RlsY_9iR52386423864epsmtip2X;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 02/15] scsi: ufs: add quirk to enable host controller
 without ph configuration
Date:   Wed, 14 Jul 2021 16:11:18 +0900
Message-Id: <20210714071131.101204-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmqa5937sEg32LjC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZDRe28dacJ634sjtc8wNjEu4uxg5OSQETCR+zXnA1sXIxSEk
        sINRYueRI0wQzidGicYlexghnM+MEj+ePGWDaelb95YVIrGLUeL9nW4WCOcjo8StuQeZQarY
        BHQltjx/BdYuAjJ41eK7YFXMAieZJU4vOMgOUiUskCzxevMPRhCbRUBV4ueayWA7eAXsJeZ8
        O8wIsU9e4tSyg0wgNqeAg8TBDR8YIWoEJU7OfMICYjMD1TRvnc0MskBC4ASHxM+7X5ghml0k
        Zj9bxQ5hC0u8Or4FypaSeNnfxg7R0M0o0froP1RiNaNEZ6MPhG0v8Wv6FqBPOYA2aEqs36UP
        YkoIKEscuQW1l0+i4/Bfdogwr0RHmxBEo7rEge3TWSBsWYnuOZ9ZIUo8JDZczoIE1mRGiY5X
        +9kmMCrMQvLNLCTfzELYu4CReRWjWGpBcW56arFRgSFyHG9iBCdtLdcdjJPfftA7xMjEwXiI
        UYKDWUmEd6nR2wQh3pTEyqrUovz4otKc1OJDjKbAsJ7ILCWanA/MG3kl8YamRmZmBpamFqZm
        RhZK4rwc7IcShATSE0tSs1NTC1KLYPqYODilGph2n7nOWibY8npxP7PFVy3TU9zBpwq258+7
        9eeNoo6ZwlzJIidJn4Z/Oumnq7ZoKxsGxbTJh8awhkUq2H8Wl47/xM471fAH2/Y7NievnvCw
        nvP4UlWM57qec4Fl2lnrVPYv5XynKfX3K8/NfddPRynPX3VxTo/JZfuJ3CKyPem7j7zOFJv8
        1/mQZnRSa+ua2WGKye+Uv4u/6BS6JCmqP3PbB6sXy/vX92m9nXn+hOSvNb0JHc/fKvxtuuW4
        +pPdB2ZrGQa+jIf2c92+Bumce1kv9Y+jtueWQKPeQv4FG7dfYtljo3nM49BOu8vVBcFZs4qf
        ftN4qPLh0T+erVLi8vO1T1n5H1m9hkHSdZuN7j4lluKMREMt5qLiRAC2AIXHYwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXteu712Cwbk+A4uTT9awWTyYt43N
        4uXPq2wW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVmsvGZhcf78BnaLm1uO
        sljMOL+PyaL7+g42i+XH/zE5CHhcvuLtcbmvl8lj8wotj8V7XjJ5bFrVyeYxYdEBRo+PT2+x
        ePRtWcXo8XmTnEf7gW6mAK4oLpuU1JzMstQifbsErozGa/tYC87zVhy5fY65gXEJdxcjJ4eE
        gIlE37q3rF2MXBxCAjsYJSaemcoCkZCVePZuBzuELSxxv+UIVNF7Ronr77azgiTYBHQltjx/
        xQiSEBHYxShx+MxhdhCHWeAys8S3aVeYQaqEBRIldpxcBmazCKhK/FwzmQ3E5hWwl5jz7TAj
        xAp5iVPLDjKB2JwCDhIHN3wAiwsB1fzbthqqXlDi5MwnYOcxA9U3b53NPIFRYBaS1CwkqQWM
        TKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKjS0trB+OeVR/0DjEycTAeYpTgYFYS
        4V1q9DZBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqao
        WRc/rNXr3m/6TH/dybR7F5/pumzZcbd1jc7jnr/9LEvPnO5Lebrn6rtLj6Yuf8M0e/3+w+mC
        TxpfcReXMNSo5a5KZlL1EJ7HfHbLf+d9Okq1oYeehisabrgfKf4igkE5lrnjtWyLx2XZfwX/
        bLLzcutfThHsy1JJmM/SnT7b9n3mEf/Ge7uWSziY57XecUw487hOImfDQr/zTUsdK38r/3Qw
        Pa5xu0XqW27uzDv2/9XUS3um8bEtFrJyemHEP2OCjDOD4flpoYyWFQenPZlest97aeJkm4R9
        vKEW3oe+qzxIigtT/qv5477ZNodpySYsV+QvCVW35IS5Z3AdLepm++A9e4tWbrbYo426QUos
        xRmJhlrMRcWJAKZAMCQdAwAA
X-CMS-MailID: 20210714071158epcas2p29900b577a489b760a1e67eba976fb815
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071158epcas2p29900b577a489b760a1e67eba976fb815
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071158epcas2p29900b577a489b760a1e67eba976fb815@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the physical host interface configuration part that cannot
be performed in the virtual host.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9702086e9860..0df337aa1e6f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7988,6 +7988,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e67b1fcfe1a2..e18b12028796 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -573,6 +573,12 @@ enum ufshcd_quirks {
 	 * support UIC command
 	 */
 	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
+
+	/*
+	 * This quirk needs to be enabled if the host controller cannot
+	 * support physical host configuration.
+	 */
+	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
 };
 
 enum ufshcd_caps {
-- 
2.32.0

