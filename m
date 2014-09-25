From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 1/1] multipath-tools: Change path checker for
 IBM IPR devices
Date: Thu, 25 Sep 2014 09:57:43 -0700
Message-ID: <20140925165743.GA20621@infradead.org>
References: <20140924195721.148637349@linux.vnet.ibm.com>
 <20140924195752.289011902@linux.vnet.ibm.com>
 <5423B664.2020007@suse.de>
 <5424472E.4060300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYQ5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 12:57:45 -0400
Content-Disposition: inline
In-Reply-To: <5424472E.4060300@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

On Thu, Sep 25, 2014 at 11:47:42AM -0500, Brian King wrote:
> The issue we've run into started when this patch started making its
> way into distros:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/scsi_error.c?id=14216561e164671ce147458653b1fea06a4ada1e
> 
> That changed the behaviour for user initiated TUR commands. After an ipr
> adapter gets reset, all disk array devices require a start unit command
> to be issued to them before they will accept commands. So, with the SCSI
> EH change, we now end up in a scenario with dual ipr adapters where the
> TUR getting issued from the health checker returns with a Not Ready response
> and since SCSI EH no longer triggers the Start Unit in this scenario,
> the path never recovers.
> 
> The alternative solution would be to change the TUR path checker in multipath-tools
> to issue a Start Unit if it sees a 02/04/02.

Or we could fix up the check introduced by the commit, with something
ala:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a2c3d3d..7228d9e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -459,13 +459,18 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+	if (scmd->cmnd[0] == TEST_UNIT_READY &&
+	    scmd->request->cmd_type == REQ_TYPE_FS &&
+	    scmd->scsi_done != scsi_eh_done) {
 		/*
 		 * nasty: for mid-layer issued TURs, we need to return the
 		 * actual sense data without any recovery attempt.  For eh
-		 * issued ones, we need to try to recover and interpret
+		 * issued ones, we need to try to recover and interpret,
+		 * and for pass through TURs we just need to stay out of the
+		 * way, so that the device handlers can do the right thing.
 		 */
 		return SUCCESS;
+	}
 
 	scsi_report_sense(sdev, &sshdr);
 

> 
> Thanks,
> 
> Brian
> 
> -- 
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
---end quoted text---
