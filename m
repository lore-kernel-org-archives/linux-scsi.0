Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE47C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3422B6112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhIQG5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20405 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210917065527epoutp0233398fd831c854336188e9a106743d94~liZhj8olU3018930189epoutp02P
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210917065527epoutp0233398fd831c854336188e9a106743d94~liZhj8olU3018930189epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861727;
        bh=MM+Niah6/Dlz37vZxUDkBeok/HyuhcWhAKujeiGkYO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5kRnUv40l5dJwox49LGzM7JuexZ/w9osJsJbX+8JL14FxWX7WSGYl13bwP78c3OR
         PYgWUnXOtCrhtdpbFXZK3KnNtTR0YlOl5XanM7dv8d6/BXOphTW+GgMEKrO4q2CQMb
         H7BpSszVx+RusJUMK2ql+u+TqXMsp8ygGYo0r4+A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210917065526epcas2p144c6baa322d00a3b94ba9985ec2e2c7f~liZg2Nkb-3017030170epcas2p1G;
        Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8D4fQ9z4x9Pv; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.43.09816.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p15b648b88af85252fe12ff8026307526a~liZdxee_x0293602936epcas2p1J;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp21040586a7dd3d1cc7ad23e06756ff324~liZdwZqey1373513735epsmtrp2D;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-14-61443bdc2803
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.20.09091.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2e04a9e96f3e8db4159a379276c1f26d5~liZdf8rn-2196321963epsmtip2p;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
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
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 09/17] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Fri, 17 Sep 2021 15:54:28 +0900
Message-Id: <20210917065436.145629-10-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmue4da5dEg2m72CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEn4/SarewFuzgrDm15y9TAuJyji5GDQ0LA
        ROLK9OguRi4OIYEdjBLduxpZIZxPjBI75qyAcr4xSpxseM7excgJ1tH7+CVUYi+jxL1NP5gg
        nI+MEk8W3GQCqWIT0JXY8vwVI0hCROA9UOLxFHYQh1lgFrPE8a+TwaqEBaIk3p68wgpiswio
        ShxbsAwszivgILF5byfUPnmJI786mUFsTqD4rV3/GSFqBCVOznzCAmIzA9U0b53NDLJAQuAO
        h8SOpjVMEM0uEo93TWaEsIUlXh3fAjVUSuLzu71sEA3djBKtj/5DJVYzSnQ2+kDY9hK/pm9h
        BYUTs4CmxPpd+pAgU5Y4cgtqL59Ex+G/7BBhXomONiGIRnWJA9uns0DYshLdcz6zQtgeEr9W
        vIUG3WRGiRWXT7JMYFSYheSdWUjemYWweAEj8ypGsdSC4tz01GKjAiPkON7ECE7lWm47GKe8
        /aB3iJGJg/EQowQHs5II74Uax0Qh3pTEyqrUovz4otKc1OJDjKbAwJ7ILCWanA/MJnkl8Yam
        RmZmBpamFqZmRhZK4rxz/zklCgmkJ5akZqemFqQWwfQxcXBKNTC5/efTidJsmtZUbd2RJHVg
        eUla90SjGwzyis+DXk9rM7aXeKhYfGzFilzJM7lbfk9LnqbAuadBTON7z94A+zBl+8RzB/8p
        zGJ5rMvf8+lv0cn55jPWPFWtCDhukn3A74TBq7TfFzdvc1djXZ0XyWyxsOyLuVy9558nEo7r
        fW9Yv98bnqSj8e9s7yr9NJnTP/yYHPvsOLrEqkVsb/Z9k/vkklb4t/7lgkUbuMvFc99+nTVn
        YSqj3j21/w+/NkX2azEYmyydLKZ3dz3DY5OPrSb9ZsunHCnt4dD+sO3IIR/tXvfWSbuuJTs/
        un3GWEG3556Lv5nl8ZIYY9mUG1IfnXTkbFfG59UF7Cz5UFJxRYmlOCPRUIu5qDgRALKmWFdu
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEgyOrJSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXF6zVb2gl2cFYe2
        vGVqYFzO0cXIySEhYCLR+/glaxcjF4eQwG5GiUdv9jNDJGQlnr3bwQ5hC0vcbznCCmILCbxn
        lNh/QgbEZhPQldjy/BUjiC0i8JFRYs43LZBBzAJLmCUaD8xjAkkIC0RITHp6jA3EZhFQlTi2
        YBlYnFfAQWLz3k6oBfISR351gi3mBIrf2vWfEWKZvcTEyYsYIeoFJU7OfMICYjMD1Tdvnc08
        gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxguNNS3MH4/ZVH/QO
        MTJxMB5ilOBgVhLhvVDjmCjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC
        1CKYLBMHp1QDk+mceTFn/oadP7pfuPrVpByO3Vv/3o84deejpPGDaS9ve+vxzmmI/7x0wQox
        Xe/Na6++KbafebYsgaNA2/G9iE7xnCm/d+b/dN3m3aTLWcn/wcyvM+x3R9btE68dKnJcXd+b
        OejefR7fcn630aTVEo2nBM7zp3SwKHqqFTvaK9uZhLFs4757bIJ+BkPgzPgvG1nsTCd77Uo8
        ci3Uru+DQEtb5arJE17OeRigPGfLorufPKyyFC40bvB5s+jUqZAPOY1Xo3ec55K1Wxx48cmT
        uoYjrmtOrLFvFvy45Elub4j3Z/kvGZWzpr73e/TIUFPFcOG8Ke+PKHk87vq9xfTn889zd0zQ
        55l/78mLHBGh71uUWIozEg21mIuKEwFj7u5+JgMAAA==
X-CMS-MailID: 20210917065523epcas2p15b648b88af85252fe12ff8026307526a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p15b648b88af85252fe12ff8026307526a
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p15b648b88af85252fe12ff8026307526a@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 2024e44a09d7..e32f7d09db1a 100644
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
2.33.0

