Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B30AC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 07:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8231A60FED
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 07:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbhHaHNa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 03:13:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37365 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhHaHN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 03:13:29 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210831071233epoutp026fa5ab493cc45c076ab494ec815e9594~gUql8vrsS0555505555epoutp02k
        for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2021 07:12:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210831071233epoutp026fa5ab493cc45c076ab494ec815e9594~gUql8vrsS0555505555epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630393953;
        bh=qzDyuoh7r1pqHPB/YFIdG2NA8YkK9g17BAcmkEHhPkw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=vOavsYbpXMSq5MC9P906QJ2hfkSZPJNX3abku+qIPg/bCwi+66CMYufM9cdM27ECw
         l39w54hJQDiMRbqnyvHCAMgV4ntdE4bwh0yPHmpi+S+hW5Fv8RT4LOhjb9E7WzN32l
         FLINSfDbPjcCK6kuLI2i2AfQ9HzrzFwcJoHzExxg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210831071231epcas1p2fe30f94711250fc0bf4a57df45e8aedf~gUqkkcCQQ2859228592epcas1p2G;
        Tue, 31 Aug 2021 07:12:31 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.38.241]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GzJKp3n79z4x9Pp; Tue, 31 Aug
        2021 07:12:30 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.BB.09827.C56DD216; Tue, 31 Aug 2021 16:12:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210831071227epcas1p188440324d4e68fb5c5ab506e02ee11e7~gUqg_qa710532705327epcas1p10;
        Tue, 31 Aug 2021 07:12:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210831071227epsmtrp1b268924852f32d341c50b7fdcaef0e6d~gUqg9orXD2015020150epsmtrp1g;
        Tue, 31 Aug 2021 07:12:27 +0000 (GMT)
X-AuditID: b6c32a36-1f0ada8000002663-48-612dd65c6222
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.81.08750.B56DD216; Tue, 31 Aug 2021 16:12:27 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210831071227epsmtip28ccd903b99c8e13d1f0ba90038faf75c~gUqgsKH531960319603epsmtip2D;
        Tue, 31 Aug 2021 07:12:27 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, daejun7.park@samsung.com,
        beanhuo@micron.com, stanley.chu@mediatek.com,
        keosung.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com,
        ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: ufshpb: Remove unused parameters
