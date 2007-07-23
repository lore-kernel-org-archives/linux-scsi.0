From: Adrian Bunk <bunk@stusta.de>
Subject: [RFC: 2.6 patch] nsp32_restart_autoscsi(): remove error check
Date: Mon, 23 Jul 2007 21:33:34 +0200
Message-ID: <20070723193334.GP26212@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42543 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934378AbXGWTeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 15:34:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yokota@netlab.is.tsukuba.ac.jp, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Coverity checker noted that we'll anyway Oops later when we ran into 
this condition - and the error check didn't prevent that.

Considering that the error condition shouldn't be possible, and we are 
not able to handle it easily, this patch simply removes the pointless 
error check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/nsp32.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/scsi/nsp32.c.old	2007-07-23 19:38:58.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/nsp32.c	2007-07-23 20:17:14.000000000 +0200
@@ -1888,44 +1888,40 @@ static void nsp32_msgout_occur(struct sc
 
 	data->msgout_len = 0;
 
 	nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR, "exit");
 }
 
 /*
  * Restart AutoSCSI
  *
  * Note: Restarting AutoSCSI needs set:
  *		SYNC_REG, ACK_WIDTH, SGT_ADR, TRANSFER_CONTROL
  */
 static void nsp32_restart_autoscsi(struct scsi_cmnd *SCpnt, unsigned short command)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = data->BaseAddress;
 	unsigned short transfer = 0;
 
 	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
 
-	if (data->cur_target == NULL || data->cur_lunt == NULL) {
-		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
-	}
-
 	/*
 	 * set SYNC_REG
 	 * Don't set BM_START_ADR before setting this register.
 	 */
 	nsp32_write1(base, SYNC_REG, data->cur_target->syncreg);
 
 	/*
 	 * set ACKWIDTH
 	 */
 	nsp32_write1(base, ACK_WIDTH, data->cur_target->ackwidth);
 
 	/*
 	 * set SREQ hazard killer sampling rate
 	 */
 	nsp32_write1(base, SREQ_SMPL_RATE, data->cur_target->sample_reg);
 
 	/*
 	 * set SGT ADDR (physical address)
 	 */
 	nsp32_write4(base, SGT_ADR, data->cur_lunt->sglun_paddr);

