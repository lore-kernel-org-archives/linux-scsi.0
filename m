Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84F0C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B983320739
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 15:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hTr18Qkc";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hTr18Qkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgFMPPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Jun 2020 11:15:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55746 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgFMPPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 13 Jun 2020 11:15:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id DF3F38EE26A;
        Sat, 13 Jun 2020 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1592061312;
        bh=r3pb4loia2wlIRGMIh2JMH3UKQykuiHoGqNrtacmoic=;
        h=Subject:From:To:Cc:Date:From;
        b=hTr18QkcifOpwrv1Y/Ndgf6h+NidPrtYgwnHfFVzL3Lh6eQ+bf4ew5DVT4fMlw525
         52Mvv1o4EChkdN3Dipu19Ff8bJTtgFsZn+ezK/ToWbNRNvY8DORTFV+pxUuHDUPpTh
         5InU5MtttbOZw18f8Tc0lB0B8Ns+VHVFLkWPQOyQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V_5DKU12lxnb; Sat, 13 Jun 2020 08:15:12 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 63C718EE200;
        Sat, 13 Jun 2020 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1592061312;
        bh=r3pb4loia2wlIRGMIh2JMH3UKQykuiHoGqNrtacmoic=;
        h=Subject:From:To:Cc:Date:From;
        b=hTr18QkcifOpwrv1Y/Ndgf6h+NidPrtYgwnHfFVzL3Lh6eQ+bf4ew5DVT4fMlw525
         52Mvv1o4EChkdN3Dipu19Ff8bJTtgFsZn+ezK/ToWbNRNvY8DORTFV+pxUuHDUPpTh
         5InU5MtttbOZw18f8Tc0lB0B8Ns+VHVFLkWPQOyQ=
Message-ID: <1592061311.5201.7.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.6+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 13 Jun 2020 08:15:11 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the set of changes collected since just before the merge window
opened.  It's mostly minor fixes in drivers.  The one non-driver set is
the three optical disk (sr) changes where two are error path fixes and
one is a helper conversion.  The big driver change is the hpsa
compat_alloc_userspace rework by Al so he can kill the remaining user. 
This has been tested and acked by the maintainer.

There's a minor merge conflict in sr.c because of a711d91cd97e ("block:
add a cdrom_device_info pointer to struct gendisk") but the resolution
is pretty obvious.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Al Viro (4):
      scsi: hpsa: hpsa_ioctl(): Tidy up a bit
      scsi: hpsa: Get rid of compat_alloc_user_space()
      scsi: hpsa: Don't bother with vmalloc for BIG_IOCTL_Command_struct
      scsi: hpsa: Lift {BIG_,}IOCTL_Command_struct copy{in,out} into hpsa_ioctl()

Bodo Stroesser (1):
      scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range

Can Guo (1):
      scsi: ufs: Don't update urgent bkops level when toggling auto bkops

Christophe JAILLET (1):
      scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Colin Ian King (1):
      scsi: qedf: Remove redundant initialization of variable rc

Dan Carpenter (1):
      scsi: cxlflash: Remove an unnecessary NULL check

Denis Efremov (1):
      scsi: storvsc: Remove memset before memory freeing in storvsc_suspend()

John Hubbard (1):
      scsi: st: Convert convert get_user_pages() --> pin_user_pages()

Qiushi Wu (1):
      scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj

Simon Arlott (2):
      scsi: sr: Fix sr_probe() missing deallocate of device minor
      scsi: sr: Fix sr_probe() missing mutex_destroy

Stanley Chu (1):
      scsi: ufs: Remove redundant urgent_bkop_lvl initialization

Sudhakar Panneerselvam (4):
      scsi: target: Rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
      scsi: target: Fix NULL pointer dereference
      scsi: target: Initialize LUN in transport_init_se_cmd()
      scsi: target: Factor out a new helper, target_cmd_init_cdb()

Suganath Prabu S (1):
      scsi: mpt3sas: Fix memset() in non-RDPQ mode

Tyrel Datwyler (1):
      scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

And the diffstat:

 drivers/scsi/arm/acornscsi.c           |   4 +-
 drivers/scsi/cxlflash/main.c           |   3 -
 drivers/scsi/hpsa.c                    | 199 +++++++++++++++------------------
 drivers/scsi/ibmvscsi/ibmvscsi.c       |   2 +
 drivers/scsi/iscsi_boot_sysfs.c        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c    |   5 +-
 drivers/scsi/qedf/qedf_fip.c           |   2 +-
 drivers/scsi/sr.c                      |   7 +-
 drivers/scsi/st.c                      |  20 +---
 drivers/scsi/storvsc_drv.c             |   3 -
 drivers/scsi/ufs/ufshcd.c              |   6 +-
 drivers/target/iscsi/iscsi_target.c    |  29 ++---
 drivers/target/target_core_device.c    |  19 ++--
 drivers/target/target_core_tmr.c       |   4 +-
 drivers/target/target_core_transport.c |  55 ++++++---
 drivers/target/target_core_user.c      |   4 +-
 drivers/target/target_core_xcopy.c     |   9 +-
 drivers/usb/gadget/function/f_tcm.c    |   6 +-
 include/target/target_core_fabric.h    |   9 +-
 19 files changed, 195 insertions(+), 193 deletions(-)

James

