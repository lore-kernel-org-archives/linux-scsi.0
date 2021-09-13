Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2550BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F212460E90
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbhIMINP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:13:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21998 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237921AbhIMINM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 04:13:12 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210913081155epoutp028c3b793bd3a95fddac97045e211eb958~kU3Jt1wWK2028620286epoutp02C
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 08:11:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210913081155epoutp028c3b793bd3a95fddac97045e211eb958~kU3Jt1wWK2028620286epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631520715;
        bh=87QFDn3C/DoVwFJwy2ZSjEIn7gw+sSRF8SjelsTGOJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=A6+aLQtEOJy0pUPTNjOiH/ELi3Q5uHJNeXNnmMYr4zE6PgGR+fumHM+3FYVATqS5V
         JBDKiVsgeVCjnbLEhToZ5gnY49NY+PUYjVx6mqmegoiM+H1yKtuyotXREk2XQE8u28
         0qglGqOewabVwdjDPalnE0SKiLQViqtp6hEVykfA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210913081155epcas2p2cf5131d48b65472075888b07a8bbae8f~kU3JCoU0j0646006460epcas2p2s;
        Mon, 13 Sep 2021 08:11:55 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H7K2K3v8cz4x9Qb; Mon, 13 Sep
        2021 08:11:53 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.44.09816.7C70F316; Mon, 13 Sep 2021 17:11:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210913081151epcas2p453eb6c6de01466060724d1445b443572~kU3FR-2mA3163831638epcas2p4r;
        Mon, 13 Sep 2021 08:11:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210913081151epsmtrp1c26c9509afd9244e60b7d8d46c59dfeb~kU3FQuZhY1350813508epsmtrp1e;
        Mon, 13 Sep 2021 08:11:51 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-3f-613f07c7850b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.CE.08750.6C70F316; Mon, 13 Sep 2021 17:11:51 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210913081150epsmtip184e72205ce3264d62bca860f7a9e2d2e~kU3FCOK550411604116epsmtip1w;
        Mon, 13 Sep 2021 08:11:50 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 2/3] scsi: ufs: introduce force requeue
Date:   Mon, 13 Sep 2021 16:55:54 +0900
Message-Id: <d036f1ee837697809533e8b14c62c4d850645143.1631519695.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1631519695.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmhe5xdvtEg7/b9SxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJV
        JuRkHH0uV3CLv+JsYzNjA+Nnni5GTg4JAROJddd2sncxcnEICexglJj/biczhPOJUWLp34tM
        EM5nRonly/6zwbSs73jJCJHYxShxb99lqJYfjBL/rs4Eq2IT0JR4enMqE4gtIrCPSeLornQQ
        m1lAXWLXhBNAcQ4OYQEriUWvWEHCLAKqEoeabjGC2LwC0RKPVi1hhVgmJ3HzXCcziM0pYClx
        /+8JJlQ2F1DNVA6JAzvOMUI0uEgs+XERqllY4tXxLewQtpTEy/42KLteYt/UBlaI5h5Giaf7
        /kE1G0vMetbOCHIcM9AD63fpg5gSAsoSR26xQJzPJ9Fx+C87RJhXoqNNCKJRWeLXpMlQQyQl
        Zt68A7XJQ2LNH1iIAm3qX/WPcQKj/CyEBQsYGVcxiqUWFOempxYbFRghR94mRnAi1XLbwTjl
        7Qe9Q4xMHIyHGCU4mJVEeLe9sU0U4k1JrKxKLcqPLyrNSS0+xGgKDMiJzFKiyfnAVJ5XEm9o
        amRmZmBpamFqZmShJM57/rVlopBAemJJanZqakFqEUwfEwenVANTdtbFly7fVWIq1WYs/q+3
        iPef0hzx/CvsFc8vfDBr9JM+XPlzWvXLtWHeYozZJUdclsuIv1z+gHWzc2jUlbaJed9X7Duv
        GvbyZ5lIxQGhHSV6ClL6Ow5r3Zq7+kNOp1yJ+FSlyBD2p49Wh3M9rDobwckwR6VAk/GA9a1C
        bkF7fwWG/wo3+c4slHWSqDj4PubFrkihLWLduy1m1B2x0OnNEE5ZcG5WtZ1a3kHLo+7/eWpv
        /i1mLfkyO7LaMax3coKSxY7Np8rKDod97eRr8mgyWd+qEeeZOe3kK52H965PXvxnR4nFK1ah
        Iyph+/mblH93fG461uMaKfpHb9G+vAPL/FSnqTxv+VSlcWvKy1dKLMUZiYZazEXFiQA1OV0t
        LQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO5xdvtEgxX7mCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58Hpf7epk8Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        OKK4bFJSczLLUov07RK4Mo4+lyu4xV9xtrGZsYHxM08XIyeHhICJxPqOl4xdjFwcQgI7GCUO
        NPxjg0hISpzY+ZwRwhaWuN9yhBWi6BujRPupnWBFbAKaEk9vTmUCSYgInGOSmHp5KRNIgllA
        XWLXhBNANgeHsICVxKJXrCBhFgFViUNNt8CG8gpESzxatYQVYoGcxM1zncwgNqeApcT9vyfA
        xggJWEj0b97EiEt8AqPAAkaGVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwZGgpbWD
        cc+qD3qHGJk4GA8xSnAwK4nwbntjmyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTE
        ktTs1NSC1CKYLBMHp1QDU+vbE36mfkKdlV+F0xgf54Rq9kmxXdp5+/kPm59zPp1M37w5tfjW
        pVxl3sOl50TdXrLf2uOU596S4/GZ+d43x8rNJ71P7wq/uqiT49wdwfj2tv/23ke/GcQfrmm1
        4JKZ+z/5Cbts4aR0jnYl6be9OjNuRydOE/4g1L9WPHhblUX1O7Vv7svqfKf8r+pQ/NN0pea6
        TL/b+9Ya0Y9h5XM/rGsrV9jTJTLRL0uC41ruDBZHNdHlRxWk8g4fMFW56rLj/8sPN5n3dTR9
        v/FzDttxxmD2w2xMh+ZIz2xfcmdKQse3s+cEJL5rvsz0Z3BoDbv1dxKb88bDfkufP91UFvvn
        LdviLbkGOR8/BUR4bDCsV2Ipzkg01GIuKk4EALuioRvzAgAA
X-CMS-MailID: 20210913081151epcas2p453eb6c6de01466060724d1445b443572
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081151epcas2p453eb6c6de01466060724d1445b443572
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081151epcas2p453eb6c6de01466060724d1445b443572@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a data command is completed but its data integrity
isn't guaranteed, the driver doesn't return any errors
but user land could face various abnormal symtoms.
All the pending commands should be queued again only if
those events could be detected before the commands are
completed. Because it could be a disaster, especially if
the command is write.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 604c505..6550052 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5294,8 +5294,11 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = retry_requests ? DID_BUS_BUSY << 16 :
-				ufshcd_transfer_rsp_status(hba, lrbp);
+			if (hba->force_requeue)
+				result = DID_REQUEUE << 16;
+			else
+				result = retry_requests ? DID_BUS_BUSY << 16 :
+					ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -6200,6 +6203,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	/* Fatal errors need reset */
 	if (needs_reset) {
 		hba->force_reset = false;
+		hba->force_requeue = false;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
 		if (err)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7af5d5b..642c547 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -855,6 +855,7 @@ struct ufs_hba {
 	bool force_reset;
 	bool force_pmc;
 	bool silence_err_logs;
+	bool force_requeue;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
-- 
2.7.4

