From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Mon, 22 Oct 2007 23:30:52 -0700
Message-ID: <20071023063052.GA17726@us.ibm.com>
References: <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk> <1191945372.3294.28.camel@localhost.localdomain> <20071010122508.GL4984@kernel.dk> <20071011180108.GA15357@us.ibm.com> <20071011182430.GC22606@kernel.dk> <20071011183319.GD22606@kernel.dk> <20071023014534.GA16702@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbXJWGaz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 02:30:55 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9N6Uso6003101
	for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 02:30:54 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9N6UsPh119238
	for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 00:30:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9N6UroR008355
	for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 00:30:54 -0600
Content-Disposition: inline
In-Reply-To: <20071023014534.GA16702@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

malahal@us.ibm.com [malahal@us.ibm.com] wrote:
> Jens Axboe [jens.axboe@oracle.com] wrote:
> > Current code is below, btw. Not a lot of changes, iirc it's just the
> > delete-always, a missing export, delete timer on empty list.
> > 
> > +void blk_add_timer(struct request *req)
> > +{
> > +	struct request_queue *q = req->q;
> > +	unsigned long expiry;
> > +
> > +	BUG_ON(!list_empty(&req->timeout_list));
> > +
> > +	if (req->timeout)
> > +		req->timeout += jiffies;
> > +	else
> > +		req->timeout = jiffies + q->rq_timeout;
> > +
> 
> The meaning of req->timeout is changed here. It was a timeout value, now
> it became an expiry time. If we happen to requeue the request, its
> timeout would be incorrect. Found using scsi_debug! Maybe, make it a
> bitfield to avoid another field...

Sorry, bitfield won't work!
