From: Jens Axboe <axboe@suse.de>
Subject: Re: [patch 2/4] ibmvscsi.c: limit size of I/O requests
Date: Thu, 2 Dec 2004 21:13:11 +0100
Message-ID: <20041202201310.GC26695@suse.de>
References: <20041129203107.GB31011@cs.umn.edu> <20041130075457.GD10450@suse.de> <20041130152916.GA7639@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:33164 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261750AbULBUNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2004 15:13:13 -0500
Content-Disposition: inline
In-Reply-To: <20041130152916.GA7639@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sleddog@us.ibm.com

On Tue, Nov 30 2004, Dave C Boutcher wrote:
> On Tue, Nov 30, 2004 at 08:54:58AM +0100, Jens Axboe wrote:
> > On Mon, Nov 29 2004, Dave C Boutcher wrote:
> > > Description: Limit the size of I/O requests sent by the 
> > > ibmvscsi adapter.  With better I/O scheduling (and thus larger
> > > requests) we were breaking some servers.
> > 
> > Nack, why can't you use /dev/block/xxx/queue/max_sectors_kb to control
> > this?
> 
> The basic function of this patch is to set host->max_sectors based
> on information from the SCSI target.
> 
> There is a default value because two of the existing target implementations
> (there are three) don't set the value.
> 
> I confess to making the default value a module parameter because I
> took a SWAG at the correct value.  I COULD remove the module
> parameter part of this patch, though if someone actually cares enough
> about performance to tweak it, modprobe.conf seems like a nice place to
> set it.

I think it's much better to set host->max_sectors to a sane high value,
then change it per-target if you need to. This is how other SCSI host
adapters work, what makes ibmvscsi different?

-- 
Jens Axboe

