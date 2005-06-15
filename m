From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 10:05:45 -0700
Message-ID: <20050615170545.GB23912@us.ibm.com>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com> <1118849292.5045.27.camel@mulgrave> <42B04A9C.7050503@us.ibm.com> <1118850458.5045.34.camel@mulgrave> <42B05330.7050406@us.ibm.com> <1118853899.5045.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:19186 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261220AbVFORG3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 13:06:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5FH6Sua442002
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 13:06:28 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5FH6S0E172352
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:06:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5FH6RmQ032258
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:06:27 -0600
Content-Disposition: inline
In-Reply-To: <1118853899.5045.39.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: brking@us.ibm.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

On Wed, Jun 15, 2005 at 11:44:59AM -0500, James Bottomley wrote:

> 
> Well, I still think you're operating unsafely ... some people let these
> batteries run out, you know ...
> 
> To fix this, add a
> 
> blk_queue_ordered(sdev->request_queue, QUEUE_ORDERED_NONE);
> 
> to the slave configure routine for each of the devices that doesn't
> synchronize the cache.  That should correct the SCSI layer assumptions.

I don't get it.

First in scsi_alloc_queue, the flush/sync code is only used if we don't
have ordered tags, and if the adapter driver explicitly allows it
(shost->order_flush).

Plus we clear order_flush in scsi_host_alloc if can_queue > 1.

So ipr will never get those sync cache commands, correct?

And we default to QUEUE_ORDERED_NONE (0) if ordered_tag and ordered_flush
are not set.

But I can't find any where that we set ordered_tag at all, am I missing
something??? Let alone in ipr.

-- Patrick Mansfield
