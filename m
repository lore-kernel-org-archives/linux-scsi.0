Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEDEC47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC58B61167
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhFAX5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhFAX5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D80C061574
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:18 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y15so726891pfn.13
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6sjod357qy+iRS54IiWGEH0Jruwsm/3lmMHnL5gm2pI=;
        b=gEpdFw3/s8o79c8KWxSsJsOdpDzjRuM4b/c+/t9oF1/tgA0FoaqFpaCl9WLEYda9wo
         jx9/NXrKSuH6Um+s8xoIrpSnAchiDa5Fe6fROt3Q5ldoDaFKNDj6c2cddcY+xZ9SH0nQ
         5U2Hy1Y6ZoUpCYy/w9SRqpWeR44K/dg3XuGuBS0Qg3DDqHa5IffklZ5bnUkIXinorVQA
         d68BLU/KT0fFp7mA5vfvDHgpqdnYQwiJ6iSwJnJp0sV3k4FirPauI7xcZuUYUX2xp4Xv
         WqLAq0f762AlJ8ykWyZiaPQ7qkB/i40JYOHV9IRfAzKRFd88x+Vv1QzHR8JA682eO33e
         WuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6sjod357qy+iRS54IiWGEH0Jruwsm/3lmMHnL5gm2pI=;
        b=gi0Cz1npTEh0Tyc8fBDqacjpWf/IbLa4WqUW5Zz3Wc8LxssyVlQhuNeHaaXGby7CQd
         kqs80vPMsglGPiZuKf7Zlj33IRDq9bprrfsGN9Kb37VH+sJVrreL73td8ZU3cPh+xSlz
         QLutgohRHw9I5pTUXV5jhVu7B+LMREoQOaTB6gyxSQ1OadUM/cn08RorRI+c4r/+5PoN
         hQj9BOMpCInHEe//amrSjNWeRJxsPQoOqZfmbYZK4d4+rbapifxnqxCrNN0v6f9ICqZv
         H7iT1/9TC38LUBo4tdEIhKYMPk4/BRopYYtlxb0JW9+BZjQooEDlHW1rMd3lX/5MHQa3
         SRUA==
X-Gm-Message-State: AOAM532vKBvX9HiZTHPUOOCKbNRNJjxxNxUl0lg67AkwtJaGE1uUf8xI
        JAqW/FWBYqqqqT/0gbAyjwKNFTaNaLI=
X-Google-Smtp-Source: ABdhPJy2NUvamguU/RUL7aDL2wtvFkeIo3lFWdQSaWbO5B251Wi0hASV0RdTEoRrTNXdncN4dKS/Kg==
X-Received: by 2002:a63:3f8f:: with SMTP id m137mr30788010pga.56.1622591717886;
        Tue, 01 Jun 2021 16:55:17 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v9 00/31] [NEW] efct: Broadcom (Emulex) FC Target driver
Date:   Tue,  1 Jun 2021 16:54:41 -0700
Message-Id: <20210601235512.20104-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set is a request to incorporate the new Broadcom
(Emulex) FC target driver, efct, into the kernel source tree.

The driver source has been Announced a couple of times, the last
version on 4/19/2021. The driver has been hosted on gitlab for
review has had contributions from the community.
  gitlab (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)

It's believed this revision has met all review comments.

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

The patches have been cut against the 5.14/scsi-queue branch.

Thank you to those that have contributed to the driver in the past.

Review comments welcome!

-- james

Note: cpu offline/online support will be added at a later time

v9 modifications:
  Non-functional changes:
    Remove EFC_SUCCESS/EFC_FAIL defines and use 0 and -Exxx errno values.
    Remove EFCT_xxx/EFCT_HW_RTN_xxx defines and use appropriate -Exxx errno
       values.
    Correct indentation on line continuations.
    Document struct efc_nport.
    Document FC sequence object.
  efc_nport_vport_del: Remove found and post nport shutdown directly.
  Use atomic_add_return instead of atomic_add
  Use cmpxchg for setting abort_in_progress
  Use bool for tpg enabled flag:
    efct_lio_tpg_get_inst_index() : return 1.
    efct_lio_sess_get_index(): return 0.
    Return tgt_io state from efct_lio_get_cmd_state()

V8 modifications:
  Added link module type defines which are used for evaluating link
    supported speeds.
  Added sli_get_lmt helper function.
  Rename struct efc_vport_spec to efc_vport.
  efc_vport naming changes.
  Mark els_io_enabled to true, when re-authenticating the node.
  Remove chip error checks, as we are anyway checking while submitting
    the command.
  efct_xport_detach to void, Simplified getting supported speeds routine.
  Return value fixes and function prototype changes.
  Use READ_ONCE/WRITE_ONCE for abort_in_progress flag.
  Complete node registration after target backend session is established.
  Converted target_submit_cmd() to
    target_init_cmd/target_submit_prep/target_submit
  Converted efct_scsi_recv_cmd() prototype to a void
  Check return values of efct_hw_command.
  Remove waiting for flushing pending commands in reset and teardown path.
  Remove unused stubs,.
  Add 64G and 128G to host speed reporting.
  Use link speed to detect the port state.

