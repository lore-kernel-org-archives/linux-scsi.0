From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 13:42:04 -0600
Message-ID: <1201808524.3131.46.camel@localhost.localdomain>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
	 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
	 <1201793647.3131.8.camel@localhost.localdomain>
	 <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
	 <1201796764.3131.15.camel@localhost.localdomain>
	 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
	 <1201802031.3131.29.camel@localhost.localdomain>
	 <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39016 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760017AbYAaTmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:42:12 -0500
In-Reply-To: <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2008-01-31 at 10:44 -0800, Nicholas A. Bellinger wrote:
> > In short, and to repeat: almost every internal size counter to block is
> > in units of 512 byte sectors ... that includes capacity, maximum etc ...
> > 
> 
> Ok, after reading your followup with Geert I see that this looks like a
> bug in ps3rom.c assuming 2048 byte sectors to calculate .max_sectors
> (which was originally set to 32 as I mentioned).  Using the setting
> BOUNCE_SIZE << 9 where BOUNCE_SIZE is the request size in bytes looks
> like this will solve the issue.  My misunderstanding was
> that .max_sectors was allowed to be calcuated in non 512 byte sectors,
> so please disregard my patch.
> 
> Geert, .max_sectors for ps3rom.c using 512 byte sectors ends up being
> 128, yes.?
> 
> James, could we put something in the SCSI docs stating that .max_sectors
> MUST be calculated against 512 byte sectors..?

If that "we" is royal, then certainly you're welcome to submit a patch
(just get Randy's ack).  However, do take a look at the existing docs
first.  Certainly the block layer seems to make this very clear:

/**
 * blk_queue_max_sectors - set max sectors for a request for this queue
 * @q:  the request queue for the device
 * @max_sectors:  max sectors in the usual 512b unit
                              ^^^^^^^^^^^^^^^^^^^^^^
 *
 * Description:
 *    Enables a low level driver to set an upper limit on the size of
 *    received requests.
 **/

I suspect you just didn't read the docs anyway ... ?

James


