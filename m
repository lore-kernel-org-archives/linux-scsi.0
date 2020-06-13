Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2577EC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02579206F5
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Dr/JJVfg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgFMDEs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10066 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgFMDEm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:42 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200613030440epoutp017dcc7cdf01bcfd6eb3bfcfbd038e3cca~X_3a21kEj3003930039epoutp01v
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200613030440epoutp017dcc7cdf01bcfd6eb3bfcfbd038e3cca~X_3a21kEj3003930039epoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017480;
        bh=HK/1/VP5ov7EOoNpQ0X08DtlhI52O+2EyAZ3cTvlQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dr/JJVfgtNIMRnlW5hOcbdHPw9s/PViwM5OqX0kQCy1WPIktxz4VehCDwojEwHwMj
         FoxcP+rLwjObyr2kbnBNWDDph8/Ue2kZRCnjxW0katB56KLQzIC8GAFkF1hyk8NtbK
         VNfE6sgVVyRD6q5lVNk3ow1hwhcKfgtcE7r/E3ZE=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200613030440epcas5p38b5f75eae3725c4fe8fe995fa17ffe89~X_3aYBa7K2268422684epcas5p3G;
        Sat, 13 Jun 2020 03:04:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.AA.09703.74244EE5; Sat, 13 Jun 2020 12:04:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200613030438epcas5p337ed074612a2a1e8b4d6ecb3dda30b5c~X_3ZMSo0U2337923379epcas5p3-;
        Sat, 13 Jun 2020 03:04:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030438epsmtrp2ef3d41d993a59ff0cf172e3142b8c64b~X_3ZLcWyz2362123621epsmtrp2s;
        Sat, 13 Jun 2020 03:04:38 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-49-5ee44247a414
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        67.62.08382.64244EE5; Sat, 13 Jun 2020 12:04:38 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030436epsmtip2bd368f2cfe2b2bc9d0fdfdabd8c142b1~X_3XOe8TD0718207182epsmtip2A;
        Sat, 13 Jun 2020 03:04:36 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Sat, 13 Jun 2020 08:16:57 +0530
Message-Id: <20200613024706.27975-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42LZdlhTU9fd6UmcwbwnlhYP5m1js3j58yqb
        xaf1y1gt5h85x2px4WkPm8X58xvYLW5uOcpisenxNVaLy7vmsFnMOL+PyaL7+g42i+XH/zFZ
        /N+zg91i6dabjA58Hpf7epk8Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6HH8xnYmj8+b5Dza
        D3QzBXBGcdmkpOZklqUW6dslcGW8OLqGpWC3QMX+D8eZGxhf83YxcnJICJhIPOlYxdrFyMUh
        JLCbUaJ3+XMWCOcTo8TdU2fYIZxvjBLHP81igml5um0JM0RiL6PExetn2SCcFiaJ/TNXsYBU
        sQloS9ydvgWsQ0RAWOLItzZGEJtZ4CWTxK5HBV2MHBzCAjESnWf4QcIsAqoSs++/YQexeQVs
        JPZf/wu1TF5i9YYDzCA2p4CtxMH/C5hAdkkIzOSQWDltDitEkYvEh4lT2SFsYYlXx7dA2VIS
        n9/tZQPZJSGQLdGzyxgiXCOxdN4xFgjbXuLAlTksICXMApoS63fpQ1zJJ9H7+wkTRCevREeb
        EES1qkTzu6tQndISE7u7oQ7wkDh6fhIjJBQmMEpceP+MZQKj7CyEqQsYGVcxSqYWFOempxab
        FhjlpZbrFSfmFpfmpesl5+duYgSnGC2vHYwPH3zQO8TIxMF4iFGCg1lJhFdQ/GGcEG9KYmVV
        alF+fFFpTmrxIUZpDhYlcV6lH2fihATSE0tSs1NTC1KLYLJMHJxSDUy8Rw86dy245LDs3kvp
        5U2zltVH5yjmO/fUqwe4x5SlPQte29nrIS120fC34GNGDinHxKtnHnUu/Jsitt1oDZNB4vuu
        k8sNutXyNY1q7RI1ThztWvTlGU9ai8rtGQduhCZ3nuXLCc3h9mVmiJhzlPfCPquO2XfN/s6o
        WymmyTUjxJmT4ez9D74TjtV5HljmcGYC/+RtShyiHwVfM6QwMdV6alXbNys7ZO7LM6nXf7h/
        5gsBy6NXozckvz60UW+ry0XZz28EbJwfG92Zw9vC4dTMflGroXjZPVXRrstbb2bk/Zur4/PE
        jfu0YcCvOb9m3YloetHE6me0+nAqd9gxqa+BWZPnN52dwCBd9Gq9kBJLcUaioRZzUXEiAMtM
        0oagAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvK6b05M4gw89mhYP5m1js3j58yqb
        xaf1y1gt5h85x2px4WkPm8X58xvYLW5uOcpisenxNVaLy7vmsFnMOL+PyaL7+g42i+XH/zFZ
        /N+zg91i6dabjA58Hpf7epk8Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6HH8xnYmj8+b5Dza
        D3QzBXBGcdmkpOZklqUW6dslcGW8OLqGpWC3QMX+D8eZGxhf83YxcnJICJhIPN22hLmLkYtD
        SGA3o8TSJ9NYIBLSEtc3TmCHsIUlVv57zg5R1MQkMalpARtIgk1AW+Lu9C1MILYIUNGRb22M
        IEXMAt+ZJA5MmMAMkhAWiJKYvGkBK4jNIqAqMfv+G7CpvAI2Evuv/2WC2CAvsXrDAbB6TgFb
        iYP/F4DFhYBqdh/9yTqBkW8BI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgINfS
        3MG4fdUHvUOMTByMhxglOJiVRHgFxR/GCfGmJFZWpRblxxeV5qQWH2KU5mBREue9UbgwTkgg
        PbEkNTs1tSC1CCbLxMEp1cAkf+LK5J/bAn5rPpBY1NN2MrXH4G3vSqPSoO7ue866O0RY153+
        rnn+u2n/Eedtbwwz2K44xXPlPJjZfUtac9b8Ga8FWtYImU14KqkeylhmHbXdtN/Yc2thfOyN
        NTGpTK+NzmbZiEstnpfr9kV+k/nbff+YWPPE+CvYvv6fMV/u1boHu28c3WubLnL7lPfWAjW9
        L/x6xn/VeiKmuMX5sLeycJp+96t6keTDtUQ/eYPHkl0nC9ed90gv3G7tz5rUPqHpjsbvV7kv
        d77aKtyYnhTwzHhVwM/Sr66i36fqKj03kWNqD797/TFvlHXxH72p6f+a/Ay9Df5VblKbYLNx
        yt83M4ufz/teKv7314TVZqFKLMUZiYZazEXFiQAlj3q24QIAAA==
X-CMS-MailID: 20200613030438epcas5p337ed074612a2a1e8b4d6ecb3dda30b5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030438epcas5p337ed074612a2a1e8b4d6ecb3dda30b5c
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030438epcas5p337ed074612a2a1e8b4d6ecb3dda30b5c@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..3655b88fc862 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..071f0edf3f64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -518,6 +518,11 @@ enum ufshcd_quirks {
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
 	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+
+	/*
+	 * Clear handling for transfer/task request list is just opposite.
+	 */
+	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

