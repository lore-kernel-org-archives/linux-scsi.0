From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally a ttached PHYs)
Date: Fri, 21 Oct 2005 06:40:37 -0600
Message-ID: <20051021124037.GA27692@parisc-linux.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD291@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58592 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964918AbVJUMko
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 08:40:44 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD291@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, dougg@torque.net, andrew.patterson@hp.com, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

On Fri, Oct 21, 2005 at 08:32:25AM -0400, Bagalkote, Sreenivas wrote:
> >Jeff Garzik wrote:
> >> Do you know where there are some clear guidelines on the use of 
> >> pointers in a structure passed to an ioctl to lessen (or bypass) 
> >> 32<->64 compat ioctl thunking?
> >
> >Its impossible.  If you pass pointers, you need to thunk.  
> >(Not even passing pointers via sysfs can avoid this.)  
> >Consider running a 32-bit app (with 32-bit pointers and 32-bit 
> >ABI) on a 64-bit kernel.
> 
> The drivers/scsi/megaraid/megaraid_mm.c simply calls regular ioctl
> from within the compat_ioctl, though it does copy to and from the
> userland pointers. This is done by adding appropriate padding.

Yes.  This is what is meant by "thunk".
