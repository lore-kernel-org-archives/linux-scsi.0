Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2704FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA1260D42
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbhIMINO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:13:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44521 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbhIMINM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 04:13:12 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210913081155epoutp042776bbb245e146b4c573aa98674dc2b5~kU3JMUrrh2102621026epoutp04Y
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 08:11:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210913081155epoutp042776bbb245e146b4c573aa98674dc2b5~kU3JMUrrh2102621026epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631520715;
        bh=qkn/feqQnJexSTxjhu5p2rZcvkOa0ceuyo47ocuUOgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=TgXhqE6D2aTi9XkWiexdeti6SkMavqFHP8TJjj4MaafDkA+gP5EKZ66cUJrcFeCa1
         T2m4pf+vFhjzud2oGF1SQgwhYZK61GAHztnXEUELKnHlxPbzerb8SVcUiNI+nmNMhA
         53yFpKIqVatb1Jh5F82ITOL3xZWNev0FVZRyS07k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210913081154epcas2p3f934a781ed0a6c2720e5ebf0e1bf6478~kU3IZxgWt0226702267epcas2p31;
        Mon, 13 Sep 2021 08:11:54 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H7K2H5HRjz4x9QQ; Mon, 13 Sep
        2021 08:11:51 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.AC.09472.6C70F316; Mon, 13 Sep 2021 17:11:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059~kU3EMZ-h_0432704327epcas2p1M;
        Mon, 13 Sep 2021 08:11:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210913081150epsmtrp1966de2a11b7ace4b037f942849b1c8dc~kU3ELh4ON1350813508epsmtrp1d;
        Mon, 13 Sep 2021 08:11:50 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-f7-613f07c64b01
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.DD.09091.5C70F316; Mon, 13 Sep 2021 17:11:49 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210913081149epsmtip13f1635850f653b72f57518d395b1b1ed~kU3D8Mdst0411604116epsmtip1v;
        Mon, 13 Sep 2021 08:11:49 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
Date:   Mon, 13 Sep 2021 16:55:53 +0900
Message-Id: <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmue4xdvtEgz9/pCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJV
        JuRkHHtwnr1guUDFkePvmRoYL/J2MXJySAiYSDyePoGxi5GLQ0hgB6PE3JUTWCGcT4wSN391
        skE43xglZk2axgbTsnn1H6iWvYwSjy7fYoFwfjBKnO/+xARSxSagKfH05lQwW0RgH5PE0V3p
        IDazgLrErgknwOLCAuYSLx92gtksAqoSezZeZwWxeQWiJabdWs0KsU1O4ua5TmYQm1PAUuL+
        X4heBJsLqGYqh8TjpwvZIRpcJB42nWKEsIUlXh3fAhWXknjZ3wZl10vsm9rACtHcwyjxdN8/
        qAZjiVnP2oFsDqBLNSXW79IHMSUElCWOgDwJcj+fRMfhv+wQYV6JjjYhiEZliV+TJkMNkZSY
        efMO1CYPiQlP2qCBBbSp9ep9pgmM8rMQFixgZFzFKJZaUJybnlpsVGCCHH2bGMHJVMtjB+Ps
        tx/0DjEycTAeYpTgYFYS4d32xjZRiDclsbIqtSg/vqg0J7X4EKMpMCAnMkuJJucD03leSbyh
        qZGZmYGlqYWpmZGFkjjv+deWiUIC6YklqdmpqQWpRTB9TBycUg1M0np8n3p5Hm2fZheUum3/
        Ru4P7wy7WkxMuSZNXy5x2/xhDefmnf+Zz8Ue/vb529m4k9uO8P4uDcwprrq6heXbQVmBx7e2
        7ngjHhS7uer/jMzLMo8XO1y4wNU1hcN4h9IRFs6Fc8rvb512+MGsZUs8N7W+1mSx9Jv3mWGG
        ZtCrz23GGfHuuvc9074p5gskXyjiKthX+avfbhVP3Wup0s6nxzdXVxacO1F2/qvHo5TEvlXt
        CfJ/2U9PPSYkPu/U00neu57GhFzSu2gvaTA7YkrdFkGTyzu+5bbWzHA2XpvW+XnRC+G94b31
        W97fPPfF3OTZDC31NIkVNttj9msu2aIR3+92QtqShWmzQPOy6w8ffVJiKc5INNRiLipOBABv
        sh8MLwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO5RdvtEg4crTC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKK4bFJSczLLUov07RK4Mo49OM9esFyg4sjx90wNjBd5uxg5OSQETCQ2r/7D2MXIxSEksJtR
        4tHBlywQCUmJEzufM0LYwhL3W46wQhR9Y5TYeecfM0iCTUBT4unNqUwgCRGBc0wSUy8vZQJJ
        MAuoS+yacALMFhYwl3j5sBPMZhFQldiz8ToriM0rEC0x7dZqVogNchI3z3WCDeUUsJS4/xei
        V0jAQqJ/8yZGXOITGAUWMDKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjgYtzR2M
        21d90DvEyMTBeIhRgoNZSYR32xvbRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeW
        pGanphakFsFkmTg4pRqYLh16/OdPQjGvQMC3zWIP16+90xZTVrzDI83kv1OLtYCsdc3svP9p
        fQdO2/6LNud9d/1Mw8SpFd7BCiUCXxttLRjSmYKf3fijxlY+20DvyAf27affFFxaoP6Id4e3
        wkr7n2viC//7n/H//v6O36YHQfqxU+4rvDvn94/fKdzBqUoyp+hF9/dJm199Vv53238Vqy2j
        LEfNusyZxc/qZ6wMCss1aH/MxLi01XeWRLP3+g5p0RL7Vy/DkxgfCHYb5x5junXygdLMpYUh
        Z5X4a7I0FG4unXLudqSwYOV7/pStqccX7djx53/bFcuOnUYmDHO32/3/JFMWrMf2t2Lh8jjv
        Zd7SSy8u+xnx7t9sLf9aJZbijERDLeai4kQACO/QrfUCAAA=
X-CMS-MailID: 20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to activate some interrupt sources
that aren't defined in UFSHCI specifications. Those
purpose could be error handling, workaround or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++++++++++-
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49..604c505 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -218,6 +218,13 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+static inline irqreturn_t
+ufshcd_vendor_isr_def(struct ufs_hba *hba)
+{
+	return IRQ_NONE;
+}
+DEFINE_STATIC_CALL(vendor_isr, ufshcd_vendor_isr_def);
+
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -6445,7 +6452,9 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
  */
 static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
-	irqreturn_t retval = IRQ_NONE;
+	irqreturn_t retval;
+
+	retval = static_call(vendor_isr)(hba);
 
 	if (intr_status & UFSHCD_UIC_MASK)
 		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
@@ -8533,6 +8542,9 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 	if (err)
 		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
 			__func__, ufshcd_get_var_name(hba), err);
+
+	if (hba->vops->intr)
+		static_call_update(vendor_isr, *hba->vops->intr);
 out:
 	return err;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f3..7af5d5b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	irqreturn_t	(*intr)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.7.4

