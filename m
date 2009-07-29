From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 18:28:44 +0200
Message-ID: <20090729162844.GA22561@merkur.ravnborg.org>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:60177 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZG2Q2p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2009 12:28:45 -0400
Content-Disposition: inline
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
> On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> > scsi/scsi.h is exported to userspace, so it should
> > use __u8 instead of u8 as other userspace-visible headers do.
> 
> Actually, can we just put a hold on this until we decide what we're
> doing with exporting include/scsi.
> 
> Arguments so far are
> 
>      1. Don't export and let glibc supply the headers (as it does now)
>      2. Move headers to be exported to include/linux
>      3. Take over include/scsi export from glibc: this will necessitate
>         comparing our current headers and those of glibc and moving
>         stuff around.

2 + 3...
Let include/scsi be kernel internal stuff.
And have the exported headers in include/linux.

This is how net/ handle their headers.

I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
>From a quick look it seems that we have more in the kernel version
than the glibc version - and no obvious conflicts.

But agree with Boaz that we should do this in one go.

	Sam
