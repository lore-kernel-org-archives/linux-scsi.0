From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] serialize bus scanning
Date: Wed, 27 Aug 2003 22:35:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030827203544.GA27020@lst.de>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24771 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262312AbTH0Ufu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 16:35:50 -0400
Content-Disposition: inline
In-Reply-To: <20030827202908.GB7852@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Thu, Aug 28, 2003 at 06:29:08AM +1000, Anton Blanchard wrote:
> 
> Hi,
> 
> > Synchronize all scanning activity, this fixes long-standing races
> > vs /proc/scsi/scsi and sysfs addition and deletion of devices.
> > 
> > Note that this does not serialize removing, the lists will get
> > their own locking soon.
> 
> Ive started playing with parallel probe in the lab (on some large ppc64
> boxes). I know we have a lot of work to do before this will all work,
> but would it be possible to make this semaphore per host?

you can just add a per-host mutex and lock it in the same places as
indicated by the comment in the patch.  

> Even with a per host semaphore, it annoys me how long it takes to spin
> up 7 disks especially if a few of them are dead. Longer term are we
> planning to overlap spinup of disks on the same host?

I have no plans to do that but if someone comes up with a proper
patch that would be nice.

