From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Set the SRB flags correctly when no data transfer is needed
Date: Fri, 24 Apr 2015 17:23:23 -0700
Message-ID: <1429921403-8606-1-git-send-email-kys@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Set the SRB flags correctly when there is no data transfer.

Cc: <stable@vger.kernel.org>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index d9dad90..3c6584f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1600,8 +1600,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		break;
 	default:
 		vm_srb->data_in = UNKNOWN_TYPE;
-		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
-						     SRB_FLAGS_DATA_OUT);
+		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_NO_DATA_TRANSFER;
 		break;
 	}
 
-- 
1.7.4.1
