From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/7] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 16 May 2008 22:18:31 +0200
Message-ID: <20080516201830.GB16538@kernel.dk>
References: <20080514144319.543D910B5DF@craiglockhart-ipmi.suse.de> <1210819780.21974.264.camel@chandra-ubuntu> <482BF09E.2070905@suse.de> <1210963077.21974.334.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23423 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbYEPUSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2008 16:18:39 -0400
Content-Disposition: inline
In-Reply-To: <1210963077.21974.334.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

On Fri, May 16 2008, Chandra Seetharaman wrote:
> It is a question to Jens :) 
> 
> On Thu, 2008-05-15 at 10:13 +0200, Hannes Reinecke wrote:
> > Chandra Seetharaman wrote:
> > > I do not know the functionality of this module. So, my comments are only
> > > related to code.
> > > 
> > > blk_request_rq() frees up the request before it returns (in
> > > blk_end_sync_rq()). So, there is no need for blk_put_request().
> > > 
> > Indeed. But this opens up another question:
> > 
> > By the time blk_execute_rq() returns, the request is already
> > put back onto the queue.
> > That means that I shouldn't access rq->errors any more, as
> > the request might have been reused already.
> > But blk_execute_rq() returns -EIO for any error, making it
> > impossible to signal a proper error here.
> > So how do I get the contents of rq->errors safely?
> > 
> > Cheers,
> > 
> > Hannes

blk_get_request() and blk_put_request() when done. See how
block/scsi_ioctl.c:sg_io() does just that.

-- 
Jens Axboe

