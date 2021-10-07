Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E0C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD513610CC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240674AbhJGIOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30396 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbhJGIOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:12 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211007081217epoutp03eb6917c80886e24c622a036d02dbe7d9~rsWUkQZ8G0769607696epoutp038
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211007081217epoutp03eb6917c80886e24c622a036d02dbe7d9~rsWUkQZ8G0769607696epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594337;
        bh=5K9EcZUc8/n5le3cg5k+E1wan3msWXl5l3tF4jKx+Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Inmbc8YaF2QvYB1f5mdp3hDSg529Ef6Oz9YfRQuDTOlBHYMn1rSWm1sF2gtKgfq19
         1yogxCetV6bW2EzorSYmjA84HOlEuL32W4RU/pOELrXh7XvFMGXaZM3Mt2n1sOY7AW
         i6p48VID2O6cOxd8blmjwVl9gXna0F+NuGtFe3YE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211007081158epcas2p45bb35e3e608756460368c78f724a767e~rsWC_Yo7T2638926389epcas2p45;
        Thu,  7 Oct 2021 08:11:58 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3vC0DrRz4x9TR; Thu,  7 Oct
        2021 08:11:51 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.08.09472.1CBAE516; Thu,  7 Oct 2021 17:11:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3~rsVseAWfd2638926389epcas2p40;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp2e251da43953852b1bb7806ab4434fbac~rsVsYiLdO2686726867epsmtrp26;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-d9-615eabc12fe3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.B7.08750.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip2b8bf4a8148f16952dcda4229eb123830~rsVsGaoc00776407764epsmtip2S;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 07/16] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Thu,  7 Oct 2021 17:09:25 +0900
Message-Id: <20211007080934.108804-8-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmhe7B1XGJBq8uSlicfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRGXbZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMC/QK07MLS7NS9fLSy2xMjQwMDIFKkzIzmjvu85ccI6rovXLVLYG
        xlWcXYycHBICJhKzt35n62Lk4hAS2MEo0TVlBjuE84lR4njzYyjnM6PEkus7WWBafkxYzgyR
        2MUocX5JM1T/R0aJNRfWMIFUsQnoSmx5/ooRJCEi8J5R4snjKWCzmAWeMkvM+9EL1MLBISwQ
        JTFzugdIA4uAqsS6tnuMIDavgL3E0v1X2SDWyUsc+dXJDGJzCjhI7Nm1lg2iRlDi5MwnYCcx
        A9U0b50NdpKEwBsOiT/df6FudZG4uO8nI4QtLPHq+BZ2CFtK4vO7vWwQDd2MEq2P/kMlVjNK
        dDb6QNj2Er+mb2EFOZRZQFNi/S59EFNCQFniyC2ovXwSHYf/skOEeSU62oQgGtUlDmyfDnWB
        rET3nM+sECUeEi/2VkHCajKjxLM7G9gnMCrMQvLNLCTfzELYu4CReRWjWGpBcW56arFRgQk8
        ipPzczcxglO7lscOxtlvP+gdYmTiYDzEKMHBrCTCm28fmyjEm5JYWZValB9fVJqTWnyI0RQY
        1hOZpUST84HZJa8k3tDE0sDEzMzQ3MjUwFxJnHfuP6dEIYH0xJLU7NTUgtQimD4mDk6pBqb0
        V1fer2hlrfcsD6vxZ16+I8zL/GPxK82s+buubmSRnFH0wMFt2tdo0ayvkwR2TbiuMndTncO6
        M9zete5sm4UnP5D6I9FmtX3BrLrrK5Yp1UefUXsXWR5tzmN/lOvyl2s5H3trWTbUL1H+9GrN
        pmNlnyqSZ0p7PJStu+PSE1csMtuUpejxtKAjf4M7Eo6e6FuwZdnU3/yhKl++nmwRlv6wSf3Q
        c/tg9iu51kZeoSmxaa8D65iSnrguKz+6IiB++jLm71O/hhrf2rp58bf3E7POf+CQ27/pyP+i
        j9yOZ9tns5zXTOM4JqCsvDVr0mH7h6tvGanHu37+dun6hqLnGybFXesVnz+z5aWvpLOO4MwP
        SizFGYmGWsxFxYkAMfRNF3YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBu8nyFicfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl
        tPddZy44x1XR+mUqWwPjKs4uRk4OCQETiR8TljN3MXJxCAnsYJTY/PkmG0RCVuLZux3sELaw
        xP2WI6wQRe8ZJb43HwdLsAnoSmx5/ooRxBYR+MgoMeebFkgRs8BHZok7K5ewdDFycAgLREic
        u1EOUsMioCqxru0eWD2vgL3E0v1XoZbJSxz51ckMYnMKOEjs2bWWDaRVCKim628kRLmgxMmZ
        T1hAbGag8uats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZG
        cARqae1g3LPqg94hRiYOxkOMEhzMSiK8+faxiUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3Sd
        jBcSSE8sSc1OTS1ILYLJMnFwSjUw2b2/Vip+96XR0ftfPdYy2nTs3f43Sn7uBs5V5r7rdwZv
        llzU3njy+huh3wrTWSWvWR/c9cSsYlrDGaHTjHcsfB3ypnC3sLxSnrWyyuDtt2vv1lXalxv3
        vD2+4cuPc69rlVJOHjkpWv/6Sm0W28UzKpu3zNtdK/2romF5cnbDr0xWTyHmI1IS00s+3/3P
        dXiXlnqEr3rfwgU1UaxPz0rosc7W6Z1z/gjLtlft0/4wlr2Ja1uZ68jpdN7C69I2lztHjgTM
        Cb+2/s3fXr5A1o3Pf13bnTbdeqrHQh/3B99q40+t2qd+zDWZzeyK2PMb/54W7JBqP9P62+v3
        tuc5qfFrZyjaKwfazNm25WLbwYUP034qsRRnJBpqMRcVJwIAZN93iS8DAAA=
X-CMS-MailID: 20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Fixes: a967ddb22d94 ("scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index e800fb9e1ce4..41797f499544 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -643,9 +643,9 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 	}
 
 	/* setting for three timeout values for traffic class #0 */
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
 
 	return 0;
 out:
-- 
2.33.0

