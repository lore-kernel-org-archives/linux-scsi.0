Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FA5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF6260F46
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhJTVop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTVom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:44:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C9C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:27 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a12-20020a17090aa50cb0290178fef5c227so2928173pjq.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7NnJZ42eqWEPkFx/B5bfT9udQ3xTI4Ztrgig+xCBc0Y=;
        b=gbgCeWT8HRQSzDuKN5wtfw3WzzjRBUBBZzmyAU+5pAJu7DWhI177R7G2pS9RTNFFXj
         qMZcgJuoUn8DBUhIynqtbPcRCBKXcvhizP5H4OVJ9Ki0S3vIlfGvRGmSXeSVkdyO1JDj
         AnyWYRg5Ac0bzbvVfc55allB3ShR2QCRuN139Qpie/WddAUHmFYBu070LwLMvkP73KDy
         a6y/HTeIIuSv0KWVygBIq/RoMOFHKdKT9QvcdZUEU3Y0o5vv7UG8NpLXro+RiuzrXsRT
         gL24gsiTDA79WQEKzUruTLDYiJQ55iCVb/03uOVycsNFae8G4A62wvGGjPgJ3EhlwKDt
         AENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7NnJZ42eqWEPkFx/B5bfT9udQ3xTI4Ztrgig+xCBc0Y=;
        b=dbeqsUCTYs0l400Z9VCrWVvE3jurmo/m7WkGDmvXYh3Nu3fA3MUJ+vLOGdKOMu2nzn
         rT7Z1JZ7UZ02FB9kfmRsgOG3hNTi9vzeieZtoUCP8JDr6g7SLkn8udWb7iJu+QyFPx5v
         trd+f9P2q6wNV9KsF8LAjHY+H7H7lGfiPvlTvJse6Iso1m7jfXT8QjYWuC0Qm1Uu7j9k
         tD91RSgYomnExbmC3ra1REuXeYxWLq+/pN48DvOHzN8UVxp6F1wZ+UuWZsmmOGiRwMQD
         ZajvLUZIcVhr4P5+bJyL/VoheEozHSQjiFBynTrzhYhFImhF4dlyKo1f+fHmGEpLKtVI
         dEGw==
X-Gm-Message-State: AOAM531+qC6jtzHfuvoDRIH63y9jYdLatwuYfc5F1jSJ42UqCRVi3Klt
        mB2/iRGn6fMlwfimIcR/Cm9Tw5pmAI1ICcVS
X-Google-Smtp-Source: ABdhPJxouzMlwNq0bJowztDWmFG0DgxWbPt+aE2DkKH94uUc017jyfPSKNS0eK/85dhphhBBRyKDZHXS+H0fBqTO
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:a1d4:87fc:d5c6:fa8f])
 (user=changyuanl job=sendgmr) by 2002:a17:902:c10c:b0:13f:68b4:4abe with SMTP
 id 12-20020a170902c10c00b0013f68b44abemr1594743pli.8.1634766146927; Wed, 20
 Oct 2021 14:42:26 -0700 (PDT)
Date:   Wed, 20 Oct 2021 14:42:05 -0700
Message-Id: <20211020214207.1248986-1-changyuanl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v1 0/2] This patchset adds tracepoints to pm80xx
From:   Changyuan Lyu <changyuanl@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Changyuan Lyu (2):
  scsi: pm80xx: Add tracepoints
  scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint

 drivers/scsi/pm8001/Makefile             |   7 +-
 drivers/scsi/pm8001/pm8001_hwi.c         |   5 +
 drivers/scsi/pm8001/pm8001_sas.c         |  16 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c         |   7 ++
 drivers/scsi/pm8001/pm80xx_tracepoints.c |  10 ++
 drivers/scsi/pm8001/pm80xx_tracepoints.h | 113 +++++++++++++++++++++++
 6 files changed, 156 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.h

-- 
2.33.0.1079.g6e70778dc9-goog

