From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 14 Mar 2004 09:59:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079276396.2022.8.camel@mulgrave>
References: <20040314082444.GA3416@linux.local.home>
	<1079275768.2022.1.camel@mulgrave>  <20040314145142.GL6955@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39568 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263373AbUCNPAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:00:10 -0500
In-Reply-To: <20040314145142.GL6955@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-03-14 at 09:51, Jens Axboe wrote:
> The explanation of why this was done (request queue limitations, huh?)
> sounded pretty bogus as well.

Actually, to be fair, I think he means the qlogic request queue, not the
block one.

The Qla chips are rather weird in that they have a single issue queue
(whose size you can vary) but whose entry formats are fixed.  If I
remember correctly, an initial command can have 4 SG elements, but a
follow on entry can have 7 (not sure of the figures).  But anyway, large
SG commands end up having to find multiple entries in this queue (and
being a single issue queue for the entire card, it has to be mutexed
while you search).  The more resources you need, the more difficult the
search and the more contention you generate on the resource mutex.

I talked to Arjan a bit about this type of card and how best to handle
it in our current infrastructure, but I haven't got any further than
thinking about it.

James


