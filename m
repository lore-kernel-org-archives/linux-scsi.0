From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: 21 Nov 2003 08:12:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069423949.1826.10.camel@mulgrave>
References: <20031120085555.A20609@beaverton.ibm.com>
	<20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de>
	<20031120135123.A2366@beaverton.ibm.com>  <20031121101728.GI1106@suse.de>
	<1069418912.1931.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:55300 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264351AbTKUONu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 09:13:50 -0500
In-Reply-To: <1069418912.1931.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-11-21 at 06:48, James Bottomley wrote:
> So the code to add the hints is in the works?

To be more specific:

I think we need to divide the error types up into

1. retryable
2. fatal

and to have at least two, possibly three sources

1. the transport
2. the device
(3. the driver)

so a medium error (say a read failure) is a fatal device error;
something like a no connect would be a fatal transport error, etc.

QUEUE_FULL is a retryable transport error under these terms, but we
might add a third category, flow control, to the error types which it
would more properly fall under.

the entity setting REQ_FASTFAIL should be able to indicate what type of
errors it is interested in (allowing others to be handled
automatically).

James




