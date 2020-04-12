Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4AEC2D0EC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 035FB2073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfEqjB23"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgDLDdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44084 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgDLDdL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id n13so2921413pgp.11
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AtKKoeTd7u4T+aN6O1A3JfYtPF04+IdexdVwAFkbgCY=;
        b=UfEqjB239uA81YMZVddnnRDywkPOjh+wxWUw3k2cSrJ3SepLBm0ugerCl/Ze/iwO1c
         kqxwpSgdEU7Ab3XsA3M+/Z5xm4rPVRNRx4eD1qfog0jf1ZCvVDzBrJ8E1V1F7thFec6I
         bF3rAieITClvab4par6I5SXcYc9dvyCVsAuDpX0d+dZz6KVxvRhhLhSwri/wuL+2XaJZ
         ssMu4BfrwMGvpf4W7w3h71gj5W7Izwzs5PMA3PbvCZD4yzbd4JypDwNqZo+IE1fkBb7q
         9tGKg+ADWAmAwLkI1jxnHmf9h/JxJl975c2FneUtBRZXwTUNRANCIM+ioCkQ2LXrmKZS
         z3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AtKKoeTd7u4T+aN6O1A3JfYtPF04+IdexdVwAFkbgCY=;
        b=lBv4FhLcBzNLHKbY/JhZufINrPI/PSiSorZW7R1s0zUdicuQtu16J+Q7YooMSYXRlY
         8YznayehcGqKivsAFcI5WxS0uLD5AAHRRN266x+iy58nny1f6gF9K/Tx4Tko6a9hhxqp
         p9Yij3NWmrUMJAqE67K4B/5EPgv60estbXouebR5AO23EVplCgLiMTZONQ20SoKy9q2B
         NSsG0VtjxcqT6sYz8b5v9nJ8eVvnYaH4vqSgh4PwLSwbglm8RtBpk607Fr5NWkMB+6PT
         9KBJL+FdmWk2gZ0yaHUl31uHlTJsMznU5CC38PaILNxhW4caqyvPkQUr9PvdbXpVerbK
         qM8w==
X-Gm-Message-State: AGi0Puaj8VHF1WeL0qv+5KzM/vSyWpPaOhRVVQ/gIi32sHC9t968oAVT
        6Ks8Z7DJwjkKESSZM0HESXc+vyJc
X-Google-Smtp-Source: APiQypKihoMyAd8Tzy7R1br5dQ/eZ5x+S7CHHG5Ugf718ZjGynpfsNg7aaZztiW0zr0fl1e2MEXx1Q==
X-Received: by 2002:a62:83c3:: with SMTP id h186mr12161873pfe.4.1586662389999;
        Sat, 11 Apr 2020 20:33:09 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 00/31] [NEW] efct: Broadcom (Emulex) FC Target driver
Date:   Sat, 11 Apr 2020 20:32:32 -0700
Message-Id: <20200412033303.29574-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set is a request to incorporate the new Broadcom
(Emulex) FC target driver, efct, into the kernel source tree.

The driver source has been Announced a couple of times, the last
version on 12/20/2019. The driver has been hosted on gitlab for
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

The patches have been cut against the 5.7/scsi-queue branch.

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

V3 modifications:
  Changed anonymous enums to named enums
  Split gaint enums into multiple enums
  Use defines to spell out _MASK values directly
  Changed multiple #defines to named enums and a few vice versa cases
    for consistency
  Added Link Speed support for up to 128G
  Removed efc_assert define. Replaced with WARN_ON.
  Returned defined return values EFC_SUCCESS & EFC_FAIL
  Added return values for routines returning more than those 2 values
  Reduction of calling arguments in various routines.
  Expanded dump type and status handling
  Fixed locking in discovery handling routines.
  Fixed line formatting length and indentation issues.
  Removed code that was not used.
  Removed Sparse Vector APIs and structures. Use xarray api instead.
  Changed node pool creation. Use mempool and allocate dma memory when
    required
  Bug Fix: Send LS_RJT for non FCP PRLIs
  Removed Queue topology string and parsing routines and rework queue
    creation. Adapter configuration is implicitly known by the driver
  Used request_threaded_irq instead of using our thread
  Reworked efct_device_attach function to use if statements and gotos
  Changed efct_fw_reset, removed accessing other port
  Convert to used pci_alloc_irq_vectors api
  Removed proc interface.
  Changed assertion log messages.
  Unified log message using cmd_name
  Removed DIF related code which is not used
  Removed SCSI get property
  Incorporated LIO interface review comments
  Reworked xxx_reg_vpi/vfi routines
  Use SPDX license in elx/Makefile
  Many more small changes.
  

