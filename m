From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 16:53:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107165347.A9371@lst.de>
References: <hch@lst.de> <200211071550.gA7Fo9p03079@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071550.gA7Fo9p03079@localhost.localdomain>; from James.Bottomley@steeleye.com on Thu, Nov 07, 2002 at 10:50:08AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, "Adam J. Richter" <adam@yggdrasil.com>, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 10:50:08AM -0500, J.E.J. Bottomley wrote:
> There are other nasties waiting in the pipeline.  The one that's been 
> bothering me is the SCSI3 Controller Commands (for arrays and the like).  This 
> basically adds array controller information to a standard direct-access 
> device, but crucially, it has two different (and incompatible with 
> direct-access) ways of addressing the array: physical-by real disk and 
> logical-by the actual RAID-n unit.
> 
> Most of the time a SCC device is an sd device but with a translation in the 
> addressing mode.  It makes sense that SCC would somehow filter the sd 
> attachment and add a special scc device type just for the controlling node.
> 
> By the way, we already have this in the tree: the compaq cpqfc driver does on 
> the fly translation for SCC devices into SD at the low level (that's for the 
> RA4100 array).

I think that's another reason why we want the one upper layer per
device model.  That way the SCC driver (it could be part of the sd
module if they share enough code or a different one) would register the
SCC device so sd can't grab them anymore.  This just requires that
module to be linked in earlier (another good reasons why the two templates
should be in the same module - this way we can guarantee that ordering)

