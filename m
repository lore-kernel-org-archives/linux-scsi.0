From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND  3/3] storvsc: Don't set the SRB_FLAGS_QUEUE_ACTION_ENABLE flag
Date: Thu, 17 Sep 2015 15:29:19 -0700
Message-ID: <1442528959-3298-3-git-send-email-kys@microsoft.com>
References: <1442528938-3252-1-git-send-email-kys@microsoft.com>
 <1442528959-3298-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:35028
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbbIQVBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 17:01:19 -0400
In-Reply-To: <1442528959-3298-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Don't set the SRB_FLAGS_QUEUE_ACTION_ENABLE flag since we are not specifying
tags. Qlogic driver does not work correctly if the SRB_FLAGS_QUEUE_ACTION_ENABLE
is set and no action tag is specified.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Vivek Yadav <vyadav@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index bce131b..9c8db21 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1647,8 +1647,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	vm_srb->win8_extension.time_out_value = 60;
 
 	vm_srb->win8_extension.srb_flags |=
-		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
-		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
+		SRB_FLAGS_DISABLE_SYNCH_TRANSFER;
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
-- 
1.7.4.1

