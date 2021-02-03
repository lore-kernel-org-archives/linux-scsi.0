Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6316FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAC764F4A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhBCHI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 02:08:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47486 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhBCHI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 02:08:28 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210203070744epoutp03666265b91118bb316f030c6a4a8d42bf~gKxuwAPSC3018630186epoutp03S
        for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2021 07:07:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210203070744epoutp03666265b91118bb316f030c6a4a8d42bf~gKxuwAPSC3018630186epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612336064;
        bh=VJliMWnZXZoAle13sep0eHx4MFHDiIudRhjQVhWLeIg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=GIk8OdjOuZVkMjNV+5cLDGkrnI6jjMAOA+m1z/kTHvCcUr35UCN/xGR/Y3Vv3lm82
         JNfXUifvGkKWrzhn64KQBQ0CMlpgsuK74ogNRd82k+IZnI00LE71+rPZPd6FLk66Fe
         /v0sjaqw0rNzDHFouXy6oICuJfZBtiRIxxBCQp60=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210203070743epcas1p2983886d0fe889b0d568d59254f3dd212~gKxuFiqlt0292402924epcas1p2L;
        Wed,  3 Feb 2021 07:07:43 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DVt6k3r7Hz4x9Pt; Wed,  3 Feb
        2021 07:07:42 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.1A.10463.EBB4A106; Wed,  3 Feb 2021 16:07:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de~gKxsV-gXB1007210072epcas1p2N;
        Wed,  3 Feb 2021 07:07:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210203070741epsmtrp293b3a62b892050b07edb948c44a22c76~gKxsU4nnO3168731687epsmtrp2B;
        Wed,  3 Feb 2021 07:07:41 +0000 (GMT)
X-AuditID: b6c32a38-f11ff700000028df-2e-601a4bbee78b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        67.C9.08745.DBB4A106; Wed,  3 Feb 2021 16:07:41 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210203070741epsmtip177e197484a4290c3dd868e3c7015fb61~gKxsCoSfR3029230292epsmtip1_;
        Wed,  3 Feb 2021 07:07:41 +0000 (GMT)
From:   DooHyun Hwang <dh0421.hwang@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com,
        DooHyun Hwang <dh0421.hwang@samsung.com>
