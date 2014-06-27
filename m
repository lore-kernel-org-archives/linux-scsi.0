From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Fri, 27 Jun 2014 00:53:30 -0700
Message-ID: <20140627075330.GA21799@infradead.org>
References: <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
 <20140611133736.GA12240@infradead.org>
 <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
 <20140625131344.GA13094@infradead.org>
 <1403791367.3572.1.camel@dabdike>
 <20140626150055.GB11199@infradead.org>
 <1403795096.3572.8.camel@dabdike>
 <20140626150832.GA31800@infradead.org>
 <1403808776.6440.14.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaF0Hxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:53:31 -0400
Content-Disposition: inline
In-Reply-To: <1403808776.6440.14.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, Jun 26, 2014 at 02:52:56PM -0400, James Bottomley wrote:
> OK, I give up, what memory leak (you don't actually mention it in your
> emails)?  All memory handling is correctly done in unprep as far as I
> can tell.

To quote my earlier mail:

>  - scsi_unprep_fn: calls ->uninit_command only for !PC request,
>	so your patch introduces a leak for discard requests

This list both very clearly what we leak and why.  Before 3.16 we'd
indeed call sd_unprep_fn for every kind of request, but we're
fortunately back to my old model from 10 years ago where BLOCK_PC
driver stay entirely away from the ULD as they should.

