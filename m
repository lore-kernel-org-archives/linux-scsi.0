Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A46C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0090361245
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhGIHAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41964 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210709065750epoutp025800ff837f8b3ab219b30e2588e58945~QDRnRmAz32525825258epoutp02V
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210709065750epoutp025800ff837f8b3ab219b30e2588e58945~QDRnRmAz32525825258epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813870;
        bh=Usn14cwoAH2iGNudSDG44vuke1ctfhBYfcmgTwhyEoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jynPTSpYYcI5X57cECqPW7YtfyQlAHNRGJZfITJc24vT6sKMS+ApZ3AmfUvlPNnms
         yqst2BKW3ptanew9kKRxeB5P6TCdEOi9rwzbksCloC/fzOQ3EqUROdPpWsSE4uT4uE
         vVnVr/PywJzFxKkGq2j64x+2BKxgZ1UjwkpkNrlc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p28e7125ff16a0d6641b49ff78c6fbde1f~QDRmoP0xI2550225502epcas2p2S;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GLkWG6Dd4z4x9Q4; Fri,  9 Jul
        2021 06:57:46 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.7D.09571.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p10d43898e863a873594f81f4a5a4f0ef2~QDRjsQaUP2622226222epcas2p1K;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp1e41ae976d43a3b009e74a5723542654a~QDRjrOl_e3179431794epsmtrp1O;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-f7-60e7f36a2c1d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.63.08394.963F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065745epsmtip2aa455aeeedd0e5870f5fb1c88b845caa~QDRjdBarj3077030770epsmtip2O;
        Fri,  9 Jul 2021 06:57:45 +0000 (GMT)
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
Subject: [PATCH 01/15] scsi: ufs: add quirk to handle broken UIC command
Date:   Fri,  9 Jul 2021 15:56:57 +0900
Message-Id: <20210709065711.25195-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmuW7W5+cJBnOWGlicfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORkvJ85jKTjCW9G88CZTA+MM7i5GTg4JAROJS9fOM3YxcnEICexglDh1
        ZDIThPOJUeL79MOsEM43RomeyctYYFpOP/7CDJHYyyixu+MzC4TzkVHi+fJJbCBVbAK6Elue
        vwIbLCLQzyixfP9csCpmgZPMEqcXHGQHqRIW8JCY8/AaWAeLgKrExkf9TCA2r4CdxPYHc9gh
        9slLnFp2ECzOKWAvMe/HBKgaQYmTM5+A3cQMVNO8dTbYTRICRzgknl84DNXsIvFp6XZmCFtY
        4tXxLVBxKYmX/W3sEA3djBKtj/5DJVYzSnQ2+kDY9hK/pm8BBgEH0AZNifW79EFMCQFliSO3
        oPbySXQc/ssOEeaV6GgTgmhUlziwfTo0uGQluud8ZoWwPSSOnFkDFhcSmMQocWxt9QRGhVlI
        vpmF5JtZCHsXMDKvYhRLLSjOTU8tNiowQY7jTYzgVK3lsYNx9tsPeocYmTgYDzFKcDArifAa
        zXiWIMSbklhZlVqUH19UmpNafIjRFBjWE5mlRJPzgdkiryTe0NTIzMzA0tTC1MzIQkmcl4P9
        UIKQQHpiSWp2ampBahFMHxMHp1QD0ynZbVOKd6Vu9J1t9iYve/ZP9VTXaQpKas7znhzW9LKI
        X6TwMkxlQi/LDf+suojcw0o/BSOc5xtrdElO2zHn8O/rk8Okwm+bvlvXxZ3barqJs9zxwyY+
        7dsTnR6ppd96vvrY4cKL+nzh//cLNh6KdKqbpit4LKqceV7Lj+dCBgo+fR/frb98tW/K5Hu3
        NpZlmzFV59i478nty5w26efqVeKfgv6VbDqmsH3Gk8dbNF13XZ9bddBIJ7SkctWVDmM3xWT/
        tgSJKw88sg8UeKvsffE19FfL5MCYJUV50j7TzzMYOV3qUvPxOZNWypfWMcf59qOcc063D/Kc
        8blduTL2oOzcRJcNqW4XHvYtOXrfTYmlOCPRUIu5qDgRAOKEYsBeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg9WvmCxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGy4nzWAqO8FY0L7zJ1MA4g7uLkZNDQsBE4vTj
        L8xdjFwcQgK7GSW6jzUwQiRkJZ6928EOYQtL3G85wgpR9J5RYsbXm2BFbAK6EluevwKzRQQm
        MkosuScGUsQscJlZ4tu0K8wgCWEBD4k5D6+xgdgsAqoSGx/1M4HYvAJ2EtsfzIHaIC9xatlB
        sDingL3EvB8TwGwhoJp7G/axQ9QLSpyc+YQFxGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU
        56bnFhsWGOallusVJ+YWl+al6yXn525iBEeUluYOxu2rPugdYmTiYDzEKMHBrCTCazTjWYIQ
        b0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTDXPrspMl1es
        Nr1uyCNxc6743/CFAc1S/7vY1pzNf+B7pelh34ILK6fJNYo4GEjc+MLscGEds+TryaukVyrH
        a/6ycJ15T2iu19sIl2v+r14K/mvYdGN638rIJ3/CWP5ds3M2YE260/vY3E5bs/3q44pZvQ7P
        nGd+CuGYcY/pf0nzYkXvY5KN2Uu9Hzbq+lzcEqjeNulNyKlE+63ZD195f902sy/+068V/6u3
        lpzjNPy377CsfGfPGbM5BQ3NV0uu/bjYeLe049LzrzaKFeWBqY/ufw26u2XFv4tC/6ML2bf8
        eVY4LeG//ny3E/uTJk6QSLJQasxX23fsyInbbolr7Gfs/e4+89nJB2EaMV79/aeUWIozEg21
        mIuKEwGGcAHyFwMAAA==
X-CMS-MailID: 20210709065746epcas2p10d43898e863a873594f81f4a5a4f0ef2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p10d43898e863a873594f81f4a5a4f0ef2
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p10d43898e863a873594f81f4a5a4f0ef2@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto9 SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function
only.

In this structure, the virtual host does not support UIC command.
To support this, we add the quirk and return 0 when the UIC command
send function is called.

Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b87ff68aa9aa..9702086e9860 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2350,6 +2350,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..e67b1fcfe1a2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -567,6 +567,12 @@ enum ufshcd_quirks {
 	 * This quirk allows only sg entries aligned with page size.
 	 */
 	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+
+	/*
+	 * This quirk needs to be enabled if the host controller does not
+	 * support UIC command
+	 */
+	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
 };
 
 enum ufshcd_caps {
-- 
2.32.0

