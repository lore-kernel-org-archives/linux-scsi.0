From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Tue, 20 Sep 2005 15:20:30 -0500
Message-ID: <1127247630.5589.30.camel@mulgrave>
References: <1126845599.9276.44.camel@max>
	 <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
	 <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
	 <1126974325.10413.5.camel@max>
	 <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
	 <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>
	 <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
	 <1127061365.800.1.camel@max> <432D97F2.5040508@cs.wisc.edu>
	 <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
	 <432D9D53.3070706@cs.wisc.edu>
	 <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>
	 <432F100D.7050007@cs.wisc.edu>
	 <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7869 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964783AbVITUUk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:20:40 -0400
In-Reply-To: <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-09-20 at 22:23 +0300, Kai Makisara wrote:
> > Yeah I think this is due to the MAX_PHYS_SEGMENTS limit. The hw segments is
> > set by scsi_lib in scsi_alloc_queue and is the sg_tablesize value on the host.
> > Right now all I do is return a error when someone violates one of the limits,
> > but I think the right thing to do is have the ULDs take some of these values
> > into account when they build their lists. However if I do that we will not be
> > able to make large requests since the MAX_PHYS_SEGMENTS/SCSI_MAX_PHYS_SEGMENTS
> > will limit them. Umm let me rethink.

There's already the code in SCSI to increase this to 256 (and
potentially beyond) if it becomes necessary.

> I have done some additional debugging. Submitting the large write fails in 
> bio_map_pages() called from scsi_req_map_sg(). The first reason is not 
> phys_segments or hw_segments limit but max_sectors. The sym53c8xx_2 uses 
> the default SCSI_DEFAULT_MAX_SECTORS which is 1024 (512 kB).
> 
> I increased max_sectors in sym_glue.c to 10240 in sym53c8xx and now I can 
> write blocks up to 1024 kB. Then bio_map_page() fails again but this time 
> in bio_alloc(). This is because st can allocate chunks of more than 1 MB 
> and this is too much for one bio. I added the code in the patch at the end 
> of this message to limit the chunk size and this allowed writing of blocks 
> up to 5120 kB.
> 
> If I try 5121 kB, write fails as is expected but not completely nicely. 
> Here are some test printks:
> 
> scsi_req_map_sg: q->back_merge failed, i=10
> st 1:0:5:0: extraneous data discarded.
> st 1:0:5:0: COMMAND FAILED (87 0 1).
> sym: cmd: 0x0a 0x00 0x50 0x04 0x00 0x00
> st: cmd=0x0a result=0x70000 resid=0 sense[0]=0x00 sense[2]=0x00
> 
> scsi_req_map_sg fails as it should but still a bogus SCSI command is sent. 
> I think the reason for this is simple but I don't want to delay the good 
> news by trying to debug this.
> 
> So, now st can write as large blocks as it should. Good work, Mike!
> 
> What I don't quite like is that being able to do this requires setting 
> SCSI adapter parameters (use_clustering, max_sectors) to values that are 
> not used by most drivers today. Changing is in most cases trivial but this 
> has to be done. Otherwise the users needing large block sizes feel that 
> these enhancements are a regression.

OK, but this is troubling either way:  Previously the LLD was simply
lying about its ability to support more sectors and clustering and you
called its bluff by sending such commands.  Now the bio layer is
actually enforcing these limits.

The fix has got to be to update the LLDs so they're reporting their
capabilities truthfully.

James


