From: Brian King <brking@linux.vnet.ibm.com>
Subject: ipr SATA problems in 2.6.20
Date: Tue, 16 Jan 2007 16:24:45 -0600
Message-ID: <45AD50AD.2040700@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53236 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbXAPWYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jan 2007 17:24:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jeff Garzik <jgarzik@pobox.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

I'm currently debugging some problems with SATA on ipr and figured I would
give a heads up. The problems include overlength errors and data corruption.
Basically SATA on ipr is completely broken in its current state.
>From what I have found so far, it looks like due to some libata changes
made recently, qc->nbytes is no longer getting setup for ATAPI devices
all the time.

Jeff - should qc->nbytes be used a libata user? If not, what is the proper
way to determine the total command length in bytes? Summing all the sg entries?
I was using nbytes + pad_len.

The other oddity I've been seeing is that I am getting zero length commands,
such as TEST_UNIT_READY with a dma_dir of DMA_FROM_DEVICE. Shouldn't this be
DMA_NONE? I'm still tracking this down.


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
