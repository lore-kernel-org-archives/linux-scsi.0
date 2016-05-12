From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] mpt3sas: add missing curly braces
Date: Thu, 12 May 2016 23:37:38 +0300
Message-ID: <20160512203738.GB26894@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There are some missing curly braces on this if statement, so we end up
printing when we shouldn't.

Fixes: a470a51cd648 ('mpt3sas: Handle active cable exception event')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6a4df5a..6bff13e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7975,13 +7975,14 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		ActiveCableEventData =
 		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
 		if (ActiveCableEventData->ReasonCode ==
-				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER)
+				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER) {
 			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d",
 			    ioc->name, ActiveCableEventData->ReceptacleID);
 			pr_info("cannot be powered and devices connected to this active cable");
 			pr_info("will not be seen. This active cable");
 			pr_info("requires %d mW of power",
 			    ActiveCableEventData->ActiveCablePowerRequirement);
+		}
 		break;
 
 	default: /* ignore the rest */
