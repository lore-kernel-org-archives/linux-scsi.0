From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 06 Nov 2002 12:15:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211061715.gA6HFNd03054@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA21285
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 09:15:28 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Tue, 05 Nov 2002 20:24:17 PST." <20021105202417.A26520@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

In this block:

+int scsi_slave_attach(struct scsi_device *sdev)
+{
+	if (sdev->attached++ == 0) {
+		/*
+		 * No one was attached.
+		 */
+		if ((sdev->host->hostt->slave_attach != NULL) &&
+		    (sdev->host->hostt->slave_attach(sdev) != 0)) {
+			printk(KERN_INFO "scsi: failed low level driver"
+			       " attach, some SCSI device might not be"
+			       " configured\n");
+			return 1;
+		}
+		if ((sdev->new_queue_depth == 0) &&
+		    (sdev->host->cmd_per_lun != 0))
+			scsi_adjust_queue_depth(sdev, 0,
+						sdev->host->cmd_per_lun);
+		scsi_build_commandblocks(sdev);

I've a marginal preference for calling scsi_build_commandblocks first, so we 
have a single command block going into the slave_attach (remember the adjust 
queue depth stuff is deferred building of command blocks).  That way, we can 
error out if the current_queue_depth is still zero without having to do a 
slave detach.

Other than that, this patch looks like an excellent solution.  Thanks!

James


