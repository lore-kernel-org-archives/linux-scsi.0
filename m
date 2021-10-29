Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1566FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C9660F58
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhJ2Tn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ2Tn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:43:58 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A875C061570;
        Fri, 29 Oct 2021 12:41:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d3so18115336wrh.8;
        Fri, 29 Oct 2021 12:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8oWnaMS0hbYmY7MrXRQ1uwREr501x1nWgXMsHvfL6Q=;
        b=AzP6lPChlThrFVtFgRBk1vmcvDQAcySAEcwOPYPXoZNSbwdmHR/YmHXUuRQVmWwoQ8
         jOlG+skNEgpxACmE/G5wtsDkywhQJZDtfPCKAs7/rrhQskNmyxS97+iuBG3oSN6x5qkn
         Byt+PiFJtXt5WukloKHMVyOaz33E19uMsSBA0na+xSxiM3k85IBlu0wZBN3NbxtmqaJ4
         mgWNUDAG7rXy2j9LQE1L93Lc/c3zmSgP8vf4pgs0Yiwvk/ve+2vhALYiez1lGTAQkixG
         cWeJ57f6bPQkMttAthwXmaiZ+caZqqN3VdlpUNUql4Kx/t3BkjBmEdPq8kz2wmOygDVm
         g0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8oWnaMS0hbYmY7MrXRQ1uwREr501x1nWgXMsHvfL6Q=;
        b=DOeUowRDEYdMZHYtGan0y08wCidpmP9A/U2roYHGulhlMpPpOo2eqIytCp+41rWVBe
         Q3Z6kJPrb7Yw9NrheVPDT+mAm/PNO0mwguGTJNZ6ydJuQc1HWGhAr0tABH6Y+LzMZns8
         KjgMlqqzFTvftG+x48oQY3forBJZjZFbQ4x8SCcolOCqUfhg8W32DtSqh6LnUqqicK3F
         h3fWtP623x4b6xKWeMYewbbySnz+9VViQ2Cxwu8ainydrgW+0X0SJTmpq/mRWHSgCIFe
         CKjcrwweQj8esFuw/wQ6GYTjQzvfT901yQb63TfpVWMBGHPdKfKJ2H3i85PAoU4FoAnv
         qidw==
X-Gm-Message-State: AOAM531xduUE0oxS+79X/gU2uG+mKLxpX+aUqDk/28Foddz4TQ+gWWSr
        3aFx2VKGdU+phaAZzxFz/jg=
X-Google-Smtp-Source: ABdhPJyqcOztstp5wyyjEmvSoY0byUkJ0Oo6RqatGqdWAuzFnNlgG912IxgrW1DXNd1CW1mRqC90pg==
X-Received: by 2002:adf:fe92:: with SMTP id l18mr16941991wrr.338.1635536487982;
        Fri, 29 Oct 2021 12:41:27 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id i6sm8890225wry.71.2021.10.29.12.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:41:27 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Clean UFS HPB 2.0
Date:   Fri, 29 Oct 2021 21:41:11 +0200
Message-Id: <20211029194113.293031-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Hi Martin and  Bart,

These patches are based on Avri's patch "scsi: ufs: ufshpb: Remove HPB2.0 flows",
which has been applid to 5.15/scsi-fixes.

Bean Huo (2):
  scsi: core: Ignore the UHPPB preparation result
  scsi: ufshpb: Delete ufshpb_set_write_buf_cmd()

 drivers/scsi/ufs/ufshcd.c | 11 +++++------
 drivers/scsi/ufs/ufshpb.c | 14 --------------
 2 files changed, 5 insertions(+), 20 deletions(-)

-- 
2.25.1

