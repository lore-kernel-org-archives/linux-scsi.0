From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 1/1] multipath-tools: Change path checker for
 IBM IPR devices
Date: Wed, 1 Oct 2014 05:51:34 -0700
Message-ID: <20141001125134.GB31067@infradead.org>
References: <20140924195721.148637349@linux.vnet.ibm.com>
 <20140924195752.289011902@linux.vnet.ibm.com>
 <5423B664.2020007@suse.de>
 <5424472E.4060300@linux.vnet.ibm.com>
 <20140925165743.GA20621@infradead.org>
 <20140930140547.Horde.m7EONeG2u3AJYXxG2TLrmQ3@ltc.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaJAMvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:51:37 -0400
Content-Disposition: inline
In-Reply-To: <20140930140547.Horde.m7EONeG2u3AJYXxG2TLrmQ3@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Brian King <brking@linux.vnet.ibm.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Unfortunately the patch wasn't quite correct - all TEST_UNIT_READY
commands are sent as BLOCK_PC, so this would basically revert James'
original fix for the SATL case.

Am I right to assume you only need the call to scsi_dh->check_sense and
not the rest of the handling for the multipath path checker?  If that's
the case something like the patch below sould work:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5db8454..399c1c8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -459,14 +459,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
-		/*
-		 * nasty: for mid-layer issued TURs, we need to return the
-		 * actual sense data without any recovery attempt.  For eh
-		 * issued ones, we need to try to recover and interpret
-		 */
-		return SUCCESS;
-
 	scsi_report_sense(sdev, &sshdr);
 
 	if (scsi_sense_is_deferred(&sshdr))
@@ -482,6 +474,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		/* handler does not care. Drop down to default handling */
 	}
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
