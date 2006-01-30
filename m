From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH, RFC] st: start using scsi_execute
Date: Mon, 30 Jan 2006 23:19:38 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601302308001.4212@kai.makisara.local>
References: <20060130182324.GA6253@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:38347 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S964996AbWA3VRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 16:17:24 -0500
In-Reply-To: <20060130182324.GA6253@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 30 Jan 2006, Christoph Hellwig wrote:

> This patch updates st to use scsi_execute instead of scsi_execute_async
> for all scsi commands except the main I/O path.  The advantage is that
> these helpers do all the request tracking for these synchronous I/Os so
> that there is no need for st_request structures.  It also decouples
> these helper scsi commands from the main tape buffer, allowing for an
> easier switchover to the generic block request mapping routines for the
> main I/O path later on.
> 
I think the main tape buffer will stay for quite a long time. Using it has 
the advantage that it is allocated using GFP_DMA if necessary. This is not 
a problem if scsi_execute does bouncing somewhere if it needs to be done.

Overall the conversion looks good. The problem with these conversions is 
to get all the small details correct as you note next :-)

> Note that I don't have a scsi tape, so this is totally untested and
> probably needs some tweaking before it's ready..
> 
It needs some tweaking. I started testing and it failed open with these 
messages in syslog:

st 0:0:5:0: extraneous data discarded.
st 0:0:5:0: COMMAND FAILED (87 0 1).
st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
st 0:0:5:0: extraneous data discarded.
st 0:0:5:0: COMMAND FAILED (87 0 1).
st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).

Next I tried to enable debugging but the driver did not compile. Now I am 
running out of time but I will continue later.

-- 
Kai
