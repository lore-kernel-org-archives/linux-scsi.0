From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/19] lpfc 10.4.8000.0: Mark functions as static in
 lpfc/lpfc_sli.c
Date: Wed, 3 Sep 2014 12:55:04 -0400
Message-ID: <1409763304.12357.1.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43837 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaICQz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D139611643606816&w=3D2

  Rashika Kheria <rashika.kheria@gmail.com>
  [PATCH 22/55] scsi: Mark functions as static in lpfc/lpfc_sli.c

  Mark functions as static in lpfc/lpfc_sli.c because they are not used
  outside this file.

  This eliminates the following warnings in lpfc/lpfc_sli.c:
  drivers/scsi/lpfc/lpfc_sli.c:13867:1: warning: no previous prototype =
for =E2=80=98lpfc_sli4_alloc_xri=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_sli.c:13897:1: warning: no previous prototype =
for =E2=80=98__lpfc_sli4_free_xri=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_sli.c:14317:1: warning: no previous prototype =
for =E2=80=98lpfc_update_rcv_time_stamp=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_sli.c:14786:1: warning: no previous prototype =
for =E2=80=98lpfc_sli4_handle_unsol_abort=E2=80=99 [-Wmissing-prototype=
s]
  drivers/scsi/lpfc/lpfc_sli.c:15331:1: warning: no previous prototype =
for =E2=80=98__lpfc_sli4_free_rpi=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_sli.c:15769:1: warning: no previous prototype =
for =E2=80=98lpfc_check_next_fcf_pri_level=E2=80=99 [-Wmissing-prototyp=
es]
  drivers/scsi/lpfc/lpfc_sli.c:16000:1: warning: no previous prototype =
for =E2=80=98lpfc_mbx_cmpl_redisc_fcf_table=E2=80=99 [-Wmissing-prototy=
pes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.=
c
index 32ada05..04a8b74 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14270,7 +14270,7 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba,
  *	A nonzero rpi defined as rpi_base <=3D rpi < max_rpi if successful
  *	LPFC_RPI_ALLOC_ERROR if no rpis are available.
  **/
-uint16_t
+static uint16_t
 lpfc_sli4_alloc_xri(struct lpfc_hba *phba)
 {
 	unsigned long xri;
@@ -14300,7 +14300,7 @@ lpfc_sli4_alloc_xri(struct lpfc_hba *phba)
  * This routine is invoked to release an xri to the pool of
  * available rpis maintained by the driver.
  **/
-void
+static void
 __lpfc_sli4_free_xri(struct lpfc_hba *phba, int xri)
 {
 	if (test_and_clear_bit(xri, phba->sli4_hba.xri_bmask)) {
@@ -14720,7 +14720,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, s=
truct fc_frame_header *fc_hdr,
  * the driver uses this time stamp to indicate if any received sequenc=
es have
  * timed out.
  **/
-void
+static void
 lpfc_update_rcv_time_stamp(struct lpfc_vport *vport)
 {
 	struct lpfc_dmabuf *h_buf;
@@ -15189,7 +15189,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vpor=
t,
  * unsolicited sequence has been aborted. After that, it will issue a =
basic
  * accept to accept the abort.
  **/
-void
+static void
 lpfc_sli4_handle_unsol_abort(struct lpfc_vport *vport,
 			     struct hbq_dmabuf *dmabuf)
 {
@@ -15734,7 +15734,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
  * This routine is invoked to release an rpi to the pool of
  * available rpis maintained by the driver.
  **/
-void
+static void
 __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
@@ -16172,7 +16172,7 @@ fail_fcf_read:
  * returns:
  * 1=3Dsuccess 0=3Dfailure
  **/
-int
+static int
 lpfc_check_next_fcf_pri_level(struct lpfc_hba *phba)
 {
 	uint16_t next_fcf_pri;
@@ -16403,7 +16403,7 @@ lpfc_sli4_fcf_rr_index_clear(struct lpfc_hba *p=
hba, uint16_t fcf_index)
  * command. If the mailbox command returned failure, it will try to st=
op the
  * FCF rediscover wait timer.
  **/
-void
+static void
 lpfc_mbx_cmpl_redisc_fcf_table(struct lpfc_hba *phba, LPFC_MBOXQ_t *mb=
ox)
 {
 	struct lpfc_mbx_redisc_fcf_tbl *redisc_fcf;
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
