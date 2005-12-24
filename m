From: Andrew Morton <akpm@osdl.org>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 19:54:36 -0800
Message-ID: <20051223195436.18fd5a1e.akpm@osdl.org>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	<20051222221329.5f317b8d.akpm@osdl.org>
	<20051223121534.GM2361@parisc-linux.org>
	<1135351652.3728.4.camel@mulgrave>
	<20051223073840.7110dbb0.akpm@osdl.org>
	<1135353536.3728.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8425 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161167AbVLXDzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 22:55:00 -0500
In-Reply-To: <1135353536.3728.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> > Perhaps you could use work_struct.data for the scsi_target* and get back to
> > the work_struct via container_of().
> 
> Could you elaborate some more on this?  If I simply use the starget
> pointer as my work_struct.data, how do I get back to the actual
> work_struct for me to free it?  It's not passed in to the function as
> far as I can tell.  But even if I do this, I still have to manage the
> allocation and deallocation of the work_struct.
> 

err, no, I'm full of it.  container_of() does pointer arithmetic to convert
a pointer to foo.bar into a pointer to foo.  But in this case the callback
would have the value of work_struct.data, not the address of it, so it
cannot be done.

Most usage in drivers would be something like:

struct driver_thing {
	...
	struct work_struct work;
};

and driver_thing.work.data gets a driver_thing* put into it.  So the need
to separately kmalloc the work_struct+data wrapper is relatively unusual.
