From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI merge for 2.6.13
Date: Wed, 07 Sep 2005 13:14:10 -0500
Message-ID: <1126116850.4823.31.camel@mulgrave>
References: <1126053452.5012.28.camel@mulgrave>
	 <20050907174744.GA13172@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45966 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932150AbVIGSOn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 14:14:43 -0400
In-Reply-To: <20050907174744.GA13172@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Wed, 2005-09-07 at 10:47 -0700, Patrick Mansfield wrote:
> The scsi_execute() retries argument is still not used.

Yes, Jens was thinking about how to add this to the block layer.

> How is this going to work?
> 
> For example, multiple unit attentions (power on / reset) during scanning.
> We send REPORT LUN, READ CAPACITY, etc., and would not retry if we got a
> unit attention.

Well ... all of the places we were specifying retries mostly had three
of them, so the scsi_request_fn() actually hard codes three retries.  A
hack, but it works until the real method is in place.

James


