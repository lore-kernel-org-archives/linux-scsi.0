From: Jens Axboe <axboe@suse.de>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Sun, 14 Mar 2004 16:15:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314151527.GM6955@suse.de>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de> <1079276396.2022.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:50916 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261980AbUCNPQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:16:09 -0500
Content-Disposition: inline
In-Reply-To: <1079276396.2022.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Mar 14 2004, James Bottomley wrote:
> On Sun, 2004-03-14 at 09:51, Jens Axboe wrote:
> > The explanation of why this was done (request queue limitations, huh?)
> > sounded pretty bogus as well.
> 
> Actually, to be fair, I think he means the qlogic request queue, not the
> block one.
> 
> The Qla chips are rather weird in that they have a single issue queue
> (whose size you can vary) but whose entry formats are fixed.  If I
> remember correctly, an initial command can have 4 SG elements, but a
> follow on entry can have 7 (not sure of the figures).  But anyway, large
> SG commands end up having to find multiple entries in this queue (and
> being a single issue queue for the entire card, it has to be mutexed
> while you search).  The more resources you need, the more difficult the
> search and the more contention you generate on the resource mutex.

Ah, makes a lot more sense now, thanks :-)

-- 
Jens Axboe

