From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/7] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 16 May 2008 17:29:06 -0700
Message-ID: <1210984146.21974.364.camel@chandra-ubuntu>
References: <20080514144319.543D910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819780.21974.264.camel@chandra-ubuntu> <482BF09E.2070905@suse.de>
	 <1210963077.21974.334.camel@chandra-ubuntu>
	 <20080516201830.GB16538@kernel.dk>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53426 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYEQA1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2008 20:27:22 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4H0RIef027725
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 20:27:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4H0RIwJ101488
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 20:27:18 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4H0RHIv009213
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 20:27:18 -0400
In-Reply-To: <20080516201830.GB16538@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>


On Fri, 2008-05-16 at 22:18 +0200, Jens Axboe wrote:
> On Fri, May 16 2008, Chandra Seetharaman wrote:
> > It is a question to Jens :) 
> > 
> > On Thu, 2008-05-15 at 10:13 +0200, Hannes Reinecke wrote:
> > > Chandra Seetharaman wrote:
> > > > I do not know the functionality of this module. So, my comments are only
> > > > related to code.
> > > > 
> > > > blk_request_rq() frees up the request before it returns (in
> > > > blk_end_sync_rq()). So, there is no need for blk_put_request().

My bad...

After Jens's comment, looked closely at blk_execute_rq() and
blk_end_sync_rq() and realized that there is an additional reference
acquired by blk_execute_rq() which is dropped later.

> > > > 
> > > Indeed. But this opens up another question:
> > > 
> > > By the time blk_execute_rq() returns, the request is already
> > > put back onto the queue.
> > > That means that I shouldn't access rq->errors any more, as
> > > the request might have been reused already.
> > > But blk_execute_rq() returns -EIO for any error, making it
> > > impossible to signal a proper error here.
> > > So how do I get the contents of rq->errors safely?
> > > 
> > > Cheers,
> > > 
> > > Hannes
> 
> blk_get_request() and blk_put_request() when done. See how
> block/scsi_ioctl.c:sg_io() does just that.
> 

