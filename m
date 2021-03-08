Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094A1C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 01:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3D865159
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 01:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhCHA7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 19:59:35 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:38689 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhCHA7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 19:59:18 -0500
Date:   Mon, 08 Mar 2021 00:59:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615165156;
        bh=0gcxEy42FQmd+kPIub4gVYl8AFmj0KeLJ8luAEKerPU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ipH2ktGu1KG6YP+4/dvQ43VyO741wxvMtJgHJoYUwhvpeW8N/V2aWKaijpHGztzRg
         HnM/kn+BUvAY3D+pb0wbKiRVnIyp2+BIMltbJWUCX8t0TxU/zLyTfl+2cerS8Bsxem
         xq4HjPG3wN+56iErz/tQE6Ja20G9F5h/7ecTCwRQ=
To:     caleb@connolly.tech, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     ejb@linux.ibm.com, stanley.chu@mediatek.com, cang@codeaurora.org,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: [PATCH 3/3] scsi: ufshcd: remove version check
Message-ID: <20210308005739.1998483-4-caleb@connolly.tech>
In-Reply-To: <20210308005739.1998483-1-caleb@connolly.tech>
References: <20210308005739.1998483-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This check is redundant as all UFS versions are currently supported.

Signed-off-by: Caleb Connolly <caleb@connolly.tech>
---
 drivers/scsi/ufs/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 458f0382292f..f2ca9d497a1c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9290,10 +9290,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *m=
mio_base, unsigned int irq)
 =09/* Get UFS version supported by the controller */
 =09hba->ufs_version =3D ufshcd_get_ufs_version(hba);
=20
-=09if (hba->ufs_version < UFSHCI_VER(1, 0))
-=09=09dev_err(hba->dev, "invalid UFS version 0x%x\n",
-=09=09=09hba->ufs_version);
-
 =09/* Get Interrupt bit mask per version */
 =09hba->intr_mask =3D ufshcd_get_intr_mask(hba);
=20
--=20
2.29.2


