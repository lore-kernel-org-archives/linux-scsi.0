Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159A8C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF215216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404870AbfHIDCh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36948 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404679AbfHIDCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so45207499pfa.4
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fQKdLoyTT+ARbRupDIrdyg4NoJtUn0vZTkPX5LP+hs=;
        b=NhAZsjNv7R+I+56OsTeWf3xcE1Fpraad/GqZB8iooV0lBiZOjyMUv3We+0zLny501e
         ZbRF1v18Jp/BMmdvUQFNLFpgqtW2J651OdyiWb2OHruHAyr+VXTtuqB742pYsExA8HjF
         e+Ly83ilTbkNgHePnZwKZPYHdd1A/KhVj2dOPl597zOjeVmIuSQnX1T0tVU2UPaqLcy2
         Hqw0hrlVyLeKIHkyaGjA06gI4bz/cns9GKcYbBDlK6iyojgzHs90rhgY1XrYMoc1k3rt
         zRZlfIO0Zt58tp2RhHOGNqLH4XJ+IcU6Tj6Npz4b5HqmOblFdkgud1VST872lSX6PM4n
         lsrw==
X-Gm-Message-State: APjAAAXb6bjn2jxGBFG/riaarolBNYEcCIsXzp4wxVoiUsZiIHicd6Q0
        q3kx1t3ploQE/Oh0DTgjcwxRTfE4
X-Google-Smtp-Source: APXvYqw+/sK+cst5rOccLjgnrQGgoZ6PQr5hcsh2RLzxf+Fc89hd6EK1kncrPcHQE/j3kj7jNPLRbQ==
X-Received: by 2002:aa7:858b:: with SMTP id w11mr18182449pfn.68.1565319755874;
        Thu, 08 Aug 2019 20:02:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/58] qla2xxx patches for kernel v5.4
Date:   Thu,  8 Aug 2019 20:01:21 -0700
Message-Id: <20190809030219.11296-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The patches in this series improve the robustness of the QLogic Fibre Channel
initiator and target drivers. These patches are a result of manual code
inspection, analysis of Coverity reports and stress testing of these two
drivers. Please consider these patches for kernel version v5.4.

Thanks,

Bart.

Changes compared to v1:
- Included a regression fix for qla2xxx_eh_abort() in the second patch of this
  series (the fix Himanshu mentioned in his e-mail).
- Moved a WARN_ON_ONCE() statement from a later patch to the second patch in
  this series.
- Dropped one patch that renames a function.

