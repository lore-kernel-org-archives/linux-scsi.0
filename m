From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix for Incorrect number of segments after building
	list problem
Date: 20 Oct 2004 11:07:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098288465.2008.13.camel@mulgrave>
References: <1097790683.1717.47.camel@mulgrave>
	<20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de>
	<1098287481.2008.6.camel@mulgrave>  <20041020155825.GP10531@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35732 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268404AbUJTQH5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 12:07:57 -0400
In-Reply-To: <20041020155825.GP10531@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-20 at 10:58, Jens Axboe wrote:
> Ah yes, now I remember. How is the fix for that coming along, btw?

Erm, it didn't cross my mind until I realised what this problem was
about.  All SCSI drivers are setting 65536 (the default) for the max
segment length.  However, this is being violated wholesale by all the
IOMMUs and it all works because their length descriptors are 32 bit
anyway ...

However, I'll add it to the list and see if I can get something out.  My
slight problem is testing.  Only SATA and IDE have this short descriptor
problem, so I've nothing really to test the actual fix with.

James


