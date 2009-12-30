From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()
Date: Wed, 30 Dec 2009 17:58:52 +0100
Message-ID: <4B3B86CC.5010205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752731AbZL3Qzq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com
List-Id: linux-scsi@vger.kernel.org

This never evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index efabea1..82c5474 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4363,7 +4363,7 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 #endif
 
 	if (!(event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET ||
 	   event_data->ReasonCode ==
 	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
 		return;
