From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg: fix races during device removal
Date: Wed, 31 Dec 2008 04:46:37 -0500
Message-ID: <20081231094637.GA2138@infradead.org>
References: <495A40D4.5030901@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYLaJql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 04:46:41 -0500
Content-Disposition: inline
In-Reply-To: <495A40D4.5030901@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, Dec 30, 2008 at 10:40:04AM -0500, Tony Battersby wrote:
>  	sdp = sg_get_dev(dev);
>  	if ((!sdp) || (!sdp->device)) {
> +		sg_put_dev(sdp);
>  		unlock_kernel();
>  		return -ENXIO;
>  	}
>  	if (sdp->detached) {
> +		sg_put_dev(sdp);
>  		unlock_kernel();
>  		return -ENODEV;
>  	}

It would be useful if you converted this to the standard goto-based
unwinding with a few labels at the end of the function:


 out_put:
	sg_put_dev(sdp);
 out_unlock:
	unlock_kernel();
 out:
	return error;

