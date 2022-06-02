Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02C0C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 03:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiFBDPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 23:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiFBDPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 23:15:09 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56522AE9FE
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 20:15:04 -0700 (PDT)
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220602031502epoutp015a9db05277eea2ef0907b1bb342ecd68~0r0ulzime1019110191epoutp016
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 03:15:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220602031502epoutp015a9db05277eea2ef0907b1bb342ecd68~0r0ulzime1019110191epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654139702;
        bh=XsPC+2arR+itCI+4cC+avNlVG/+DLEOwvO8nKCqSQ5s=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=uiL7FcCTFcyBIMW+dEF91tCkYNRFDclM4CGPVpRIVITrWtemEI4xl4OYQW7axOCdW
         xQLfeDxfdcHPOyawSxNwTpwXOi+drt2YPpMm+W7IqoL4kI3hve9v63lN2ujOeVw+4B
         WM8te/QefmIR5AYqpVM8RxVg2UCKWmMcSqzpQViU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20220602031502epcas3p27d77886d217b6ccc6bfcbdf64f18bac6~0r0uCwkm72258822588epcas3p2O;
        Thu,  2 Jun 2022 03:15:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4LDB2s6kkyz4x9Q4; Thu,  2 Jun 2022 03:15:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Split struct ufs_hba
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        cpgsproxy2 <cpgsproxy2@samsung.com>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01654139701937.JavaMail.epsvc@epcpadp3>
Date:   Thu, 02 Jun 2022 12:13:30 +0900
X-CMS-MailID: 20220602031330epcms2p3d0955d6cdd45eafd4d514d7dc51de003
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220531035501epcas2p33ef286ea964e39f45a0696edf2d8ae32
References: <CGME20220531035501epcas2p33ef286ea964e39f45a0696edf2d8ae32@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Improve separation between UFSHCI core and host drivers by splitting
>struct ufs_hba. This patch does not change the behavior of the UFS
>driver. The conversions between the struct ufs_hba and the struct
>ufs_hba_priv pointer types do not introduce any overhead since the
>compiler can optimize these out.
> 
>Cc: Adrian Hunter <adrian.hunter@intel.com>
>Cc: Avri Altman <avri.altman@wdc.com>
>Cc: Bean Huo <beanhuo@micron.com>
>Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>Cc: Keoseong Park <keosung.park@samsung.com>
>Cc: Eric Biggers <ebiggers@google.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> drivers/ufs/core/ufs-debugfs.c   |   79 +-
> drivers/ufs/core/ufs-hwmon.c     |   42 +-
> drivers/ufs/core/ufs-sysfs.c     |  141 ++-
> drivers/ufs/core/ufs_bsg.c       |   14 +-
> drivers/ufs/core/ufshcd-crypto.c |   49 +-
> drivers/ufs/core/ufshcd-priv.h   |  229 +++-
> drivers/ufs/core/ufshcd.c        | 1782 ++++++++++++++++--------------
> drivers/ufs/core/ufshpb.c        |   40 +-
> include/ufs/ufshcd.h             |  175 +--
> 9 files changed, 1409 insertions(+), 1142 deletions(-)
> 
>diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
>index e3baed6c70bd..12ff7bdf84aa 100644
>--- a/drivers/ufs/core/ufs-debugfs.c
>+++ b/drivers/ufs/core/ufs-debugfs.c
>@@ -34,7 +34,8 @@ void ufs_debugfs_exit(void)
> static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
> {
>         struct ufs_hba *hba = hba_from_file(s->file);
>-        struct ufs_event_hist *e = hba->ufs_stats.event;
>+        struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);

How about functionalizing container_of in ufshcd-priv.h like below?

static inline struct ufs_hba_priv *hba_to_hba_priv(struct ufs_hba *hba)
{
        return container_of(hba, struct ufs_hba_priv, hba);
}

I think it will be easy to understand.

Best Regards,
Keoseong Park

>+        struct ufs_event_hist *e = priv->ufs_stats.event;
> 
> #define PRT(fmt, typ) \
>         seq_printf(s, fmt, e[UFS_EVT_ ## typ].cnt)
>
