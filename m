From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Fri, 9 Apr 2004 09:56:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040409095657.A2970@beaverton.ibm.com>
References: <1081518779.2203.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:40684 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261317AbUDIQ5E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 12:57:04 -0400
Content-Disposition: inline
In-Reply-To: <1081518779.2203.29.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Apr 09, 2004 at 08:52:59AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Fri, Apr 09, 2004 at 08:52:59AM -0500, James Bottomley wrote:
> All this does is replace our kobject usage with a kref.

Nice work, I did not think this could be fixed without changing gendisk
code. It took me a bit to walk through the code paths, I still don't
fully grok the kobj_unmap/map/lookup. 

I was about to post on the other thread that you missed the semaphore
around the put in sd_remove but I see it is fixed here.

Per other thread, comments about using the private_data to mark the device
as removed, and about the get/put race would be good.

Code comments can't clarify the overall ref counting that occurs, maybe
Mike A can update his ref counting slides.

-- Patrick Mansfield
