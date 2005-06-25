From: James.Smart@Emulex.Com
Subject: [PATCH 4 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:13 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4149@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39870 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261242AbVFYOeP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:15 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYE9P008176
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:14 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix error loading lpfc on sparc

Bug reported via SourceForge - lpfc does not load on sparc.  The lpfc
driver must byteswap all FCP IOCBs to recover the data into cpu native
format.

Also correct issue of "iotag not found" messages

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c |   17 +++++++++----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~bebyteswap drivers/scsi/lpfc/lpfc_sli.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_sli.c~bebyteswap	2005-06-25 09:42:03.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c	2005-06-25 09:42:03.000000000 -0400
@@ -904,6 +904,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 {
  	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
 	IOCB_t *irsp = NULL;
+	IOCB_t *entry = NULL;
 	struct lpfc_iocbq *cmdiocbq = NULL;
 	struct lpfc_iocbq rspiocbq;
 	uint32_t status;
@@ -948,7 +949,17 @@ lpfc_sli_handle_fast_ring_event(struct l
 
 	rmb();
 	while (pring->rspidx != portRspPut) {
-		irsp = (IOCB_t *) IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
+		/*
+		 * Fetch an entry off the ring and copy it into a local data
+		 * structure.  The copy involves a byte-swap since the
+		 * network byte order and pci byte orders are different.
+		 */
+		entry = (IOCB_t *) IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
+		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
+				      (uint32_t *) &rspiocbq.iocb,
+				      sizeof (IOCB_t));
+		irsp = &rspiocbq.iocb;
+
 		type = lpfc_sli_iocb_cmd_type(irsp->ulpCommand & CMD_IOCB_MASK);
 		pring->stats.iocb_rsp++;
 		rsp_cmpl++;
@@ -980,10 +991,6 @@ lpfc_sli_handle_fast_ring_event(struct l
 				break;
 			}
 
-			rspiocbq.iocb.un.ulpWord[4] = irsp->un.ulpWord[4];
-			rspiocbq.iocb.ulpStatus = irsp->ulpStatus;
-			rspiocbq.iocb.ulpContext = irsp->ulpContext;
-			rspiocbq.iocb.ulpIoTag = irsp->ulpIoTag;
 			cmdiocbq = lpfc_sli_txcmpl_ring_iotag_lookup(phba,
 								pring,
 								&rspiocbq);
_
