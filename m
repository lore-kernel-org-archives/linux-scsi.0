Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AE7C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 00:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ABF365146
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 00:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhCHA6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 19:58:52 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:64708 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhCHA6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 19:58:21 -0500
Date:   Mon, 08 Mar 2021 00:58:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615165099;
        bh=etJHP96tjkEzh5mT5I9673lOGciwkrDRMnmojm9oaxI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=UXO9Tn941baCCvPx/oRKbGUffeT0grobb2mPyYhfxmuHqF/P3z6kPmytCzgOQUHu2
         o952vmxMHsAAgx3SDCimMl45qZzZCUsLJ1jNIoVf7tSIKtwL5koiusdEPfTibC5YsT
         2hi1aRhx4fzFQZS35S/rWjXGBQ29gnTaW65LWa98=
To:     caleb@connolly.tech
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, ejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: scsi: ufshcd: use a macro for UFS versions
Message-ID: <20210308005739.1998483-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using a device with UFS > 2.1 the error "invalid UFS version" is
misleadingly printed in dmesg. There was a patch for this almost a year
ago to which this solution was suggested, lets avoid growing a list of
versions and just use a macro instead.

I've also dropped that check entirely as it seems to be more misleading
than useful, and hasn't been accurate for a long time.

I dealt with the different encoding used for UFS 1.x by converting it
to match the newer versions in ufshcd_get_ufs_version(). That means it's
possible to use comparisons for version checks, e.g.

        if (hba->ufs_version < UFSHCI_VER(3, 0))
                ...


I've tested this on a device with UFS 3.0 and a device with UFS 2.1
however I don't own any older versions to test with.

        Caleb
---
Caleb Connolly (3):
      scsi: ufshcd: switch to a version macro
      scsi: ufs: qcom: use UFSHCI_VER macro
      scsi: ufshcd: remove version check

 drivers/scsi/ufs/ufs-qcom.c |  4 +--
 drivers/scsi/ufs/ufshcd.c   | 65 ++++++++++++++++------------------------
 drivers/scsi/ufs/ufshci.h   | 16 +++++-----
 3 files changed, 36 insertions(+), 49 deletions(-)


