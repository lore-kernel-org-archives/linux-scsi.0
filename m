From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] usb-storage: do not increment cmd->serial_number
Date: Mon, 4 Apr 2011 09:42:22 -0400
Message-ID: <20110404134221.GB32522@infradead.org>
References: <20110404134203.GA29525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1DDNmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 09:42:22 -0400
Content-Disposition: inline
In-Reply-To: <20110404134203.GA29525@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

The isd200 sub-driver increments the command serial number despite not
using it at all in it's routine for sending internal scsi commands.
Remove the increment to prepare for removing the serial_number field.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/usb/storage/isd200.c
===================================================================
--- linux-2.6.orig/drivers/usb/storage/isd200.c	2011-04-02 07:34:20.983235059 -0700
+++ linux-2.6/drivers/usb/storage/isd200.c	2011-04-02 07:34:27.907237105 -0700
@@ -499,7 +499,6 @@ static int isd200_action( struct us_data
 	memset(&ata, 0, sizeof(ata));
 	srb->cmnd = info->cmnd;
 	srb->device = &srb_dev;
-	++srb->serial_number;
 
 	ata.generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 	ata.generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
