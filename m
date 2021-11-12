Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D87DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 13:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1996360F46
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 13:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhKLNqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 08:46:10 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34548 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231436AbhKLNqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Nov 2021 08:46:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636724596;
        bh=Dc3pPXaBd8QfDvYOqsz4KdRQcZ4o3mhiYLkSlLaQXZg=;
        h=Message-ID:Subject:From:To:Date:From;
        b=OABkiMmdc+LvbQjs7CzAqiw6X0NZvaVOp0G0wxzNraq4UrlX7a87aFJ3RnZxqGiLR
         oW/eKXLyA01ZoVraIYT1cyqawqIu4EDxPdpaDQAXphokBBBPkB45F3k1Gn0Wwua3IT
         WdKa/oYVATd1Mt7UuYZe/Df9u64DKxls2VOko9RM=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C2FDF1280989;
        Fri, 12 Nov 2021 08:43:16 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XhiV1SqqL5Pv; Fri, 12 Nov 2021 08:43:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636724596;
        bh=Dc3pPXaBd8QfDvYOqsz4KdRQcZ4o3mhiYLkSlLaQXZg=;
        h=Message-ID:Subject:From:To:Date:From;
        b=OABkiMmdc+LvbQjs7CzAqiw6X0NZvaVOp0G0wxzNraq4UrlX7a87aFJ3RnZxqGiLR
         oW/eKXLyA01ZoVraIYT1cyqawqIu4EDxPdpaDQAXphokBBBPkB45F3k1Gn0Wwua3IT
         WdKa/oYVATd1Mt7UuYZe/Df9u64DKxls2VOko9RM=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3282C1280966;
        Fri, 12 Nov 2021 08:43:16 -0500 (EST)
Message-ID: <d9405d786496756564b31540cc73a9d22cc97730.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.15+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 12 Nov 2021 08:43:14 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is all the stragglers that didn't quite make the first
merge window pull.  It's mostly minor updates and bug fixes of merge
window code but it also has two driver updates: ufs and qla2xxx.

James


The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Force a full restore after suspend-to-disk

Alexey Dobriyan (1):
      scsi: sr: Remove duplicate assignment

Andrea Parri (Microsoft) (1):
      scsi: storvsc: Fix validation for unsolicited incoming packets

Avri Altman (2):
      scsi: ufs: ufshpb: Properly handle max-single-cmd
      scsi: ufs: ufshpb: Remove HPB2.0 flows

Bart Van Assche (10):
      scsi: ufs: core: Micro-optimize ufshcd_map_sg()
      scsi: ufs: core: Add a compile-time structure size check
      scsi: ufs: core: Remove three superfluous casts
      scsi: ufs: core: Add debugfs attributes for triggering the UFS EH
      scsi: ufs: core: Make it easier to add new debugfs attributes
      scsi: ufs: core: Export ufshcd_schedule_eh_work()
      scsi: ufs: core: Log error handler activity
      scsi: ufs: core: Improve static type checking
      scsi: ufs: core: Improve source code comments
      scsi: ufs: Revert "Retry aborted SCSI commands instead of completing these successfully"

Brian King (1):
      scsi: ibmvfc: Fix up duplicate response detection

Chanho Park (12):
      scsi: ufs: ufs-exynos: Introduce ExynosAuto v9 virtual host
      scsi: ufs: ufs-exynos: Multi-host configuration for ExynosAuto v9
      scsi: ufs: ufs-exynos: Support ExynosAuto v9 UFS
      scsi: ufs: ufs-exynos: Add pre/post_hce_enable drv callbacks
      scsi: ufs: ufs-exynos: Factor out priv data init
      scsi: ufs: ufs-exynos: Add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
      scsi: ufs: ufs-exynos: Support custom version of ufs_hba_variant_ops
      scsi: ufs: ufs-exynos: Add setup_clocks callback
      scsi: ufs: ufs-exynos: Add refclkout_stop control
      scsi: ufs: ufs-exynos: Simplify drv_data retrieval
      scsi: ufs: ufs-exynos: Change pclk available max value
      scsi: ufs: ufs-exynos: Correct timeout value setting registers

Christophe JAILLET (1):
      scsi: elx: Use 'bitmap_zalloc()' when applicable

Dexuan Cui (1):
      scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Dmitry Bogdanov (2):
      scsi: target: core: Remove from tmr_list during LUN unlink
      scsi: qla2xxx: Fix unmap of already freed sgl

Ewan D. Milne (1):
      scsi: core: Avoid leaving shost->last_reset with stale value if EH does not run

George Kennedy (1):
      scsi: scsi_debug: Don't call kcalloc() if size arg is zero

Jackie Liu (1):
      scsi: bsg: Fix errno when scsi_bsg_register_queue() fails

Joy Gu (1):
      scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Martin K. Petersen (1):
      scsi: mpt3sas: Fix reference tag handling for WRITE_INSERT

Mike Christie (1):
      scsi: iscsi: Fix set_param() handling

Miles Chen (1):
      scsi: sd: Fix crashes in sd_resume_runtime()

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.07.200-k

Quinn Tran (12):
      scsi: qla2xxx: edif: Fix EDIF bsg
      scsi: qla2xxx: edif: Fix inconsistent check of db_flags
      scsi: qla2xxx: edif: Increase ELS payload
      scsi: qla2xxx: edif: Reduce connection thrash
      scsi: qla2xxx: edif: Tweak trace message
      scsi: qla2xxx: edif: Replace list_for_each_safe with list_for_each_entry_safe
      scsi: qla2xxx: edif: Flush stale events and msgs on session down
      scsi: qla2xxx: edif: Fix app start delay
      scsi: qla2xxx: edif: Fix app start fail
      scsi: qla2xxx: Turn off target reset during issue_lip
      scsi: qla2xxx: Fix gnl list corruption
      scsi: qla2xxx: Relogin during fabric disturbance

Sreekanth Reddy (1):
      scsi: mpi3mr: Fix duplicate device entries when scanning through sysfs

Steffen Maier (1):
      scsi: core: Fix early registration of sysfs attributes for scsi_device

Tadeusz Struk (2):
      scsi: core: Remove command size deduction from scsi_setup_scsi_cmnd()
      scsi: scsi_ioctl: Validate command size

Zheyu Ma (1):
      scsi: qla2xxx: Return -ENOMEM if kzalloc() fails

jongmin jeong (2):
      scsi: ufs: Add quirk to enable host controller without PH configuration
      scsi: ufs: Add quirk to handle broken UIC command


