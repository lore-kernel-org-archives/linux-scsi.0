Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D71C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8817B20838
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BwhlKMwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbgJLWv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730613AbgJLWv4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:51:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09FEC0613D0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:51:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so2448719pgt.8
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=YdjlcpmuuOmFFc3/YIc/W2YeHV7XoRKpD4hWilZq5ys=;
        b=BwhlKMwSxqc5rtgkcnfJk9Cx4+1Rwp52UPyd7yvCDo7jIjcuc9neEWUNGOh/n6TwC9
         Lgn9e+2FF80talBIFq0iTFn35cekQeWKePliJNF9LNwNyHgpWQO/VKW+AJmDjb3nzC85
         XQevK4emWajRtTEeDahy1LK/+zrVgvBa4ulgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=YdjlcpmuuOmFFc3/YIc/W2YeHV7XoRKpD4hWilZq5ys=;
        b=pLg9+Ayx+dkiCR40kxvg+YjTsCOaUYyBfoSQLD+RuUUKq8dFIjynWaYiE8N9Ac3xFs
         ChXEU6ilXDcaU/589qeSwbuOt6yLFhAPdaKy9dl9Lyc0w/Rj/za1Pwu0cV/Xm8R/xTUr
         r48P68C2EPhBOANEYgAs8uiol1/Sbw1LzLrUMPHt6l7nu4Rr44dM+KZrZPInsGrzAfME
         dO1jefdAByf1BWa5cLQICUY9zBoAnBgGVkqa2/bw9WFWh2eCfidaRB9Tk8TMiqyWiA3+
         gf7yTifMHxBQWBv953EBxc60WC9YAmQ2Jf1qLgC1PlqcfcH49V9YweYee5XwH3XpEgLO
         BObw==
X-Gm-Message-State: AOAM531mmznD04hZ6bIAMNrqwkU4O8kLb5TNAdg6zgrY2RhQ9NGCOCrN
        jE1JGlAFGbm+qmI0f805NVV+n21xPg3pveq8mqFFhyNxAnXey08wLrJrgI7gsv5FLmNPc36VvW2
        O6ZHQASK9wggfPXVd5wKmS/FnCONlb51g+NQrO6yNctl4OU9lVoPMoCySUx9Y9sBVG2j0B4oaqe
        pQmNs=
X-Google-Smtp-Source: ABdhPJzg4gQWUECtpcCgzOJ3bdfI4fTi8iZ9VJIlHRBcalpeJUhxArfCiOM6WroJ8cULB6qVQa5K2g==
X-Received: by 2002:a17:90a:1bc3:: with SMTP id r3mr22895476pjr.196.1602543115265;
        Mon, 12 Oct 2020 15:51:55 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:51:54 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>
Subject: [PATCH v4 00/31] [NEW] efct: Broadcom (Emulex) FC Target driver
Date:   Mon, 12 Oct 2020 15:51:16 -0700
Message-Id: <20201012225147.54404-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000029a04105b18125a1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000029a04105b18125a1
Content-Transfer-Encoding: 8bit

This patch set is a request to incorporate the new Broadcom
(Emulex) FC target driver, efct, into the kernel source tree.

The driver source has been Announced a couple of times, the last
version on 4/11/2020. The driver has been hosted on gitlab for
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

The patches have been cut against the 5.10/scsi-queue branch.

Thank you to those that have contributed to the driver in the past.

Review comments welcome!

-- james


