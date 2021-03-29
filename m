Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0970C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38D961989
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhC2ShI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhC2ShE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 14:37:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A77C061574
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 11:37:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i6so5170982ybk.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1vYqWXWgWdZ5+ahoSUjQxl0+5ThOEDP8PcqkMxFDfBY=;
        b=maPA/5otFkkMMNgtwD6uwEMcgoQ33SFCOasVZhnGsCgt4W4rUPicwKfW4F0eMC315n
         h0RPuw3CYJIHsDxEvPpLYnfFXmx3XaYrnndAe1Z4AMSj/JEehD5jGpGXWTp3mbnFQgOa
         pQfR4p/cXG/VRWdUiEf96FcIU5ZAvKqi+1PkVhZjx/b0dcVzoN+XjFM0rJekICLeH37f
         pF3g3Z7euZyBQyVQm1cqj6jkf8xBSP0p8+JOMd484Jcx/t66w4CgLWnS1gJutugTftX0
         OHRWzI2exGAsyU7XUWswpuM3ZumLeEd8zm00RlsqfS9QGdQpQ4WlYbQx4PwWL9q+i27N
         SLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1vYqWXWgWdZ5+ahoSUjQxl0+5ThOEDP8PcqkMxFDfBY=;
        b=WJL8GPyarXi/LTyDlhQlMeg0pmUZiyWoVlxa3sTv6Ob1e4ER9lcD32LpEPDHxR8N8G
         UnO5dVt5U4WmtIg7T/BjNKsjHBRt2wkHPcLgcFUO5wQxs8AGiCFpka7ixT7R4bo5eKMx
         x4iKwf6S4NYMP0zSbi9N2q/RRuLDGm4f742bNEUIcQKhw0kOwqiRoJ1BnB4caYuQRDbm
         NH2XvlXMtu4PhAWk3EYSK9quD/cWvhPkXTa50gBsvekTW8au2yoQhfMKUcP+GsS2PzYZ
         Ls3Nx+TOD6SVw2wf9MDHy4fKxsdywqcaVGVugPm/DVu0n0dctSaC4A47Y0e3aF9hDtmz
         SOuw==
X-Gm-Message-State: AOAM533F5HcfJFVWGNYf/irlR6dLk0DxiouaSW5lQfYed3aVxRaVbKJA
        zZWCcNHBASn8aA5u2KLrJegAUV3pxhDeqg==
X-Google-Smtp-Source: ABdhPJxwKAtJwX+VzYJTro//cMJmQn6yVK3VMpzm6bVc9zn5QHbU2CMtL0ZpUmbG/hCCO1R194mr2YQG6hKjSQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:31d5:9537:66db:f466])
 (user=ipylypiv job=sendgmr) by 2002:a25:c64d:: with SMTP id
 k74mr30935067ybf.56.1617043022914; Mon, 29 Mar 2021 11:37:02 -0700 (PDT)
Date:   Mon, 29 Mar 2021 11:36:37 -0700
Message-Id: <20210329183639.1674307-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 0/2] pm80xx mpi_uninit_check() fixes
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series changes the wait time handling in mpi_uninit_check() to
make it similar to mpi_init_check().

In commit e90e236250e9 ("scsi: pm80xx: Increase timeout for pm80xx
mpi_uninit_check") the wait time for the inbound doorbell was increased
in the mpi_init_check() instead of the mpi_uninit_check().

Note:
SPC[/V]_DOORBELL_CLEAR_TIMEOUT defines could not be used in the first
commit in this series because the values were decreased in
commit d71023af4bec0 ("scsi: pm80xx: Do not busy wait in MPI init check").

Igor Pylypiv (2):
  scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
  scsi: pm80xx: Remove busy wait from mpi_uninit_check()

 drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

