From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] serialize bus scanning
Date: Mon, 15 Sep 2003 10:10:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915101004.B25024@infradead.org>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme> <20030827203544.GA27020@lst.de> <20030910075741.GC1532@krispykreme> <20030911133419.A10316@beaverton.ibm.com> <20030915071305.GA820@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:41481 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261595AbTIOJKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 05:10:12 -0400
Content-Disposition: inline
In-Reply-To: <20030915071305.GA820@krispykreme>; from anton@samba.org on Mon, Sep 15, 2003 at 05:13:05PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, Sep 15, 2003 at 05:13:05PM +1000, Anton Blanchard wrote:
> 
> Hi Pat,
> 
> > The patch looks fine to me, I hope James will apply it.
> 
> Good to see someone else does parallel scan :)

Looks fine to me aswell.  Not that I have a machine with more than
one real HBA :)

> Speaking of races... Ive been tripping one when parallel probing.
> I hit a poisoned list pointer in scsi_run_host_queues, which is being
> called out of the error handler thread. (Ive got a few scsi buses in this
> machine full of bad disks)
> 
> I havent had a chance to look into it but Im guessing we are racing with
> someone calling scsi_free_sdev. Im not sure how we should be protecting
> ->siblings but it looks like we have to do something.

->siblings needs protection.  I've been working for this for a long time
and should have a final patchkit soon.

