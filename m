From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Sun, 23 Nov 2003 00:00:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031122230015.GA2366@win.tue.nl>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de> <20031120135123.A2366@beaverton.ibm.com> <20031121101728.GI1106@suse.de> <1069418912.1931.5.camel@mulgrave> <1069423949.1826.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:1553 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S262787AbTKVXAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 18:00:24 -0500
Content-Disposition: inline
In-Reply-To: <1069423949.1826.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 21, 2003 at 08:12:29AM -0600, James Bottomley wrote:

> To be more specific:
> 
> I think we need to divide the error types up into
> 
> 1. retryable
> 2. fatal
> 
> and to have at least two, possibly three sources
> 
> 1. the transport
> 2. the device
> (3. the driver)
> 
> so a medium error (say a read failure) is a fatal device error;
> something like a no connect would be a fatal transport error, etc.

Yes, the driver is a legitimate source of errors.

If the driver knows that a certain command is not supported
and returns an error condition, then retrying is meaningless.
The error is not necessarily fatal in the sense that the device
does not work, it works just fine, but this particular command
will never get any other reply.

It also happens that the driver needs to allocate memory for
some command. If the allocation fails, that may be a retryable
condition, but immediately retrying is counterproductive.

Andries

