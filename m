From: Jens Axboe <axboe@suse.de>
Subject: Re: PATCH: Off-by-one bug in user page calculations for Direct I/O
Date: Mon, 17 Nov 2003 11:49:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117104909.GN888@suse.de>
References: <Pine.LNX.4.44L0.0311161151400.1071-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37354 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263460AbTKQKtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 05:49:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311161151400.1071-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kai.Makisara@kolumbus.fi, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Nov 16 2003, Alan Stern wrote:
> The page count calculations in drivers/scsi/st.c (and copied in sg.c) are
> wrong.  The code says:
> 
> 	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> 
> 		PAGE_SHIFT;
> 
> That will compute an incorrect value if the user's buffer happens to end 
> on the first byte of a new page.  Example:  Suppose uaddr starts right on 
> a page boundary and count is PAGE_SIZE + 1.  Then
> 
> 	(uaddr & ~PAGE_MASK)	->  0
> 	count - 1		->  PAGE_SIZE
> 	~PAGE_MASK		->  PAGE_SIZE - 1
> 
> 	nr_pages		-> (2 * PAGE_SIZE - 1) >> PAGE_SHIFT = 1
> 
> when in fact nr_pages should be 2.  Either the "- 1" shouldn't be there or 
> the second "~PAGE_MASK" should be replaced by "PAGE_SIZE".

Good catch, that's a classic error. page calculations 101? :)

-- 
Jens Axboe

