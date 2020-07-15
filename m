Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BA9C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51FF2072E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rpObkymi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgGOHsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:48:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17570 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbgGOHsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:48:04 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200715074802epoutp024010132620efab0862c972f559acadd3~h3X9dct472952429524epoutp02z
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 07:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200715074802epoutp024010132620efab0862c972f559acadd3~h3X9dct472952429524epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594799282;
        bh=ESW9/859tMw8nuAmuvv783Rqq0SSjQhD6jWoM46pHBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=rpObkymi89L6/4/RXoMUfDFy3Y1nOvRByxGPONEhBkQFFMrcgVwq/JJT+5Msklxk3
         1Kv+UhpgVp2ZiBvrETSIohmWNL0Wgi2zJHVKBcIaqsPBV4xv/v9L5K1yDTuzrnDgE4
         YVLaNGWTB9AjDNjo2HJWSd6Os6N8hC2/WxnmofRY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200715074801epcas2p4f0c39c308a14ee1a955c57762c1f2f7f~h3X83TlR21805018050epcas2p4C;
        Wed, 15 Jul 2020 07:48:01 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B68ct6FkpzMqYkZ; Wed, 15 Jul
        2020 07:47:58 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.B5.19322.EA4BE0F5; Wed, 15 Jul 2020 16:47:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200715074758epcas2p31bd668e519f59a47268bb086363b1826~h3X5xSgHC2699126991epcas2p3a;
        Wed, 15 Jul 2020 07:47:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200715074758epsmtrp2969ddc092d18a51e27034a43d89031c4~h3X5wZuAB3059730597epsmtrp2i;
        Wed, 15 Jul 2020 07:47:58 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-9e-5f0eb4aef711
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.97.08303.EA4BE0F5; Wed, 15 Jul 2020 16:47:58 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200715074757epsmtip224cfbcf25d33244985e6bf548b44b2be~h3X5j-Ru53053030530epsmtip2q;
        Wed, 15 Jul 2020 07:47:57 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v6 1/3] ufs: introduce a callback to get info of command
 completion
Date:   Wed, 15 Jul 2020 16:39:55 +0900
Message-Id: <770fe25cc0210c80fe7a1083a2d31a479afaa548.1594798514.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmqe66LXzxBscPy1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjKuT5/PVjBXsGL9k1a2BsY1fF2MnBwSAiYS/ZuusHYxcnEICexglHj0axkLhPOJUWLGxJ+M
        IFVCAp8ZJY7dLITpuLD4N1THLkaJ3+ufQnX8YJRoebWHBaSKTUBT4unNqUwgCRGBzUwSrxbc
        ZwZJMAuoS+yacIIJxBYWCJX43vCQFcRmEVCVOPRkBdg6XoFoiZ279rFArJOTuHmuE6yXU8BS
        Yt2k8+yobC6gmqkcEq27F7BDNLhIzP70mRHCFpZ4dXwLVFxK4vO7vWwQdr3EvqkNrBDNPYwS
        T/f9g2owlpj1rB3I5gC6VFNi/S59EFNCQFniyC0WiPv5JDoO/2WHCPNKdLQJQTQqS/yaNBlq
        iKTEzJt3oLZ6SNw4e4cNEkBAm/Y1/WeZwCg/C2HBAkbGVYxiqQXFuempxUYFhsjRt4kRnEq1
        XHcwTn77Qe8QIxMH4yFGCQ5mJRFeHi7eeCHelMTKqtSi/Pii0pzU4kOMpsCAnMgsJZqcD0zm
        eSXxhqZGZmYGlqYWpmZGFkrivLmKF+KEBNITS1KzU1MLUotg+pg4OKUamISm9lzs1ExMLv60
        Rujc5l/2DO9tE1a63JbnC4q2ePPar8r5f2xCHOe6rzc3GO5+brCZ6/frffbuH+443vVaVH/V
        5/FGty339n1o/n3c8FRZILPYb5leze6M4wx/n0/lEPiovkHzOt/tWye17PpWrPlp7jEvddOL
        0PxToeoTdIwXtt290vdwr/kqh+B3XC6P1111tN7xp+pkxaHrRgn1ab+WLtM3D1G+ZiiUqW41
        X7IoJTGSbaUX6w/tpNtMtU+eNZx68btnhatulvz5ZyImK2eJZr5Tvr5JYebsf/MedMe99P3T
        bJ3THXjIzObC3YSK23WtC2vnPRVu76z9sevj2Wb+69PmVzCfqU++lVK53E2JpTgj0VCLuag4
        EQBJbzsoLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvO66LXzxBl1T2CwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6M69PnsxXMFaxY/6SVrYFxDV8XIyeHhICJxIXFv1m7GLk4hAR2MEr8
        WHWaGSIhKXFi53NGCFtY4n7LEaiib4wSPZNfgCXYBDQlnt6cygSSEBE4zCTxf+tzdpAEs4C6
        xK4JJ5hAbGGBYIkfV3awgNgsAqoSh56sAGvmFYiW2LlrHwvEBjmJm+c6wTZzClhKrJt0HmyO
        kICFxKZ37xlxiU9gFFjAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4FrS0djDu
        WfVB7xAjEwfjIUYJDmYlEV4eLt54Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxfZy2MExJITyxJ
        zU5NLUgtgskycXBKNTAt3h7j+vxTilWj507llwq2q8t11MWaX/5/NGn//+jeTeIsv3Tdj/A+
        OPhhv+GL+7sezDj8TFx6m71lmKPS5KzIg8lHFyrU/6r+euF7Oo+RsO3Loht69q03uidcTX5Z
        1r//kcGfyXEvbBNWntv/4L9CzIcHRp6yNdOcROV03AP/Z9zZ/ddY+/eiBpl6HoFwC9eNW+vl
        JnlvqMx5a2q4bukKsYfWopduZP2W2ptqlSza48NTI+IzbZrUN63Y3CDFO4/rmI0OfjK5UcXS
        JHmnVEM+5lqvr9jtBxvnf0xt++YTMG9KGZd7h9JmjlczuPUfhkq/men8p5p9xeTtFwsWBfvm
        hDrJz7l0vf+GzOH70ReUWIozEg21mIuKEwF2Wahf9AIAAA==
X-CMS-MailID: 20200715074758epcas2p31bd668e519f59a47268bb086363b1826
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200715074758epcas2p31bd668e519f59a47268bb086363b1826
References: <cover.1594798514.git.kwmad.kim@samsung.com>
        <CGME20200715074758epcas2p31bd668e519f59a47268bb086363b1826@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 292af12..092480a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,6 +4884,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..e5353d6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -294,6 +294,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1070,6 +1071,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
2.7.4

