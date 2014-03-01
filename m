From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 0/3] m68k Atari SCSI fixes
Date: Sat,  1 Mar 2014 20:51:02 +1300
Message-ID: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53980 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaCAHvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2014 02:51:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de

All, 

please review the following patches to the m68k Atari NCR5380 SCSI code. 

The first patch is my corrected version of Arnd Bergmann's sleep_on removal RFC
series (2/16), tested on my Atari Falcon. Geert, please take this one through the   
linux-m68k tree so Arnd's sleep_on remove can go ahead. 

The second and third one are updates to the Atari NCR5380 drivers' error handling
(return codes updated) and queue_command() function (return SCSI_MLQEUE_HOST_BUSY  
if the lock for the SCSI/DMA hardware cannot be safely taken). Again, tested on my 
Falcon. These will need Ack from the SCSI maintainers but could be taken through
Geert's tree as well. 

This patch series supersedes a previous one of mine, due to a botch-up mingling parts
of patch 1 and 3. Apologies for spamming everyone again.

Please CC: me in on any replies, I am not subscribed to linux-scsi.

Thanks,

        Michael Schmitz 

[PATCH 1/3] m68k/atari - convert atari_scsi falcon_get_lock() to use wait_event()
[PATCH 2/3] m68k/atari - atari_scsi: change abort/reset return codes
[PATCH 3/3] m68k/atari - atari_scsi: punt if deadlocked
