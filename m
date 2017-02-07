From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH RFC] enclosure: fix symlinks creation
Date: Tue,  7 Feb 2017 15:08:47 +0100
Message-ID: <1486476528-27580-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754088AbdBGOIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 09:08:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

James,

one of our customers complains that in some cases, when using multipath,
the enclosure driver fails to create the symlinks in sysfs.

This is an example of what happens:

[   19.251902] scsi 0:0:27:0: Direct-Access     SEAGATE  ST8000NM0075     E002 PQ: 0 ANSI: 6
[   19.261874] scsi 0:0:27:0: SSP: handle(0x0027), sas_addr(0x5000c50085826dd6), phy(34), device_name(0x5000c50085826dd4)
[   19.274656] scsi 0:0:27:0: SSP: enclosure_logical_id(0x500093d001be4000), slot(57)
[   19.283944] scsi 0:0:27:0: SSP: enclosure level(0x0000), connector name(     )
[   19.292933] scsi 0:0:27:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_l
[...]
[   60.066524] enclosure_add_device(0:0:27:0) called, enclosure_add_links() failed with error -2
[...]
[   75.119146] sd 0:0:27:0: Attached scsi generic sg27 type 0
[   75.126722] sd 0:0:27:0: [sdaa] 15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)
[   75.126723] sd 0:0:27:0: [sdaa] 4096-byte physical blocks
[   75.129059] sd 0:0:27:0: [sdaa] Write Protect is off
[   75.129061] sd 0:0:27:0: [sdaa] Mode Sense: db 00 10 08
[   75.130417] sd 0:0:27:0: [sdaa] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   75.158088] sd 0:0:27:0: [sdaa] Attached SCSI disk
[...]
[   75.192722] enclosure_add_device(0:0:27:0) called, device already exists

The first time enclosure_add_device() is called, the symlinks creation failed.
The second time it would have succeeded, but the enclosure_add_device() function returned immediately
without retrying to create the symlinks.

Maurizio Lombardi (1):
  enclosure: fix sysfs symlinks creation when using multipath

 drivers/misc/enclosure.c  | 16 ++++++++++++++--
 include/linux/enclosure.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
Maurizio Lombardi
