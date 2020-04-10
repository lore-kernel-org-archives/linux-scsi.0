Return-Path: <SRS0=e6eI=52=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A830C2D0EC
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 18:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ACB5206C1
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 18:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ak3NNOOB";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ak3NNOOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDJSTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Apr 2020 14:19:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56892 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgDJSTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Apr 2020 14:19:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D91178EE39A;
        Fri, 10 Apr 2020 11:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1586542753;
        bh=2iTv1noPTW6+GEIMJCLq+M+/lZUkH7uo/dGX2q40SRQ=;
        h=Subject:From:To:Cc:Date:From;
        b=ak3NNOOBzlZ3bDEPKXM2BwY1dxY8OLnOvJrFOwyg6aY670zDQRFbgOHBnCnH6z5+w
         FoGcqjpGTIW4A2gcTYlOaA1pG2dPtiLLq3G+H7dXtBiVDttlmpkvLc+PHX9iVBdmKK
         sXw7psi3sgbmIJUKhBjvzkTezwItFFy4+/DGohBY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 00zl8DJAY2XP; Fri, 10 Apr 2020 11:19:13 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5408F8EE0D2;
        Fri, 10 Apr 2020 11:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1586542753;
        bh=2iTv1noPTW6+GEIMJCLq+M+/lZUkH7uo/dGX2q40SRQ=;
        h=Subject:From:To:Cc:Date:From;
        b=ak3NNOOBzlZ3bDEPKXM2BwY1dxY8OLnOvJrFOwyg6aY670zDQRFbgOHBnCnH6z5+w
         FoGcqjpGTIW4A2gcTYlOaA1pG2dPtiLLq3G+H7dXtBiVDttlmpkvLc+PHX9iVBdmKK
         sXw7psi3sgbmIJUKhBjvzkTezwItFFy4+/DGohBY=
Message-ID: <1586542752.4129.55.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.6+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 10 Apr 2020 11:19:12 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a batch of changes that didn't make it in the initial pull
request because the lpfc series had to be rebased to redo an incorrect
split.  It's basically driver updates to lpfc, target, bnx2fc and ufs
with the rest being minor updates except the sr_block_release one which
fixes a use after free introduced by the removal of the global mutex in
the first patch set.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alex Dewar (1):
      scsi: aic7xxx: Remove more FreeBSD-specific code

Bart Van Assche (1):
      scsi: sr: Fix sr_block_release()

Can Guo (1):
      scsi: ufs: Use ufshcd_config_pwr_mode() when scaling gear

David Disseldorp (5):
      scsi: target: use the stack for XCOPY passthrough cmds
      scsi: target: increase XCOPY I/O size
      scsi: target: avoid per-loop XCOPY buffer allocations
      scsi: target: drop xcopy DISK BLOCK LENGTH debug
      scsi: target: use #define for xcopy descriptor len

Dick Kennedy (1):
      scsi: lpfc: Change default SCSI LUN QD to 64

Hannes Reinecke (1):
      scsi: aacraid: do not overwrite retval in aac_reset_adapter()

James Smart (11):
      scsi: lpfc: Update lpfc version to 12.8.0.0
      scsi: lpfc: Remove prototype FIPS/DSS options from SLI-3
      scsi: lpfc: Make debugfs ktime stats generic for NVME and SCSI
      scsi: lpfc: Fix erroneous cpu limit of 128 on I/O statistics
      scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG
      scsi: lpfc: Fix update of wq consumer index in lpfc_sli4_wq_release
      scsi: lpfc: Fix crash after handling a pci error
      scsi: lpfc: Fix scsi host template for SLI3 vports
      scsi: lpfc: Fix lpfc overwrite of sg_cnt field in nvmefc_tgt_fcp_req
      scsi: lpfc: Fix lockdep error - register non-static key
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Javed Hasan (3):
      scsi: libfc: rport state move to PLOGI if all PRLI retry exhausted
      scsi: libfc: If PRLI rejected, move rport to PLOGI state
      scsi: bnx2fc: Process the RQE with CQE in interrupt context

Joe Perches (1):
      scsi: zfcp: use fallthrough;

Nikhil Kshirsagar (1):
      scsi: core: Add DID_ALLOC_FAILURE and DID_MEDIUM_ERROR to hostbyte_table

Saurav Kashyap (2):
      scsi: bnx2fc: Update the driver version to 2.12.13
      scsi: bnx2fc: Fix SCSI command completion after cleanup is posted

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Stanley Chu (3):
      scsi: ufs: set device as active power mode after resetting device
      scsi: ufs-mediatek: add error recovery for suspend and resume
      scsi: ufs: export ufshcd_link_recovery

Subhash Jadavani (1):
      scsi: ufs: Clean up ufshcd_scale_clks() and clock scaling error out path

Wu Bo (1):
      scsi: iscsi: Report unbind session event when the target has been removed

kbuild test robot (1):
      scsi: bnx2fc: fix boolreturn.cocci warnings

And the diffstat:

 drivers/s390/scsi/zfcp_erp.c         |  10 +-
 drivers/s390/scsi/zfcp_fsf.c         |  23 ++-
 drivers/scsi/aacraid/commsup.c       |   7 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c  |  23 ---
 drivers/scsi/bnx2fc/bnx2fc.h         |  13 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c    |   8 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c     | 103 ++++++++---
 drivers/scsi/bnx2fc/bnx2fc_io.c      |  34 ++--
 drivers/scsi/constants.c             |   2 +-
 drivers/scsi/libfc/fc_rport.c        |  10 +-
 drivers/scsi/lpfc/lpfc.h             |  25 ++-
 drivers/scsi/lpfc/lpfc_attr.c        |  73 +-------
 drivers/scsi/lpfc/lpfc_crtn.h        |   3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c     | 333 ++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_debugfs.h     |   3 +-
 drivers/scsi/lpfc/lpfc_hw.h          |  20 +--
 drivers/scsi/lpfc/lpfc_init.c        | 106 ++++++++---
 drivers/scsi/lpfc/lpfc_mbox.c        |   2 -
 drivers/scsi/lpfc/lpfc_nvme.c        | 147 ++++------------
 drivers/scsi/lpfc/lpfc_nvmet.c       |  62 ++++---
 drivers/scsi/lpfc/lpfc_scsi.c        |  90 +++-------
 drivers/scsi/lpfc/lpfc_sli.c         |  47 ++---
 drivers/scsi/lpfc/lpfc_sli.h         |   2 +-
 drivers/scsi/lpfc/lpfc_sli4.h        |  19 +-
 drivers/scsi/lpfc/lpfc_version.h     |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   8 +-
 drivers/scsi/scsi_transport_iscsi.c  |   4 +-
 drivers/scsi/sr.c                    |   4 +-
 drivers/scsi/ufs/ufs-mediatek.c      |  13 +-
 drivers/scsi/ufs/ufshcd.c            |  87 +++++----
 drivers/scsi/ufs/ufshcd.h            |  15 ++
 drivers/target/target_core_xcopy.c   | 187 +++++++-------------
 drivers/target/target_core_xcopy.h   |   9 +-
 33 files changed, 723 insertions(+), 771 deletions(-)

James

