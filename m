From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Thu, 23 Dec 2004 12:34:22 -0600
Message-ID: <1103826862.5290.39.camel@mulgrave>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54242 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261235AbULWSec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 13:34:32 -0500
In-Reply-To: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-12-22 at 13:15 +0100, Guennadi Liakhovetski wrote:
> Further to my recent doubts wrt change_queue_depth semantics, I decided to 
> just implement this function for tmscsim following comments in 
> scsi_host.h. If this gets accepted in this form (returning -EIO if depth 
> != sdev->queue_depth after scsi_adjust_depth_queue), I'll submit patches 
> to 53c700.c and a comment-modification to scsi_host.h.

Actually, there's currently no way for scsi_adjust_queue_depth to fail,
so the check really isn't necessary.

Also, even if it were, the correct return would be either -EINVAL, or
the true nature of the error (most likely -ENOMEM).

The idea of the error return is more for drivers that have to allocate
internal resources to tag queues, so they can fail in those allocations.

James


