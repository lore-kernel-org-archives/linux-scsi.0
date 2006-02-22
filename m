From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/9] lpfc 8.1.3 : Adding hbaapi event support using new fc
 transport events api
Date: Wed, 22 Feb 2006 12:34:01 -0500
Message-ID: <43FCA089.9090101@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:474 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1161136AbWBVReE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:34:04 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHY3rf029942
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:34:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Adding hbaapi event support using new fc transport events api

Requires the following patch, which adds event support to the FC transport:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114062467404472&w=2


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -320,6 +320,8 @@ lpfc_linkdown(struct lpfc_hba * phba)
  		spin_unlock_irq(phba->host->host_lock);
  	}

+	fc_host_event_post(phba->host, FCH_EVT_LINKDOWN, 0);
+
  	/* Clean up any firmware default rpi's */
  	if ((mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))) {
  		lpfc_unreg_did(phba, 0xffffffff, mb);
@@ -415,6 +417,7 @@ lpfc_linkup(struct lpfc_hba * phba)
  	phba->fc_ns_retry = 0;
  	spin_unlock_irq(phba->host->host_lock);

+	fc_host_event_post(phba->host, FCH_EVT_LINKUP, 0);

  	node_list[0] = &phba->fc_plogi_list;
  	node_list[1] = &phba->fc_adisc_list;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -561,6 +561,7 @@ lpfc_handle_eratt(struct lpfc_hba * phba

  		lpfc_offline(phba);
  		phba->hba_state = LPFC_HBA_ERROR;
+		fc_host_event_post(phba->host, FCH_EVT_VENDOR_UNIQUE, 0);
  		lpfc_hba_down_post(phba);
  	}
  }
@@ -1333,6 +1334,8 @@ lpfc_online(struct lpfc_hba * phba)
  	if (lpfc_sli_hba_setup(phba))	/* Initialize the HBA */
  		return 1;

+	fc_host_event_post(phba->host, FCH_EVT_PORT_ONLINE, 0);
+
  	spin_lock_irq(phba->host->host_lock);
  	phba->fc_flag &= ~FC_OFFLINE_MODE;
  	spin_unlock_irq(phba->host->host_lock);
@@ -1354,6 +1357,8 @@ lpfc_offline(struct lpfc_hba * phba)
  	if (phba->fc_flag & FC_OFFLINE_MODE)
  		return 0;

+	fc_host_event_post(phba->host, FCH_EVT_PORT_OFFLINE, 0);
+
  	psli = &phba->sli;
  	pring = &psli->ring[psli->fcp_ring];

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2383,6 +2383,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
  	uint32_t *lp;
  	IOCB_t *icmd;
  	uint32_t payload_len, cmd;
+	int i;

  	icmd = &cmdiocb->iocb;
  	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -2401,6 +2402,9 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
  			phba->brd_no,
  			phba->fc_flag, payload_len, *lp, phba->fc_rscn_id_cnt);

+	for (i = 0; i < payload_len/sizeof (uint32_t); i++)
+		fc_host_event_post(phba->host, FCH_EVT_RSCN, lp[i]);
+
  	/* If we are about to begin discovery, just ACC the RSCN.
  	 * Discovery processing will satisfy it.
  	 */


