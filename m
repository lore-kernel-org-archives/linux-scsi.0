From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [BUGFIX 0/2] BUG Fixes for OSD in mainline (2.6.30)
Date: Tue, 31 Mar 2009 19:58:59 +0300
Message-ID: <49D24BD3.2030801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:20441 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869AbZCaRA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 13:00:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xu Yang <onlyxuyang@qq.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

A very serious and stupid bug was found by users in current osd code,
which caused it not to be usable in it's current form.

It would hard-lock immediately on any asynchronous execution call
on an SMP Kernel. Just to show that it was only run on uni-machines
until today.

Since found I've setup a test rig with SMP machines banging on each
other with multi threaded/devices/mounts and they are still up.
(Same setup I used to run with UMLs before)

Thanks to Xu Yang <onlyxuyang@qq.com> for reporting this and his devotion
to finding a fix.

These are the patches

[PATCH 1/2] libosd: BUGFIX: blk_put_request can't be called from within request_end_io

    A fix for a very serious and stupid bug in osd_initiator. It used to
    call blk_put_request() regardless of if it was from the end_io callback
    or if called after a sync execution. It should call the unlocked version
    __blk_put_request() instead.

    Also fixed is the remove of _abort_unexecuted_bios hack, and use of
    blk_end_request(,-ERROR,) to deallocate half baked requests. I've
    audited the code and it should be safe.

    Reported and
    Tested-by: Xu Yang <onlyxuyang@qq.com>
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

[PATCH 2/2] osd_uld: Remove creation of osd_scsi class symlink

    Remove the creation of the symlink from the device to
    it's class. On modern systems this is already created by
    a udev rule and would WARN on load. On old systems it is
    not needed, none of the current osd user-mode tools use
    this link.

    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Please apply for inclusion in the next round of scsi fixes for
2.6.30

Thank you
Boaz
