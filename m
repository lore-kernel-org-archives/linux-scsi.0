From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 0/7] Asynchronous Notification for ATAPI devices (resend)
Date: Wed, 9 May 2007 16:37:56 -0700
Message-ID: <20070509163756.dd8136c7.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbXEIXk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2007 19:40:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

Hi Jeff,
Here are the AN patches again, they have not changed with the exception
of patch #1, which does set the host flag in board_ahci and board_ahci_pi
now (thanks Tejun).

This patch series implements Asynchronous Notification (AN) for SATA
ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
which support this feature will send a notification when new media is
inserted and removed, preventing the need for user space to poll for
new media.  This support is exposed to user space via a flag that will
be set in /sys/block/sr*/capability_flags.  If the flag is set, user
space can disable polling for the new media, and the genhd driver will
send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.

Note that this patch only implements support for directly attached
drives - AN with drives attached to a port multiplier requires 
additional changes.

Thanks!
Kristen

-- 
