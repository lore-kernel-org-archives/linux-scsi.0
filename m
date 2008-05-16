From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/7] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 16 May 2008 11:37:57 -0700
Message-ID: <1210963077.21974.334.camel@chandra-ubuntu>
References: <20080514144319.543D910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819780.21974.264.camel@chandra-ubuntu>  <482BF09E.2070905@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44109 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbYEPSgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2008 14:36:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4GIaAVW026234
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:36:10 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4GIaAFr134962
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:36:10 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4GIa9Et010406
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:36:10 -0400
In-Reply-To: <482BF09E.2070905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "jens.axboe" <jens.axboe@oracle.com>

It is a question to Jens :) 

On Thu, 2008-05-15 at 10:13 +0200, Hannes Reinecke wrote:
> Chandra Seetharaman wrote:
> > I do not know the functionality of this module. So, my comments are only
> > related to code.
> > 
> > blk_request_rq() frees up the request before it returns (in
> > blk_end_sync_rq()). So, there is no need for blk_put_request().
> > 
> Indeed. But this opens up another question:
> 
> By the time blk_execute_rq() returns, the request is already
> put back onto the queue.
> That means that I shouldn't access rq->errors any more, as
> the request might have been reused already.
> But blk_execute_rq() returns -EIO for any error, making it
> impossible to signal a proper error here.
> So how do I get the contents of rq->errors safely?
> 
> Cheers,
> 
> Hannes

