From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Patch] SCSI I/O statistics
Date: Tue, 26 Sep 2006 16:45:54 -0500
Message-ID: <45199F92.106@cs.wisc.edu>
References: <1159286194.2925.5.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <20060926103930.471b75a5.akpm@osdl.org> <20060926182347.GH5017@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57265 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964845AbWIZVqJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 17:46:09 -0400
In-Reply-To: <20060926182347.GH5017@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@osdl.org>, Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Sep 26, 2006 at 10:39:30AM -0700, Andrew Morton wrote:
>> - Should it have been done at the block layer rather than at the scsi layer?
> 
> This was already mentioned when he sent it to linux-scsi a few days ago.
> There are scsi commands which bypass the block layer, such as SG_IO, and


I do not think any command completely bypasses the block layer now.
SG_IO, tape, sd and scanning insertion go through blk_execute_rq_nowait
for insertion. For completion they go through blk_complete_request +
end_that_request_first/last in the normal path and blk_complete_request
+ blk_requeue_request in the retry path.


> block layer stats can make an extremely busy disc look not busy.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

