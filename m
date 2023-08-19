Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31DDEE49A5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Aug 2023 00:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjHTAVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Aug 2023 20:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjHTAUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2023 20:20:42 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4A0DC5D2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58cb845f2f2so32670817b3.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692480648; x=1693085448;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zGv/v6naep/b+mIMHZ4DeLrWqaJwD2hmPCv9H75nQsI=;
        b=s8ET6mhpE+LhYgPrhI/n0PfmPkeNhwcLIUZ2LaAvglluGcjMhgUaA1o7ClJGVi9dTH
         SNGcXcuvrf7cbU++U5aPAun/GkaiSTWwdppzBGJtm5kK8BHXMRT8Ummkq3CHV3TYOtbm
         lq5gQVCkwY8SqGXBYWPtizC30aG++Ty4CWQOEwkXk6ZYw78yZE1A99wy4T4iI327WMJY
         oR99a17elTeWR1flAfCrtBWGeIQy8RLT+bkuuKf879mI3XYkzer9i9/fPGfpQ5H+2/9q
         lV0A68qFlvBwad3vogLPAs0XP+QNsVHeVkFlq/3WwvZP7dhuoJUGppu1adghTZWHy+RQ
         K1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692480648; x=1693085448;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGv/v6naep/b+mIMHZ4DeLrWqaJwD2hmPCv9H75nQsI=;
        b=HinkzaP/wgqoWbKZbT8SbNfIwkh7LixuXlJ16BKgFWxHLxmMzQ2KbUhQs5qpAkgfF8
         WwBuEVG6v2f1iQfJehBilK9zPukb2w4NPGAoIPfhv0YTQ8tcaRUdjH2/Bslt0ZnA48SZ
         SoCQjI7/e2IjNfeXhAQIXRfs//S4+u7rRP5smOjt19nB0U2lwK6AXVV00LiXf6DL81tQ
         hfaERXQYi0CuIYa9qJSuoisVa53NE7Fi93zkilFmAKeQD2t524QSaHaAjvZh1mGmSDU5
         xnTmNxVc+KcqE6JyDjDsa2UXb2WAA97Df22fvq1JyGymy/ro8FhGm1NmLNdy4DowXFzI
         KsIQ==
X-Gm-Message-State: AOJu0YzH5XJMj0wxTSFwnJz5M2KWyluarmLgWylZjqUYL6uG6hXDALmI
        k9+cYA61dD0kkL7O9aiGIOnWz00RL7cUoQ==
X-Google-Smtp-Source: AGHT+IGMfNOGO9BybL8+kcoUYEsMcbZKh7bXpkFGO2q03PTW8d6RJgUJFkP5aLlshSvGzjkym/hYP4XWSJP3aA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:7789:3ff3:28cf:bae9])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1612:b0:d47:f09c:cc8e with SMTP
 id bw18-20020a056902161200b00d47f09ccc8emr19762ybb.10.1692480648706; Sat, 19
 Aug 2023 14:30:48 -0700 (PDT)
Date:   Sat, 19 Aug 2023 14:30:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819213040.1101044-1-ipylypiv@google.com>
Subject: [PATCH v2 0/2] Returning FIS on success for CDL
From:   Igor Pylypiv <ipylypiv@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series plumbs libata's request for a result taskfile
(ATA_QCFLAG_RESULT_TF) through libsas to pm80xx LLDD. Other libsas LLDDs
can start using the newly added return_fis_on_success as well, if needed.

For Command Duration Limits policy 0xD (command completes without
an error) libata needs FIS in order to detect the ATA_SENSE bit and read
the Sense Data for Successful NCQ Commands log (0Fh). pm80xx HBAs do not
return FIS on success by default, hence, the driver is updated to set
the RETFIS bit (Return FIS on good completion) when requested by libsas.

Changes since v1:
- Dropped the ata_qc_has_cdl() helper
- Changed the condition when return_fis_on_success is getting set from
  "qc->flags & ATA_QCFLAG_HAS_CDL" to "qc->flags & ATA_QCFLAG_RESULT_TF".
  The latter is more generic solution that works for non-CDL use cases
  as well.
- Updated the retfis setting code in pm80xx to avoid potential compiler
  issues with single bit fields.

Igor Pylypiv (2):
  scsi: libsas: Add return_fis_on_success to sas_ata_task
  scsi: pm80xx: Set RETFIS when requested by libsas

 drivers/scsi/libsas/sas_ata.c    |  3 +++
 drivers/scsi/pm8001/pm8001_hwi.c | 11 ++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 17 ++++++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 include/scsi/libsas.h            |  1 +
 6 files changed, 24 insertions(+), 12 deletions(-)

-- 
2.42.0.rc1.204.g551eb34607-goog

