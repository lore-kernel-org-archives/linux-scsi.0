Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C8FC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFE422B3B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgLVCdd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:33:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24099 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVCdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:33:33 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201222023249epoutp02df68fb4f4a761287c89b1a27504cf0c5~S6Sajx9JP0084200842epoutp02q
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:32:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201222023249epoutp02df68fb4f4a761287c89b1a27504cf0c5~S6Sajx9JP0084200842epoutp02q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608604369;
        bh=6otfCUScQsQqUhT8MT7TE9t5Yf/LoIlk1bakCNDOfgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=skG1zs2MXQPwGixaVIQ/ZQuVLik1AhNgCAGRxmo6lfdfSh3JzGUr7DlGlsY0c6fna
         tdA7gTJfUamS9marzDq2eZ4BwpONYAa8obtQly1ygvUHF5a780GqRR+50Auy3RAzgN
         k3oZ6qswNk4iFW4RckvdnVB4ZO2a8Lgz8hRxsUrc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201222023243epcas2p179fd04267ca6df915faa21f5ff9d6baa~S6SVQjvd_2557125571epcas2p13;
        Tue, 22 Dec 2020 02:32:43 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4D0L3F6jDfzMqYkZ; Tue, 22 Dec
        2020 02:32:41 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.01.52511.9CA51EF5; Tue, 22 Dec 2020 11:32:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201222023238epcas2p14c4beca3db4c11e98cde7e7c037fd4b5~S6SQbIdzL2759527595epcas2p1U;
        Tue, 22 Dec 2020 02:32:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222023238epsmtrp236bc23534f911247f17aaf9c8cec302a~S6SQZOtIA1587315873epsmtrp2G;
        Tue, 22 Dec 2020 02:32:38 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-9a-5fe15ac9a18d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.6E.13470.5CA51EF5; Tue, 22 Dec 2020 11:32:37 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222023237epsmtip1d9299c62ce724b890a75c6fba1a1d840~S6SQGz5j81491814918epsmtip11;
        Tue, 22 Dec 2020 02:32:37 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 1/2] ufs: add a vops to configure block parameter
