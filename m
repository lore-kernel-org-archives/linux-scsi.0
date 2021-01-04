Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E50CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D694420784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbhADSDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhADSDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:03:31 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C3BC061574
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:02:51 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s15so14937181plr.9
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9F95oshbdfQZvwYsmSAyaOyfe/ThjcJco3M1PVoDf0c=;
        b=HXJHS0QeXJIlXF5V0uT7gIDHIEE7PmxewXabvNdRgqcK4Wfi2SylVOPzJtIxdjIQNs
         zlewULX0KkZiWwMJBMYm4ny3R6K/NtSzWkh9NCQMyMt/n30abaiIzNKCL6i3EzKANFFf
         tKrcmDonIfvML/wEYyIonprIqv08lHL/z0kVUiQdl/MAWcHqGlKUD3HPgAaJDDbR8QS5
         bB/cog6juFSiwSiuCe8CeoTn7FRuP6ccFiCKrzlR+YWNwXGFcuO7Sa1p+ELdNJ4UmMSA
         dnJGejwFzDqJtmbx81LhgIWg4fGNh3sBLNw/noYUoKT4cMnc9rrsz3xN52FYA+3LN4dG
         +sgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9F95oshbdfQZvwYsmSAyaOyfe/ThjcJco3M1PVoDf0c=;
        b=FC+XakzQ6IbE0du6gvOt+jXTQ0NlXXqGbyCbKsM51l2mcsElN8i7qlvwvs5u7yss/6
         rUfjpI7UkZFyxvU57jEO38HCy4EoUZYR8kk0frDJjeUeqjKEpNg+s+R7doFtZAf/2XPm
         vRuhpDgm6yq/50rT2V+OK4OI3BbL2PfRHkUehHIv/aKThbQSgaDDlAec+b1tlf7Xju7m
         BLw0fnIsR8bbMLBA5JvoXvQPwhQ18Li2MDFL0cnhYBS2R2yQEk00g0jAosO6IOwcsEJH
         R2Y9gB91lWtnmbKbcNInnjzff65aNCOnFjrUDG88ZgvORsQp4ke/AWKLjvLa0as2eSj+
         n2zg==
X-Gm-Message-State: AOAM531FVp7VZ+/jv9JRveT7tFk0XrXE1IeWI5f3N+7HZi1meh+AqehC
        +IKUUOtEllb+01iHD7F21aHXSsEBmsU=
X-Google-Smtp-Source: ABdhPJzmMd2VhS+TX3MbirkV8gFtc77/k5cMXGhQ+9pHSDTQ8m5YAKzlfYRO2hZqaQf37jkaq6SQXQ==
X-Received: by 2002:a17:90a:b284:: with SMTP id c4mr41366pjr.183.1609783369953;
        Mon, 04 Jan 2021 10:02:49 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:02:49 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/15] lpfc: Update lpfc to revision 12.8.0.7
Date:   Mon,  4 Jan 2021 10:02:25 -0800
Message-Id: <20210104180240.46824-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.7

This patch set contains fixes and a cleanup of trace logging.

The patches were cut against Martin's 5.11/scsi-queue tree

---
v2:
 Reword description on patch 7 as it wasn't quite right:
   Prevent duplicate requests to unregister with cpuhp framework

James Smart (15):
  lpfc: Fix PLOGI S_ID of 0 on pt2pt config
  lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3
  lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
  lpfc: Fix crash when a fabric node is released prematurely.
  lpfc: Use the nvme-fc transport supplied timeout for LS requests
  lpfc: Fix FW reset action if IOs are outstanding
  lpfc: Prevent duplicate requests to unregister with cpuhp framework
  lpfc: Fix error log messages being logged following scsi task mgnt
  lpfc: Fix target reset failing
  lpfc: Fix NVME recovery after mailbox timeout
  lpfc: Fix vport create logging
  lpfc: Fix crash when nvmet transport calls host_release
  lpfc: Implement health checking when aborting io
  lpfc: Enhancements to LOG_TRACE_EVENT for better readability
  lpfc: Update lpfc version to 12.8.0.7

 drivers/scsi/lpfc/lpfc.h           |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   9 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   6 +-
 drivers/scsi/lpfc/lpfc_disc.h      |  15 +-
 drivers/scsi/lpfc/lpfc_els.c       |  47 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  21 ++-
 drivers/scsi/lpfc/lpfc_init.c      | 241 +++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  21 ++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  45 +++---
 drivers/scsi/lpfc/lpfc_nvmet.c     |  33 +++-
 drivers/scsi/lpfc/lpfc_scsi.c      |  58 ++++++-
 drivers/scsi/lpfc/lpfc_sli.c       | 141 +++++++++++------
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   2 +-
 14 files changed, 436 insertions(+), 209 deletions(-)

-- 
2.26.2

