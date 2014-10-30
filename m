From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Thu, 30 Oct 2014 08:19:55 -0700
Message-ID: <20141030151955.GA12158@infradead.org>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
 <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
 <545102FE.3010003@kernel.dk>
 <20141029183828.GA31689@infradead.org>
 <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee>
 <54514A7A.8050008@kernel.dk>
 <alpine.LRH.2.11.1410301317340.19899@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760387AbaJ3PT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 11:19:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410301317340.19899@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Meelis,

can you try the patch below?  It's a hack and not a proper fix, but it
addresses what seems to be your culprit, given that it is the only
place allocating a request from the error handler.


diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fa7b5ec..5804ea0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2010,6 +2010,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	struct scsi_device *sdev;
 	unsigned long flags;
 
+#if 0
 	/*
 	 * If the door was locked, we need to insert a door lock request
 	 * onto the head of the SCSI request queue for the device.  There
@@ -2019,6 +2020,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 		if (scsi_device_online(sdev) && sdev->locked)
 			scsi_eh_lock_door(sdev);
 	}
+#endif
 
 	/*
 	 * next free up anything directly waiting upon the host.  this
