From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 06 Nov 2002 13:50:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211061850.gA6Io0003502@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA12999
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 10:50:04 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Wed, 06 Nov 2002 10:39:20 PST." <20021106103920.A12204@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> That is what we had before, but then there is no warning that the
> queue depth is at 1, and the only way to make sure it is right is to
> audit the drivers. 

I'm OK with that, since the drivers can be audited as they're moved over to 
slave attach.  It also works for drivers that use older hardware (like the 
53c700) which don't call adjust_queue_depth from slave attach, but slightly 
later on when they've really verified the device will accept tags.  In this 
case, I don't want the mid layer to call adjust_queue_depth for me even if I 
leave slave_attach with only one command allocated.

The bottom line is that if a driver supplies a slave_attach routine, tag setup 
is entirely under its control and the mid-layer won't try to second guess it 
if it doesn't set them up correctly.

James


