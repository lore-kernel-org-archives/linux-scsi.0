Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D839DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 01:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD46965149
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 01:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhCHA7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 19:59:34 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:44089 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbhCHA67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 19:58:59 -0500
Date:   Mon, 08 Mar 2021 00:58:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615165138;
        bh=xsfirT0SbT5Ybixat05doun3ZnWlMLUZKHqY7eSUrW0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=J6g8Hd3HQEh0rkKmqj+I09gI0Tqvl559ek1/99nGd6MbWlRilzREz6DOckbnoDur1
         IrPeS/uFPTDyXl2xzNUIa9k4+F3vZJk02PL9wuCCCQYMup3hs47WwJ5xDkT9KCGDgj
         i9+ZvHww4l5FRVnAak83qsL+pLVSS7h2OcirUWjE=
To:     caleb@connolly.tech, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     ejb@linux.ibm.com, stanley.chu@mediatek.com, cang@codeaurora.org,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: [PATCH 2/3] scsi: ufs: qcom: use UFSHCI_VER macro
Message-ID: <20210308005739.1998483-3-caleb@connolly.tech>
In-Reply-To: <20210308005739.1998483-1-caleb@connolly.tech>
References: <20210308005739.1998483-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new version macro, instead of the old enum.

Signed-off-by: Caleb Connolly <caleb@connolly.tech>
---
 drivers/scsi/ufs/ufs-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f97d7b0ae3b6..00ae0476f2cc 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -809,9 +809,9 @@ static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba =
*hba)
 =09struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
=20
 =09if (host->hw_ver.major =3D=3D 0x1)
-=09=09return UFSHCI_VERSION_11;
+=09=09return UFSHCI_VER(1, 1);
 =09else
-=09=09return UFSHCI_VERSION_20;
+=09=09return UFSHCI_VER(2, 0);
 }
=20
 /**
--=20
2.29.2


