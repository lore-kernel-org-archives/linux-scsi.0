From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 06 Nov 2002 13:32:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211061832.gA6IWgb03420@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA05512
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 10:32:46 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Wed, 06 Nov 2002 10:24:44 PST." <20021106102444.A11790@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> The only problem is that scsi_build_commandblocks() sets sdev->
> new_queue_depth  to 1, so if the slave_attach() does not set queue
> depth, we will leave it at 1, and the post-slave_attach call to
> scsi_adjust_queue_depth can never be hit.

OK, missed that.  What about just conditioning the call to 
scsi_adjust_queue_depth to be if you don't have a slave attach call.  The 
expectation would be that if you do have a slave_attach then the queue depth 
stays one until something is done about it by the LLD?

James