V4 modifications:
  Copyright year change.
  Fixed cppcheck tool reported warnings.
  Ran pahole tool, fixed padding for most of the structures. 
  Support for Multiple RQs and EQs.
  New user driver node structure to avoid lock contension in IO path.
  libefc_sli:
    Add target-devel@vger.kernel.org in MAINTAINERS
    Changed doorbell defines to inline functions
    Code cleanup: Indentation, code simplification, unnecessary brackets
    Added SLI4_ prefix to missing defines
    Moved driver specific structures to the end of the file.
    Page size calculation changes
    Reduce function parameters for WQE filling functions
    Changed wait functions to use usleep_range and time_before apis
    Removed size input for all the cmds as its fixed to SLI4_BMBX_SIZE.
    Changed all SLI mbox routines to memset using SLI_BMBX_SIZE.
    All WQE helper routines to use sli->wqe_size for memset.
  libefc:
    Remove the " EFC_SM_EVENT_START" id and define SM events serially.
    Moved hold frames and pending frames handling to library.
    Added efc locking notes.
    Added kref to domain, nport and node objects.
    Renamed efc_sli_port object to efc_nport
    Reworked on APIs and libefc_function_template.
    Moved ELS handling to Library
    Moved registering discovery objects to library.
    Added issue_mbox_rqst, send_els, send_bls template functions.
    Changes to use new function template
    Get Domain Ref count when a new nport is added
    Release domain ref when nport is freed.
    Renamed efc_sport.[ch] to efc_nport.[ch]
    Add kref support for Nport structure.
    Upon received PRLI, wait for LIO session registation before sending
      the PRLI response.
    Changes to call new els functions.
    Move all state machine functions return value from void * to void.
    Replace fall through commnet with fallthrough statement.
    New patch added ELS handling to libefc library.
    New els_io_req for discovery io object.
    New patch cmds to register VFI, VPI and RPI.
    Removed all hw related template calls and added issue_mbox_rqst
       template call.
    Consolidate all the discovery related mbox related cmds in discovery
       library.
    Replaced allocation of command buffer for mailbox with stack variable.
  efct driver:
    New library Template registration and associated functions
    Muti-RQ support, configure mrq.
    Configure filter to send all ELS traffic to one RQ and remaining IOs
       to all RQs.
    CPU based WQ scaling.
    Allocate loop map during initialization
    Remove redundant includes in efc_driver.h
    Remove els entries from scsi io object as discovery object handles it.
    Changed unsol frame handling. 
    Lookup for efct target node based on d_id and s_id.
    Rework IO path to not look up discovery object every time.
    Changes to reduce function params for efct_hw_io_send
    Changes to create efct_node(user driver specific node) and store
       lookup id.
    Removed debugfs interface.
    Reduced the argument list for WQE filling routines.


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
  elx: libefc: Extended link Service IO handling
  elx: libefc: Register discovery objects with hardware
  elx: efct: Data structures and defines for hw operations
  elx: efct: Driver initialization routines
  elx: efct: Hardware queues creation and deletion
  elx: efct: RQ buffer, memory pool allocation and deallocation APIs
  elx: efct: Hardware IO and SGL initialization
  elx: efct: Hardware queues processing
  elx: efct: Unsolicited FC frame processing routines
  elx: efct: SCSI IO handling routines
  elx: efct: LIO backend interface routines
  elx: efct: Hardware IO submission routines
  elx: efct: link and host statistics
  elx: efct: xport and hardware teardown routines
  elx: efct: scsi_transport_fc host interface support
  elx: efct: Add Makefile and Kconfig for efct driver
  elx: efct: Tie into kernel Kconfig and build process

 MAINTAINERS                            |    9 +
 drivers/scsi/Kconfig                   |    2 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/elx/Kconfig               |    9 +
 drivers/scsi/elx/Makefile              |   18 +
 drivers/scsi/elx/efct/efct_driver.c    |  810 ++++
 drivers/scsi/elx/efct/efct_driver.h    |  109 +
 drivers/scsi/elx/efct/efct_hw.c        | 3651 +++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        |  782 ++++
 drivers/scsi/elx/efct/efct_hw_queues.c |  677 ++++
 drivers/scsi/elx/efct/efct_io.c        |  191 +
 drivers/scsi/elx/efct/efct_io.h        |  166 +
 drivers/scsi/elx/efct/efct_lio.c       | 1697 ++++++++
 drivers/scsi/elx/efct/efct_lio.h       |  189 +
 drivers/scsi/elx/efct/efct_scsi.c      | 1164 ++++++
 drivers/scsi/elx/efct/efct_scsi.h      |  214 +
 drivers/scsi/elx/efct/efct_unsol.c     |  495 +++
 drivers/scsi/elx/efct/efct_unsol.h     |   17 +
 drivers/scsi/elx/efct/efct_xport.c     | 1280 ++++++
 drivers/scsi/elx/efct/efct_xport.h     |  186 +
 drivers/scsi/elx/include/efc_common.h  |   44 +
 drivers/scsi/elx/libefc/efc.h          |   69 +
 drivers/scsi/elx/libefc/efc_cmds.c     |  877 ++++
 drivers/scsi/elx/libefc/efc_cmds.h     |   34 +
 drivers/scsi/elx/libefc/efc_device.c   | 1600 ++++++++
 drivers/scsi/elx/libefc/efc_device.h   |   72 +
 drivers/scsi/elx/libefc/efc_domain.c   | 1095 +++++
 drivers/scsi/elx/libefc/efc_domain.h   |   54 +
 drivers/scsi/elx/libefc/efc_els.c      | 1152 ++++++
 drivers/scsi/elx/libefc/efc_els.h      |  107 +
 drivers/scsi/elx/libefc/efc_fabric.c   | 1565 +++++++
 drivers/scsi/elx/libefc/efc_fabric.h   |  116 +
 drivers/scsi/elx/libefc/efc_lib.c      |   73 +
 drivers/scsi/elx/libefc/efc_node.c     | 1157 ++++++
 drivers/scsi/elx/libefc/efc_node.h     |  191 +
 drivers/scsi/elx/libefc/efc_nport.c    |  825 ++++
 drivers/scsi/elx/libefc/efc_nport.h    |   50 +
 drivers/scsi/elx/libefc/efc_sm.c       |   54 +
 drivers/scsi/elx/libefc/efc_sm.h       |  197 +
 drivers/scsi/elx/libefc/efclib.h       |  629 +++
 drivers/scsi/elx/libefc_sli/sli4.c     | 5185 ++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h     | 4106 +++++++++++++++++++
 42 files changed, 30919 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
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
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.c
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.h
 create mode 100644 drivers/scsi/elx/libefc/efc_device.c
 create mode 100644 drivers/scsi/elx/libefc/efc_device.h
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h
 create mode 100644 drivers/scsi/elx/libefc/efc_els.c
 create mode 100644 drivers/scsi/elx/libefc/efc_els.h
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h
 create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.h
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

-- 
2.26.2


--00000000000029a04105b18125a1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgNH50MaOSW1fgED5f
eEcvK/yboXKlYSrzI2v5cIfuiwQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MTU1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBALCBgEmbCijKnHrzjB7i6ogbuop1nhOIoP23
g2cuy1mW2eOSjYczBVFys7gWvB1k1gDSltMaSh9C+xlRKBQPmfYn2AgZQqddvgrVmmQ7m2GYkXA8
9p/qRvZsEXYU2ycITlIhGwuY+U8LSf2GrwPdoJc6zfVnmU11N5/jxbZ9Drciv85kcjc6wRSUvHQ8
N5OaqJYkEHmGH6HRmqdc2ZGDtmO67t4DN29q4Sv0PiEI9kTjUayBl0cM76DeinPHv+oJ8RCEAjAC
1PZByIeeoSOoe3vBteKSVY/+JThPGc4+qdxTi7A6gT/Fu35QWq9WaNDwBYBvVI0pYMkW3ytBDnHq
z5E=
--00000000000029a04105b18125a1--
