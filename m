Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5213FC433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 12:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152C36526E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 12:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhCIMDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 07:03:37 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:13457 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCIMDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 07:03:19 -0500
Date:   Tue, 09 Mar 2021 12:03:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615291398;
        bh=HiWqG/wJGrdIv4mglu2FebUtS099/QUoKTgH5H0mxEc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=aENeeXV/ntlfcuBIwX20VJ5A8L/u9+IDT/+I6yV77Hd1kdh1NZ1losiuEwIWNszka
         dV/ofjmr7FQIR2ZlVGNLW4JhYxNobwcPFGpyjLkTJQD0IZxsou9fpvVO4HuvaLkVhD
         qPQB9k2bJKyKP/IsaWnu8vT77G26xYL4Ca4i8JMw=
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
Subject: [RESEND PATCH v2 3/3] scsi: ufshcd: remove version check
Message-ID: <20210309120212.119451-4-caleb@connolly.tech>
In-Reply-To: <20210309120212.119451-1-caleb@connolly.tech>
References: <20210309120212.119451-1-caleb@connolly.tech>
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


