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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D56C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF616138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhGNHPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31516 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbhGNHO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:59 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071203epoutp04d1f5012878be2faeadbdf465a16f6a29~RlsdJKMlN0948909489epoutp04H
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071203epoutp04d1f5012878be2faeadbdf465a16f6a29~RlsdJKMlN0948909489epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246723;
        bh=ZaMi4QacgtlRAgjhOjwhR1V6/hTtev/Lnt+7zdF5Yl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFlG6ZZdKkqZ1dOCFvDFqx4vFtrYawuBUlI6x0g8mOkXcvcFvnhKn+UYiZvOwL3E9
         H78ThUKHEHdWAEg7eErLtmumwF1LgY+cXLcCxidjnzeSgDm0P8zLwlGYlrK7tBBE6X
         xTL5HQGOPDdGxYUDg+w2ahLxSeXCXrujWN3oxw0c=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p256dc6c6f6d4eba9c95a5c2b672c3fc18~RlscX_0F21657016570epcas2p2j;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbN4Txkz4x9Pv; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.BF.09541.F3E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p24b7be0cad31af09bc71c608f9b03fe36~RlsZ2TdkI0402804028epcas2p2E;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp24fd04a77a7de79fdd3d7aeb50520adfe~RlsZ1bWnb0755107551epsmtrp2p;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-f1-60ee8e3ff0b1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2c1a4706c716236f06f9ff0501af836e7~RlsZixBcM2388323883epsmtip2T;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
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
Subject: [PATCH v2 08/15] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Wed, 14 Jul 2021 16:11:24 +0900
Message-Id: <20210714071131.101204-9-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxjdfa+8Prp0PiobdywT8ohsshRoY/FqYLBJ8BlgqRIX48LKE54t
        WtqmP8hmwtTh5EeFwdyAVUYUAmrVwLBiITgLlSljG38UUXBsTGC1ZhAUNsY25lpel/Hf+e49
        557zffdeEpd8R0SShTozZ9SxWpoQCbrcm5A0rXouL9HuBmhw+hKBJpu6CORbvkOguvllHD1p
        bwtBnhuvoZPd29FQTTOGptttOGq+14WhC6MIDQ93CNGYY0CAGoa/wpD1rpNA5279g6VRjGck
        k/FUV2HMlfNxTEuvD2M67RUEU9PsAszjmXEBU+2wA2ahcwNT5rJiStE+bbKGYws4YzSny9cX
        FOrUKXRmjmq7SpGUKJPKtqItdLSOLeJS6PQspTSjUOvvg44uZrUW/5KSNZnohNeTjXqLmYvW
        6E3mFJozFGgNMpkh3sQWmSw6dXy+vmibLDFRrvAz87Saiqk7AsMF8r2eBi84ClqFlYAkIbUZ
        OscslUBESigngOWf+Ai+eALgqYFenC9+B9A1eFlQCUJXFd8vuYOs6wDOtTYJAxsS6jGAbbb9
        AUxQUujwPgIBUnjgXHvLhCBQ4NQgDofO9K2ar6f2waYPLQGBgNoIj388QASwmEqFtu6nBO8W
        Bb9p68MCOJRKg30d84DnhMHBz6dXE+F+TunV06tRIfUtCXub3cGo6XCkpwPweD18dMsh5HEk
        XJi7TvACK4AfPXga3LgIYMWxLB6nwj/rHSGBoDi1Cbb3JPADi4E3x4O+z8Fy90pwjmJYfkLC
        C1+Brmv1wQQvQ2vjQghPYeD4Lwf5uZ0CsO+SG6sB0bY13djWdGP73/cMwO3gBc5gKlJzJrlB
        vvaCO8Hqu47LcIJPZ+fj+wFGgn4ASZwOF7fKZ/Mk4gL2/cOcUa8yWrScqR8o/LOuxSOfz9f7
        P4bOrJIp5ElJiVsVSJEkR3SEmBT250koNWvmDnGcgTP+p8PI0MijmHRZEDpT1T2a+8HlqnrV
        yajUu6Jr3rGhV2MVpR1/bYSLS7vFE4eUI7a9R8reFqybMiQcV7cUV9vDNJnvRLzpu4hb/06t
        yML+gAenROF7DqQ7G7EXd8pyfSrlcobrS9VPv3qUKdovYq60qZSwqj3EU6afV89uWNdUMuM8
        pnk4cuT8G781hP1cMrqwpLJg897Sodb73T88s+fdStqhQDk7TnSoRY3FD+ldradrR1wv5WxO
        0ixMnLsXm83m3t57wzspvHlWeXW8fIaurcg+kLm4f0fG/ZadK+E/An3hZElK/ltfR009G6Eu
        yUp+8FldYU9MzeH+CdmW3dsW8ZXb2R6rJLZORAtMGlYWhxtN7L9/BqN0YAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXte+712Cwb/lUhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBmdj6+yFKzkqNg14zljA+NS9i5GTg4J
        AROJc98Ps4HYQgK7GSUatzFCxGUlnr3bAVUjLHG/5QhrFyMXUM17Rokp+z6zgCTYBHQltjx/
        xQiSEBHYxShx+MxhdhCHWeAys8S3aVeYQaqEBSIkDm05BTaKRUBVoqX/KNg6XgF7iVk7/7NB
        rJCXOLXsIBOIzSngIHFwwwdGiJPsJf5tWw1VLyhxcuYTsM3MQPXNW2czT2AUmIUkNQtJagEj
        0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjODY0tLcwbh91Qe9Q4xMHIyHGCU4mJVE
        eJcavU0Q4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgUl9
        1/qfJdLh8aePGrvtDf3K8qb6z/qCzXuzNx1cpBvxbm2i/OeNwvnf7htst/IQ65ATnNXs91LS
        40yeqDH7y3knLR1lDl3f/2Dylmkaj4OusnqcnHslc4mH66yVFVm79jDKLjU7ZWYXFXax9+R6
        q2+SsRK1C0PXtWsfydrta1fxVrn/vK3Xg+clhZ91TfuSL59vjbs/odtqmY3GD47nZ/4w6J7M
        /7UzMsT89/15b2e/7zuXvjNQ4qD3l327mTaGnKx4vkl07q8svp7GJc5W3wRE5vw/qxnDcOuH
        02f1CW4WNy+eqHy9p+ohT/mH+mcl+xLW7i/N3WDK2f3Tq59njR3X7ibRyTtXGmXPXaJt6/NM
        iaU4I9FQi7moOBEA9rv3mhwDAAA=
X-CMS-MailID: 20210714071159epcas2p24b7be0cad31af09bc71c608f9b03fe36
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p24b7be0cad31af09bc71c608f9b03fe36
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p24b7be0cad31af09bc71c608f9b03fe36@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 530dab500d11..60edd420095f 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -644,9 +644,9 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
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
2.32.0

