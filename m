From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 00/12] target: target_alloc_session w/ percpu_ida+ACK_KREF conversion
Date: Mon, 25 Jan 2016 08:10:54 +0000
Message-ID: <1453709466-6308-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34083 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcAYINq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 03:13:46 -0500
Received: by mail-oi0-f52.google.com with SMTP id k206so84026900oia.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2016 00:13:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here is -v2 series code for target_alloc_session() helper
support using existing percpu-ida tag pre-allocation, along
with a new (*callback)() for allowing fabric driver code
to complete ahead of transport_register_session() finishing
I_T nexus setup.

This includes a tree-wide fabric driver conversion to use
use target_alloc_session() + associated (*callback)() with
common code.

Also as per HCH, it contains sbp-target, usb-gadget/tcm
and xen-scsiback driver percpu_ida tag pre-allocation
conversions, along with initial TARGET_SCF_ACK_KREF
support for v4.6-rc code.

Please review.

--nab

Christoph Hellwig (1):
  target: Convert demo-mode only drivers to target_alloc_session

Nicholas Bellinger (11):
  target: Add target_alloc_session() helper function
  vhost/scsi: Convert to target_alloc_session usage
  tcm_qla2xxx: Convert to target_alloc_session usage
  tcm_fc: Convert to target_alloc_session usage
  ib_srpt: Convert to target_alloc_session usage
  sbp-target: Conversion to percpu_ida tag pre-allocation
  sbp-target: Convert to TARGET_SCF_ACK_KREF I/O krefs
  usb-gadget/tcm: Conversion to percpu_ida tag pre-allocation
  usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs
  xen-scsiback: Convert to percpu_ida tag allocation
  xen-scsiback: Convert to TARGET_SCF_ACK_KREF I/O krefs

 drivers/infiniband/ulp/srpt/ib_srpt.c  |  23 +--
 drivers/scsi/qla2xxx/qla_target.c      |   8 +-
 drivers/scsi/qla2xxx/qla_target.h      |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  79 +++++-----
 drivers/target/loopback/tcm_loop.c     |  35 +----
 drivers/target/sbp/sbp_target.c        |  97 ++++++------
 drivers/target/target_core_transport.c |  56 +++++++
 drivers/target/tcm_fc/tfc_sess.c       |  44 +++---
 drivers/usb/gadget/function/f_tcm.c    | 181 ++++++++++------------
 drivers/vhost/scsi.c                   |  99 +++++-------
 drivers/xen/xen-scsiback.c             | 265 ++++++++++++++++-----------------
 include/target/target_core_fabric.h    |   6 +
 12 files changed, 437 insertions(+), 458 deletions(-)

-- 
1.9.1

