Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35F6C07E96
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 07:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A12B61351
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 07:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhGKHHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jul 2021 03:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKHHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jul 2021 03:07:51 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003F9C0613DD;
        Sun, 11 Jul 2021 00:04:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1A95112808B7;
        Sun, 11 Jul 2021 00:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1625987096;
        bh=J/b6rDBUO87PcG+JF3Vqas4h9GoS8olbWKUqA39MK0U=;
        h=Message-ID:Subject:From:To:Date:From;
        b=CkJ6DhvD5Py0fx/qzg5+94TWskcUpEPyjlu5ZLw0bjVlGwpp5YxyDHdcYV94WA8/C
         cY0VO//Ov8FtGfEn5B/c2m0XrROrOcX7t/Yr3xpcwyyvSB1AsnzNQbJormA3TO39gt
         syqrImGoj7zdXP8v/F1nkhHj0YeHxzZV+K2qS+0Q=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yZ5jOA0uPSXc; Sun, 11 Jul 2021 00:04:56 -0700 (PDT)
Received: from [192.168.42.44] (host86-165-242-165.range86-165.btcentralplus.com [86.165.242.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DECAD12808B6;
        Sun, 11 Jul 2021 00:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1625987095;
        bh=J/b6rDBUO87PcG+JF3Vqas4h9GoS8olbWKUqA39MK0U=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ips1D0YVF7deitA7mX4o7a6l/oCeWb6alFvXWn2vc9Dul6ZsEZqdK2lNtMR6EGXt1
         zq66HbQwWq1ugCyTc46A8I/cSdoU1ZV+axVM+0L6Gl2AIs0/iIgvyR85ps4YzQyDOR
         Aj6pKbrJPpyUF1nVXRRXZSROC7DT7vnFKs5KWHuI=
Message-ID: <64e271620b6a9a8a12848f9fa5dc8d4c31be8123.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.13+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 11 Jul 2021 08:04:52 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a set of minor fixes and clean ups in the core and various
drivers.  The only core change in behaviour is the I/O retry for spinup
notify, but that shouldn't impact anything other than the failing case.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

And the short changelog is:

Bart Van Assche (1):
      scsi: core: Inline scsi_mq_alloc_queue()

Christophe JAILLET (3):
      scsi: message: mptfc: Switch from pci_ to dma_ API
      scsi: be2iscsi: Fix some missing space in some messages
      scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Colin Ian King (1):
      scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8

Hannes Reinecke (1):
      scsi: virtio_scsi: Do not overwrite SCSI status

James Smart (2):
      scsi: elx: efct: Fix vport list linkage in LIO backend
      scsi: elx: libefc_sli: Fix ANDing with zero bit value

Javed Hasan (2):
      scsi: qedf: Add check to synchronize abort and flush
      scsi: libfc: Fix array index out of bound exception

Quat Le (1):
      scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Quinn Tran (1):
      scsi: qla2xxx: Add heartbeat check

SeongJae Park (1):
      scsi: bnx2fc: Remove meaningless bnx2fc_abts_cleanup() return value assignment

Sreekanth Reddy (2):
      scsi: mpi3mr: Fix warnings reported by smatch
      scsi: MAINTAINERS: Add mpi3mr driver maintainers

Wen Xiong (1):
      scsi: ipr: System crashes when seeing type 20 error

Xie Yongji (1):
      scsi: virtio_scsi: Add validation for residual bytes from response

YueHaibing (1):
      scsi: ufs: Fix build warning without CONFIG_PM

Yufen Yu (1):
      scsi: libsas: Add LUN number check in .slave_alloc callback

Zhen Lei (4):
      scsi: mvsas: Use DEVICE_ATTR_RO()/RW() macro
      scsi: megaraid_mbox: Use DEVICE_ATTR_ADMIN_RO() macro
      scsi: qedf: Use DEVICE_ATTR_RO() macro
      scsi: qedi: Use DEVICE_ATTR_RO() macro

And the diffstat:

 MAINTAINERS                            |  11 ++++
 drivers/message/fusion/mptfc.c         |  35 +++++------
 drivers/scsi/aic7xxx/aic7xxx_core.c    |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c    |   1 +
 drivers/scsi/be2iscsi/be_main.c        | 103 +++++++++++++--------------------
 drivers/scsi/bnx2fc/bnx2fc_io.c        |   2 +-
 drivers/scsi/elx/efct/efct_lio.c       |   8 +--
 drivers/scsi/elx/libefc_sli/sli4.c     |   2 -
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   1 +
 drivers/scsi/ipr.c                     |   4 +-
 drivers/scsi/ipr.h                     |   1 +
 drivers/scsi/isci/init.c               |   1 +
 drivers/scsi/libfc/fc_rport.c          |  13 +++--
 drivers/scsi/libsas/sas_scsi_host.c    |   9 +++
 drivers/scsi/megaraid/megaraid_mbox.c  |  18 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c        |   5 +-
 drivers/scsi/mvsas/mv_init.c           |  27 ++++-----
 drivers/scsi/pm8001/pm8001_init.c      |   1 +
 drivers/scsi/qedf/qedf_attr.c          |  14 ++---
 drivers/scsi/qedf/qedf_io.c            |  22 ++++++-
 drivers/scsi/qedi/qedi_sysfs.c         |  14 ++---
 drivers/scsi/qla2xxx/qla_def.h         |   4 ++
 drivers/scsi/qla2xxx/qla_gbl.h         |   1 +
 drivers/scsi/qla2xxx/qla_init.c        |   6 +-
 drivers/scsi/qla2xxx/qla_iocb.c        |   4 ++
 drivers/scsi/qla2xxx/qla_isr.c         |   4 ++
 drivers/scsi/qla2xxx/qla_mbx.c         |  27 +++++++++
 drivers/scsi/qla2xxx/qla_nvme.c        |   4 ++
 drivers/scsi/qla2xxx/qla_os.c          |  68 ++++++++++++++++++++++
 drivers/scsi/scsi_lib.c                |  13 +----
 drivers/scsi/scsi_priv.h               |   1 -
 drivers/scsi/scsi_scan.c               |  12 ++--
 drivers/scsi/ufs/ufshcd.c              |   4 ++
 drivers/scsi/virtio_scsi.c             |   5 +-
 36 files changed, 287 insertions(+), 162 deletions(-)

James


