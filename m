From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 06 Jun 2003 19:43:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054943015.1777.67.camel@mulgrave>
References: <1054742495.1674.18.camel@mulgrave>
	<20030604165146.GA1426@beaverton.ibm.com>
	<1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org>
	<3EE0B316.4060207@rogers.com> <1054913984.1778.31.camel@mulgrave>
	<3EE0B8D8.4020909@rogers.com> <20030606215152.B3240@infradead.org>
	<3EE12371.90403@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:18692 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262363AbTFFXaq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 19:30:46 -0400
In-Reply-To: <3EE12371.90403@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 2003-06-06 at 19:27, Luben Tuikov wrote:
> *If* eh is to be done in SCSI Core you just cannot avoid it --
> this is *the whole point* which James had in mind to allow
> to send cmnds if !online. (see prev msgs on this thread)

Actually, I didn't.  Error handling has its own separate entry into
->queuecommand() (scsi_send_eh_cmnd()), so it wouldn't be affected by my
changes.

My purpose is quite simple: Any normal block actions (read/write from
mounted fs, or CD burning via SG_IO) would be errored.  Any special
commands (from ioctls, direct commands or stack generated) would not be
affected.

i.e.

REQ_CMD	errors
REQ_BLOCK_PC errors
REQ_SPECIAL is allowed

James


