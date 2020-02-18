Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206F0C34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 22:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF9F922B48
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 22:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qFeraHGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBRWpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:45:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17082 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgBRWpJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 17:45:09 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200218224507epoutp039c7d96b77b0f5d5352fe202fc2b638c2~0oI_KbgoW0226002260epoutp03I
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 22:45:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200218224507epoutp039c7d96b77b0f5d5352fe202fc2b638c2~0oI_KbgoW0226002260epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582065907;
        bh=7FPK4TNPMxajhwWErt+f0FcjQEMzfSsuFBnDo5KrFcI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qFeraHGxymI/xTfVEmLiJFIvLUrQu2VIW0bDFr58DlO77ImLQvM/AGI06OJy9RXhf
         IltbGsL0tAKpZkaSi8rp0Nh1ZJdFrvhaV2bFRIT0/Ki5ytLOXx/db0zriOpo7VTXI9
         wEJg4AZxPwR2aCt0ZICk3t2z+53LMFMFLf85qywU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200218224506epcas2p46314662b47cef7f9bd34f8312acae315~0oI9sNZlP2050120501epcas2p41;
        Tue, 18 Feb 2020 22:45:06 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 48MbXK5016zMqYkY; Tue, 18 Feb
        2020 22:45:05 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.55.17960.FE86C4E5; Wed, 19 Feb 2020 07:45:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938~0oI6EhLO42050120501epcas2p4r;
        Tue, 18 Feb 2020 22:45:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200218224503epsmtrp24b737c05161d07f1f22a6e4ec3ef91ed~0oI6D3KLn0293102931epsmtrp2h;
        Tue, 18 Feb 2020 22:45:03 +0000 (GMT)
X-AuditID: b6c32a48-10dff70000014628-b8-5e4c68ef40f6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.30.10238.EE86C4E5; Wed, 19 Feb 2020 07:45:02 +0900 (KST)
Received: from tiffany.dsn.sec.samsung.com (unknown [12.36.155.63]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200218224502epsmtip17ee08fc20dcf55a7c0e288707eea9773~0oI55tPI32775727757epsmtip1k;
        Tue, 18 Feb 2020 22:45:02 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH] ufs: add quirk to fix abnormal ocs fatal error
Date:   Wed, 19 Feb 2020 07:43:07 +0900
Message-Id: <20200218224307.8017-1-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.14.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmue77DJ84gwd3dC0W3djGZHFzy1EW
        i+7rO9gslh//x+TA4jFh0QFGj49Pb7F49G1ZxejxeZNcAEtUjk1GamJKapFCal5yfkpmXrqt
        kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvp1NUX5pSapC
        Rn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxpTN69gK9vBUrPx5ka2BcRlX
        FyMnh4SAicTzlRdZQWwhgR2MEosuKHYxcgHZnxglTm1YyAjhfGOUWP7lLhNMx7rp95ggEnsZ
        JbY9PccK4fxglLj9/hwzSBWbgKbE05tTwTpEBAIk7pzawwJiMwuoS+yacAIsLixgL/FnG8gK
        Tg4WAVWJE1e2gMV5BSwlPjR+Y4TYJi/xfsF9sDMkBB6ySsw7/I8dIuEiMeHPbDYIW1ji1fEt
        UHEpic/v9kLF6yX2TW1ghWjuYZR4uu8f1FRjiVnP2oFsDqCLNCXW79IHMSUElCWO3IK6k0+i
        4/Bfdogwr0RHmxBEo7LEr0mToYZISsy8eQdqq4dERwPIWxzAcIiVWDPbewKj7CyE8QsYGVcx
        iqUWFOempxYbFZggx9EmRnAq0vLYwXjgnM8hRgEORiUe3gMXveOEWBPLiitzDzFKcDArifB6
        i3vFCfGmJFZWpRblxxeV5qQWH2I0BYbdRGYp0eR8YJrMK4k3NDUyMzOwNLUwNTOyUBLn3cR9
        M0ZIID2xJDU7NbUgtQimj4mDU6qBcaJrfa3piyAJvfqPl2ac2GPj+WflInE9tmbHuedTgmct
        D1cIDeptr25aMCNT07nh9VL3U9Ghr+653vD4NJl367djSz4sPN/TzuTtvXV2ZZ76K5HjzrOP
        XpFTX7Ir/NM6LYntU8rWTAn3DXg2t7/+Cfu798fn/jspofV3tpTjrLzHPBUHfs/NalFiKc5I
        NNRiLipOBACWjfANWwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsWy7bCSnO67DJ84gye3rC0W3djGZHFzy1EW
        i+7rO9gslh//x+TA4jFh0QFGj49Pb7F49G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aUzevY
        CvbwVKz8eZGtgXEZVxcjJ4eEgInEuun3mLoYuTiEBHYzSjTMmcMEkZCUOLHzOSOELSxxv+UI
        K0TRN0aJmfO7wIrYBDQlnt6cCmaLCARJ/F3yiQXEZhZQl9g14QRYXFjAXuLPtoVgg1gEVCVO
        XNkCFucVsJT40PgNaoG8xPsF9xknMPIsYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yf
        u4kRHB5amjsYLy+JP8QowMGoxMObcd47Tog1say4MvcQowQHs5IIr7e4V5wQb0piZVVqUX58
        UWlOavEhRmkOFiVx3qd5xyKFBNITS1KzU1MLUotgskwcnFINjJxhTxLCsySaLI/1nj055e0v
        RaevaffPy2yI7i8oCzJUcAjkZA5f97PH66LXSw0J22kHPLfofVgb5GsVYrjyW6uhkamByvUn
        Dx2VanlWSWwt8YhnmHnLe3fGS1vJxTcuu97Xipdh5S/StH+Zr+1a51zUruD2xVVqIdOk0IvJ
        FuwiGeY2H+uVWIozEg21mIuKEwGfUxTNCwIAAA==
X-CMS-MailID: 20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938
References: <CGME20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some architectures determines if fatal error for OCS
occurrs to check status in response upiu. This patch
is to prevent from reporting command results with that.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4aa10fdbb0c..39305076051e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4731,6 +4731,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
+		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
+					MASK_RSP_UPIU_RESULT)
+			ocs = OCS_SUCCESS;
+	}
+
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8f516b205c32..4757e1eadee0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -635,6 +635,12 @@ struct ufs_hba {
 	 * enabled via HCE register.
 	 */
 	#define UFSHCI_QUIRK_BROKEN_HCE				0x400
+
+	/*
+	 * This quirk needs to be enabled if the host controller reports
+	 * OCS FATAL ERROR with device error through sense data
+	 */
+	#define UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		0x800
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.14.2

