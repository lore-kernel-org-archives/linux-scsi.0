From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 07 Nov 2002 10:50:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071550.gA7Fo9p03079@localhost.localdomain>
References: <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA24964
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 07:50:13 -0800
In-Reply-To: Message from Christoph Hellwig <hch@lst.de>
   of "Thu, 07 Nov 2002 16:39:54 +0100." <20021107163954.B9189@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Anderson <andmike@us.ibm.com>, "Adam J. Richter" <adam@yggdrasil.com>, linux-scsi@vger.kernel.org

hch@lst.de said:
> Yupp, IMHO we should move to a better interpretation of the driver
> model.  But the question how do we solve the sg issue.  There are two
> ways I could imagine:

There are other nasties waiting in the pipeline.  The one that's been 
bothering me is the SCSI3 Controller Commands (for arrays and the like).  This 
basically adds array controller information to a standard direct-access 
device, but crucially, it has two different (and incompatible with 
direct-access) ways of addressing the array: physical-by real disk and 
logical-by the actual RAID-n unit.

Most of the time a SCC device is an sd device but with a translation in the 
addressing mode.  It makes sense that SCC would somehow filter the sd 
attachment and add a special scc device type just for the controlling node.

By the way, we already have this in the tree: the compaq cpqfc driver does on 
the fly translation for SCC devices into SD at the low level (that's for the 
RA4100 array).

James