James Smart (31):
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
  elx: efct: Firmware update, async link processing
  elx: efct: scsi_transport_fc host interface support
  elx: efct: Add Makefile and Kconfig for efct driver
  elx: efct: Tie into kernel Kconfig and build process

 MAINTAINERS                            |    8 +
 drivers/scsi/Kconfig                   |    2 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/elx/Kconfig               |    9 +
 drivers/scsi/elx/Makefile              |   18 +
 drivers/scsi/elx/efct/efct_driver.c    |  856 +++++
 drivers/scsi/elx/efct/efct_driver.h    |  142 +
 drivers/scsi/elx/efct/efct_els.c       | 1928 +++++++++++
 drivers/scsi/elx/efct/efct_els.h       |  133 +
 drivers/scsi/elx/efct/efct_hw.c        | 5347 +++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        |  864 +++++
 drivers/scsi/elx/efct/efct_hw_queues.c |  765 +++++
 drivers/scsi/elx/efct/efct_io.c        |  198 ++
 drivers/scsi/elx/efct/efct_io.h        |  191 ++
 drivers/scsi/elx/efct/efct_lio.c       | 1840 +++++++++++
 drivers/scsi/elx/efct/efct_lio.h       |  178 +
 drivers/scsi/elx/efct/efct_scsi.c      | 1192 +++++++
 drivers/scsi/elx/efct/efct_scsi.h      |  235 ++
 drivers/scsi/elx/efct/efct_unsol.c     |  813 +++++
 drivers/scsi/elx/efct/efct_unsol.h     |   49 +
 drivers/scsi/elx/efct/efct_xport.c     | 1310 ++++++++
 drivers/scsi/elx/efct/efct_xport.h     |  201 ++
 drivers/scsi/elx/include/efc_common.h  |   43 +
 drivers/scsi/elx/libefc/efc.h          |   72 +
 drivers/scsi/elx/libefc/efc_device.c   | 1672 ++++++++++
 drivers/scsi/elx/libefc/efc_device.h   |   72 +
 drivers/scsi/elx/libefc/efc_domain.c   | 1109 +++++++
 drivers/scsi/elx/libefc/efc_domain.h   |   52 +
 drivers/scsi/elx/libefc/efc_fabric.c   | 1759 ++++++++++
 drivers/scsi/elx/libefc/efc_fabric.h   |  116 +
 drivers/scsi/elx/libefc/efc_lib.c      |   41 +
 drivers/scsi/elx/libefc/efc_node.c     | 1196 +++++++
 drivers/scsi/elx/libefc/efc_node.h     |  183 ++
 drivers/scsi/elx/libefc/efc_sm.c       |   61 +
 drivers/scsi/elx/libefc/efc_sm.h       |  209 ++
 drivers/scsi/elx/libefc/efc_sport.c    |  846 +++++
 drivers/scsi/elx/libefc/efc_sport.h    |   52 +
 drivers/scsi/elx/libefc/efclib.h       |  640 ++++
 drivers/scsi/elx/libefc_sli/sli4.c     | 5523 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h     | 4133 ++++++++++++++++++++++++
 40 files changed, 34059 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_els.c
 create mode 100644 drivers/scsi/elx/efct/efct_els.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h
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
2.16.4