V7 modifications:
  Change els functions to return status from efc_els_send_rsp()
  Fix return codes in efct_hw_config_mrq()
  Ensure an EFC_XXX status value is returned (not numerical constants)
  Style: break declaration assignment into declaration and later value
    assignment.

V6 modifications:
  Refactor for better indentation and reduced else's
  Refactor to use structure elements directly and avoid local vars
  Slight update to node_sm_trace macro
  convert efc_nport_cb() to not return a value
  moved libefc/efc_lib.c to libefc/efclib.c
  Reword comment in efc_node_handle_explicit_logo()
  efc_disc_io_complete(): update WARN_ON to WARN_ON_ONCE
  Change els send functions to return status from efc_els_send_req()
  Ensure an EFC_XXX status value is returned (not numerical constants)
  Dynamically allocate wq_cpu_array rather than fixed size array
  Fix return variables to have same type as routine
  Ensure an EFCT_HW_XXX status value is returned (not numerical constants)
  Kernel doc format changes for efct_io structure.
  Cleanup of meaningless comments in efct_scsi_cmd_resp declaration
  in hw rtns: Replace EFC_FAIL status with EFCT_HW_XXX status values
  add kfree to efct_hw_teardown()

V5 modifications:
  Copyright for 2021 year change.
  Fixed kernel test robot reported warnings.
  Changed BMBX_WRITE defines to static inline functions.
  Common naming for topology defines.
  Remove efc_log_test.
  Topology naming changes.
  Indentation change.
  Changed argument list for sli_cmd_reg_fcfi/ sli_cmd_reg_fcfi_mrq 
  Added Mempool for ELS ios.
  Remove EFC_HW_NODE_XXX and EFC_HW_NPORT_XXX events.
  Use EFC_EVT_XXX events directly for port and node callbacks.
  Remove node_list from nport and use xarray lookup.
  Use WRITE_ONCE/READ_ONCE for els_io_enabled flag.
  Replace nport_list with xarray lookup related changes.
  Topology naming changes.
  ELS IO mempool changes.
  EFC_EVT_XXX name changes.
  Replace global efct_devices array with linked list.
  Add support for FC speed 64G and 128G
  Use list_del_int() when needed.

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
 drivers/scsi/elx/efct/efct_driver.c    |  786 ++++
 drivers/scsi/elx/efct/efct_driver.h    |  109 +
 drivers/scsi/elx/efct/efct_hw.c        | 3582 ++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        |  764 ++++
 drivers/scsi/elx/efct/efct_hw_queues.c |  677 ++++
 drivers/scsi/elx/efct/efct_io.c        |  191 +
 drivers/scsi/elx/efct/efct_io.h        |  174 +
 drivers/scsi/elx/efct/efct_lio.c       | 1698 ++++++++
 drivers/scsi/elx/efct/efct_lio.h       |  189 +
 drivers/scsi/elx/efct/efct_scsi.c      | 1159 ++++++
 drivers/scsi/elx/efct/efct_scsi.h      |  203 +
 drivers/scsi/elx/efct/efct_unsol.c     |  492 +++
 drivers/scsi/elx/efct/efct_unsol.h     |   17 +
 drivers/scsi/elx/efct/efct_xport.c     | 1114 +++++
 drivers/scsi/elx/efct/efct_xport.h     |  186 +
 drivers/scsi/elx/include/efc_common.h  |   37 +
 drivers/scsi/elx/libefc/efc.h          |   52 +
 drivers/scsi/elx/libefc/efc_cmds.c     |  777 ++++
 drivers/scsi/elx/libefc/efc_cmds.h     |   35 +
 drivers/scsi/elx/libefc/efc_device.c   | 1603 ++++++++
 drivers/scsi/elx/libefc/efc_device.h   |   72 +
 drivers/scsi/elx/libefc/efc_domain.c   | 1088 +++++
 drivers/scsi/elx/libefc/efc_domain.h   |   54 +
 drivers/scsi/elx/libefc/efc_els.c      | 1098 +++++
 drivers/scsi/elx/libefc/efc_els.h      |  107 +
 drivers/scsi/elx/libefc/efc_fabric.c   | 1564 +++++++
 drivers/scsi/elx/libefc/efc_fabric.h   |  116 +
 drivers/scsi/elx/libefc/efc_node.c     | 1102 +++++
 drivers/scsi/elx/libefc/efc_node.h     |  191 +
 drivers/scsi/elx/libefc/efc_nport.c    |  777 ++++
 drivers/scsi/elx/libefc/efc_nport.h    |   50 +
 drivers/scsi/elx/libefc/efc_sm.c       |   54 +
 drivers/scsi/elx/libefc/efc_sm.h       |  197 +
 drivers/scsi/elx/libefc/efclib.c       |   81 +
 drivers/scsi/elx/libefc/efclib.h       |  620 +++
 drivers/scsi/elx/libefc_sli/sli4.c     | 5162 ++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h     | 4132 +++++++++++++++++++
 42 files changed, 30349 insertions(+)
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
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.c
 create mode 100644 drivers/scsi/elx/libefc/efclib.h
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

-- 
2.26.2