Date:   Tue, 31 Aug 2021 16:04:43 +0900
Message-Id: <20210831070443.25480-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmrm7MNd1EgyXzhCwezNvGZvHy51U2
        i4MPO1ksZpxqY7VY9SDcYt+1k+wWv/6uZ7dYdGMbk8WO52fYLY6ffMdocXnXHDaL7us72CyW
        H//HZNH0Zx+LxdKtNxkd+D0mLDrA6NFycj+Lx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAHs
        Udk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAr0ihNzi0vz0vXyUkusDA0MjEyBChOy
        M5Y8bWMq+M1ZsbbtM1MD41SOLkZODgkBE4mGT/uZuxi5OIQEdjBKvPswixHC+cQosf/2L2aQ
        KiGBz4wSC844wHS8enqbDaJoF6PEtlOn2CGKvjBK3GxW72Lk4GAT0JK4fcwbJCwi0MQksfts
        FUg9s0AXo8Svg10sIAlhARuJOxdmgfWyCKhKXH63gw3E5hWwlljy4zQbxDJ5iT/3e5gh4oIS
        J2c+AetlBoo3b50NdraEwEwOicXrj7NCNLhI/NzTxgxhC0u8Or6FHcKWknjZ38YO0dDMKHFq
        9jkop4VR4vWVG1BVxhKfPn9mBHmBWUBTYv0ufYiwosTO33MZITbzSbz72sMKUiIhwCvR0SYE
        UaIiMafrHBvMro83HkPd4yFx6/EiRkgAxUrcm7OXbQKj/Cwk/8xC8s8shMULGJlXMYqlFhTn
        pqcWGxYYwWM1OT93EyM47WqZ7WCc9PaD3iFGJg7GQ4wSHMxKIrzZb7QShXhTEiurUovy44tK
        c1KLDzGaAkN4IrOUaHI+MPHnlcQbmlgamJgZmVgYWxqbKYnzMr6SSRQSSE8sSc1OTS1ILYLp
        Y+LglGpgWvm/g21i9/rCt1m7frXNNthn/kSJe0HZhiLL16Hb/pWEM/qU9UtO+lFcGqxh0CE/
        t/XGTufKmT9vSM9bpiMyz3i5muitigtth9t/6h7gTq/KVGIo27izraP4FLtM6wX5loYqlp3L
        3MQMDa/HSe+yKutS6rtbEMG0OPVvWONT0+Xuy7y31vX6Wt+7ctHz37KrMysYv0tKfRKqtHqT
        vjzo1t+F1nf67twJdPfsKyz692G6osfXwLkxB96el31R9MI3s9a8zTY4rF1d/qqQ8SKO0K6C
        6rXs5ZlsPrKn/89N/RZ7OGuRlOGEPWm1Bj7/Gf9um2y3PWV5wt9imaPzwnL1Jb9qcmUvsrvY
        MO9lWagSS3FGoqEWc1FxIgCZe2jmRAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvG70Nd1Eg7Y1ChYP5m1js3j58yqb
        xcGHnSwWM061sVqsehBuse/aSXaLX3/Xs1ssurGNyWLH8zPsFsdPvmO0uLxrDptF9/UdbBbL
        j/9jsmj6s4/FYunWm4wO/B4TFh1g9Gg5uZ/F4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgD2
        KC6blNSczLLUIn27BK6MJU/bmAp+c1asbfvM1MA4laOLkZNDQsBE4tXT22xdjFwcQgI7GCVW
        P5vNDJGQkti9/zxQggPIFpY4fLgYouYTo8SLFU8YQeJsAloSt495g8RFBPqYJHauWscI4jAL
        TGCUWHzlLdggYQEbiTsXZrGD2CwCqhKX3+1gA7F5Bawllvw4zQaxTF7iz/0eZoi4oMTJmU9Y
        QGxmoHjz1tnMExj5ZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzgS
        tLR2MO5Z9UHvECMTB+MhRgkOZiUR3uw3WolCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwX
        EkhPLEnNTk0tSC2CyTJxcEo1MHG1rHrplar5+f9NHdZJzZ7Bwqd7znyoPZX+lfeb3c9SF6Xz
        Js3zRdlvFZ/LCTIR8ePatvBgou2+40L7N9dcrZaIy97/4mmngu4r1ajjDqmRJgaxd3mffnlb
        pC/kXZHrEzCP89Or+plL2p6UHVv5/8yN5SYy89Q29t1j/yd6/rXKbsbD/jPWcrF7a/5e1DTL
        46ff3zbzFXwCtS5RCn/r1oq7Sqg8WjBNZ4Uqg9ITG70ga+HcM8Jc5c3ON+/M2rP3QejTAG3b
        WR8PFSucde0SaJeRrOQUW2t2dt+1vfPDdG8nmtRPqxI9ejHMaVnKdFM5DUNnl+XXl1rlpEvK
        OO5Z31MpwPc+Qqy0/+j+91YSSizFGYmGWsxFxYkAsHnoHvMCAAA=
X-CMS-MailID: 20210831071227epcas1p188440324d4e68fb5c5ab506e02ee11e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210831071227epcas1p188440324d4e68fb5c5ab506e02ee11e7
References: <CGME20210831071227epcas1p188440324d4e68fb5c5ab506e02ee11e7@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

Remove unused parameters
* ufshpb_set_hpb_read_to_upiu()
 -> struct ufshpb_lu *hpb
 -> u32 lpn

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 02fb51ae8b25..589af5f6b940 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -333,9 +333,8 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 }
 
 static void
-ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
-			    struct ufshcd_lrb *lrbp, u32 lpn, __be64 ppn,
-			    u8 transfer_len, int read_id)
+ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+			    __be64 ppn, u8 transfer_len, int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 	__be64 ppn_tmp = ppn;
@@ -703,8 +702,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hba, hpb, lrbp, lpn, ppn, transfer_len,
-				    read_id);
+	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
 
 	hpb->stats.hit_cnt++;
 	return 0;
-- 
2.29.0

