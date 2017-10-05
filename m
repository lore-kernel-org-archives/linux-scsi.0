From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aic7xxx: make a couple of functions static
Date: Thu,  5 Oct 2017 13:01:53 +0100
Message-ID: <20171005120153.32383-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Functions ahc_devlimited_syncrate and ahc_linux_initialize_scsi_bus
are declared static in their prototypes but are missing in their
definitions, so add the missing static.

Cleans up sparse warnings:
symbol 'ahc_devlimited_syncrate' was not declared. Should it be static?
symbol 'ahc_linux_initialize_scsi_bus' was not declared. Should it
be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 381846164003..6612ff3b2e83 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2212,7 +2212,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-const struct ahc_syncrate *
+static const struct ahc_syncrate *
 ahc_devlimited_syncrate(struct ahc_softc *ahc,
 			struct ahc_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index acd687f4554e..c6be3aeb302b 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1141,7 +1141,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
  * or forcing transfer negotiations on the next command to any
  * target.
  */
-void
+static void
 ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc)
 {
 	int i;
-- 
2.14.1
