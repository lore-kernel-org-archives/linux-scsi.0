From: kys@exchange.microsoft.com
Subject: [PATCH 5/6] storvsc: properly handle SRB_ERROR when sense message is present
Date: Wed, 14 Dec 2016 18:46:02 -0800
Message-ID: <1481769963-2069-5-git-send-email-kys@exchange.microsoft.com>
References: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
 <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481769963-2069-1-git-send-email-kys@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
Cc: Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sense message is present on error, we should pass along to the upper
layer to decide how to deal with the error.
This patch fixes connectivity issues with Fiber Channel devices.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3209387..3c92dc2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -925,6 +925,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	switch (SRB_STATUS(vm_srb->srb_status)) {
 	case SRB_STATUS_ERROR:
 		/*
+		 * Let upper layer deal with error when
+		 * sense message is present.
+		 */
+
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID)
+			break;
+		/*
 		 * If there is an error; offline the device since all
 		 * error recovery strategies would have already been
 		 * deployed on the host side. However, if the command
-- 
1.7.4.1
