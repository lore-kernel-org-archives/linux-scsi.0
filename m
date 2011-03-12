From: Jens Axboe <axboe@kernel.dk>
Subject: Re: reusing bios
Date: Sat, 12 Mar 2011 11:08:45 +0100
Message-ID: <4D7B462D.5000305@kernel.dk>
References: <4D7B3CF0.5040102@die-jansens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1CLKIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Mar 2011 05:08:48 -0500
In-Reply-To: <4D7B3CF0.5040102@die-jansens.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Jansen <lists@die-jansens.de>
Cc: linux-scsi@vger.kernel.org

On 2011-03-12 10:29, Arne Jansen wrote:
> Hi,
> 
> I'm trying to re-use struct bio after completion, including the
> allocated pages. Normally I re-initialize the fields bi_sector,
> bi_size, bi_next, bi_flags, bi_comp_cpu and bi_bdev.
> This works perfectly well, as long as no media errors are encountered.
> After a media error, all subsequent reads with this bio fail. Are
> there any more fields that need to get re-initialized? Or, better,
> is there a function to reset the bio?

bio_init()? Sounds like you are not setting BIO_UPTODATE when resetting
it.

-- 
Jens Axboe

