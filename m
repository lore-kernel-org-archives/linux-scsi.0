From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 0/5] scsi/bnx2*: Plug hotplug race,
 correct locking and simplify hotplug code
Date: Mon, 24 Jul 2017 12:52:55 +0200
Message-ID: <20170724105255.715647116@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

The conversion of the cpu hotplug locking to a percpu rwsem does not longer
allow recursive locking of the hotplug lock.

The BNX2I and BNX2FC drivers install/remove hotplug states with the hotplug
lock held. The install/removal code acquired the hotplug lock as well.

While looking into this, I noticed an interesting hotplug race in the
BNX2FC driver, which could result in dereferencing a NULL pointer or freed
and potentially reused memory.

The following series addresses these problems and as a final step on top it
simplifies the hotplug code in both drivers.

Thanks,

	tglx

----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   68 ++++++++------------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   45 ++++++++++++-------------
 drivers/scsi/bnx2i/bnx2i_init.c   |   64 ++++++++---------------------------
 include/linux/cpuhotplug.h        |    2 -
 4 files changed, 53 insertions(+), 126 deletions(-)
