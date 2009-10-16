From: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/7] scsi error: have scsi-ml call
	change_queue_depth to	handle QUEUE_FULL
Date: Thu, 15 Oct 2009 17:46:44 -0700
Message-ID: <20091016004644.22451.37634.stgit@vifc.jf.intel.com>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20091016004639.22451.76363.stgit-M4Lc0Xp98oKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

This has scsi-ml call the change_queue_depth functions when
we get a QUEUE_FULL. It will only change the queue depth if
change_queue_depth is set because the LLD may have to
modify some internal resources, so I thought this would
be the safest route.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-v2
Limits change_queue_depth to only all luns of target by adding
channel check while iterating for all luns of Scsi_Host. This is
same as currently qla2xxx FC HBA does on QUEUE_FULL event.

Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/scsi/scsi_error.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1b0060b..7b1e20f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -331,6 +331,28 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	}
 }
 
+static void scsi_handle_queue_full(struct scsi_device *sdev)
+{
+	struct scsi_host_template *sht = sdev->host->hostt;
+	struct scsi_device *tmp_sdev;
+
+	if (!sht->change_queue_depth)
+		return;
+
+	shost_for_each_device(tmp_sdev, sdev->host) {
+		if (tmp_sdev->channel != sdev->channel ||
+		    tmp_sdev->id != sdev->id)
+			continue;
+		/*
+		 * We do not know the number of commands that were at
+		 * the device when we got the queue full so we start
+		 * from the highest possible value and work our way down.
+		 */
+		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
+					SCSI_QDEPTH_QFULL);
+	}
+}
+
 /**
  * scsi_eh_completed_normally - Disposition a eh cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -387,8 +409,10 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * let issuer deal with this, it could be just fine
 		 */
 		return SUCCESS;
-	case BUSY:
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
+		/* fall through */
+	case BUSY:
 	default:
 		return FAILED;
 	}
@@ -1387,6 +1411,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
 		/*
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
