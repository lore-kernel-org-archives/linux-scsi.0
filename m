Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4F2C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 15:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1381B64FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 15:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhCJPeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:34:23 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:63574 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhCJPeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 10:34:10 -0500
Date:   Wed, 10 Mar 2021 15:34:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615390448;
        bh=HiWqG/wJGrdIv4mglu2FebUtS099/QUoKTgH5H0mxEc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=qRhsrARG0iYox7wzXbtdoJLy/JPwyscZEg32fuIrr1WH5ze33jPND3H4Z4QPxhcqM
         8mgs4qUTjJY7W0TCeqHNR7sXigk61rntfIyW2ySfPodvx3O0/bBwIwkh8sJsVzjItP
         7lm1DkZGgsMcXWhXewx2TV98QKFuHTqNvNHTPl6s=
To:     caleb@connolly.tech, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     ejb@linux.ibm.com, stanley.chu@mediatek.com, cang@codeaurora.org,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: [PATCH v3 3/3] scsi: ufshcd: remove version check
Message-ID: <20210310153215.371227-4-caleb@connolly.tech>
In-Reply-To: <20210310153215.371227-1-caleb@connolly.tech>
References: <20210310153215.371227-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This check is redundant as all UFS versions are currently supported.

Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Caleb Connolly <caleb@connolly.tech>
---
 drivers/scsi/ufs/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4d4b885d4df..a6f317f0dc9b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9291,10 +9291,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *m=
mio_base, unsigned int irq)
 =09/* Get UFS version supported by the controller */
 =09hba->ufs_version =3D ufshcd_get_ufs_version(hba);
=20
-=09if (hba->ufs_version < ufshci_version(1, 0))
-=09=09dev_err(hba->dev, "invalid UFS version 0x%x\n",
-=09=09=09hba->ufs_version);
-
 =09/* Get Interrupt bit mask per version */
 =09hba->intr_mask =3D ufshcd_get_intr_mask(hba);
=20
--=20
2.29.2