Date:   Tue, 22 Dec 2020 11:21:46 +0900
Message-Id: <dad43ff87d34cea599e35eed46762f87f4af939d.1608603608.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608603608.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608603608.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA1WSb0xbVRjGc27vvS0slZsO9YzEye6cExTWImUHMuY/Qm42jXXOD2PTUuGm
        dLS3pbc16oeJOhgrG5YN5lgHbFMkm5tdEJGg4NaBK4mYmTqkbAYw0A3kX1cYDFqw5bKo337n
        vM9znjfveSUiWT0ZJ9FxFtbMafQ0GY23XEtQJnXnDKnlnmolGqxrIVF7qVuMRh/cJNHVocM4
        mm3wEejE9AMRuuf8ikALIacYff3FII7O9bVgyNvchaPyP1pJ1Hh9CUO2P/sAaliawF+MYTy/
        72Q8FUcxxn7uCmDmnGUk4x/px5mK5guACTStZw5dKcdUkhz9tgJWk8+a41kuz5iv47SZ9M43
        1a+olWlyRZIiHW2l4zmNgc2ks15VJWXr9OHm6fj3NHpr+Eql4Xl6y/ZtZqPVwsYXGHlLJs2a
        8vUmhcKUzGsMvJXTJucZDRkKuTxFGVbm6guaR29gppk179c0j4uLwVSUDURJIJUKTwaDRIRl
        VCuAx0dIG4gO8z0AL00NYMLhPoCf3a8WPXQEyy8CwdEOYFWTVRDNA/hxiZOMFEgqAY54q1fc
        sdQvGOwt6VnJEFGbYZvdjUV4LZUFzw5N4hHGqU3wO//nKxoptRe6a92EkLYeen89vJIcRaXD
        jrpe4v8cHdbUSuAd1+iqIQsuzc+JBV4Lx643r3IcDEy2kwJ/BDuqi1fNRwAc6VgCQuF5eMp3
        KMyScKcJ0Nm2JYKQ2gg7+3Gh/0dg2bWQWLiWwrJSmWDcCBeOHV99ZB2s8d5eTWVg5XIXIQwo
        nOTwBQk7ePLUvwFnALgAHmNNvEHL8imm1P/+XhNY2dREphU4JqaTXQCTABeAEhEdK02LG1DL
        pPmaDz5kzUa12apneRdQhgdZKYp7NM8YXnXOolYoU9LS5OlKpExLQfTjUrN8UC2jtBoLW8iy
        Jtb80IdJouKKMTXDh3oOUL/tOhZr8W/iTrwwfv6pb7Pf4ejTu7ADww5mLoao8Q7Xdeaemd1q
        YN51PDcTuDHxfdCGwU8Ui/1ns27Oz4XQpzsaa2y5w28XiesnjyZOjS/PiMZea3tmx7MObFj3
        Y6HL93rFT7fSFeP7/tpQ3dUw361PryMUt7+5vH+op7LqtL+sb09V9pf1pMol9fvtRe7O0rte
        fLI/pJVu3r395J7Fv423Agvc8n772PlLB4/MzL7V7ptqz5Fbf/bv1r3RY9hnioEo5uU7nr2F
        L405quw/4IMb7tIdgW6TR39RP/CE1lOf2oumi9Zdrn36IJGRoUqVNcISHXAa11xdpHG+QKNI
        FJl5zT8M7e2fMgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnO7RqIfxBn/v2Vg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MrY8vICU8EX7oqZW96wNzC+5+xi5OSQEDCR+NO9hrGLkYtD
        SGA3o8Tn71fYIRKSEid2PmeEsIUl7rccYYUo+sYose3SXRaQBJuApsTTm1OZQBIiAveYJC5N
        mMsMkmAWUJfYNeEEE4gtLOAisfDhO7AGFgFVia0fp7OC2LwC0RIn5p5ghdggJ3HzXCdYL6eA
        pcS+edfA4kICFhJ/dn5iwyU+gVFgASPDKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M
        4KjQ0tzBuH3VB71DjEwcjIcYJTiYlUR4zaTuxwvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1
        Ml5IID2xJDU7NbUgtQgmy8TBKdXAVDeFPy3VtImz9f02w2zDtDK71Beb3//RfdPzNuOvhvWX
        MO5rTRf7N3ze4i65VrHxrfZ9LcYLDk6Szn9y/iw/EK1rwxX79cgfE73OgDjFRUdyV0R2rzh6
        sfpT62vxS+dC6+9sNvii8HD+zbU595tqI+/GfncqCOJc/6swXTtp/ocsxeN/dzVPs5sX8mbq
        tO75+d5OE7QjVVlehOc3nZWYtvPlswkuNnUFH018mdpblcUL6v9tV/fU3Xgn+eI9fuYOG+6N
        qj/PHEuNrMk/9vmSTs7Nro0H5Et3LHA2+jqZebptoe+S5PT4GQWLTB8rnlMu3PmEr+NU39k3
        /WK+W7mkUv6fsHRVPHEx41pF0sunSizFGYmGWsxFxYkAm75lofkCAAA=
X-CMS-MailID: 20201222023238epcas2p14c4beca3db4c11e98cde7e7c037fd4b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222023238epcas2p14c4beca3db4c11e98cde7e7c037fd4b5
References: <cover.1608603608.git.kwmad.kim@samsung.com>
        <CGME20201222023238epcas2p14c4beca3db4c11e98cde7e7c037fd4b5@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There could be some cases to set block paramters
per host, because of its own dma structure or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..5f89b0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	ufshcd_vops_slave_configure(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..4bf4fed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	void	(*slave_configure)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -1228,6 +1229,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_slave_configure(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->slave_configure)
+		hba->vops->slave_configure(sdev);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

