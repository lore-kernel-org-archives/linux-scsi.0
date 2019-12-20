Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4752FC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0972B2082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjGkQpBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLTWhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:32 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:33238 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfLTWhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:32 -0500
Received: by mail-pl1-f170.google.com with SMTP id c13so4720610pls.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RAs2y1rPECK1aQkAX7+Vc9j98b2uHXh0BIB89YkO5Eo=;
        b=QjGkQpBeQO7c4Y1B/vCRYQGWkbKXGXR7N9coavWFPVYzrLDm+7oJhNlSg8iHds8oHN
         dt5mzqf5SwABD9gPCm7Qpieo+qi7X4jd7P3HjPnP/Bi9vIWwVfiU5rTqQetbQxvaJzyG
         6mJQCVvh0jAxVV5cAaK2NHB5e7MwGX/gIoNDskCqhZwoyX9ECtml2kiCvsuxn78qwdHA
         tIC3D93MmA/7EfOWx8bcwGDPGk8sfEERPw22c1O+7+BSrODukyDsJlvDk4XIO/Q0WuU4
         43sCFbIeFnVY3SPNjPIIRQiKirHltwVLANOgg0F1XQeU1D7XmEmFL4mIpmIOw9cQuH9+
         o5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RAs2y1rPECK1aQkAX7+Vc9j98b2uHXh0BIB89YkO5Eo=;
        b=XCQP8ZTH+ZflnBcZZdUneuS+lDqzA6u/Z0ygv3cvKGfYSakMLEN5iDU0daPgjWnFVt
         VT0qVOtlldyC/Wzm0LEHw/gBiNi/IduVJNxpI9ehogx5ME3vdsYgjxotlnv/b3y7iPRb
         C+ZgQl+wSgDk22imI8gGqoWwXdSApquXWwOF9sS4jSMzqR31uWtQ9mdScHOX8LeRuJr0
         gX50OhJ1HobKSk8aSy9eVRSoL7g4x31QA9Tq1ZNkX/Rkco3H52ftJciyyck4lx9p6xb0
         7fRIvSbU+HfJOi0wH6V/KHXH7MQSRI+8ga6z+RF8xbBPYu2rx2Qp0v/rx7GP+HCdUR5o
         2Q4A==
X-Gm-Message-State: APjAAAXOadYiaYZFFaF7+LG5ueAEkVWdvc5KOynfBi+oCxVXnC0bbExG
        bwi1pVprS4s6qIbEu4zaeE9nJU2a
X-Google-Smtp-Source: APXvYqwfxGgJfOqHKfqr2PiSMUv1vDXxrjg74UuxHRHxuhsKiS4P2EDI4ZdNYL97971GHj7BffalIg==
X-Received: by 2002:a17:902:7046:: with SMTP id h6mr15511273plt.231.1576881451296;
        Fri, 20 Dec 2019 14:37:31 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/32] [NEW] efct: Broadcom (Emulex) FC Target driver
Date:   Fri, 20 Dec 2019 14:36:51 -0800
Message-Id: <20191220223723.26563-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set is a request to incorporate the new Broadcom
(Emulex) FC target driver, efct, into the kernel source tree.

The driver source has been Announced a couple of times, the last
version on 12/18/2018. The driver has been hosted on gitlab for
review has had contributions from the community.
  gitlab (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)

The driver integrates into the source tree at the (new) drivers/scsi/elx
subdirectory.

The driver consists of the following components:
- A libefc_sli subdirectory: This subdirectory contains a library that
  encapsulates common definitions and routines for an Emulex SLI-4
  adapter.
- A libefc subdirectory: This subdirectory contains a library of
  common routines. Of major import is a number of routines that
  implement a FC Discovery engine for target mode.
- An efct subdirectory: This subdirectory contains the efct target
  mode device driver. The driver utilizes the above librarys and
  plugs into the SCSI LIO interfaces. The driver is SCSI only at
  this time.

The patches populate the libraries and device driver and can only
be compiled as a complete set.

This driver is completely independent from the lpfc device driver
and there is no overlap on PCI ID's.

The patches have been cut against the 5.6/scsi-queue branch.

Thank you to those that have contributed to the driver in the past.

Review comments welcome!

-- james


V2 modifications:

Contains the following modifications based on prior review comments:
  Indentation/Alignment/Spacing changes
  Comments: format cleanup; removed obvious or unnecessary comments;
    Added comments for clarity.
  Headers use #ifndef comparing for prior inclusion
  Cleanup structure names (remove _s suffix)
  Encapsulate use of macro arguments
  Refactor to remove static function declarations for static local routines
  Removed unused variables
  Fix SLI4_INTF_VALID_MASK for 32bits
  Ensure no BIT() use
  Use __ffs() in page count macro
  Reorg to move field defines out of structure definition
  Commonize command building routines to reduce duplication
  LIO interface:
    Removed scsi initiator includes
    Cleaned up interface defines
    Removed lio WWN version attribute.
    Expanded macros within logging macros
    Cleaned up lio state setting macro
    Remove __force use
    Modularized session debugfs code so can be easily replaced.
    Cleaned up abort task handling. Return after initiating.
    Modularized where possible to reduce duplication
    Convert from kthread to workqueue use
    Remove unused macros
  Add missing TARGET_CORE build attribute
  Fix kbuild test robot warnings

Comments not addressed:
  Use of __packed: not believed necessary
  Session debugfs code remains. There is not yet a common lio
    mechanism to replace with.


