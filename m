From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape block size
Date: Thu, 28 Sep 2006 22:47:00 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
References: <200609241605.32327.johna@onevista.com>
 <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:54354 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1161041AbWI1TrD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 15:47:03 -0400
In-Reply-To: <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 27 Sep 2006, Guennadi Liakhovetski wrote:

> Hi all
> 
> I've got a problem report and a patch from John Adams, he says tmscsim 
> driver under 2.6.17 and on doesn't allow him to read tapes with blocksize 
> of 1MB. He fixes this with the below patch.
> 
> On Sun, 24 Sep 2006, John Adams wrote:
> 
> > --- drivers/scsi/tmscsim.c.bak	2006-09-24 12:55:08.000000000 -0400
> > +++ drivers/scsi/tmscsim.c	2006-09-24 12:55:56.000000000 -0400
> > @@ -2300,7 +2300,8 @@
> >  	.this_id		= 7,
> >  	.sg_tablesize		= SG_ALL,
> >  	.cmd_per_lun		= 1,
> > -	.use_clustering		= DISABLE_CLUSTERING,
> > +	.use_clustering		= ENABLE_CLUSTERING,
> > +	.max_sectors            = 2048,
> >  };
> >  
> >  /***********************************************************************
> 
> It looks like
> 
> 1) use_clustering doesn't directly affect maximum block size, so, he 
> doesn't really need it, although, it might make sense for tmscsim to 
> improve performance.
> 
> 2) max_sectors is indeed what he needs, but it looks strange that now it 
> has to be set by the low-level driver... For block devices you can set it 
> at run time with /sys/block/sda/queue/max_sectors_kb, right? But what 
> about tapes?
> 
Both 1 and 2 are needed for 1 MB block size. max_sectors_kb for tapes is 
not visible in /sys.

> Sorry, didn't find too much documentation about it.
> 
The limits come from the block subsystem that all scsi devices use 
nowadays. It is a rather long story but can be found from linux-scsi 
archives, e.g.,
http://marc.theaimsgroup.com/?l=linux-scsi&m=114147170831847&w=2

-- 
Kai
