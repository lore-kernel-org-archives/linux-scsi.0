Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7911EC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F0C20888
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CvoRxINZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgE1Bca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34970 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE1Bc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:29 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200528013226epoutp02c852e6d749d7846f4a8ece2af817dc77~TDSU94udj3019730197epoutp02i
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200528013226epoutp02c852e6d749d7846f4a8ece2af817dc77~TDSU94udj3019730197epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629547;
        bh=HK/1/VP5ov7EOoNpQ0X08DtlhI52O+2EyAZ3cTvlQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvoRxINZ+mTA0agfax3yn8vaVWRUB4f66icmLId8+zfOpcwEMhCYxa0k+OYZEi70Z
         Mucv/EMsS5s7qmzsXpGQwvHBgWolcatxZoJxXRgWUiRlD8T4AnUlsOTxOPQ1/4fwu3
         3dPCOoABm1KZ89Whsp0WX/xXVNzZy36RYPAGx5mg=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200528013226epcas5p17c56ec6d989480e834855950b36e2334~TDSUe02Wh1882918829epcas5p1c;
        Thu, 28 May 2020 01:32:26 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.00.09467.AA41FCE5; Thu, 28 May 2020 10:32:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013226epcas5p1c73527c71424679443c10daf8bf561df~TDSUD0My00728507285epcas5p10;
        Thu, 28 May 2020 01:32:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528013226epsmtrp2285c64bdb564c4513d91654752e6b269~TDSUC227J2107921079epsmtrp2d;
        Thu, 28 May 2020 01:32:26 +0000 (GMT)
X-AuditID: b6c32a49-fba88a80000024fb-0d-5ecf14aa192c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.77.08303.9A41FCE5; Thu, 28 May 2020 10:32:25 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013223epsmtip1efd3432a48365af5ec1348fbaaf4812d~TDSSJ3bxJ1673116731epsmtip1k;
        Thu, 28 May 2020 01:32:23 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Thu, 28 May 2020 06:46:49 +0530
Message-Id: <20200528011658.71590-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZdlhTS3eVyPk4g7XnJS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxouja1gKdgtU7P9wnLmB8TVvFyMnh4SAicTHD2vZuxi5OIQEdjNKHGx/zArh
        fGKUeLziDhOE85lRYvGUB4wwLSvWLGGBSOxilPhxajkrSEJIoIVJYsVsXRCbTUBb4u70LUwg
        toiAsMSRb21gzcwCN5gkHqx0AbGFBUIljuztZAexWQRUJa6dfgtWzytgI3F+z0ZWiGXyEqs3
        HGDuYuTg4BSwldg7wQFkr4RAL4fEn7XT2SFqXCR+rfrNBGELS7w6vgUqLiXx+d1eNpBeCYFs
        iZ5dxhDhGoml846xQNj2EgeuzGEBKWEW0JRYv0sf4ko+id7fT5ggOnklOtqEIKpVJZrfXYXq
        lJaY2N0NdaSHxKpDB9kgITKBUWLbr7/sExhlZyFMXcDIuIpRMrWgODc9tdi0wDAvtVyvODG3
        uDQvXS85P3cTIziZaHnuYLz74IPeIUYmDsZDjBIczEoivE5nT8cJ8aYkVlalFuXHF5XmpBYf
        YpTmYFES51X6cSZOSCA9sSQ1OzW1ILUIJsvEwSnVwDStxFvUST1otld5oEWxBwdf0d1ck2gt
        wXa2pM4CP8PkdTYTH98QY+s3sJwZcuHye/kTJY4JokvtHE4r6+0IFnutnLhvmcilWfHNClsb
        sjZ+vc29/ZWs+Je383u9jJrrJneEFllonvzRUXlc+9WP28y6c5pfiV2/tl3D67TFjtVy/urf
        olcaS71RvSt1Ty+S0+w/e9zjc/bKnesVhVgVdbR2HD64eE7t7ZWad56rztRZN617ZarQC75t
        nXVJX6uzA65lil+8fCirp5fv3m+51z/Fn8lIzo/M3shVv0DG5J7d5Cti1lzVynunySVnN7C4
        vF6+pNlof5Zum8XdGznRp0716hl8uR57VFTccFOTEktxRqKhFnNRcSIAqIW44ZUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnO5KkfNxBidfmFk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujBdH17AU7Bao2P/hOHMD42veLkZODgkBE4kVa5awdDFycQgJ7GCUeNP7gA0i
        IS1xfeMEdghbWGLlv+fsEEVNTBKdDxcwgiTYBLQl7k7fwgRiiwAVHfnWBhZnFnjGJHHqYSmI
        LSwQLHG67z8LiM0ioCpx7fRbsHpeARuJ83s2skIskJdYveEAcxcjBwengK3E3gkOIGEhoJIJ
        q/YyTmDkW8DIsIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIziYtbR2MO5Z9UHvECMT
        B+MhRgkOZiURXqezp+OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUI
        JsvEwSnVwJTxSLjlzsKc9XKPWGZpbv98ZcEv/73uR20Cvi+/f5nxzceo03c2s+Zv5Os04fj/
        dseaKkn27g/HFwQEyv7w15zmsH9Fg7j4nmtXPr1inMd3miXL5N7b/TExDSznvpYav2xauUAt
        Ii1x8QaXx+czah5Yh9212fP4VPO27nlRT/PWbLeMWLhgv4RrwsNL3Ndz2SyUzSqD2ydOFE2b
        WZp6XPpGbSXzx/MPdV1rGE3/r001VZq2+GQt16Fcw2AV940TjsbfilQJ5st0/eAvlH93ffub
        EMbpN77+3vfptm12+nyHF9/li7o4zHdIGlu+sz9zOuI6f3BOjIhquvoCdx5Fw00lTc8+PPug
        Nfl7snTfmRtKLMUZiYZazEXFiQAvvvT61QIAAA==
X-CMS-MailID: 20200528013226epcas5p1c73527c71424679443c10daf8bf561df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013226epcas5p1c73527c71424679443c10daf8bf561df
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013226epcas5p1c73527c71424679443c10daf8bf561df@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..3655b88fc862 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..071f0edf3f64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -518,6 +518,11 @@ enum ufshcd_quirks {
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
 	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+
+	/*
+	 * Clear handling for transfer/task request list is just opposite.
+	 */
+	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

