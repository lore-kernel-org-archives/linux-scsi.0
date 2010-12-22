From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] SCSI: Prevent from retrying with expecting_cc_ua in case
 of disk change.
Date: Wed, 22 Dec 2010 15:53:43 +0900
Message-ID: <4D11A077.1030100@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35013 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0LVGzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 01:55:33 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id oBM6tVSq006131
	for <linux-scsi@vger.kernel.org> (envelope-from taruishi.hiroak@jp.fujitsu.com);
	Wed, 22 Dec 2010 15:55:32 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9036D45DE54
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7A80645DD6F
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 6E0EEE08006
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:31 +0900 (JST)
Received: from m024.s.css.fujitsu.com (m024.s.css.fujitsu.com [10.0.81.64])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3E67DE08001
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:31 +0900 (JST)
Received: from m024.css.fujitsu.com (m024 [127.0.0.1])
	by m024.s.css.fujitsu.com (Postfix) with ESMTP id 0C3DA180F1
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:31 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.173])
	by m024.s.css.fujitsu.com (Postfix) with ESMTP id CD81A180E1
	for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 15:55:30 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

 I have found a following trouble.

   1. Boot with a particular usb DVD-RAM drive with RHEL boot disk
      in rescue mode.
   2. Change disk to DVD-RAM (whatever disk may ok which is bigger
      capacity than previous boot disk)
   3. execute ioctl(BLKGETSIZE[64]).
   4. We get the size of boot disk. (not one of DVD-RAM)

  Actually, I replaced to DVD-RAM disk with ext2 filesystem and check
  it with fsck, I get these nice error message.

      The filesystem size (according to the superblock) is xxxx blocks
      The physical size of the device is yyyy blocks
      Either the superblock or the partition table is likely to be corrupt!
      Abort?

  I found this problem is caused by retry logic of scsi driver.
  scsi driver retries i-o in case of unit attention with expecting_cc_ua=1
  even if the unit attention means disk change. So, sr driver loses unit
  attention, and also loses disk change event.

  (As for expecting_cc_ua=1, this was set because of a hardware bug and
   this is also another cause. I wonder why this bit is off only when
   unit attention or not ready. It should be off at the first i-o after
   reset operation, I think...)

  I made a simple patch for this problem. Could someone check this patch?

Regards,
taruisi

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 drivers/scsi/scsi_error.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 30ac116..fd93145 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -285,13 +285,15 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
    case UNIT_ATTENTION:
        /*
         * if we are expecting a cc/ua because of a bus reset that we
-        * performed, treat this just as a retry.  otherwise this is
-        * information that we should pass up to the upper-level driver
-        * so that we can deal with it there.
+        * performed, treat this just as a retry except a case of disk
+        * change.  otherwise this is information that we should pass up
+        * to the upper-level driver so that we can deal with it there.
         */
        if (scmd->device->expecting_cc_ua) {
-           scmd->device->expecting_cc_ua = 0;
-           return NEEDS_RETRY;
+           if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
+               scmd->device->expecting_cc_ua = 0;
+               return NEEDS_RETRY;
+           }
        }
        /*
         * if the device is in the process of becoming ready, we
-- 
1.4.4.4


-- 
taruisi

