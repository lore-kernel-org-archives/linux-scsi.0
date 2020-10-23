Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73446C388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 18:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C2A20E65
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 18:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="UOMASn5B";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="UOMASn5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750881AbgJWSqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 14:46:23 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34954 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S465802AbgJWSqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Oct 2020 14:46:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6D5C712811DE;
        Fri, 23 Oct 2020 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603478782;
        bh=Z0P7xAz4y7i8dIiRV6SiqEYgPgrzt7vkHce19pGuLV4=;
        h=Subject:From:To:Cc:Date:From;
        b=UOMASn5BsZ6W70lgP+52uOxHNGJwSgUYxwW3mm+tdgygcz+3sEVmxB9HRDTXDIiJD
         lHgENK2kJr7kwB+IAbAilcshr+LOuruEoxL8OtoTXK1BU2CkaCIIuIxrLhtV4qKSH2
         bNY16WlrNEdDlQRaQpxDpwopgImGvMTtBiO+sqIw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3KDFmZn3ZexH; Fri, 23 Oct 2020 11:46:22 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1345B12810AE;
        Fri, 23 Oct 2020 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603478782;
        bh=Z0P7xAz4y7i8dIiRV6SiqEYgPgrzt7vkHce19pGuLV4=;
        h=Subject:From:To:Cc:Date:From;
        b=UOMASn5BsZ6W70lgP+52uOxHNGJwSgUYxwW3mm+tdgygcz+3sEVmxB9HRDTXDIiJD
         lHgENK2kJr7kwB+IAbAilcshr+LOuruEoxL8OtoTXK1BU2CkaCIIuIxrLhtV4qKSH2
         bNY16WlrNEdDlQRaQpxDpwopgImGvMTtBiO+sqIw=
Message-ID: <4affd2a9c347e5f1231485483bf852737ea08151.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.9+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 23 Oct 2020 11:46:21 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The set of core changes here is Christoph's submission path cleanups. 
These introduced a couple of regressions when first proposed so they
got held over from the initial merge window pull request to give more
testing time, which they've now had and Syzbot has confirmed the
regression it detected is fixed.  The other main changes are two driver
updates (arcmsr, pm80xx) and assorted minor clean ups.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Christoph Hellwig (11):
      scsi: core: Set sc_data_direction to DMA_NONE for no-transfer commands
      scsi: sr: Initialize ->cmd_len
      scsi: core: Only start the request just before dispatching
      scsi: core: Remove scsi_setup_cmnd() and scsi_setup_fs_cmnd()
      scsi: core: Clean up allocation and freeing of sgtables
      scsi: core: Rename scsi_mq_prep_fn() to scsi_prepare_cmd()
      scsi: core: Rename scsi_prep_state_check() to scsi_device_state_check()
      scsi: core: Use rq_dma_dir in scsi_setup_cmnd()
      scsi: core: Move command size detection out of the fast path
      scsi: core: Remove scsi_init_cmd_errh
      scsi: core: Don't export scsi_device_from_queue()

Christophe JAILLET (1):
      scsi: isci: Fix a typo in a comment

Colin Ian King (2):
      scsi: qla2xxx: Fix return of uninitialized value in rval
      scsi: sym53c8xx_2: Fix sizeof() mismatch

Daniel Wagner (1):
      scsi: qla2xxx: Do not consume srb greedily

Jason Yan (1):
      scsi: gdth: Make option_setup() static

Jing Xiangfeng (2):
      scsi: myrb: Remove redundant assignment to variable timeout
      scsi: bfa: Fix error return in bfad_pci_init()

Julia Lawall (1):
      scsi: target: rd: Drop double zeroing

Liu Shixin (4):
      scsi: snic: Simplify the return expression of svnic_cq_alloc()
      scsi: fnic: Simplify the return expression of vnic_wq_copy_alloc()
      scsi: initio: Use module_pci_driver() to simplify the code
      scsi: dc395x: Use module_pci_driver() to simplify the code

Pavel Machek (CIP) (1):
      scsi: qla2xxx: Use constant when it is known

Qinglang Miao (2):
      scsi: fcoe: Simplify the return expression of fcoe_sysfs_setup()
      scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE

Tom Rix (1):
      scsi: qla2xxx: Initialize variable in qla8044_poll_reg()

Viswas G (4):
      scsi: pm80xx: Driver version update
      scsi: pm80xx: Increase the number of outstanding I/O supported to 1024
      scsi: pm80xx: Remove DMA memory allocation for ccb and device structures
      scsi: pm80xx: Increase number of supported queues

Ye Bin (2):
      scsi: qla4xxx: Fix inconsistent format argument type
      scsi: myrb: Fix inconsistent format argument types

Zheng Yongjun (1):
      scsi: 53c700: Remove set but not used variable

ching Huang (4):
      scsi: arcmsr: Update driver version to v1.50.00.02-20200819
      scsi: arcmsr: Add support for ARC-1886 series RAID controllers
      scsi: arcmsr: Fix device hot-plug monitoring timer stop
      scsi: arcmsr: Remove unnecessary syntax

And the diffstat:

 drivers/scsi/53c700.c                 |   4 -
 drivers/scsi/arcmsr/arcmsr.h          | 102 ++++++++-
 drivers/scsi/arcmsr/arcmsr_hba.c      | 377 ++++++++++++++++++++++++++--------
 drivers/scsi/bfa/bfad.c               |   1 +
 drivers/scsi/dc395x.c                 |  25 +--
 drivers/scsi/fcoe/fcoe_sysfs.c        |   8 +-
 drivers/scsi/fnic/vnic_wq_copy.c      |   8 +-
 drivers/scsi/gdth.c                   | 151 +++++++-------
 drivers/scsi/initio.c                 |  14 +-
 drivers/scsi/isci/remote_node_table.h |   2 +-
 drivers/scsi/myrb.c                   |   5 +-
 drivers/scsi/pm8001/pm8001_ctl.c      |   6 +-
 drivers/scsi/pm8001/pm8001_defs.h     |  27 ++-
 drivers/scsi/pm8001/pm8001_hwi.c      |  38 ++--
 drivers/scsi/pm8001/pm8001_init.c     | 221 +++++++++++++-------
 drivers/scsi/pm8001/pm8001_sas.h      |  15 +-
 drivers/scsi/pm8001/pm80xx_hwi.c      | 109 +++++-----
 drivers/scsi/qla2xxx/qla_dfs.c        |  68 +-----
 drivers/scsi/qla2xxx/qla_isr.c        |  42 ++--
 drivers/scsi/qla2xxx/qla_nvme.c       |   8 +-
 drivers/scsi/qla2xxx/qla_nx2.c        |   2 +-
 drivers/scsi/qla4xxx/ql4_nx.c         |   2 +-
 drivers/scsi/scsi_lib.c               | 108 ++++------
 drivers/scsi/sd.c                     |  27 +--
 drivers/scsi/snic/vnic_cq.c           |   8 +-
 drivers/scsi/sr.c                     |  17 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |   2 +-
 drivers/target/target_core_rd.c       |   2 +-
 include/scsi/scsi_cmnd.h              |   3 +-
 29 files changed, 818 insertions(+), 584 deletions(-)

James


