From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/19] lpfc 10.4.8000.0: Mark functions as static in
 lpfc/lpfc_scsi.c
Date: Wed, 3 Sep 2014 12:55:36 -0400
Message-ID: <1409763336.12357.4.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47622 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbaICQzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D139611665406898&w=3D2

  Rashika Kheria <rashika.kheria@gmail.com>
  [PATCH 25/55] scsi: Mark functions as static in lpfc/lpfc_scsi.c

  Mark functions as static in lpfc/lpfc_scsi.c because they are not use=
d
  outside this file.

  This eliminates the following warnings in lpfc/lpfc_scsi.c:
  drivers/scsi/lpfc/lpfc_scsi.c:299:1: warning: no previous prototype f=
or =E2=80=98lpfc_change_queue_depth=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_scsi.c:795:1: warning: no previous prototype f=
or =E2=80=98lpfc_sli4_post_scsi_sgl_list=E2=80=99 [-Wmissing-prototypes=
]
  drivers/scsi/lpfc/lpfc_scsi.c:3019:1: warning: no previous prototype =
for =E2=80=98lpfc_bg_crc=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_scsi.c:3035:1: warning: no previous prototype =
for =E2=80=98lpfc_bg_csum=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_scsi.c:3048:1: warning: no previous prototype =
for =E2=80=98lpfc_calc_bg_err=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scs=
i.c
index 7862c55..3c250e3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -306,7 +306,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_=
hba *phba,
  * depth for a scsi device. This function sets the queue depth to the =
new
  * value and sends an event out to log the queue depth change.
  **/
-int
+static int
 lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reas=
on)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->hostda=
ta;
@@ -741,7 +741,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
  *
  * Returns: 0 =3D failure, non-zero number of successfully posted buff=
ers.
  **/
-int
+static int
 lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 			     struct list_head *post_sblist, int sb_count)
 {
@@ -2965,7 +2965,7 @@ err:
  * on the specified data using a CRC algorithmn
  * using crc_t10dif.
  */
-uint16_t
+static uint16_t
 lpfc_bg_crc(uint8_t *data, int count)
 {
 	uint16_t crc =3D 0;
@@ -2981,7 +2981,7 @@ lpfc_bg_crc(uint8_t *data, int count)
  * on the specified data using a CSUM algorithmn
  * using ip_compute_csum.
  */
-uint16_t
+static uint16_t
 lpfc_bg_csum(uint8_t *data, int count)
 {
 	uint16_t ret;
@@ -2994,7 +2994,7 @@ lpfc_bg_csum(uint8_t *data, int count)
  * This function examines the protection data to try to determine
  * what type of T10-DIF error occurred.
  */
-void
+static void
 lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd=
)
 {
 	struct scatterlist *sgpe; /* s/g prot entry */
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
