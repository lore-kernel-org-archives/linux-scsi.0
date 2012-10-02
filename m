From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit packets in the RESET path
Date: Tue,  2 Oct 2012 11:03:31 -0700
Message-ID: <1349201011-14572-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Properly account for I/O in transit before returning from the RESET call.
In the absense of this patch, we could have a situation where the host may
respond to a command that was issued prior to the issuance of the RESET
command at some arbitrary time after responding to the RESET command.
Currently, the host does not do anything with the RESET command. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/storvsc_drv.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 528d52b..0144078 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1221,7 +1221,12 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	/*
 	 * At this point, all outstanding requests in the adapter
 	 * should have been flushed out and return to us
+	 * There is a potential race here where the host may be in
+	 * the process of responding when we return from here.
+	 * Just wait for all in-transit packets to be accounted for
+	 * before we return from here.
 	 */
+	storvsc_wait_to_drain(stor_device);
 
 	return SUCCESS;
 }
-- 
1.7.4.1
