From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix for Incorrect number of segments after building list problem
Date: Wed, 20 Oct 2004 18:11:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020161139.GR10531@suse.de>
References: <1097790683.1717.47.camel@mulgrave> <20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de> <1098287481.2008.6.camel@mulgrave> <20041020155825.GP10531@suse.de> <1098288465.2008.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58274 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267866AbUJTQMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 12:12:19 -0400
Content-Disposition: inline
In-Reply-To: <1098288465.2008.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 20 2004, James Bottomley wrote:
> On Wed, 2004-10-20 at 10:58, Jens Axboe wrote:
> > Ah yes, now I remember. How is the fix for that coming along, btw?
> 
> Erm, it didn't cross my mind until I realised what this problem was
> about.  All SCSI drivers are setting 65536 (the default) for the max
> segment length.  However, this is being violated wholesale by all the
> IOMMUs and it all works because their length descriptors are 32 bit
> anyway ...
> 
> However, I'll add it to the list and see if I can get something out.  My
> slight problem is testing.  Only SATA and IDE have this short descriptor
> problem, so I've nothing really to test the actual fix with.

Just set some articial limit (say, 0x3fff) and add a debug check in
init_io() to check the violation?

-- 
Jens Axboe

