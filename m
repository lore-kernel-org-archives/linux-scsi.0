Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12DCC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC67A610A1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJRMre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52842 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhJRMr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:26 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018124511epoutp02f15070e2d5762403d2963a9987b9777e~vIKvG7LnA0052800528epoutp02b
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018124511epoutp02f15070e2d5762403d2963a9987b9777e~vIKvG7LnA0052800528epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561111;
        bh=s/NRKLGG+cLII4ky6u5V4JB+gZHADy01q1qEGPQRDqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf8+yZhlJmA2mgAz7iHutYeTUrme78N1sFQxFHFZ09nugHUe9F/el+2Hw4yVnQMaZ
         tPjdz2FUWp8lF12Ms+t1s8GzBW2jpTIT3Ybr+icpHqoFRikfdshkoqI2ygKkBjK2i9
         sqHQZU5/h6iIZvrzYa4DZDSM+h03fMTXozN6s+Ok=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211018124511epcas2p25aad19d66e84b9b63243071a2e93b656~vIKug9BaP2095320953epcas2p2M;
        Mon, 18 Oct 2021 12:45:11 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.101]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HXxRQ0Y7Lz4x9Q3; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.6A.10018.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2~vIKo2oi350992709927epcas2p2T;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp292c1a82500ae966c07a757e0ad3bdb51~vIKoyxQlv2052720527epsmtrp2I;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-54-616d6c51edbe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.40.08738.05C6D616; Mon, 18 Oct 2021 21:45:04 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124504epsmtip29aaa3e2dbefe57254e2bc2cbf686d8f5~vIKohxxG30235802358epsmtip2s;
        Mon, 18 Oct 2021 12:45:04 +0000 (GMT)
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
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v5 01/15] scsi: ufs: add quirk to handle broken UIC command
Date:   Mon, 18 Oct 2021 21:42:02 +0900
Message-Id: <20211018124216.153072-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjeube9LUrxroKesIDNZc5QV2wJH4dNBg4kN4M0fGQ6tzl2gTvK
        6BdtcWqyyObkG60RRQqBCUa2jo0BtQIqlo9IkDiSMQa46Aa2cTTIxDomkM21tm7+e97zPs/7
        5HnPOXxcOEcE8wvUBlanZpQUsY5jHQqPlWQoVYx0pel1NGpvJ9BvTVYCza9MEmhgtoKDzjxY
        wdHDjgtcNHFtO6ruTUJjxhYM2TtMOGqZtmJoerWUi77+GaHO+48xdHa8H0NVUz0Eahv5B0Nr
        K4NYopCe+CmVNpXUEPTE8RqM7v5KTLdemcfoLnMFQRtbbID+q6OcoJcctzj0cYsZ0K6uULrM
        VoWl+79buFPBMnmsTsSqczV5Ber8eCo1KzspOzpGKpPI4lAsJVIzKjaeSk5Ll6QUKN3ZKNEB
        RlnsPkpn9Hpqxxs7dZpiAytSaPSGeIrV5im1sdoIPaPSF6vzI9Ss4TWZVBoZ7SZ+WKhwLNuA
        tnPDwSdjRqwEzPtXAj8+JKNgmfMirxKs4wvJHgAHjo4T3uIhgObycl/hArD/2C/cZ5Jzi3cw
        b6MPwC7rJZ9+CcBTj85jHhZBSqDlnhN4GoHkHwDa79Y+ZeHkPA4nR108D2sjmQqrHYtuFp/P
        IbfCKw1veo4FZAI8Z63CvHZb4PBqBe7BfmQirG4ZxrycF+FovZ3jwbibc/RiA+6ZD8nf+XDG
        /D3PMxOSyfBOmy/pRugcsfC8OBi6Fq8SXn4VgMfmnvga3wBY8VmaFyfA1ToL1zMHJ8NhR98O
        78gwOHzLZxsAy4f+9jkJYHmp0CvcBm2X6jheHAKrGl2+xdGwd9bi29Upt9FCGWYEItNzaUzP
        pTH9b/wlwM1gE6vVq/JZfaQ28r8rztWousDTxy5O6QG19x9EDAKMDwYB5ONUoCBnt4oRCvKY
        Q4dZnSZbV6xk9YMg2r3qk3hwUK7G/VvUhmxZVJw0KiZGFhsZLY2lNgviggoZIZnPGNhCltWy
        umc6jO8XXILZQr5zTQfsLbXsXfQvHTA6G3jOigzhwa1HMtcyTm8XOXt3+z1en1AZ7zyP22ve
        S1Pu6cXXbnywOa0HpnT/OpW91PrxkXHien3owmTNUjN1cw5lvXL68D6NWPD51MmYM8O1xJ5W
        3lDdbesny9/+GZCmkNvjO82mzgOYZSy1rO5u36OwbY2Kj2xvcYkLP0gk8oHMV6WcsENSMtFx
        dZ+kXhkSniyWs/sbr8/UjRjT27NWVC8X7Trx0hehwwH3brfNyuVJRYlFKamhl5eDAt/mEjkN
        66duXp4Wv/PpaF/EDcd884ZmzpZNmasvtHeL9jt/jGq10o6Zhf6GXatN17qRPOf9ubMUR69g
        ZGJcp2f+BXLwHch1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG5ATm6iwZdr1hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi5XX
        LCw2vv3BZDHj/D4mi+7rO9gslh//x2Tx++chJgchj8tXvD1mNfSyeVzu62Xy2LxCy2PxnpdM
        HptWdbJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU1JzMstQifbsEroyn
        3w4wFmzkr/h/egJTA+NLni5GTg4JAROJhe/uMXUxcnEICexglDhzbAsTREJW4tm7HewQtrDE
        /ZYjrBBF7xklfh9sZQRJsAnoSmx5/grMFhH4yCgx55sWSBGzwFdmiU1Hp4FNEhbwluh5+g6o
        iIODRUBVYs9sJ5Awr4C9xMJt3VDL5CWO/OpkBrE5BRwkehYdAYsLAdUsfjmbGaJeUOLkzCcs
        IDYzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzgC
        tbR2MO5Z9UHvECMTB+MhRgkOZiUR3iTX3EQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYL
        CaQnlqRmp6YWpBbBZJk4OKUamPzOCOyo3RXe6TPRoYxXM3FFPL/R79XW+n+fOKc80V5WG3Rq
        x6HVJzPPbN1qwTWLObBMQ79tb8aebyk9oievxIc47557wsNn1dWoPZtPvOqzXj1lm9/R+NN2
        /176/RcQLl5YUrC5/PXjqPncN/V61CRWm+cFxrSe2HUt/NXL3zsiz6StvP+c5dHtG9/i19yz
        PpjEOnndJa6eaVzCFe0X0qM+drvmRrstshGN/B/yKoRT+FhrYtmnI16Rhm9mHVJlqHh8gf+w
        /NaXixl+qh74svHkvsNZ0SwrD3HIlBm1mFdzm6n8YQvT2acmKZ9bz5Rx7t2SP4LVj3g3CU5U
        YHY5/3RNSOqf4/o2FVNWtwTLGyqxFGckGmoxFxUnAgD+1fGeLwMAAA==
X-CMS-MailID: 20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2@epcas2p2.samsung.com>
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
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bd5a088f12c4..3dbfae32599c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2323,6 +2323,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 64ce723327b9..5d39aeb2bccb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -589,6 +589,12 @@ enum ufshcd_quirks {
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

