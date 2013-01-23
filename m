From: "spren.gm@gmail.com" <spren.gm@gmail.com>
Subject: device_blocked with mpt2sas
Date: Wed, 23 Jan 2013 16:19:47 +0800
Message-ID: <201301231618228908399@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59868 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3AWITz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2013 03:19:55 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so3876480pbc.40
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2013 00:19:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,
  we encounter a problem that a disk is blocked forever with mpt2sas, the key log is:

mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
sd 2:0:1:0: device_blocked, handle(0x000a)

  looking into the driver code, it seems that the device is blocked by function 
_scsih_block_io_to_children_attached_directly() in mpt2sas/mpt2sas_scsih.c
with reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING,
  my question is what this reason_code mean? when should it be returned? and any way to handle it?

Best Regards,
spren
2013-01-23

