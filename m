From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] set error value when failing block pc commands in
	prep_fn
Date: Sat, 10 Sep 2005 14:57:05 -0500
Message-ID: <1126382225.4813.63.camel@mulgrave>
References: <1126378749.2696.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36532 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932223AbVIJT5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 15:57:18 -0400
In-Reply-To: <1126378749.2696.4.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-09-10 at 13:59 -0500, Mike Christie wrote:
> This patch is updated against scsi-rc-fixes which has
> Alan's patch that fixes the places where we did not set
> a error value in the request_fn.
> 
> But when we kill a block pc request in the prep function
> the  errors value is still not getting set. And if scsi_init_io
> returned BLKPREP_DEFER we missed the blk_plug_device code so
> this patch just has it go to the defer label in that case.
> 
> Patch was made against scsi-rc-fixes.

Is there a reason we shouldn't be setting the error in all cases?  I
certainly can't think of one, in which case just set it globally.
There's also a return BLKPREP_DEFER on line 1191:

	if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
		if(specials_only == SDEV_QUIESCE ||
				specials_only == SDEV_BLOCK)
			return BLKPREP_DEFER;

That needs to become a goto defer; for the same reasons as outlined
above.

James



