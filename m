From: Julia Lawall <julia@diku.dk>
Subject: question about drivers/scsi/aic7xxx/aic7xxx_osm.c
Date: Tue, 22 Sep 2009 11:53:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0909221148580.20456@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:40837 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIVJxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2009 05:53:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, linux-scsi@vger.kernel.org

The function ahc_linux_run_command in the file 
drivers/scsi/aic7xxx/aic7xxx_osm.c contains the following code:

	/*
	 * We only allow one untagged transaction
	 * per target in the initiator role unless
	 * we are storing a full busy target *lun*
	 * table in SCB space.
	 */
	if (!blk_rq_tagged(cmd->request)
	    && (ahc->features & AHC_SCB_BTT) == 0) {
		int target_offset;

		target_offset = cmd->device->id + cmd->device->channel * 8;
		untagged_q = &(ahc->untagged_queues[target_offset]);
		if (!TAILQ_EMPTY(untagged_q))
			/* if we're already executing an untagged command
			 * we're busy to another */
			return SCSI_MLQUEUE_DEVICE_BUSY;
	}

The constant AHC_SCB_BTT, however, is defined in the enum type ahc_flag in 
the file drivers/scsi/aic7xxx/aic7xxx.h, unlike the other constants that 
the features field is compared with, which are defined in the enum type 
ahc_feature, in the same file.  Is this correct?  AHC_SCB_BTT has the 
value 0x40000, which is the same as the ahc_feature value AHC_MULTIROLE.  
Should that value be used instead?  Or something else?

julia
