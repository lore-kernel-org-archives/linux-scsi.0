From: James.Smart@Emulex.Com
Subject: [PATCH 6/15]  lpfc 8.1.0 : Fix for "Unknown IOCB command Data: x0 x3 x0 x0"
Date: Fri, 28 Oct 2005 20:29:28 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A55@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3281 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750919AbVJ2A3b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:31 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TTDp018525
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:30 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix for "Unknown IOCB command Data: x0 x3 x0 x0" messages and 
 inability to see devices

Fix: On some platforms, the host-memory based ring mgmt area was
  not zero. Also, driver wasn't manipulating the entire 32bits of
  the ring pointers.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -125,10 +125,10 @@ struct lpfc_sli_ring {
 
 	uint32_t local_getidx;   /* last available cmd index (from cmdGetInx) */
 	uint32_t next_cmdidx;    /* next_cmd index */
+	uint32_t rspidx;	/* current index in response ring */
+	uint32_t cmdidx;	/* current index in command ring */
 	uint8_t rsvd;
 	uint8_t ringno;		/* ring number */
-	uint8_t rspidx;		/* current index in response ring */
-	uint8_t cmdidx;		/* current index in command ring */
 	uint16_t numCiocb;	/* number of command iocb's per ring */
 	uint16_t numRiocb;	/* number of rsp iocb's per ring */
 
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1430,6 +1430,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (!phba->slim2p)
 		goto out_iounmap;
 
+	memset(phba->slim2p, 0, SLI2_SLIM_SIZE);
 
 	/* Initialize the SLI Layer to run with lpfc HBAs. */
 	lpfc_sli_setup(phba);
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -531,6 +531,7 @@ lpfc_config_port(struct lpfc_hba * phba,
 	size_t offset;
 	struct lpfc_hgp hgp;
 	void __iomem *to_slim;
+	int i;
 
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_CONFIG_PORT;
@@ -587,7 +588,11 @@ lpfc_config_port(struct lpfc_hba * phba,
 	/* write HGP data to SLIM at the required longword offset */
 	memset(&hgp, 0, sizeof(struct lpfc_hgp));
 	to_slim = phba->MBslimaddr + (SLIMOFF*sizeof (uint32_t));
-	lpfc_memcpy_to_slim(to_slim, &hgp, sizeof(struct lpfc_hgp));
+
+	for (i=0; i < phba->sli.num_rings; i++) {
+		lpfc_memcpy_to_slim(to_slim, &hgp, sizeof(struct lpfc_hgp));
+		to_slim += sizeof (struct lpfc_hgp);
+	}
 
 	/* Setup Port Group ring pointer */
 	offset = (uint8_t *)&phba->slim2p->mbx.us.s2.port -
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -335,7 +335,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 	 * driver will put a command into.
 	 */
 	pring->cmdidx = pring->next_cmdidx;
-	writeb(pring->cmdidx, phba->MBslimaddr
+	writel(pring->cmdidx, phba->MBslimaddr
 	       + (SLIMOFF + (pring->ringno * 2)) * 4);
 }
 
@@ -1033,7 +1033,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 
 		to_slim = phba->MBslimaddr +
 			(SLIMOFF + (pring->ringno * 2) + 1) * 4;
-		writeb(pring->rspidx, to_slim);
+		writel(pring->rspidx, to_slim);
 
 		if (pring->rspidx == portRspPut)
 			portRspPut = le32_to_cpu(pgp->rspPutInx);
@@ -1147,7 +1147,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 
 		to_slim = phba->MBslimaddr + (SLIMOFF + (pring->ringno * 2)
 					      + 1) * 4;
-		writeb(pring->rspidx, to_slim);
+		writel(pring->rspidx, to_slim);
 
 		if (list_empty(&(pring->iocb_continueq))) {
 			list_add(&rspiocbp->list, &(pring->iocb_continueq));
