Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE8FC433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8386722C7B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgLUBbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:31:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30034 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgLUBbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:31:38 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201221013055epoutp044b7c0f936b5b3c3d7da328d9373690c3~SlzFkNDIM1554115541epoutp04F
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:30:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201221013055epoutp044b7c0f936b5b3c3d7da328d9373690c3~SlzFkNDIM1554115541epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608514255;
        bh=YBx4FRQN8FFEpVmEak7+buh0GvhBRpidJQdKl3sdqzE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=rMb68lI0WrmHdDDDTZlp34DYR61SLILcDvcnbthytzrPhOMwYVkf0O5rXO9pEH9nK
         iqstScgubJCLG3BDFNXNOInAR4Urv9xhiqmbj9sT4p8S9guCNASEt9OuNoOtljxudR
         GKI4XuTmfOamD2v4Tzt6kraYeG732gwJ/00icsXQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201221013054epcas2p29981b5ed261162c0579d4728d8a79f52~SlzEWZJkP2122621226epcas2p2Z;
        Mon, 21 Dec 2020 01:30:54 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CzhkM3gV9zMqYkY; Mon, 21 Dec
        2020 01:30:51 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.89.52511.BCAFFDF5; Mon, 21 Dec 2020 10:30:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201221013050epcas2p49a93492e623f0c213abc039b3b8a3922~SlzA1j0Vc3222732227epcas2p4t;
        Mon, 21 Dec 2020 01:30:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201221013050epsmtrp205e37f1761108b6f16859091c5d06cca~SlzAz_flv2868528685epsmtrp2U;
        Mon, 21 Dec 2020 01:30:50 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-5d-5fdffacb3339
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.9A.13470.ACAFFDF5; Mon, 21 Dec 2020 10:30:50 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201221013049epsmtip29afa98794946aa3d9159ed8f24fb60a5~SlzAmw3y82311123111epsmtip2p;
        Mon, 21 Dec 2020 01:30:49 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: relocate flush of exceptional event
Date:   Mon, 21 Dec 2020 10:19:59 +0900
Message-Id: <1608513599-129229-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTTPf0r/vxBhu+s1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk9H04RVrQTd3xev1kxgbGFs4uxg5OSQETCTW71vK1sXIxSEksINRYtGnPSwQzidG
        iTMHfzJBON8YJQ7POs0O03Lj5CFGiMReRonlL09DtfxglOj+8osJpIpNQFPi6c2pYO0iAmeY
        JK61nmUFSTALqEvsmnACrEhYwEai68U7sDiLgKrEteOtYHFeATeJD0ufsEGsk5O4ea6TGWSQ
        hEAjh8Sfnd+hEi4SW+5OY4KwhSVeHd8CdZ+UxOd3e6Fq6iX2TW1ghWjuYZR4uu8fI0TCWGLW
        s3YgmwPoIk2J9bv0QUwJAWWJI7dYIO7kk+g4/JcdIswr0dEmBNGoLPFr0mSoIZISM2/egdrq
        IfFvyRqwV4QEYiUurFjBNIFRdhbC/AWMjKsYxVILinPTU4uNCkyQo2kTIzhJannsYJz99oPe
        IUYmDsZDjBIczEoivGZS9+OFeFMSK6tSi/Lji0pzUosPMZoCw2sis5Rocj4wTeeVxBuaGpmZ
        GViaWpiaGVkoifOGruyLFxJITyxJzU5NLUgtgulj4uCUamCKefj304VUjg8iPocSemeuD63c
        /EW0YUNaAIfd7FXW/H/XKDFxvg5ZbMq56/T1n5fMA2X+pOd90zjhsPOi+8KPyUXWn+UXdwWf
        3GsVt2vdYvvJ326/dz1YO+Ncu8avP52MrultFSx5b8tlW5o2VTi51x9I2HVRrTtkyYbzU2f4
        3ipgPbt0oezS7ihv3v3BC5Vs5nI2JRpE2NtXqXxYvfLrcqfdt+oSdhVLrgxWOnJwU6jgk7Nn
        9z3Zsd/u4eGLHtXF1cvO+Z4Q5kj9vU7Je7lt8vo7XlX+H/dnLdZWmulnmKZy6VnCAcc5vGyz
        mP+86lvWOvu1fYBE9JqqE6LXkpt/2XQpZh6Ly5sRl8sue+iuEktxRqKhFnNRcSIA+7qhCBsE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvO6pX/fjDc58YLN4MG8bm8XethPs
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fm
        sfz4PyaLrrs3GC2W/nvL4sDvcfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNo
        P9DNFMARxWWTkpqTWZZapG+XwJXR9OEVa0E3d8Xr9ZMYGxhbOLsYOTkkBEwkbpw8xNjFyMUh
        JLCbUWLV5C52iISkxImdzxkhbGGJ+y1HWCGKvjFKrH/5iQUkwSagKfH05lQmkISIwD0miUsT
        5jKDJJgF1CV2TTjBBGILC9hIdL14xwpiswioSlw73goW5xVwk/iw9AkbxAY5iZvnOpknMPIs
        YGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHLRamjsYt6/6oHeIkYmD8RCjBAez
        kgivmdT9eCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqY
        GLpe2H6TDPbYanon7tEH3Ql7txpfl7PVbtm+3th+em4upxtzOKuHfeKTVevfdlRZzBO7u2L3
        h6BfO0rKjN8pcPKo9ffwp5hvimM93Sdv8Fpybrt35baqvzOY76hsUr+9cGZrf9LJ0PjNRgtm
        r8nJurbEZUe3/c+6xCdzBJpiKnKuMSSb3oqZqf2w5cYPxhXvW/R+3y2/y5i/w6arYm9x7+/g
        6c4zZqkeWXy8uXHzn+6tZaXf+Z+fuMtr/Y2tW+acxgEjvZ2T5BeoS68t4u52CWDj2bW25Rzr
        M16LrLB9QmuUZHZdX/f9THTWg71stiHLjz/1c+jm+3TBnD/5/dp1pzVnq3NOaXb7yvH9xQkj
        JZbijERDLeai4kQARb3yJskCAAA=
X-CMS-MailID: 20201221013050epcas2p49a93492e623f0c213abc039b3b8a3922
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221013050epcas2p49a93492e623f0c213abc039b3b8a3922
References: <CGME20201221013050epcas2p49a93492e623f0c213abc039b3b8a3922@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2: modify prefix and addded tags

I found one case as follows and the current flush
location doesn't guarantee disabling BKOPS in the
case of requsting device power off.
1) The exceptional event handler is queued.
2) ufs suspend starts with a request of device power off
3) BKOPS is disabled in ufs suspend
4) The queued work for the handler is done and BKOPS
is enabled again.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..414025c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8608,6 +8608,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			ufshcd_wb_need_flush(hba));
 	}
 
+	flush_work(&hba->eeh_work);
+
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
 		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
 		    !ufshcd_is_runtime_pm(pm_op)) {
@@ -8622,8 +8624,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		}
 	}
 
-	flush_work(&hba->eeh_work);
-
 	/*
 	 * In the case of DeepSleep, the device is expected to remain powered
 	 * with the link off, so do not check for bkops.
-- 
2.7.4

