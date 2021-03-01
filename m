Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91367C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FF365207
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbhCARVh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhCARTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8B0C061788
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:26 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id e9so12343532pjj.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tsMgbI4EVDLlR5EHAMWEzUzYh+oxfclLRO1UIFJZgDw=;
        b=uSG01UZkDKj9LvsEwtJMmUAL0Lv245tr7nH67/pN5azalBA0USJdxDMT+pwnADeIB4
         PibghqL2gsiMOm0B1k3nGuEadhLo6tCFyFy3jDsVKx02d5xk8JQFFkkSFPMFh6jLuM+0
         GG5bhw4iE6pTN7AqWoKkdpjSFYX0e/3G2NQtnZKKQnlXUBNI2CnParV78der2IZb7tQY
         ZsTnlBl3VFrB9vf0S/yK16pl/3PlQHMckECbYZDL/5lWzotIZHjCSgHeKUgcUj+IPgnv
         wkUglifCp5DOCBS70T5qGM6du+i5iXgx3337B1imz2qpQSaKNHVSIPYS3y6LhR7VEbYd
         cLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tsMgbI4EVDLlR5EHAMWEzUzYh+oxfclLRO1UIFJZgDw=;
        b=a9jvi1MoTcq9bkeCb67C6eOseb6yhSOg345QQI4HZFS8mVQ+nS2+jlgG+UIZRgnXO3
         g5R+NitJFR9e0r8pOlHGiddqqYc+g7K8fhwwrsBrVtrYDagQ29yduwcVVFYjx0WNyoyd
         EDlq8DctHBvgwwAFGSfQtl4+GhTtFUVc9SGEB1xvXtSb/TiNdGY4mBvB3W8DL55wS7fs
         +171CNnojKYbvYgst0KBeoGwy2OO0d/ovwgWq1iBG+OwB7rAwSXC1f01VuY2w1nknhpJ
         gl6J4V5Tpha5WhGlrSUGOYe4H7E3H80avUB0lGE+X1WnqDSZeViFDc6pY9trG8a9Rjcm
         3SgQ==
X-Gm-Message-State: AOAM533qeuif1ObAaxj+zUl+HhrHvBSsopMRRpWeziB3Yi8dJLxd5kQ7
        H99WK/l3zCLZvkOx5bNlsruTNAYHbBg=
X-Google-Smtp-Source: ABdhPJx2fbMgBUXcI/vmK9k/JOAOuH6Q2V7sJ2OXGlavssIuuvW22LXBuPQuHy0Um0mSesgq4LSjbA==
X-Received: by 2002:a17:90a:6383:: with SMTP id f3mr18112338pjj.14.1614619105748;
        Mon, 01 Mar 2021 09:18:25 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:25 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/22] lpfc: Update lpfc to revision 12.8.0.8
Date:   Mon,  1 Mar 2021 09:17:59 -0800
Message-Id: <20210301171821.3427-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.8

This patch set contains fixes and a cleanup patches.

The patches were cut against Martin's 5.11/scsi-queue tree

v2:
  lpfc: Fix reftag generation sizing errors
    replace lpfc_scsi_get_reftag() with the system routine
    t10_pi_ref_tag()


James Smart (22):
  lpfc: Fix incorrect dbde assignment when building target abts wqe
  lpfc: Fix vport indices in lpfc_find_vport_by_vpid()
  lpfc: Fix reftag generation sizing errors
  lpfc: Fix stale node accesses on stale RRQ request
  lpfc: Fix FLOGI failure due to accessing a freed node
  lpfc: Fix lpfc_els_retry() possible null pointer dereference
  lpfc: Fix pt2pt connection does not recover after LOGO
  lpfc: Fix unnecessary null check in lpfc_release_scsi_buf
  lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
  lpfc: Fix use after free in lpfc_els_free_iocb
  lpfc: Fix status returned in lpfc_els_retry() error exit path
  lpfc: Fix dropped FLOGI during pt2pt discovery recovery
  lpfc: Fix PLOGI ACC to be transmit after REG_LOGIN
  lpfc: Fix ADISC handling that never frees nodes
  lpfc: Fix nodeinfo debugfs output
  lpfc: Fix pt2pt state transition causing rmmod hang
  lpfc: Fix crash caused by switch reboot
  lpfc: Change wording of invalid pci reset log message
  lpfc: Reduce LOG_TRACE_EVENT logging for vports
  lpfc: Correct function header comments related to ndlp reference
    counting
  lpfc: Update lpfc version to 12.8.0.8
  lpfc: update copyrights for 12.8.0.7 and 12.8.0.8 changes

 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  13 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +-
 drivers/scsi/lpfc/lpfc_els.c       | 639 ++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   6 +-
 drivers/scsi/lpfc/lpfc_init.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 272 +++++-------
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |   5 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  98 +++--
 drivers/scsi/lpfc/lpfc_sli.c       |  29 +-
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  10 +-
 15 files changed, 497 insertions(+), 597 deletions(-)

-- 
2.26.2