Subject: [PATCH] scsi: ufs: Add total count for each error history
Date:   Wed,  3 Feb 2021 15:53:46 +0900
Message-Id: <20210203065346.26606-1-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1ATVxjt3V02AQZnC4KX6JSYUSsokACBqwVan12rU2k7tk5nbNiQLWBD
        ksmDQvsHi8NDkZeDraFpRQF5qJmmgUJGwKYPiGPBlgoWLQqDBaU8JEMpitgNq1P+ne9859wz
        33fvFeL+o6RImK4xsnoNo5aQPkTzD6HS8Pa9omRprms1co1cINHdr5pJ1JbXJUD352+Q6Puh
        QgLNWGu90BdX87xQe59LgB49sQrQiNWMo4Kmkxg6e7MZQy2j1wTI8SQXQ72OL0l0vL+FROc7
        FzFU0vgniT5baCdQ37UuL1TT9AdA3/72D/FaEN1bfAKjz9hM9LnL9zHa1lBI0qVnrwD6qKuD
        oOesBST98N4AQRfbGwDttr1E5185jiX5vq+OT2MZFasXs5oUrSpdk5og2fuOYodCHiuVhcu2
        oDiJWMNksAmSnfuSwnenq7lxJeJMRm3iqCTGYJBEJsbrtSYjK07TGowJElanUutkUl2Egckw
        mDSpESnajK0yqTRKzimT1WnVuW/rin2zJmv+BjmgyvsY8BZCKgYuWtowD/anWgD8t/KNY8CH
        wzMAdvTUCfjCDWBOjxl/7lgYGiT4hgPAwd5TOG/nVPW3lo4lqQh4+USDl0e0kmrH4O36DsxT
        4NRDAKsGxkmPKoDaDm8P2JbCCWo9LJqrXOL9qAQ4nDeK8XEhcOFOEc7zL0LX6RHCg3GOz22q
        xD2HQmpaCHsqCwnesBP+mr8AeBwAH3TaBTwWQfdkG8nj4wCWOBN5cymAvZ1FzxrRcMbt5sxC
        LiEUWh2RPL0Wtj62AD54BZycLfLySCDlBwvy/HnJBnhucY6TCDi8Bh7x5VkaDha1PlvvIWhx
        loNSEGJeNox52TDm/2PPALwBBLE6Q0Yqa5DpYpbfqQ0svfgw1AIsE9MRToAJgRNAIS5Z6Xe1
        PCjZ30/FZH/C6rUKvUnNGpxAzq23DBcFpmi5L6MxKmTyqOjoaBQTGxcrj5as8lNK7yr8qVTG
        yH7EsjpW/9yHCb1FOdgOuOdD65RjW+iN809tk/tfCdRV2LMst0rk07VjvbHBW7v3vxXsMFyi
        O1zZY8Fy8fqKkIP4A7Fy01/zVQWDAUceFW/sO5WlFDtO/9SlOvzN0OHq+rDP54xlMbEXNrz7
        5ljT9uyadbWP+2VVwt0R7q+Hp6KUm/atSN3yS1LrwfCTkePrbI0bSSG8eHQmF//Zstn+o3Lq
        48Cn9p61yuuO2bqpS6tNRP71pO/y9ZVdPdsKN/c7f2/pIGOa49LLh1+37/pgDztbVXOveyJ+
        Fe0b+LLWtgtUzysZ9QEzFux6VZGTeei9NZ/WWsMjp7pfUImSLzI3+w7UNGa6ZibKfCrG79Qt
        JifGSQhDGiMLw/UG5j/EhdDkegQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSnO5eb6kEg6uzDC1OPlnDZvFg3jY2
        i71tJ9gtXv68ymZx8GEni8Wn9ctYLWacamO12HftJLvFr7/r2S2erJ/FbNGxdTKTxaIb25gs
        djw/w26x628zk8XlXXPYLLqv72CzWH78H5NF/+q7bBZNf/axWFw7c4LVYunWm4wWmy99Y3EQ
        87jc18vksWBTqcfiPS+ZPDat6mTzmLDoAKNHy8n9LB7f13eweXx8eovFo2/LKkaPz5vkPNoP
        dDMFcEdx2aSk5mSWpRbp2yVwZSxpDiro4654t/QNYwPjQs4uRk4OCQETiT8P77GA2EICOxgl
        3v2KgIjLSHTf38vexcgBZAtLHD5c3MXIBVTykVHif+taVpAaNgE9iT29q1hBEiIC55gkbs9b
        wgjiMAv8ZpSY9KOZHaRKWMBJ4s6tTUwgNouAqkTP99lsIDavgK3Eo7bnTBDb5CX+3O9hhogL
        Spyc+QTsImagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/
        dxMjOOq0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeU5PEEoR4UxIrq1KL8uOLSnNSiw8xSnOwKInz
        Xug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg2tmbHlv2veVt5MG6H0833XdNDJx3+Wmg2+sF/jYp
        T1tF/4ucN+j49jopsnf28u8+5b+nifZ1SF96/SZh947fTzuPb6q/xPR77r5yUfvZfv+2rtGd
        Fm65nW3LH+lD1+RuGzUG6/W2L3ny6/BJN7/FDCd+l6sssspd+tDqyXSvyw8k59wqmBB+/Ktz
        FHNY9Z8Xvxcec3coX8ra1yQqq3ZTKOX07BeTjD2Tl7w4uib25Iczi97uusQlNf8x57658XoB
        lufFLb5YSR254LGRi/P456Py0xUXnNqztLvHZ4r9mVedPLdjTH5YdWocWmf9rb6xzPma/MzH
        vDPjV938sCHlrqHyJ791Ira688o8Kp+aFwkrsRRnJBpqMRcVJwIADD8TgSkDAAA=
X-CMS-MailID: 20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de
References: <CGME20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the total error history count is unknown because the error history
records only the number of UFS_EVENT_HIST_LENGTH, add a member to count
each error history.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d122f2e3..7ebc892553fc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -437,6 +437,8 @@ static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
 
 	if (!found)
 		dev_err(hba->dev, "No record of %s\n", err_name);
+	else
+		dev_err(hba->dev, "%s: total count=%u\n", err_name, e->count);
 }
 
 static void ufshcd_print_evt_hist(struct ufs_hba *hba)
@@ -4544,6 +4546,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 	e->val[e->pos] = val;
 	e->tstamp[e->pos] = ktime_get();
 	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
+	e->count++;
 
 	ufshcd_vops_event_notify(hba, id, &val);
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index aa9ea3552323..df28d3fc89a5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -450,6 +450,7 @@ struct ufs_event_hist {
 	int pos;
 	u32 val[UFS_EVENT_HIST_LENGTH];
 	ktime_t tstamp[UFS_EVENT_HIST_LENGTH];
+	u32 count;
 };
 
 /**
-- 
2.29.0

