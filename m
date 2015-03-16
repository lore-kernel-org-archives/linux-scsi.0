From: =?utf-8?Q?Peter_M=C3=BCnster?= <pmlists@free.fr>
Subject: avoid disk spinup at system resume
Date: Mon, 16 Mar 2015 13:28:21 +0100
Message-ID: <871tkpunx6.fsf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42312 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbCPMaE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Mar 2015 08:30:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1YXU9i-0005r0-Vu
	for linux-scsi@vger.kernel.org; Mon, 16 Mar 2015 13:30:03 +0100
Received: from arennes-651-1-149-36.w2-2.abo.wanadoo.fr ([2.2.212.36])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2015 13:30:02 +0100
Received: from pmlists by arennes-651-1-149-36.w2-2.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2015 13:30:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

My SATA disk (sdb) spins up at every system resume. How could I avoid
that please?

Some details:

- sdb not mounted
- echo 0 >/sys/block/sdb/device/scsi_disk/2:0:0:0/manage_start_stop
- hdparm -C /dev/sdb :   "drive state is:  standby"
- s2ram
- after wake up:         "drive state is:  active/idle"
- kernel message at wakeup: "sd 2:0:0:0: [sdb] Synchronizing SCSI cache"
- when doing "echo scsi remove-single-device 2 0 0 0 >/proc/scsi/scsi"
  before s2ram, sdb keeps sleeping after resume

I need the disk only about once per week. I use s2ram several times per
day, and I prefer that sdb keeps sleeping.

TIA for any hints,
-- 
           Peter

