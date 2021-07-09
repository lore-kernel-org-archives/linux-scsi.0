Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC05C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADA96138C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhGIHAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50489 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhGIHAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:36 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065750epoutp037a22a2ef8051a3033bbec00e6c29b15f~QDRn36Gyq2653826538epoutp03F
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065750epoutp037a22a2ef8051a3033bbec00e6c29b15f~QDRn36Gyq2653826538epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813870;
        bh=S5HB5xvQdT3pMtN03xwBx1oWe6MtahuoR1sZ+8K+9zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtZ57o+AamVK82FdYkgfHBVTQlnL2vo7p0IL/Fdb1B8+d+EdRDHCnjfw0/pfssZms
         A372EdhZIgx2rvnthS43e9PLalsSYS8uYJgaO7OnNTGvxkzP++a2pzNWOm0SQp/peD
         JbySSts6U6Fa/zRA+OAhH+eUeD6keG8GjpMc2XAY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p3afd39e0d8e3d016e24ad29de1aff8db3~QDRmkDtG02002520025epcas2p3G;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWH0Lg3z4x9Q7; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.CF.09541.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972~QDRj4PUXD1603316033epcas2p4g;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp178c5eba4d9177a663b0b3af791fd7034~QDRj3U7HX3220632206epsmtrp1T;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a47-609ff70000002545-11-60e7f36aaa56
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2d13146600666c12da1707ee3df6bdae1~QDRjmsDjK3215132151epsmtip2L;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: [PATCH 03/15] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Fri,  9 Jul 2021 15:56:59 +0900
Message-Id: <20210709065711.25195-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmhW7W5+cJBoefW1ucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORlXNz9jL5jAWjHx1WT2BsaVLF2MnBwSAiYSl6ZvZu1i5OIQEtjBKLFu
        62UmCOcTo8TfP01QzjdGiQNzNrLDtMxc9IMZIrGXUWLyvTdsEM5HRom29wfABrMJ6Epsef6K
        ESQhItDPKLF8/1wWEIdZ4CSzxOkFB8FmCQv4S7xdsp4NxGYRUJW4seodI4jNK2An8eT9OUaI
        ffISp5YdZAKxOQXsJeb9mMAEUSMocXLmE7BtzEA1zVtng90kIXCAQ+L1pqVAQzmAHBeJZS8F
        IOYIS7w6vgXqBymJl/1t7BD13YwSrY/+QyVWM0p0NvpA2PYSv6ZvYQWZwyygKbF+lz7ESGWJ
        I7eg1vJJdBz+yw4R5pXoaBOCaFSXOLB9OjSAZSW653xmhbA9JNY/aIEG1iRGiQ9vWpgmMCrM
        QvLNLCTfzEJYvICReRWjWGpBcW56arFRgTFyHG9iBKdqLfcdjDPeftA7xMjEwXiIUYKDWUmE
        12jGswQh3pTEyqrUovz4otKc1OJDjKbAsJ7ILCWanA/MFnkl8YamRmZmBpamFqZmRhZK4rwc
        7IcShATSE0tSs1NTC1KLYPqYODilGph8Nbcb+J/TyRI/IfM9YOm0mmkpNjtZhTvPvJsueeKS
        qWewaJp+xK7nTZ9fzj95N0WsMqen4Z0b9/qvj4X/beoWW958qufE0uBoq4sZlnaupUee+++O
        j9F703K2akHFnexjCU9f7z0WWXHE7KTQ5oXCmmzpUr0ZBj2Z737O4F6raL5Adf2TIvWv71av
        bL62zCuzUPng2taH6UecFiTLdMa++tj2l615vvKZxr49+1JqmA7a3+d4rXh1cuW9om+/Ze2z
        I7VPv/UWcnx38MpvKdWjoVv+sV6tNBS6rJCT93Bm8NOUGWdWzJnJz/fio8Fa2837wrQmH/gQ
        pJDf1rf2wQe25CsK7sx+V47M5KluPrRDiaU4I9FQi7moOBEAk++HOl4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEgytr+S1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG1c3P2AsmsFZMfDWZvYFxJUsXIyeHhICJxMxF
        P5i7GLk4hAR2M0o8+/kXKiEr8ezdDnYIW1jifssRVoii94wSp25uZgRJsAnoSmx5/grMFhGY
        yCix5J4YSBGzwGVmiW/TrjCDJIQFfCX+Tp7DBGKzCKhK3Fj1DqyBV8BO4sn7c4wQG+QlTi07
        CFbDKWAvMe/HBDBbCKjm3oZ97BD1ghInZz4Bu44ZqL5562zmCYwCs5CkZiFJLWBkWsUomVpQ
        nJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERxRWpo7GLev+qB3iJGJg/EQowQHs5IIr9GMZwlC
        vCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MBmayEVsv6n8
        zvS6cfClQ1c0vL4o9W/7f+FGa2RRgo3CzE8agSbHX1fzajozBZUX8s5ZZtG+NbE6Ktyp/Pdm
        VqWPeazuXrIMq+Vb2CpEz8XILz1xREL789xwp/wt0q/ENe2099y/p2dzWI3ZsPu9QfQpze86
        630l62yd3wSEJjG98TifamiwaY/835Nbf/Ocs1V/c0J7S6Pb9FXuQakHj16P2Hh59hf+CpOt
        T88e87rj0Z3kPG+nl5vN3V28ofaOBbEihZEM8hULj0s33mPb9OGIg13FJgnnTydruFSCvhY1
        XDlTI/fwnN1fpbBvfvnTFiyJk92+5NtWR8bkTM5zW6ZyTtbgv/HIy1L5gV2BEktxRqKhFnNR
        cSIAqXriahcDAAA=
X-CMS-MailID: 20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p47985fa3c33297a36d772fb9d45f30972@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support 167MHz PCLK, we need to adjust the maximum value.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 67505fe32ebf..475a5adf0f8b 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -99,7 +99,7 @@ struct exynos_ufs;
 #define PA_HIBERN8TIME_VAL	0x20
 
 #define PCLK_AVAIL_MIN	70000000
-#define PCLK_AVAIL_MAX	133000000
+#define PCLK_AVAIL_MAX	167000000
 
 struct exynos_ufs_uic_attr {
 	/* TX Attributes */
-- 
2.32.0

