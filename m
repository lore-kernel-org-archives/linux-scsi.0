From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding commands
Date: Tue, 1 Oct 2002 08:01:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021001080115.A27028@eng2.beaverton.ibm.com>
References: <andmike@us.ibm.com> <200210010038.g910cnB31623@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210010038.g910cnB31623@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Sep 30, 2002 at 08:38:49PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 30, 2002 at 08:38:49PM -0400, James Bottomley wrote:
> andmike@us.ibm.com said:
> > Are we guaranteed that blk_run_queues will be called for all types of
> > I/O? 
> 
> Pretty much, it looks like.  It's mainly triggered by I/O stuff in fs, 
> including the buffer functions, so I think the assumption that we will be 
> called eventually is good.
> 
> James

What about applications and devices that only send one IO at a time?
They could still hang.

We have: tape (st or osst), sg usage, partitioning, scanning, direct
use of the block device (i.e. dd if=/dev/sda), and probably others.

-- Patrick Mansfield
