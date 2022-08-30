Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EA2ECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 20:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiH3Ug4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Aug 2022 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiH3Ugz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2022 16:36:55 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 13:36:54 PDT
Received: from l2mail1.panix.com (l2mail1.panix.com [166.84.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4897D7A0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 13:36:54 -0700 (PDT)
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
        by l2mail1.panix.com (Postfix) with ESMTPS id 4MHJYT2HptzDTK
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 16:19:09 -0400 (EDT)
Received: from xps-7390 (ip68-111-137-238.sd.sd.cox.net [68.111.137.238])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4MHJYR23m3z2lVv;
        Tue, 30 Aug 2022 16:19:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1661890747; bh=oRqOoN18XVBlT9x4mDN7lrYukK4DFgShHVBesT4bu/Y=;
        h=Date:From:Reply-To:To:cc:Subject;
        b=hV1HX3m4QfTUc0Io/eaVgLy6xxtCAg18RR4rFfsZ4+wMm6mkfBK3pJOTuacqFty5s
         V1xwciF0AyLYoq68hQ7rhyGRd3BvI1YW7pP6f72PyAR3nbfAlLliTZmc97WFkbG0xH
         PLPqzmbPcCrXWLg7sf0fNirlW1Zm4W/FEJJ5MMo8=
Date:   Tue, 30 Aug 2022 13:19:06 -0700 (PDT)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     bvanassche@acm.org
cc:     linux-scsi@vger.kernel.org
Subject: Another DP for Revert "scsi: core: Call blk_mq_free_tag_set()
 earlier"
Message-ID: <9dc65f12-7692-7f2f-b3a7-41befb47d9a6@panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


I have a power-hungry NVMe-to-USB-C enclosure that sometimes falls offline
under heavy load and disconnects from the USB. Normally I curse and re-plug
it into a powered hub and go on with things. But I'm running Linus' master
(6.0-rc3 of Sunday August 28th, which also has the asynchronous resume support
rework reverted) and I was seeing a lot of the below (along with a hanging up
of the USB).

Reverting f323896f (and setting it up to reproduce the disk error/disconnect)
seems to have fixed the "usb_hub_wq hub_event" hangup, at least at first glance.

	-Kenny

----
Aug 30 11:26:36 xps-7390 kernel: [12225.445356][T20556] I/O error, dev sdb, sector 314643672 op 0x1:(WRITE) flags 0x800
 phys_seg 1 prio class 2
Aug 30 11:26:36 xps-7390 kernel: [12225.445360][T20556] sd 1:0:0:0: [sdb] tag#9 FAILED Result: hostbyte=DID_TIME_OUT dr
iverbyte=DRIVER_OK cmd_age=30s
Aug 30 11:26:36 xps-7390 kernel: [12225.445361][T20556] sd 1:0:0:0: [sdb] tag#9 CDB: Write(10) 2a 00 12 c1 11 48 00 00
08 00
Aug 30 11:26:36 xps-7390 kernel: [12225.445362][T20556] I/O error, dev sdb, sector 314642760 op 0x1:(WRITE) flags 0x800
 phys_seg 1 prio class 2
Aug 30 11:26:36 xps-7390 kernel: [12225.445412][   T72] sd 1:0:0:0: rejecting I/O to offline device
Aug 30 11:27:37 xps-7390 systemd-udevd[465]: sdb1: Worker [20868] processing SEQNUM=5188 is taking a long time
Aug 30 11:28:08 xps-7390 kernel: [12316.738013][T15511] usb 3-9: USB disconnect, device number 14
Aug 30 11:28:08 xps-7390 kernel: [12316.738020][T15511] usb 3-9.4: USB disconnect, device number 17
Aug 30 11:28:08 xps-7390 kernel: [12316.739071][T15511] usb 3-9.5: USB disconnect, device number 18
Aug 30 11:29:37 xps-7390 systemd-udevd[465]: sdb1: Worker [20868] processing SEQNUM=5188 killed
Aug 30 11:29:37 xps-7390 systemd-udevd[465]: Worker [20868] terminated by signal 9 (KILL)
Aug 30 11:29:37 xps-7390 systemd-udevd[465]: sdb1: Worker [20868] failed
Aug 30 11:29:43 xps-7390 kernel: [12411.657995][   T55] INFO: task kworker/4:1:11393 blocked for more than 122 seconds.
Aug 30 11:29:43 xps-7390 kernel: [12411.658007][   T55]       Tainted: G S   U     O       6.0.0-rc3-XPS-Kenny+ #3
Aug 30 11:29:43 xps-7390 kernel: [12411.658011][   T55] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 30 11:29:43 xps-7390 kernel: [12411.658013][   T55] task:kworker/4:1     state:D stack:    0 pid:11393 ppid:     2 flags:0x00004000
Aug 30 11:29:43 xps-7390 kernel: [12411.658020][   T55] Workqueue: usb_hub_wq hub_event
Aug 30 11:29:43 xps-7390 kernel: [12411.658030][   T55] Call Trace:
Aug 30 11:29:43 xps-7390 kernel: [12411.658033][   T55]  <TASK>
Aug 30 11:29:43 xps-7390 kernel: [12411.658035][   T55]  __schedule+0x3fc/0x5e0
Aug 30 11:29:43 xps-7390 kernel: [12411.658042][   T55]  schedule+0x4f/0x80
Aug 30 11:29:43 xps-7390 kernel: [12411.658047][   T55]  scsi_remove_host+0x185/0x200
Aug 30 11:29:43 xps-7390 kernel: [12411.658053][   T55]  ? wake_bit_function+0x50/0x50
Aug 30 11:29:43 xps-7390 kernel: [12411.658060][   T55]  usb_stor_disconnect+0x64/0xb0
Aug 30 11:29:43 xps-7390 kernel: [12411.658066][   T55]  usb_unbind_interface+0xb0/0x250
Aug 30 11:29:43 xps-7390 kernel: [12411.658071][   T55]  device_release_driver_internal+0x1b4/0x2c0
Aug 30 11:29:43 xps-7390 kernel: [12411.658077][   T55]  bus_remove_device+0xd3/0x100
Aug 30 11:29:43 xps-7390 kernel: [12411.658081][   T55]  device_del+0x252/0x470
Aug 30 11:29:43 xps-7390 kernel: [12411.658085][   T55]  usb_disable_device+0x6b/0x180
Aug 30 11:29:43 xps-7390 kernel: [12411.658089][   T55]  usb_disconnect+0xf7/0x260
Aug 30 11:29:43 xps-7390 kernel: [12411.658094][   T55]  usb_disconnect+0xe1/0x260
Aug 30 11:29:43 xps-7390 kernel: [12411.658107][   T55]  hub_event+0xbe8/0x1860
Aug 30 11:29:43 xps-7390 kernel: [12411.658113][   T55]  process_one_work+0x1e7/0x340
Aug 30 11:29:43 xps-7390 kernel: [12411.658118][   T55]  worker_thread+0x24d/0x490
Aug 30 11:29:43 xps-7390 kernel: [12411.658123][   T55]  ? process_one_work+0x340/0x340
Aug 30 11:29:43 xps-7390 kernel: [12411.658126][   T55]  kthread+0xd4/0xe0
Aug 30 11:29:43 xps-7390 kernel: [12411.658130][   T55]  ? kthread_unuse_mm+0x80/0x80
Aug 30 11:29:43 xps-7390 kernel: [12411.658133][   T55]  ret_from_fork+0x1f/0x30
Aug 30 11:29:43 xps-7390 kernel: [12411.658138][   T55]  </TASK>
----

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
