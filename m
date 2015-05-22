From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/4] target: Eliminate se_port + t10_alua_tg_pt_gp_member
Date: Fri, 22 May 2015 07:06:53 +0000
Message-ID: <1432278417-29994-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33423 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbEVHJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 03:09:37 -0400
Received: by oiww2 with SMTP id w2so7643537oiw.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 00:09:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here is a -v1 series with HCH's recent changes to go ahead and drop
all se_port + t10_alua_tg_pt_gp_member usage within target-core in
favor of direct se_lun pointer dereference.

This includes the original patch + minor fixes, along with two other
improvements for killing off se_lun->lun_sep_lock via RCU pointer
access, and converting the remaining se_lun->lun_active busy-wait
special cases to existing percpu se_lun->lun_ref access.

Also included in the series is a recently discussed change to go
ahead and drop an unnecessary core_tpg_register() parameter, and
all associated target_core_fabric_ops forward declartions within
fabric driver code.

Please review.

--nab

Christoph Hellwig (1):
  target: Subsume se_port + t10_alua_tg_pt_gp_member into se_lun

Nicholas Bellinger (3):
  target: Drop lun_sep_lock for se_lun->lun_se_dev RCU usage
  target: Drop se_lun->lun_active for existing percpu lun_ref
  target: Drop unnecessary core_tpg_register TFO parameter

 drivers/infiniband/ulp/srpt/ib_srpt.c        |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   9 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   3 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   8 +-
 drivers/target/loopback/tcm_loop.c           |   5 +-
 drivers/target/sbp/sbp_target.c              |   2 +-
 drivers/target/target_core_alua.c            | 393 ++++++++++-----------------
 drivers/target/target_core_alua.h            |  14 +-
 drivers/target/target_core_configfs.c        |  11 +-
 drivers/target/target_core_device.c          | 180 ++----------
 drivers/target/target_core_fabric_configfs.c |  32 +--
 drivers/target/target_core_internal.h        |  12 +-
 drivers/target/target_core_pr.c              |  50 ++--
 drivers/target/target_core_spc.c             |  48 ++--
 drivers/target/target_core_stat.c            | 305 +++++++--------------
 drivers/target/target_core_tpg.c             | 111 +++++---
 drivers/target/target_core_transport.c       |  46 +---
 drivers/target/target_core_xcopy.c           |  17 +-
 drivers/target/tcm_fc/tfc_conf.c             |   5 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |   5 +-
 drivers/vhost/scsi.c                         |   4 +-
 drivers/xen/xen-scsiback.c                   |   5 +-
 include/target/target_core_base.h            |  75 +++--
 include/target/target_core_fabric.h          |   3 +-
 24 files changed, 465 insertions(+), 882 deletions(-)

-- 
1.9.1

