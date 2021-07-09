Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F319BC11F66
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF9B961221
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhGIHAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50443 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhGIHAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:35 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065750epoutp031a025309f9acb323a20b7dde052339b4~QDRnxBjf42276222762epoutp03i
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065750epoutp031a025309f9acb323a20b7dde052339b4~QDRnxBjf42276222762epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813870;
        bh=ZaMi4QacgtlRAgjhOjwhR1V6/hTtev/Lnt+7zdF5Yl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHc9iXlToUfoBXNM8oNYUJ05PIvWGdqlbpB1CKX8UBggd/YWEV2+038SBQXku2I1o
         QvDhzaTwYNqBK6i2wt9T+DUnAxP+sS85nOTSSAop528y6/PhMakEDRKZTkuCJz7Ofb
         PPHy0lB5fniCpyj5WZ9hddDCWhBpRJbsjOj6wa3c=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p304b4086b18a092dca32dc9d40030bdce~QDRmurVcD2702827028epcas2p3t;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkWH2yPFz4x9QC; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.D4.09541.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p1b3e10cef9024d2092b019bddd7580256~QDRkTpXG52881228812epcas2p1F;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp22428ed66ebaafcc89578a096c14f5f0d~QDRkS3qzU0268602686epsmtrp26;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a46-095ff70000002545-64-60e7f36b403b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2e9d196d81ad10241ce924ecd94b448aa~QDRkEvZDA3177431774epsmtip2f;
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
Subject: [PATCH 08/15] scsi: ufs: ufs-exynos: correct timeout value setting
 registers
Date:   Fri,  9 Jul 2021 15:57:04 +0900
Message-Id: <20210709065711.25195-9-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmqW725+cJBjM6BSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXVI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
        i0+ArltmDtALSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS9
        5PxcK0MDAyNToMqEnIzOx1dZClZyVOya8ZyxgXEpexcjJ4eEgIlEx4RjjF2MXBxCAjsYJfrW
        f2OBcD4xSlxYe4cVwvnGKPHs0FG4lrmzX0NV7WWUmN72mwUkISTwkVHi+rZcEJtNQFdiy/NX
        YHNFBPoZJZbvnwvWwSxwklni9IKDYKOEBcIlPpx7DtbNIqAqsbfhIzOIzStgJ9HU18UIsU5e
        4tSyg0wgNqeAvcS8HxOYIGoEJU7OfALWywxU07x1NjPIAgmBAxwSWyf0QzW7SPya0skEYQtL
        vDq+BeoHKYnP7/ayQTR0M0q0PvoPlVjNKNHZ6ANh20v8mr4FGAIcQBs0Jdbv0gcxJQSUJY7c
        gtrLJ9Fx+C87RJhXoqNNCKJRXeLA9uksELasRPecz6wQtofEwZmTmSAhNwkYKKeamScwKsxC
        8s4sJO/MQli8gJF5FaNYakFxbnpqsVGBEXIcb2IEp2ottx2MU95+0DvEyMTBeIhRgoNZSYTX
        aMazBCHelMTKqtSi/Pii0pzU4kOMpsDAnsgsJZqcD8wWeSXxhqZGZmYGlqYWpmZGFkrivBzs
        hxKEBNITS1KzU1MLUotg+pg4OKUamCr/d2+zfzTBo6qcj+Pb5Q3KixT162zLku7lRkSLZq/b
        cZhJ2HNDQufdQ1dry3y1Z3GVm6tu2vv71P6+fskr5bb/lT13xsYJt+u7eL10+Z25QlezpcQx
        9VSSaQYXV+Sq7Dk+hQFp5oZ3s7Ik2Llq+B5snqI5U95lmvPj6vwJXF2Gb6/7m/15tHVivskJ
        lafzhRn1/tlU8c5I7Z16tE1iSv9Ke63I94yXihU6+kvlVdUNj7y+UTvnyJQu/u7Fs56JyRdc
        Djrz0Nr3UnlHoUqUWJLF+aDznNpGYpPus53aoFH2S2wWY0vm+wevorin+E7yFbpl3DHrS8fC
        vCMHlG9eTWszndcglmWyMUcrslaJpTgj0VCLuag4EQALw118XgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg3fTdC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAldG5+OrLAUrOSp2zXjO2MC4lL2LkZNDQsBEYu7s
        1yxdjFwcQgK7GSWWbPrIDJGQlXj2bgdUkbDE/ZYjrCC2kMB7RonbL01BbDYBXYktz18xgtgi
        AhOBmu+JgQxiFrjMLPFt2hWwQcICoRLNE/6CFbEIqErsbYBYwCtgJ9HU18UIsUBe4tSyg0wg
        NqeAvcS8HxOYIJbZSdzbsI8dol5Q4uTMJywgNjNQffPW2cwTGAVmIUnNQpJawMi0ilEytaA4
        Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOJ60NHcwbl/1Qe8QIxMH4yFGCQ5mJRFeoxnPEoR4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgMj9VmuHX6Lk0
        Yf6ai9GT3q5Sfp8QnpnSt+e2CX/1Mh/z9svsEVNTHz/+4PK52f5vWPyad0Xld5dsXbF2wpqf
        Ujuev9NiYshYcsCz93KBQBiDZJ7r57gH709tKIrL2irjbrQ+lF2oNPlD0MpTkkLqOmLzO0+d
        OFf67LFIp6+hVV6w1+WX73vnnZY5euX+lU+Z8poRO1s8gqdFu26LnrVqm7+f9opbngl/Ht7e
        9iXRcnf0v6+/WBW/mFZZf05S3OT1M2nhiZtSixdPDz3Vt3nVvZvrp17j9D1nErAyzXVKlJLD
        grhTC6x+MRxbeMotufSQ1GrHDLlqWfGLrOoH1vZc643X4811+ODaU7i54NsRbSWW4oxEQy3m
        ouJEAOJb9goWAwAA
X-CMS-MailID: 20210709065746epcas2p1b3e10cef9024d2092b019bddd7580256
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p1b3e10cef9024d2092b019bddd7580256
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p1b3e10cef9024d2092b019bddd7580256@epcas2p1.samsung.com>
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

