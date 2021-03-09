Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0941EC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 12:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A694B65259
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 12:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCIMDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 07:03:03 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:61760 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhCIMCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 07:02:48 -0500
Date:   Tue, 09 Mar 2021 12:02:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615291367;
        bh=pu6lccqhqj3I+jPm2ns/pyx3iyBZmmcxHmBTWk/5tt0=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=RqGC0rIXr/iKrDKwVUYBpPGu4JDuSnhNSob7tr6+D4ipg6XeB3Gzfi58wH0DSaoj4
         jZA5OtoOhnoWote5lB2Ip/o9PRxlXbbwl1Urhn9otbD8r9bEPI/W4ocX33uu4GZY4M
         cSCk0OAxz3nUhMsNVFngVwrN8wyiElAVIntubp5g=
To:     caleb@connolly.tech
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, ejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: RESEND v2: scsi: ufshcd: use a macro for UFS versions
Message-ID: <20210309120212.119451-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using a device with UFS > 2.1 the error "invalid UFS version" is
misleadingly printed. There was a patch for this almost a year
ago to which this solution was suggested.

This series replaces the use of the growing UFSHCI_VERSION_xy macros with
an inline function to encode a major and minor version into the scheme
used on devices, that being:

        (major << 8) + (minor << 4)

I dealt with the different encoding used for UFS 1.x by converting it
to match the newer versions in ufshcd_get_ufs_version(). That means it's
possible to use comparisons for version checks, e.g.

        if (hba->ufs_version < ufshci_version(3, 0))
                ...

I've also dropped the "invalid UFS version" check entirely as it seems to
be more misleading than useful, and hasn't been accurate for a long time.

This has been tested on a device with UFS 3.0 and a device with UFS 2.1,
however I don't own any older devices to test with.

        Caleb
---
Changes since v1:
 * Switch from macro to static inline function
 * Address Christoph's formatting comments
 * Add Nitin's signoff on patch 3
Resend:
 * Fix patches 1/3 referencing the macro from v1
   instead of the new inline function

Caleb Connolly (3):
      scsi: ufshcd: use a function to calculate versions
      scsi: ufs: qcom: use ufshci_version function
      scsi: ufshcd: remove version check

 drivers/scsi/ufs/ufs-qcom.c |  4 +--
 drivers/scsi/ufs/ufshcd.c   | 66 ++++++++++++++++++-----------------------=
----
 drivers/scsi/ufs/ufshci.h   | 17 +++++++-----
 3 files changed, 38 insertions(+), 49 deletions(-)


