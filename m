Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30B3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA0E63219
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhKOWyg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353653AbhKOWpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 17:45:05 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D2EC034018
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:54 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id l7-20020a622507000000b00494608c84a4so10644373pfl.6
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YsZ4KXChLC2bUyDKJS2V3W28EBYy33HBmNk1vhM7ndI=;
        b=aSRJKMLHc3cI8ZL+CvOSUurM8LRCt8tXGgxYIv0pE2+/T9r/vALk1q6Bqagd8YY5r1
         9g1IR6g4muicYfbchQowKcmxoYCtS8kP6S2eN7FcbMkkFea90Lr76YvvmHRpgg3nDIzE
         mzcwFAaEriCur0N8Be2UuHwLJkG7TUtwuLWxEYWK7WFtTlWnjl6iEtTjSgHzIHT4hX/t
         sVk/sRIXc2+XmZmFmzQiQk33Fij+F39rGaC586Ag05ruwahowI9osuvrUWjhArex0CmH
         Ie86l+qHLqZk/vS4n91QBUpVVY8QmS2ric6THgl9HPISGj0W+4u+lqgaoA4Qm5L1JnjO
         nr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YsZ4KXChLC2bUyDKJS2V3W28EBYy33HBmNk1vhM7ndI=;
        b=ROiCX3XAz81Z5ZZCh2ixRL+YZRGl84lZPykoCbxZE8Edm9cH7rZZr3asL1pP8dTbyP
         iV72ivmrmSWxODyGWV6sT+BkuoRjzKsslJNp76xEqWzmhUwSyTtI/ajQgGnhYQtg8VV2
         xbFyHhMCTXAgzmzQD11WUVU8N769oJPtlC14Zhp47lNRmijp2yOtQuQgl50eH8pztXHR
         3L+J16Ix/eEzfuTJzwcvOSbYaxbfj8bvLr2e98VG3Y2amb0U4Gv7JBo/D0qHosTnYlUT
         2UsknqwRSDzCUQVCr/UBVIJo3D0L22XMuZQQX6h9smsKjGwjgr1NCwx/STbtebd+t5nX
         vvHQ==
X-Gm-Message-State: AOAM531qYmo4Xt8sxP7c2uX8IOE8eJpU7pIGx8ZnrGBgoSI4lJOZzFft
        TvhC2vD2jNjtCVfCHQBmBPENEfz8cPvhAxJ3
X-Google-Smtp-Source: ABdhPJzMwB1g00OkBWgE4lJYP+k7rXA4EB+LKxhm3cIyVNDNwH389eriVb+ECb+EksL0WG2zJQ/Mv+4d1dHgdpnX
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:f30c:72b6:c6d5:9b63])
 (user=changyuanl job=sendgmr) by 2002:a17:90b:2389:: with SMTP id
 mr9mr69500533pjb.152.1637013473984; Mon, 15 Nov 2021 13:57:53 -0800 (PST)
Date:   Mon, 15 Nov 2021 13:57:48 -0800
Message-Id: <20211115215750.131696-1-changyuanl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 0/2] This patchset adds tracepoints to pm80xx
From:   Changyuan Lyu <changyuanl@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2: added le32_to_cpu() when calling trace_pm80xx_mpi_build_cmd()
to eliminate the incorrect type error in patch `scsi: pm80xx: Add 
pm80xx_mpi_build_cmd tracepoint`.
Reported-by: kernel test robot <lkp@intel.com>

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
2.34.0.rc1.387.gb447b232ab-goog

