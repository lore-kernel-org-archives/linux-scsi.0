From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2.6.11] ide-scsi: map sg buffers in idescsi_input/output_buffers() to kernel virtual address
Date: Wed, 16 Mar 2005 17:06:46 +0100
Message-ID: <20050316160645.GW7842@suse.de>
References: <7A8F92187EF7A249BF847F1BF4903C04010EEA11@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:6806 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262663AbVCPQGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 11:06:51 -0500
Content-Disposition: inline
In-Reply-To: <7A8F92187EF7A249BF847F1BF4903C04010EEA11@ausx2kmpc103.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stuart_Hayes@Dell.com
Cc: linux-scsi@vger.kernel.org, Joshua_Giles@Dell.com

On Wed, Mar 16 2005, Stuart_Hayes@Dell.com wrote:
> Hayes, Stuart wrote:
> > This patch will map the sg buffers to kernel virtual memory space in
> > the functions idescsi_input_buffers() and idescsi_output_buffers(). 
> > Without this patch, idescsi passes a null pointer to
> > atapi_input_bytes() and atapi_output_bytes() when sg pages are in
> > high memory (i686 architecture).   
> > 
> > I'm attaching as a file, too, as the text will certainly be wrapped.
> > 
> > (Sorry for the subject rename--I'm trying to use the correct format
> > for patch emails.) 
> > 
> > Thanks
> > Stuart
> 
> And, while there's another high memory/kmap patch question on this 
> list...
> 
> Is there some reason nobody seems interested in this patch (except 
> Jens--thanks for the help!)?  I'm kind of new to sending in patches, 
> and I'm not sure if I'm just not waiting long enough, or if there is 
> a problem with this patch... 
> 
> But really, we're getting a null pointer dereference oops when using 
> ATAPI tape drives (with ide-scsi) without this patch...

Sorry, that did seem to get dropped on the floor. Actually I'm wondering
why you are seeing highmem pages there in the first place, it would be
easier/better just to limit ide-scsi to non-highmem pages. That would
remove the need to add any work arounds in the driver.

-- 
Jens Axboe

