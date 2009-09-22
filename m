From: Julia Lawall <julia@diku.dk>
Subject: question about drivers/scsi/libsas/sas_ata.c
Date: Tue, 22 Sep 2009 13:59:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0909221355170.20456@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:44853 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbZIVL7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2009 07:59:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The function sas_ata_task_done in the file drivers/scsi/libsas/sas_ata.c 
contains the following code:

	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_GOOD) {
		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
		dev->sata_dev.sstatus = resp->sstatus;
		dev->sata_dev.serror = resp->serror;
		dev->sata_dev.scontrol = resp->scontrol;
	} else if (stat->stat != SAM_STAT_GOOD) {
		ac = sas_to_ata_err(stat);
		if (ac) {
			SAS_DPRINTK("%s: SAS error %x\n", __func__,
				    stat->stat);
			/* We saw a SAS error. Send a vague error. */
			qc->err_mask = ac;
			dev->sata_dev.tf.feature = 0x04; /* status err */
			dev->sata_dev.tf.command = ATA_ERR;
		}
	}

Should the reference to SAM_STAT_GOOD be instead a reference to SAM_GOOD?  
They both have the same value (0), but SAM_STAT_GOOD is defined in a 
different file than the other constants used with stat->stat.

julia
