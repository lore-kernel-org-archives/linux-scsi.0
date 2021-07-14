Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DB7C11F6D
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C066F613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhGNHPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31202 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp04d2377c8b3d4e5532f814f3b60acb9566~Rlsclf9Eg0784307843epoutp04M
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071202epoutp04d2377c8b3d4e5532f814f3b60acb9566~Rlsclf9Eg0784307843epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=rjwJ4dRGZpPwc9QzXTmfR3F2iqx4i1w0LwG82FMYvV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMjA1ztkSTWWvEbmXa6KZ2GsxadASIoi6vTZPVDHOBkf+PZ+Lw2TAAC1C30oDRWGB
         YpGjbmmwFaZblaGS6rA3eZ3sHZui5EiBFjmGyNPMtmBWsLHnBWYcwdJ1etLVEaWDhr
         LiX3pliS36G8ngp4OwmH55b8ureLtYDMfJS+5esk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p3455987b64ea4ba11125098109bfecff2~Rlsb1wLiU2304323043epcas2p3V;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPpbN24PTz4x9Q7; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.3D.09571.04E8EE06; Wed, 14 Jul 2021 16:12:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p24323976939fa21a5ed44d81649b33d85~RlsZ8YCVP1657016570epcas2p2Y;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp2ea346cb4701f1ec0dc1533ce0e7584d9~RlsZ7ZAxQ0755107551epsmtrp2q;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-0b-60ee8e40f224
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.43.08394.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2f9a530f2482a2b19f6aab1b9ec280ecc~RlsZvaC4r2465824658epsmtip2p;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 10/15] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Wed, 14 Jul 2021 16:11:26 +0900
Message-Id: <20210714071131.101204-11-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmma5D37sEg12feSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZNx/eIC5YAV3xd8v59kaGN9zdjFyckgImEi86bjC2MXIxSEk
        sINR4smc3SwgCSGBT4wSHybHQCS+MUq0v2lhgem43nOUCSKxl1Gi4/UnKOcjo8SjD2fZQKrY
        BHQltjx/BTZXBGTuqsV3WUAcZoGTzBKnFxxkB6kSFkiUePK3hxXEZhFQlZizr5O5i5GDg1fA
        QWJqvwPEOnmJU8sOMoHYnEDhgxs+MILYvAKCEidnPgE7iRmopnnrbGaQ+RICVzgkvs78xAYy
        R0LARaLlsCzEHGGJV8e3sEPYUhKf3+1lg6jvZpRoffQfKrGaUaKz0QfCtpf4NX0LK8gcZgFN
        ifW79CFGKkscuQW1lk+i4/Bfdogwr0RHmxBEo7rEge3ToYElK9E95zMrhO0h0dG1mxUSVpMZ
        JfauOso0gVFhFpJvZiH5ZhbC4gWMzKsYxVILinPTU4uNCkyQY3gTIzhha3nsYJz99oPeIUYm
        DsZDjBIczEoivEuN3iYI8aYkVlalFuXHF5XmpBYfYjQFBvVEZinR5HxgzsgriTc0NTIzM7A0
        tTA1M7JQEuflYD+UICSQnliSmp2aWpBaBNPHxMEp1cBUmfNFRyu6uLCew+OBeyiP95yqFwck
        LY/ZrJ4SOCl+spNOjch386cHHmUoZiotFfzOxX7CxGJB5u/Abw2yGaImssskg36d0JpZUnVl
        mh97dfDUiBWbwzRzZgXOPucbd6cr4jyHuY74j1+2iz4ITVh7+Mqr+F0nnG89utz/aW3BFJVT
        +7gTe/6rBVbseH44JfJA1ZGosPzW1P8zG2KNpiueb8u23nAtwW8bj374HM4v5gKx5fKyHz/f
        rIx/U3bGVc0y8vESkfezdvpUOJxf1f/55pKLMzoqn3woSxJ075WSCQnb3NBTkXRnMlPz6feZ
        MUz38/a3sb86/3rVLNlg58UahkGXnf9tSfyluuDP+fVKLMUZiYZazEXFiQA9VqwMYQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXte+712CwZ6pqhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBn3Hx5gLljBXfH3y3m2Bsb3nF2MnBwS
        AiYS13uOMnUxcnEICexmlJj85h4bREJW4tm7HewQtrDE/ZYjrBBF7xkl7lzrYQFJsAnoSmx5
        /ooRJCEisItR4vCZw+wgDrPAZWaJb9OuMINUCQvES7Sf+s0IYrMIqErM2dcJFOfg4BVwkJja
        7wCxQV7i1LKDTCA2J1D44IYPYOVCAvYS/7atBruIV0BQ4uTMJ2CLmYHqm7fOZp7AKDALSWoW
        ktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBsaWluYNx+6oPeocYmTgYDzFK
        cDArifAuNXqbIMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwen
        VAPT4tzJHg/iO7ifx6eufTk5cL/U+cwDZ4VilC/OPdLP++vwNZeaGT0r3jAfrjV8qlJiy3B3
        /vL7P/b+XlHj95w9e9LbLZUyCUvFphXwJjNmf5vxc6rMzgN93rIpB9aXHZl48qiugZx69Rmj
        k3MYdLo0rBQTPHu3Llm//eeq81s+vqiqefvw+/Ibz8taP2ar7ig/yb3W//Van7jbXPPFFPuy
        9h1T/f793DWeHgGDtXzZO47JT9blSz4qzrI6rfq6bPXmh8b/HNmc2XNK9zv/epYqpfB1ws/v
        AdfEfXvbnjlHCjY8my945cfCil2x+Q9CmR+4n1717WlM6Je59w7O28EQveW179ItJb1X1i4T
        tIzQVVFiKc5INNRiLipOBAC3biX5HAMAAA==
X-CMS-MailID: 20210714071159epcas2p24323976939fa21a5ed44d81649b33d85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p24323976939fa21a5ed44d81649b33d85
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p24323976939fa21a5ed44d81649b33d85@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To skip exynos_ufs_config_phy_*_attr settings for exynos-ufs variant,
this patch provides EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR as an opts
flag.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 ++++--
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 90c0d7c85a13..9a5a7a5ffc4b 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -831,8 +831,10 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
-	exynos_ufs_config_phy_time_attr(ufs);
-	exynos_ufs_config_phy_cap_attr(ufs);
+	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
+		exynos_ufs_config_phy_time_attr(ufs);
+		exynos_ufs_config_phy_cap_attr(ufs);
+	}
 
 	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 0938bd82763f..8695270d38d9 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -200,6 +200,7 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+#define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.32.0

