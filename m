Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D71C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF0A613D0
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbhDFSF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 14:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhDFSF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 14:05:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090AAC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 11:05:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q14so5995078ybk.22
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 11:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PLqnTqrW97CAndoy42UHRBOSBlVatBc00ZpHafZzpTk=;
        b=ixyRum8wjrei3S42dV3PN5EBbIaoG3rCP9yTTqwIIhS/7MRRJcvfi8xygHu+gws3em
         IhZvxM/fZ3HVb2s6SGmZzIPO0NMYwDvOR+kx8AGSGqE88u5PzK6gXbsmNPVwBG0LKT0B
         XerGnJ6FxE+5FvtIbO4ZLaOk9CoAtK3R5elDsEsNPTPHqdpK4EOmrT4sPDmiYlrpT8YL
         sT1L7PXhgpOMPhZoLrEn/64VcmbKHke2JtnVGf+Q6m7eH60vmOCPTXv+cIlPPiT4cm17
         6PLuXJPVSCT4Qyebm1mveHlk0+WXUWcb9s5aEWNX9nXIsGn0WYdWDYTj9Pm+Ftw+bL29
         18Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PLqnTqrW97CAndoy42UHRBOSBlVatBc00ZpHafZzpTk=;
        b=k5qNREOoQVNtSpyHyvY375taO5fEcRef7DG3brfUraYAWt5MPRdIixLFKP0uJoJ39M
         scCQ7xB2b10Rf5tVaBldj2pp0zOSpC2GORxlYnYekTb9A8cI5QpjRgq72TDYbivtHCBk
         HsnoEWXuGqSS4qghv8QIjEXEcBKp97RYsjuH6aR1le4tutZG7j0pZHRLI7PHh+5gju3v
         e5q8JRjpVjarX9ruxoC/CwXdG4Djymo3waAx9wct3jr/YL4O/3nARomL6Tq0Nmm6IrsF
         vIi+pO8pOb9n8prl/8xQVDFou/IStYyNbxMnXj6nSmVjs9KurMFB4oZ9qxdWV2m9tY2f
         ssKA==
X-Gm-Message-State: AOAM530N4QK0qNDr0HYgVAQOITifuZsBsF8RcqPvnHMoQrMfdBY6kuHl
        tupHHZ3Yd67iMOlw/cfgfWsMVAyzJLV5xg==
X-Google-Smtp-Source: ABdhPJwCjSYBj/UVPEhi34n9mMFiT5CvnSMJfuVmw4/k0ch9nHjLV/1n1oC8Xh+1jCcFGjMWyY4+w7cf4b50+w==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:ff2:f4b8:7c38:13d7])
 (user=ipylypiv job=sendgmr) by 2002:a25:cc54:: with SMTP id
 l81mr31878211ybf.281.1617732347297; Tue, 06 Apr 2021 11:05:47 -0700 (PDT)
Date:   Tue,  6 Apr 2021 11:05:32 -0700
Message-Id: <20210406180534.1924345-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v2 0/2] pm80xx mpi_uninit_check() fixes
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

Changes from v1:
 - Added missing semicolons
 - Removed redundant parentheses

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
2.31.1.295.g9ea45b61b8-goog

