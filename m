Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D802DC3F2CD
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B894820842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgCDF3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:29:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38831 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCDF3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:29:53 -0500
Received: by mail-pl1-f194.google.com with SMTP id p7so497343pli.5
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5/eIUYeQKA4Qq2l1XG2mf9ytRGiAKtcwA+c6BWQWEM=;
        b=t/2UIfvCL7bVexv5giVUtWG0jIGshNMQJQplQjRQt6rrU9CgrVlyuFu04y4l73SY4N
         +2srVZZEvgCdoJaIfcs8QtuKOcVAkXbkxdQn6jCknIw5kyPAJt2u2bscj+hysxREYaNN
         r4VZJsyh/n3kKgN8hQArj6CWK9wWGD/P9yhhfqQK8JV2TNrA0puZ7K8B/elgDAuitCEb
         5mnJ8GUnj8YMmNL+FN1rnrSOgQ48o0ATKhg96ErNUL+dx10I0ritTRv3QvFKsNbuHuUA
         l62r8S5pvBsejklsuMHV56MFYwtfukgalsdlyIszPm/Hu9t9jObs9ce2TGVzCHizxwVM
         iAmg==
X-Gm-Message-State: ANhLgQ0wr/+DiRPRDCnMEe/IzUqcqtSgJxPag//BEsEBc3zpQTewxENG
        UP9zk3GdkgEwh+2I28wrPsJwWfhR9cA=
X-Google-Smtp-Source: ADFU+vslj7rO+nGMgHDTB7NL83MXJDGX5WlqBgV//J4/Sd82YVO6dBg3fpwqRognWaeRBcg4wA+Gpw==
X-Received: by 2002:a17:90a:8006:: with SMTP id b6mr1390491pjn.194.1583299791859;
        Tue, 03 Mar 2020 21:29:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id p94sm972784pjp.15.2020.03.03.21.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:29:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/6] Fix qla2xxx endianness annotations
Date:   Tue,  3 Mar 2020 21:29:39 -0800
Message-Id: <20200304052945.23250-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes the endianness annotations in the qla2xxx driver.
Please consider this patch series for the v5.7 kernel.

Thanks,

Bart.

Changes compared to v1:
- Left out the raw_smp_processor_id() patch because it may take time to achieve
  agreement about this patch.
- Added three patches to this series: two patches for verifying structure size
  at compile time and one patch for changing function names from upper case to
  lower case.

Bart Van Assche (6):
  qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
  qla2xxx: Add more BUILD_BUG_ON() statements
  qla2xxx: Fix endianness annotations in header files
  qla2xxx: Fix endianness annotations in source files
  qla2xxx: Fix the code that reads from mailbox registers
  qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
    lower case

 drivers/scsi/qla2xxx/qla_attr.c   |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.c    | 672 +++++++++++++--------------
 drivers/scsi/qla2xxx/qla_dbg.h    | 442 +++++++++---------
 drivers/scsi/qla2xxx/qla_def.h    | 711 ++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_fw.h     | 738 +++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_init.c   | 279 +++++------
 drivers/scsi/qla2xxx/qla_inline.h |   8 +-
 drivers/scsi/qla2xxx/qla_iocb.c   | 121 ++---
 drivers/scsi/qla2xxx/qla_isr.c    | 217 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c    | 111 +++--
 drivers/scsi/qla2xxx/qla_mr.c     | 111 +++--
 drivers/scsi/qla2xxx/qla_mr.h     |  32 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  12 +-
 drivers/scsi/qla2xxx/qla_nvme.h   |  46 +-
 drivers/scsi/qla2xxx/qla_nx.c     | 161 +++----
 drivers/scsi/qla2xxx/qla_nx.h     |  36 +-
 drivers/scsi/qla2xxx/qla_nx2.c    |  12 +-
 drivers/scsi/qla2xxx/qla_os.c     | 121 +++--
 drivers/scsi/qla2xxx/qla_sup.c    | 345 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c |  84 ++--
 drivers/scsi/qla2xxx/qla_target.h | 208 ++++-----
 drivers/scsi/qla2xxx/qla_tmpl.c   |  12 +-
 23 files changed, 2296 insertions(+), 2190 deletions(-)

