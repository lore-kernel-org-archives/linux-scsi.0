From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical
	address >16Mb used for aha1542" at boot time
Date: 23 Feb 2004 11:34:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077557656.1759.58.camel@mulgrave>
References: <20040218171212.0eb6618a.akpm@osdl.org>
	<1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia>
	<20040220083808.GA11822@suse.de> <1077300620.1937.11.camel@mulgrave>
	<20040223164811.GK32010@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:5085 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261972AbUBWReX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 12:34:23 -0500
In-Reply-To: <20040223164811.GK32010@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-02-23 at 10:48, Jens Axboe wrote:
> Something half-assed like this should work as an immediate fix...

But I don't see how this bounces the buffer?  Without a bio, this simply
passes req->data (which is cgc->buffer) into cmd->request_buffer in
scsi_init_io(); but the problem was that this buffer is outside the
dma_mask.


James


