From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: question about drivers/scsi/libsas/sas_ata.c
Date: Mon, 28 Sep 2009 11:43:54 -0700
Message-ID: <20090928184354.GA21723@tux1.beaverton.ibm.com>
References: <Pine.LNX.4.64.0909221355170.20456@pc-004.diku.dk>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:35110 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZI1SoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 14:44:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8SIh8d5016347
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2009 12:43:08 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8SIhtIi161164
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2009 12:44:00 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8SIhsR3015496
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2009 12:43:55 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909221355170.20456@pc-004.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, Sep 22, 2009 at 01:59:50PM +0200, Julia Lawall wrote:
> The function sas_ata_task_done in the file drivers/scsi/libsas/sas_ata.c 
> contains the following code:
> 
> 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_GOOD) {
> 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
> 		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
> 		dev->sata_dev.sstatus = resp->sstatus;
> 		dev->sata_dev.serror = resp->serror;
> 		dev->sata_dev.scontrol = resp->scontrol;
> 	} else if (stat->stat != SAM_STAT_GOOD) {
> 		ac = sas_to_ata_err(stat);
> 		if (ac) {
> 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
> 				    stat->stat);
> 			/* We saw a SAS error. Send a vague error. */
> 			qc->err_mask = ac;
> 			dev->sata_dev.tf.feature = 0x04; /* status err */
> 			dev->sata_dev.tf.command = ATA_ERR;
> 		}
> 	}
> 
> Should the reference to SAM_STAT_GOOD be instead a reference to SAM_GOOD?  
> They both have the same value (0), but SAM_STAT_GOOD is defined in a 
> different file than the other constants used with stat->stat.

Yes, particularly since stat->stat is an enum that defines STAT_GOOD.  Sorry
about the fubar code from years ago.

--D
