Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAB4C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 22:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83C4322AAF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 22:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLVWM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 17:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgLVWM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 17:12:27 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0275C0613D6;
        Tue, 22 Dec 2020 14:11:46 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b9so20304624ejy.0;
        Tue, 22 Dec 2020 14:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6fjbj6zN8Pcd6q1ORs/Fz1E5K0tWXO14nIkNBitzKJs=;
        b=mdJMcZjPuF9qBh9b/6l3hXvV1d0rkB/TPTKgH5iFINL38wp0cLIwP2SFVAvW6x0ZYw
         jAaTMTk8P7VnPiwDVn7zAJ9iCLIDg5RyUj+T97cobnv1x5RDbLz07kmIuz0YbMvP66pR
         yANsqyN6GNkqHu/cXm/OCsmDrGIHNKauSSNAa24+BJtShQda7xnn09SkNGYfsqfDKiVV
         gCDlJlHlk8rF/qy6xbBoDTJSBL4ROvfmAyA/5kyxIRhSh31ibmN+iUrHe8TCBbPH8w3d
         DXcxLBBPoHcG8b+xEIn3/t6CJteXe01cHFPMvrsRJSPCC6YUX+4//CAIag7jW85WFO4K
         dETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6fjbj6zN8Pcd6q1ORs/Fz1E5K0tWXO14nIkNBitzKJs=;
        b=OaPgyk6E7a1IIOeZykdo9WYtqHQtWuLMbK11AUZw8HtKxBgwEOm3Jy48P7QO9yHh/K
         t9oNbYE9U7QHGpPsr15uh2D4+E7rGSc7MmaM+Y3c0YpvlYZvNodNnPZHS1dGxgorWyf0
         5Nb+urH2xiywFs42LZG59RHyH3/277VsWmjVHF9BASfYHNx4t47vWeJEm2OVTwbPN5mZ
         t3qoqOIORCy7VPcwrFERYrZwQTsyx21mN11PGf8wFli5CqdaWU1tX1zJ98Vg7pBdcbJn
         8Os3EBEqX+Ndkh52LXBUNuBKcqnFYmUrgpJ5+cVigZT0RJKxpcHxJgxNaGjkuAQEBjCM
         vElg==
X-Gm-Message-State: AOAM530Ezty+eHtI3RrckiNykgG5SBTIMTEPQtHtSK8Vi4u4b5oeQwlL
        g2dtzsqcPkvy/pjJ7LBcvXU=
X-Google-Smtp-Source: ABdhPJwN+SpqzBrvPoRyKl7GOqlZXhaK4bIoQp1zxYwg+mbvIRPzXHI6cgLvfK5yjWB5iZDZ/1ixow==
X-Received: by 2002:a17:906:2755:: with SMTP id a21mr16147998ejd.374.1608675105465;
        Tue, 22 Dec 2020 14:11:45 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id cb4sm4820273ejb.82.2020.12.22.14.11.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Dec 2020 14:11:44 -0800 (PST)
Message-ID: <28211d08700d1e4876a9aea342e8fcb79534cd2c.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Dec 2020 23:11:43 +0100
In-Reply-To: <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
         <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
         <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-22 at 21:57 +0100, Bean Huo wrote:
> > > May this operation race with UFS shutdown flow?
> > > 
> > > To be more clear, ufshcd_wb_ctrl() here may be executed after
> > > host 
> > > clock
> > > is disabled by shutdown flow?
> > > 
> > > If yes, we need to avoid it.
> > 
> > I have the same doubt - can user still access sysfs nodes after
> > system
> > starts to run shutdown routines? If yes, then we need to remove all
> > UFS
> > sysfs nodes in ufshcd_shutdown().
> > 
> 
> No, we shouldn't do in this way, user space complains this. I think
> the nodes in the sysfs can be shileded write, but the nodes shouldn't
> be flash of its presence frequently.
> 
> Thanks,
> Bean 
> 
> 
> > Thanks,
> > 
> > Can Guo.


Hi Can
Got your point, you don't want user space to interrupt UFS by sysyfs if
UFS is in power down mode. if this is true, insteading of removing all
sysfs node in ufshcd_shutdown, maybe just add this checkup before
accessing UFS device descriptors/flag/attributes/LU:

for example, for the device descriptor:


diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-
sysfs.c       
index b3bf7fca00e5..881fe1c24a9f 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -262,6 +262,9 @@ static ssize_t ufs_sysfs_read_desc_param(struct
ufs_hba *hba,
        u8 desc_buf[8] = {0};
        int ret;
 
+       if (!ufshcd_is_ufs_dev_active(hba) ||
!ufshcd_is_link_active(hba))
+               return -EACCES;
+

Bean


