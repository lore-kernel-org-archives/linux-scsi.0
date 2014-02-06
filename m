From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/4] isci: fix needless ata reset escalations
Date: Thu, 06 Feb 2014 12:23:15 -0800
Message-ID: <20140206202315.5227.86986.stgit@viggo.jf.intel.com>
References: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dave.jiang@intel.com, lukasz.dorau@intel.com, stable@vger.kernel.org, artur.paszkiewicz@intel.com, JBottomley@Parallels.com, Xun Ni <xun.ni@intel.com>, Nelson Cheng <nelson.cheng@intel.com>
List-Id: linux-scsi@vger.kernel.org

isci is needlessly tying libata's hands by returning
SAM_STAT_CHECK_CONDITION to some ata errors.  Instead, prefer
SAS_PROTO_RESPONSE to let libata (via sas_ata_task_done()) disposition
the device-to-host fis.

For example isci is triggering an HSM Violation where AHCI is showing a
simple media error for the same bus condition:

isci:
ata7.00: failed command: READ VERIFY SECTOR(S)
ata7.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
         res 01/04:00:00:00:00/00:00:00:00:00/e0 Emask 0x3 (HSM violation)

ahci:
ata6.00: failed command: READ VERIFY SECTOR(S)
ata6.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0
         res 51/40:01:00:00:00/00:00:00:00:00/e0 Emask 0x9 (media error)

Note that the isci response matches this from sas_ata_task_done():
	/* We saw a SAS error. Send a vague error. */
	[..]
	dev->sata_dev.fis[3] = 0x04; /* status err */
	dev->sata_dev.fis[2] = ATA_ERR;

The end effect is that isci is needlessly triggering hard resets when
they are not necessary.

Cc: <stable@vger.kernel.org>
Reported-by: Xun Ni <xun.ni@intel.com>
Tested-by: Nelson Cheng <nelson.cheng@intel.com>
Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 99d2930b18c8..56e38096f0c4 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2723,13 +2723,9 @@ static void isci_process_stp_response(struct sas_task *task, struct dev_to_host_
 	memcpy(resp->ending_fis, fis, sizeof(*fis));
 	ts->buf_valid_size = sizeof(*resp);
 
-	/* If the device fault bit is set in the status register, then
-	 * set the sense data and return.
-	 */
-	if (fis->status & ATA_DF)
+	/* If an error is flagged let libata decode the fis */
+	if (ac_err_mask(fis->status))
 		ts->stat = SAS_PROTO_RESPONSE;
-	else if (fis->status & ATA_ERR)
-		ts->stat = SAM_STAT_CHECK_CONDITION;
 	else
 		ts->stat = SAM_STAT_GOOD;
 
