From: Tony Battersby <tonyb@cybernetics.com>
Subject: Device removal lockup with mptsas + scsi-mq
Date: Wed, 04 Feb 2015 13:39:09 -0500
Message-ID: <54D2674D.5090503@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:31959 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161728AbbBDSqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 13:46:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Summary:

When removing a SCSI device with scsi-mq, blk_mq_update_tag_set_depth()
ends up waiting for commands to *other* SCSI devices to complete.  If
those other SCSI devices are in the SDEV_BLOCK state, then the removal
deadlocks.

Setup:

kernel 3.19-rc7 with the following additional commits:
  0f98c38d725f88d6452af46eed96a3a6791b230a
    Revert "blk-mq: fix hctx/ctx kobject use-after-free"
    blk-mq: release mq's kobjects in blk_release_queue()
scsi-mq enabled
LSI 3.0 Gbps SAS HBA using mptsas
disk enclosure containing SAS expander and one disk drive

Procedure:

1) connect SAS cable to disk enclosure
2) two SCSI devices show up - the expander and the disk
3) begin sending commands to the disk
4) disconnect SAS cable
5) cat /proc/scsi/scsi - devices never disappear

Analysis:

When mptsas detects a cable pull, it calls scsi_device_set_state(sdev,
SDEV_BLOCK) on the expander sdev and the disk sdev.  A moment later it
calls sas_port_delete(), which eventually calls scsi_remove_device() on
the expander sdev (and later on the disk sdev, but it never gets that
far).  This deadlocks in blk_mq_freeze_queue_wait() trying to freeze the
queue for the *disk*, even though it is the *expander* that is being
deleted first.  The disk queue cannot be frozen because it has
outstanding commands that cannot make progress due to the disk being in
SDEV_BLOCK.  Here is the call chain for the deadlock:

mptsas_firmware_event_work() [mptsas]
mptsas_send_expander_event() [mptsas]
mptsas_expander_delete() [mptsas]
mptsas_delete_expander_siblings() [mptsas]
mptsas_del_end_device() [mptsas]
sas_port_delete() [scsi_transport_sas]
sas_rphy_delete() [scsi_transport_sas]
sas_rphy_remove() [scsi_transport_sas]
scsi_remove_target()
__scsi_remove_target()
scsi_remove_device()
__scsi_remove_device()
blk_cleanup_queue()
blk_mq_free_queue()
blk_mq_del_queue_tag_set()
blk_mq_update_tag_set_depth()
list_for_each_entry(q, &set->tag_list, tag_set_list)
blk_mq_freeze_queue()
blk_mq_freeze_queue_wait()

Apparently the expander and the disk are both in the same "struct
blk_mq_tag_set", so blk_mq_update_tag_set_depth() ends up waiting for
commands to complete to the disk when deleting the expander, which
causes the deadlock.

I found this patch from 2012-07-19 for a different but related issue:
mptfusion: Fix for issue - The device is removed in blocked state
http://marc.info/?l=linux-scsi&m=134268885517580&w=4
http://marc.info/?l=linux-scsi&m=134269193618776&w=4

That patch was apparently ignored and forgotten.  However, that patch
did not fix my problem.  For one thing, the expander and the disk have
separate target ids, so the call to mptsas_ublock_io_starget() in the
patch before deleting the expander took the expander out of the
SDEV_BLOCK state but left the disk in the SDEV_BLOCK state, so it did
not prevent the deadlock.  If I change the
mptsas_find_vtarget()+starget_for_each_device() in the patch to
shost_for_each_device() to unblock all devices, then sometimes the
device removal completes successfully, but sometimes it still deadlocks
(especially with more than one disk) because of
scsi_internal_device_unblock() racing with scsi_internal_device_block()
on the other devices.

So far the only way I can get device removal to be reliable with scsi-mq
enabled is by disabling the call to scsi_device_set_state(sdev,
SDEV_BLOCK) entirely.  Device removal completes successfully with
scsi-mq disabled, both with an unmodified kernel and with the patch from
2012.

I think the best fix would be to change
blk_mq_del_queue_tag_set()/blk_mq_update_tag_set_depth() not to wait for
commands to *other* sdevs during device removal.  It looks like the only
reason this is done currently is to update the BLK_MQ_F_TAG_SHARED flag,
which is used only by hctx_may_queue() in blk-mq-tag.c, but perhaps
there is another reason I am missing.  I will leave that change to
someone more familiar with the blk-mq code.


Regarding mptsas:

When the cable is pulled, mptsas calls scsi_device_set_state(sdev,
SDEV_BLOCK) and sets vtarget->deleted = 1.  If mptsas queuecommand()
sees vtarget->deleted, it fails the I/O with DID_NO_CONNECT.  There is
nowhere in mptsas where it calls scsi_device_set_state(sdev,
SDEV_RUNNING) or scsi_internal_device_unblock() (except in the patch
from 2012 just before deleting the device).  So setting SDEV_BLOCK is
just blocking commands that can never do anything but fail anyway, so it
can probably either be removed, or else a call to
scsi_internal_device_unblock() should be added somewhere to unblock a
device that came back.

