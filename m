Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A709C3A5A0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 810F522250
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NcF8kzSR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgDQSKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11665 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbgDQSKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:18 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200417181010epoutp03abc22c5a4a106ad5763804e80e3595fd~Grcwj08ag0168001680epoutp034
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200417181010epoutp03abc22c5a4a106ad5763804e80e3595fd~Grcwj08ag0168001680epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147011;
        bh=RGpDjOip8NxrtFUkwIRsldggJ3prXwHbaBTjKYt8Ygc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcF8kzSRfcRHUrBFnP8NWvppwMQcxB8Lr3IUOUQfthP4bfGHVgVgAJvER+7mWxu53
         acHoe4mWs2VRTAvNUV+PoLqhzi0SWGTj6XRVw/Fqe9S/gj+nfmmoe8gfQR2v72W9fh
         FaHLd2uTy1sVhoyMUTRHUTl+WxYfOYZ8i4VLJTQQ=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200417181010epcas5p4a10985d225b7584ed00c2145a64271f2~GrcwHwD7Q1060310603epcas5p4p;
        Fri, 17 Apr 2020 18:10:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.16.04778.201F99E5; Sat, 18 Apr 2020 03:10:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200417181010epcas5p23cb018eee5b7ae0eba87d81dbaaec3ce~Grcv0msIw2908329083epcas5p20;
        Fri, 17 Apr 2020 18:10:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200417181010epsmtrp24978e105a8b2faae4cb769500324dd65~Grcvz1gql1697716977epsmtrp2j;
        Fri, 17 Apr 2020 18:10:10 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-17-5e99f102e28d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.DE.04158.101F99E5; Sat, 18 Apr 2020 03:10:10 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181008epsmtip115c231bb619ac7f04509b08173b6dbf4~Grct9rDqd2094920949epsmtip1F;
        Fri, 17 Apr 2020 18:10:08 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Date:   Fri, 17 Apr 2020 23:29:36 +0530
Message-Id: <20200417175944.47189-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdlhTXZfp48w4g9c7pC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxq6+1ywFq3gqzh27ytbAuIKri5GTQ0LARGLO3r9sXYxcHEICuxkl2idfYIZw
        PjFK3F54nQWkSkjgG5AzJR6mY/LhaSwQRXsZJeb1PWKEcFqYJM4+OMQKUsUmoC1xd/oWJhBb
        REBY4si3NkYQm1ngBpPEg5UuILawQLTErj+bwDawCKhKvJ61E6yGV8BGYt/PY8wQ2+QlVm84
        AGZzCthKtLUsZQJZJiFwm01i/nyIoRICLhJbls1gg7CFJV4d38IOYUtJfH63FyjOAWRnS/Ts
        MoYI10gsnXeMBcK2lzhwZQ4LSAmzgKbE+l36EGfySfT+fsIE0ckr0dEmBFGtKtH87ipUp7TE
        xO5uVogSD4mv8/MgoTCBUeLis0+sExhlZyEMXcDIuIpRMrWgODc9tdi0wCgvtVyvODG3uDQv
        XS85P3cTIziZaHntYFx2zucQowAHoxIPb0ffzDgh1sSy4srcQ4wSHMxKIrwH3YBCvCmJlVWp
        RfnxRaU5qcWHGKU5WJTEeSexXo0REkhPLEnNTk0tSC2CyTJxcEo1MNq1Mt73+uuq+mPW+q5D
        xx9Yr2G5P9VG1/P647/OHW1n2UQYO1p/G+3+uvhjdoqk8bbkLhPFBLV7qxfqHO+bEHGEuZ+p
        OdR6VeZT3U2PJTbszjnCzSD4ni1t542NTbabT07+8+mhwFfBDWmT/xxYcGNdkd37ffOTHZdv
        l6y+I1Y+L6gzPuTk521KLMUZiYZazEXFiQAhvbKPIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnC7Tx5lxBv9fMVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujF19r1kKVvFUnDt2la2BcQVXFyMnh4SAicTkw9NYuhi5OIQEdjNKrDj7kQ0i
        IS1xfeMEdghbWGLlv+fsEEVNTBJv7mxmBEmwCWhL3J2+hQnEFgEqOvKtDSzOLPCMSeLUw1IQ
        W1ggUqL59gJmEJtFQFXi9aydYDW8AjYS+34eY4ZYIC+xesMBMJtTwFairWUp0EwOoGU2Ehue
        xExg5FvAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4mLW0djCeOBF/iFGAg1GJ
        h7ejb2acEGtiWXFl7iFGCQ5mJRHeg25AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzy+ccihQTS
        E0tSs1NTC1KLYLJMHJxSDYzcc3W1klVY2navfr7L9uJctu6fzV+i/3M7S8k7zOZveVg20fDO
        oRKhD0smlk34Jdh2cdKuOW5vFjgm8UheF/qavvZXn1nRf1Pl9XkqnX6dVfxvNGOKdMVjfXN2
        nnPhZZ8ayF/Ps5M7auEMW6agwrZkxbcLcxJO/N4crVcRPDsieGZXgtMMGyWW4oxEQy3mouJE
        AFIhEJtiAgAA
X-CMS-MailID: 20200417181010epcas5p23cb018eee5b7ae0eba87d81dbaaec3ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181010epcas5p23cb018eee5b7ae0eba87d81dbaaec3ce
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181010epcas5p23cb018eee5b7ae0eba87d81dbaaec3ce@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers support interrupt aggregation but don't allow
resetting counter and timer in software.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3655b88fc862..0e9704da58bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,7 +4884,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 071f0edf3f64..53096642f9a8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -523,6 +523,12 @@ enum ufshcd_quirks {
 	 * Clear handling for transfer/task request list is just opposite.
 	 */
 	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
+
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