James Smart (32):
  elx: libefc_sli: SLI-4 register offsets and field definitions
  elx: libefc_sli: SLI Descriptors and Queue entries
  elx: libefc_sli: Data structures and defines for mbox commands
  elx: libefc_sli: queue create/destroy/parse routines
  elx: libefc_sli: Populate and post different WQEs
  elx: libefc_sli: bmbx routines and SLI config commands
  elx: libefc_sli: APIs to setup SLI library
  elx: libefc: Generic state machine framework
  elx: libefc: Emulex FC discovery library APIs and definitions
  elx: libefc: FC Domain state machine interfaces
  elx: libefc: SLI and FC PORT state machine interfaces
  elx: libefc: Remote node state machine interfaces
  elx: libefc: Fabric node state machine interfaces
  elx: libefc: FC node ELS and state handling
  elx: efct: Data structures and defines for hw operations
  elx: efct: Driver initialization routines
  elx: efct: Hardware queues creation and deletion
  elx: efct: RQ buffer, memory pool allocation and deallocation APIs
  elx: efct: Hardware IO and SGL initialization
  elx: efct: Hardware queues processing
  elx: efct: Unsolicited FC frame processing routines
  elx: efct: Extended link Service IO handling
  elx: efct: SCSI IO handling routines
  elx: efct: LIO backend interface routines
  elx: efct: Hardware IO submission routines
  elx: efct: link statistics and SFP data
  elx: efct: xport and hardware teardown routines
  elx: efct: IO timeout handling routines
  elx: efct: Firmware update, async link processing
  elx: efct: scsi_transport_fc host interface support
  elx: efct: Add Makefile and Kconfig for efct driver
  elx: efct: Tie into kernel Kconfig and build process

 MAINTAINERS                            |    8 +
 drivers/scsi/Kconfig                   |    2 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/elx/Kconfig               |    9 +
 drivers/scsi/elx/Makefile              |   30 +
 drivers/scsi/elx/efct/efct_driver.c    | 1031 +++++
 drivers/scsi/elx/efct/efct_driver.h    |  150 +
 drivers/scsi/elx/efct/efct_els.c       | 1953 +++++++++
 drivers/scsi/elx/efct/efct_els.h       |  136 +
 drivers/scsi/elx/efct/efct_hw.c        | 6742 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        | 1099 ++++++
 drivers/scsi/elx/efct/efct_hw_queues.c | 1648 ++++++++
 drivers/scsi/elx/efct/efct_hw_queues.h |   67 +
 drivers/scsi/elx/efct/efct_io.c        |  203 +
 drivers/scsi/elx/efct/efct_io.h        |  196 +
 drivers/scsi/elx/efct/efct_lio.c       | 1921 +++++++++
 drivers/scsi/elx/efct/efct_lio.h       |  192 +
 drivers/scsi/elx/efct/efct_scsi.c      | 1572 ++++++++
 drivers/scsi/elx/efct/efct_scsi.h      |  313 ++
 drivers/scsi/elx/efct/efct_unsol.c     |  835 ++++
 drivers/scsi/elx/efct/efct_unsol.h     |   49 +
 drivers/scsi/elx/efct/efct_utils.c     |  446 +++
 drivers/scsi/elx/efct/efct_utils.h     |   83 +
 drivers/scsi/elx/efct/efct_xport.c     | 1472 +++++++
 drivers/scsi/elx/efct/efct_xport.h     |  205 +
 drivers/scsi/elx/include/efc_common.h  |   52 +
 drivers/scsi/elx/libefc/efc.h          |   99 +
 drivers/scsi/elx/libefc/efc_device.c   | 1658 ++++++++
 drivers/scsi/elx/libefc/efc_device.h   |   72 +
 drivers/scsi/elx/libefc/efc_domain.c   | 1126 ++++++
 drivers/scsi/elx/libefc/efc_domain.h   |   52 +
 drivers/scsi/elx/libefc/efc_fabric.c   | 1762 +++++++++
 drivers/scsi/elx/libefc/efc_fabric.h   |  116 +
 drivers/scsi/elx/libefc/efc_lib.c      |  131 +
 drivers/scsi/elx/libefc/efc_node.c     | 1343 +++++++
 drivers/scsi/elx/libefc/efc_node.h     |  188 +
 drivers/scsi/elx/libefc/efc_sm.c       |  213 +
 drivers/scsi/elx/libefc/efc_sm.h       |  140 +
 drivers/scsi/elx/libefc/efc_sport.c    |  843 ++++
 drivers/scsi/elx/libefc/efc_sport.h    |   52 +
 drivers/scsi/elx/libefc/efclib.h       |  637 +++
 drivers/scsi/elx/libefc_sli/sli4.c     | 5748 +++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h     | 4296 ++++++++++++++++++++
 43 files changed, 38891 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_els.c
 create mode 100644 drivers/scsi/elx/efct/efct_els.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.h
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h
 create mode 100644 drivers/scsi/elx/efct/efct_utils.c
 create mode 100644 drivers/scsi/elx/efct/efct_utils.h
 create mode 100644 drivers/scsi/elx/efct/efct_xport.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.h
 create mode 100644 drivers/scsi/elx/include/efc_common.h
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efc_device.c
 create mode 100644 drivers/scsi/elx/libefc/efc_device.h
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h
 create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.h
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

-- 
2.13.7

