Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1893C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D446112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhIQG5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29074 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238174AbhIQG4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:53 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065527epoutp04b7c977b36f2d6f3742963c3df65f7554~liZhXuZOX2950429504epoutp04M
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065527epoutp04b7c977b36f2d6f3742963c3df65f7554~liZhXuZOX2950429504epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861727;
        bh=IXVj5Waay/hQadpvtal/iLGeiq/eGtXYjqtoTXuAkXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiNTgJwu4Qb8QnQaoT9lRQR22tGNugq0GNwupwgnqlIDY99OLRIchNsgMAM6qffz4
         jHVDomedWcNx2u77BVyUueumIYyyT1/pvmQjDWYHttfTsIH3gAj4eG92cF0RjmhT6W
         656XkecRi4uCQMqSUT7SkANPUjIkuffa3Y9X9/xw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210917065526epcas2p44e088ca420ba44f934abc5c413d0e909~liZgZ6rbM0164301643epcas2p4a;
        Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H9l8C3sHnz4x9QJ; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.DF.09472.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052~liZdBULDl1208812088epcas2p4d;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065522epsmtrp2e333dddf0c5240ec1c4a6559823b89cb~liZc-8Cmw1373513735epsmtrp2A;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-43-61443bdbc118
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.10.09091.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip239db9bfc3eaa35eb0e6ff15762bffe4a~liZcx0Jwr2199021990epsmtip2r;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
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
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 01/17] scsi: ufs: add quirk to handle broken UIC command
Date:   Fri, 17 Sep 2021 15:54:20 +0900
Message-Id: <20210917065436.145629-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxTefa99FKTsUQTvSJzdc26jjB+tll02CjIIvghmJMsy45bgG7xQ
        ttI2fe2izmSA2/hRIRAcaBlOMRuKLh0MamUWGNQh0QgZjHU1IAIOZJGBoBNEXMurGf9955zv
        u985594rwiUuIlyUpzWyBi2joYgAga0nIi7q5lupTOxisQT1TV4g0NhJG4HuLv1OoF9ulwpQ
        zdwSju5bvxeiwc5IdPRSCrpW2YChSasFRw0uG4bODSPUfO8Rho73d2DI/IedQI29q9hOkh4c
        SqctBeUEPVhRjtE/nZXRZy7fxeiWplKCrmzoAvS/1hKCnr/jFtAVrU2AXmh5kS7uMmOZgfs0
        CWqWyWENUlabrcvJ0+aqqPR3s1KylHGx8ih5PHqDkmqZfFZFpWZkRqXlaTwTUdJPGY3Jk8pk
        OI6KSUww6ExGVqrWcUYVxepzNHq5XB/NMfmcSZsbna3Lf1MeG6tQepj7NeozZpn+SdCBvvFO
        UADaA8uAvwiSO+BYfQ3uxRLSDuCJ5vgyEODB9wF8NNGG88FDAP9q7MWfKXqtdiFfcAA4UL3s
        Y80D2Nk2D7wsgoyCrVMzwFvYSP4D4OTEMT9vgJMncTg99gVRBkSiEDId/ubM8AoE5DY4WtW3
        ZiEmk+Bg46KAt9sCncula3l/cid0tz8FPCcY9p2YXOPgHs6Rtrq1LiDpEkHHSp2v11R4q+6o
        76AQONPb6sfjcLgw6yB4gRnAL8ef+grnASwtzOBxElyubRV6G8XJCGhtj/FCSG6FTrfPNwiW
        9Dzx49NiWPKVhBe+Crsu1vpcN0PzNwtCHtPwR8cPfvyyqgF8PHhZWAmklnXjWNaNY/nf+BTA
        m0AYq+fyc1lOod+x/oZbwNoTl9F2UHdvLrobYCLQDaAIpzaKBw4nMxJxDnPwEGvQZRlMGpbr
        BkrPsqvw8NBsneePaI1ZcqUiLi42XomUcQpEbRLXr77NSMhcxsh+wrJ61vBMh4n8wwuwC6Eq
        KeW6cukjsflBSfRAsP6cZd+plbDIwwtuoV0pU31umq56vqPZ3PkcZu1Kn+l77NrQrcEjskfg
        HCK233jZ9mCJiWECdcUV9iD3CyO5SRWN1K3Q0kNfXx82LO5tFf16rSz7av3u6k0JNQe2p8GR
        xdHV4pqJleECx4Z+9bdG8+uRtzUfYLVy20sOZ/KuKVfI7EzPVPor+YXTW/78eOrI8ObXipjm
        oeN/NxreHzZeUV6sdQbfzHiYTLwXCW3Xfz4mSDz/jnG8u3zvwlARd/ZgScTWVEthx/7TdKL1
        zq7ktKK8gO/IPbPTIfWqD+NT2q6GzTDbPlOkjLbJ1TXhewpv2PspAadm5DLcwDH/AVEK6G5r
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvO4ta5dEg4aFKhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLlNQuLjW9/
        MFnMOL+PyaL7+g42i+XH/zE5CHhcvuLtMauhl83jcl8vk8fmFVoei/e8ZPLYtKqTzWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBlLO7WKvjLV3Hy0X7G
        BsZdPF2MnBwSAiYSx9fvYO1i5OIQEtjNKLF+00cWiISsxLN3O9ghbGGJ+y1HoIreM0psONfA
        BJJgE9CV2PL8FSOILSLwkVFizjctkCJmgRXMEksvbQeaxMEhLOAtcemID0gNi4CqxL2JJ5lB
        bF4Be4nLy79ALZOXOPKrEyzOKeAgcWvXf7CZQkA1EycvYoSoF5Q4OfMJWD0zUH3z1tnMExgF
        ZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzjWtDR3MG5f9UHvECMT
        B+MhRgkOZiUR3gs1jolCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MHm+2ir/P5tdQVxn6+mw9GP8vgIrlxo93F1+MuBW5NPH72ZctQxRcy88u/ehZoZc
        sun7yWd/HZ+iedhVVnhaR5r1pns26ptvnBda+iHmsUOR7LuE2Bu5O0x7f01wW6i0LtXoQ0TR
        VeWHDu4/Ll8wk70o/n6Vc49QwSoOj+27+tl8P8U1Xa2Kiv4iEaZqGPWgTf6/sc33kkaFPhnt
        wKdfmp1kf5yVMPttaG2bPrOffwL3/7Lp0mtnztyYe1ecI/X9i6k1wu9fHejdtM7g0C1PyfMz
        PuXdm/UjetbeM4evJtZt+2jne/XT5RdpbyeeDmOpEa2rXvt1rnNDrIf3uqsTrijsbNl0z0om
        oZlf03ayl50SS3FGoqEWc1FxIgD0mycMJAMAAA==
X-CMS-MailID: 20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p49ce06e9686c9b6f5cb1dd16ca9d82052@epcas2p4.samsung.com>
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

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..8a45e8c05965 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2324,6 +2324,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..e1d8fd432614 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -588,6 +588,12 @@ enum ufshcd_quirks {
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
2.33.0

