Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8A6C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CAF22E00
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394506AbhASClb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 21:41:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36288 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394339AbhASClU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 21:41:20 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210119024017epoutp03923eb5f842dd2a686765a8e36845d54f~bgc760ElG0797607976epoutp03M
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 02:40:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210119024017epoutp03923eb5f842dd2a686765a8e36845d54f~bgc760ElG0797607976epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611024017;
        bh=IUvNu4dNPyTjKtls0lrz2Urf0qov0F2gqycSUqGOIkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=vdQSaCN3gB4KLRCL77V5jYjPzQm/GksHseDUkqDSu0R8OGf1PENsPD4OPl4Mli0Es
         oC1yhecy5eyKRm3McYxNTK6iaE7/Xup37ibNGjPxqzlbZKquw0btLwqwiKUMXafJ9V
         NA73Xi/NvKGTQEbg6/wMpCnbMIPmgoxGWgVOdR5g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210119024016epcas2p2e36349d1143f43e041496fe55ba81227~bgc7HJ-l00524205242epcas2p2N;
        Tue, 19 Jan 2021 02:40:16 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DKXv26JLJz4x9Q8; Tue, 19 Jan
        2021 02:40:14 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.94.05262.E8646006; Tue, 19 Jan 2021 11:40:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210119024013epcas2p1b0ebaa5fbc2e966529a549386535fdbb~bgc4WMAFt0127201272epcas2p1A;
        Tue, 19 Jan 2021 02:40:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210119024013epsmtrp27a33271ac6761a171b7663a82e55c99b~bgc4UQjzw0484804848epsmtrp2O;
        Tue, 19 Jan 2021 02:40:13 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-20-6006468e8ad4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.6A.08745.D8646006; Tue, 19 Jan 2021 11:40:13 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210119024013epsmtip2b3bed87e0c821d01943747204ea672ae~bgc4FcOAB0182701827epsmtip2B;
        Tue, 19 Jan 2021 02:40:13 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [ PATCH v6 2/2] ufs: ufs-exynos: use
 UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
Date:   Tue, 19 Jan 2021 11:28:49 +0900
Message-Id: <80d7e27d6ec537e650a6bd74897b6c60618efcdc.1611023224.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611023224.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611023224.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmmW6fG1uCwbSPhhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZMw8/JmtYBl7xcoDE9gaGJvYuhg5OSQETCRamn4xdjFycQgJ7GCUmPDgATOE84lR
        4tXlJ6wQzmdGiUd3HzLDtNzv2MgCkdjFKPFk3lso5wejxJW7S1lBqtgENCWe3pzKBJIQETjD
        JHGt9SxYgllAXWLXhBNMILawQIjE8fdvGUFsFgFViZ0d/UA2BwevQLTE8eesENvkJG6e6wTb
        zClgKTF78RlGVDYXUM1cDomti9qZIBpcJB7fXwvVLCzx6vgWdghbSuLzu71QX9dL7JvawArR
        3MMo8XTfP0aIhLHErGftYEcwA32wfpc+iCkhoCxx5BYLxPl8Eh2H/7JDhHklOtqEIBqVJX5N
        mgw1RFJi5s07UFs9JHYufgMNX6BNr2/1sk9glJ+FsGABI+MqRrHUguLc9NRiowJj5OjbxAhO
        qlruOxhnvP2gd4iRiYPxEKMEB7OSCG/pOqYEId6UxMqq1KL8+KLSnNTiQ4ymwHCcyCwlmpwP
        TOt5JfGGpkZmZgaWphamZkYWSuK8xQYP4oUE0hNLUrNTUwtSi2D6mDg4pRqYrHIlWi4n1xQe
        Xi/5y3bppx2x+ltfC+mlvez/+VD9itkVxokJc1VOLDhpsn93VcCcrYsYr2S8yLDo9fu043aR
        yCTm8k03xFfbHjjZ98jRyt5I68/3lgs+WrfTWCTjfDZosC/zXHtf5HPS/LtP/LfksrGvOtcz
        q9H5EpdVKR8Ld+6kj+aMzNcOvNt89bD+jZCL2jNOXup/xPdXPMLIyuds9JkDXUFeLqEBc6cY
        eLZHHWzLWGdz6FBfqPzWibXRpd+UF1wwjXDLtkkw4nE6tU+0+3pwQuKaf2731wRr1TGKzPgS
        dKDizSMdjo13HCPFXDe93rWqf1Lb9pTyTwcTpct2N7cuzrU9WrF3ufziPe/FlFiKMxINtZiL
        ihMBNvnqeDMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvG6vG1uCwdd3OhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiiuGxSUnMyy1KL9O0SuDJmHv7MVrCMvWLlgQlsDYxNbF2MnBwSAiYS9zs2snQxcnEI
        CexglNg1/zMrREJS4sTO54wQtrDE/ZYjrBBF3xgl3rWvZwFJsAloSjy9OZUJJCEicI9J4tKE
        ucwgCWYBdYldE04wgdjCAkES1770gk1lEVCV2NnRDzSVg4NXIFri+HOoZXISN891grVyClhK
        zF58BmyxkICFxK0v79hxiU9gFFjAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4
        JrS0djDuWfVB7xAjEwfjIUYJDmYlEd7SdUwJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2M
        FxJITyxJzU5NLUgtgskycXBKNTDtOFfZlr6jVbZvt6iiVwpz1I5btxMbDIKUxS17s14/Dzxz
        sJjjuMG9qcuSO5anqAvNnn3m6xa2U3I9FsW3g/d89dmgvXT5K+dnTDVrZfzayv8tawndtGT2
        cu/WaTcnlvdOKDktl6KQ8FT+yI6MF8KLm7bu8qpMjPOyvm2m9L4t9sLOixnsu6I6prbq2O0o
        dNwasGlKavoxA4vzJllXNFmXhV6uP3p/reaWeuuNP2ZMnS+yVDlevWrbV5sP244XTgmdu3nH
        +7RlZgv35Dozi5lfPxV0K9PydUlQbfruiWxzOKuTDT/diNsrEuHRddhct1ry3om3VrP1FTI9
        RbjnvC6uadn/a2P1Q4e9s5mUV0srsRRnJBpqMRcVJwIAIBzFVfgCAAA=
X-CMS-MailID: 20210119024013epcas2p1b0ebaa5fbc2e966529a549386535fdbb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119024013epcas2p1b0ebaa5fbc2e966529a549386535fdbb
References: <cover.1611023224.git.kwmad.kim@samsung.com>
        <CGME20210119024013epcas2p1b0ebaa5fbc2e966529a549386535fdbb@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exynos needs alignment with page size because it isn't capable
to transfer data in one DATA IN to seversal areas.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..d1f0031 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1236,7 +1236,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

