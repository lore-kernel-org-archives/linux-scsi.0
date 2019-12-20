Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECC8C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015C124679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dDg8popt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTKcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:23 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:37506 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:23 -0500
Received: by mail-pf1-f181.google.com with SMTP id p14so4967413pfn.4
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HRlCo0nVJSOCs9WhaN2hULgO0NzL0dhWeIh4uDf3Gho=;
        b=dDg8poptbYR5PcuXmfBeTaqA3wGvQpWwaalZP/Ok1UhMZbCd0iCABJI7bYpgL20/sP
         Q7DhxSawtJ0L95fET+j/Z/9vdmnNtFIJv6rBBrjF5OY52KA7yzCy6rQsNh69/S3MSoU9
         Aq7nUnoA2X7IefmcPp4XIOsMP1sHbX1IEgUR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HRlCo0nVJSOCs9WhaN2hULgO0NzL0dhWeIh4uDf3Gho=;
        b=Oa29ylRVTJoJxDLV9PI3brkOlTVoBW2Y0R1bVGOGnq5pE8tvOp7df1t3utZTY8azGn
         3J2TiLwngo1D9xBWrF1i7rhO3gQdkA9nal1Q2y1Wo3VC5897+tCU1iHnAj6AU3ky6yDx
         Hjaon4lH5a2ILCNJsk3sGcbkJ/63+VJdFlOjGXTO9c1FL26ssiXzhkgC6zS2QfDKJWUd
         PdlC2t+nsFVaG1nd1xvpsefgmhOwK5khEi/ZVos4ShSv7SKyJvGioL6x+s3KlAuWCFez
         Nu4QeI5QuUk6R7yKu+yy9c34+abF6VHVOHyOS7eSZw6SiejOR+QH8l9MYVs17PUuJKkR
         cxPQ==
X-Gm-Message-State: APjAAAWZuEk5+SNb6VilSe7xNFvbZ3LmLZZ9dhxDI3/iGu9Pj8tajCBd
        UKZp+vh5tjLDyBxzZGywQxNrUBU2CQ7D192FvN6w477nLL398feByHV95emvwp2cRavVWPHZhar
        wxdxhDt4OvTzxgQRlH8sBQ1xtDHyoPg+onYtJ9PNRQAelrnjANAbRPca6l9eLjaUSAOCgn7FfhP
        PxbCYz7EJ7OhbTfgukwA==
X-Google-Smtp-Source: APXvYqzGy5D7GbonLixGxOvPZt+Isrz36jhltCYc/Hat9OPNzsmhA1NUmtyu+icuEHQLoE+ROef2yA==
X-Received: by 2002:a62:f94d:: with SMTP id g13mr15014638pfm.60.1576837942230;
        Fri, 20 Dec 2019 02:32:22 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:21 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 00/10] mpt3sas: Enhancements of phase14
Date:   Fri, 20 Dec 2019 05:32:00 -0500
Message-Id: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Below are the main features are added in this patch set.

* Add support for NVMe shutdown operation. Where driver
issues IO Unit Control Shutdown message to Firmware during
system shutdown to inform that shutdown operation has
initiated. SO that Firmware issue NVMe shutdown command
to NVMe drives attached to it.

* Add support for new IOC state named 'CoreDump'. Once
driver detects this new state then driver has stop sending
any new requests and has wait for firmware to change the
IOC state from CoreDump to Fault State. In CoreDump state
Firmware will copy its logs to CoreDump flash region.

* Optimize the driver logging so that most of the important
information will be captured in the first instance of failure
logs itself with default logging level.

Suganath Prabu S (10):
  mpt3sas: Update MPI Headers to v02.00.57
  mpt3sas: Add support for NVMe shutdown.
  mpt3sas: renamed _base_after_reset_handler function
  mpt3sas: Add support IOCs new state named COREDUMP
  mpt3sas: Handle CoreDump state from watchdog thread
  mpt3sas: print in which path firmware fault occurred
  mpt3sas: Optimize mpt3sas driver logging.
  mpt3sas: Print function name in which cmd timed out
  mpt3sas: Remove usage of device_busy counter
  mpt3sas: Update drive version to 33.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   6 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  19 +-
 drivers/scsi/mpt3sas/mpi/mpi2_image.h    |   7 +
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 340 ++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  45 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  39 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  46 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 222 +++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  11 +-
 10 files changed, 594 insertions(+), 149 deletions(-)

-- 
2.18.1

