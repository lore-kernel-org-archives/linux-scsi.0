From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/15] sas_ata: Don't copy aic94xx's sactive to ata_port
Date: Fri, 17 Nov 2006 13:08:21 -0800
Message-ID: <20061117210821.17052.37114.stgit@localhost.localdomain>
References: <20061117210737.17052.67041.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755923AbWKQVD3@vger.kernel.org>
In-Reply-To: <20061117210737.17052.67041.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alexisb@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Since the aic94xx sequencer assigns its own NCQ tags to ATA commands, it
no longer makes any sense to copy the sactive field in the STP response
to ata_port->sactive, as that will confuse libata.  Also, libata seems
to be capable of managing sactive on its own.

The attached patch gets rid of one of the causes of the BUG messages in
ata_qc_new, and seems to work without problems on an IBM x206m.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77860ab..e2650fa 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -105,7 +105,6 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-		dev->sata_dev.ap->sactive = resp->sactive;
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