Bart Van Assche (58):
  qla2xxx: Make qla2x00_abort_srb() again decrease the sp reference
    count
  qla2xxx: Really fix qla2xxx_eh_abort()
  qla2xxx: Improve Linux kernel coding style conformance
  qla2xxx: Use tabs instead of spaces for indentation
  qla2xxx: Include the <asm/unaligned.h> header file from qla_dsd.h
  qla2xxx: Remove an include directive from qla_mr.c
  qla2xxx: Remove a superfluous forward declaration
  qla2xxx: Declare the fourth ql_dump_buffer() argument const
  qla2xxx: Change the return type of qla2x00_update_ms_fdmi_iocb() into
    void
  qla2xxx: Reduce the scope of three local variables in
    qla2xxx_queuecommand()
  qla2xxx: Declare qla_tgt_cmd.cdb const
  qla2xxx: Change data_dsd into an array
  qla2xxx: Verify locking assumptions at runtime
  qla2xxx: Reduce the number of casts in GID list code
  qla2xxx: Simplify qlt_lport_dump()
  qla2xxx: Remove a superfluous pointer check
  qla2xxx: Remove two superfluous tests
  qla2xxx: Simplify qla24xx_abort_sp_done()
  qla2xxx: Fix session lookup in qlt_abort_work()
  qla2xxx: Report the firmware status code if a mailbox command fails
  qla2xxx: Do not corrupt vha->plogi_ack_list
  qla2xxx: Use strlcpy() instead of strncpy()
  qla2xxx: Complain if a mailbox command times out
  qla2xxx: Complain if parsing the version string fails
  qla2xxx: Remove dead code
  qla2xxx: Simplify a debug statement
  qla2xxx: Fix qla24xx_process_bidir_cmd()
  qla2xxx: Remove unreachable code from qla83xx_idc_lock()
  qla2xxx: Suppress a Coveritiy complaint about integer overflow
  qla2xxx: Suppress multiple Coverity complaint about out-of-bounds
    accesses
  qla2xxx: Always check the qla2x00_wait_for_hba_online() return value
  qla2xxx: Declare fourth qla2x00_set_model_info() argument const
  qla2xxx: Complain if waiting for pending commands times out
  qla2xxx: Check the PCI info string output buffer size
  qla2xxx: Use memcpy() and strlcpy() instead of strcpy() and strncpy()
  qla2xxx: Complain if a soft reset fails
  qla2xxx: Introduce the be_id_t and le_id_t data types for FC src/dst
    IDs
  qla2xxx: Change the return type of qla24xx_read_flash_data()
  qla2xxx: Check secondary image if reading the primary image fails
  qla2xxx: Make it explicit that ELS pass-through IOCBs use little
    endian
  qla2xxx: Set the responder mode if appropriate for ELS pass-through
    IOCBs
  qla2xxx: Rework key encoding in qlt_find_host_by_d_id()
  qla2xxx: Enable type checking for the SRB free and done callback
    functions
  qla2xxx: Introduce the function qla2xxx_init_sp()
  qla2xxx: Fix a race condition between aborting and completing a SCSI
    command
  qla2xxx: Make qlt_handle_abts_completion() more robust
  qla2xxx: Modify NVMe include directives
  qla2xxx: Introduce qla2xxx_get_next_handle()
  qla2xxx: Make sure that aborted commands are freed
  qla2xxx: Complain if sp->done() is not called from the completion path
  qla2xxx: Let the compiler check the type of the SCSI command context
    pointer
  qla2xxx: Remove superfluous sts_entry_* casts
  qla2xxx: Report invalid mailbox status codes
  qla2xxx: Inline the qla2x00_fcport_event_handler() function
  qla2xxx: Introduce qla2x00_els_dcmd2_free()
  qla2xxx: Remove two superfluous if-tests
  qla2xxx: Simplify qla24xx_async_abort_cmd()
  qla2xxx: Fix a NULL pointer dereference

 drivers/scsi/qla2xxx/qla_attr.c    |   6 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  19 +--
 drivers/scsi/qla2xxx/qla_dbg.c     |   3 +-
 drivers/scsi/qla2xxx/qla_def.h     | 130 ++++++++++----
 drivers/scsi/qla2xxx/qla_dfs.c     |   9 +-
 drivers/scsi/qla2xxx/qla_dsd.h     |   2 +
 drivers/scsi/qla2xxx/qla_fw.h      |   8 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |  33 ++--
 drivers/scsi/qla2xxx/qla_gs.c      | 219 +++++++++---------------
 drivers/scsi/qla2xxx/qla_init.c    | 261 +++++++++++------------------
 drivers/scsi/qla2xxx/qla_inline.h  |  28 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    | 221 +++++++++---------------
 drivers/scsi/qla2xxx/qla_isr.c     |  24 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  10 +-
 drivers/scsi/qla2xxx/qla_mid.c     |   4 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  67 ++++----
 drivers/scsi/qla2xxx/qla_nvme.c    |  28 +---
 drivers/scsi/qla2xxx/qla_nvme.h    |   5 +-
 drivers/scsi/qla2xxx/qla_nx.c      |  16 +-
 drivers/scsi/qla2xxx/qla_nx.h      |  14 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c      | 213 ++++++++++-------------
 drivers/scsi/qla2xxx/qla_sup.c     |   8 +-
 drivers/scsi/qla2xxx/qla_target.c  | 209 +++++++++--------------
 drivers/scsi/qla2xxx/qla_target.h  |  35 ++--
 drivers/scsi/qla2xxx/qla_tmpl.c    |   7 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  27 ++-
 include/linux/nvme-fc-driver.h     |   2 +
 28 files changed, 677 insertions(+), 933 deletions(-)

-- 
2.22.0

