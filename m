From: badari <pbadari@us.ibm.com>
Subject: Re: many-disk support
Date: Fri, 09 Jan 2004 10:51:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFEF832.A7DB3D92@us.ibm.com>
References: <20031229022549.50bae6d7.akpm@osdl.org> <20031229110603.A27408@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:22015 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263805AbUAISzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 13:55:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>

I am not sorry for not replying for so long. I have been on vacation.

1) I am not really concerned about bitmap overhead. Bitmap of one
page (4k) - should be enough to support 32K disks. That should be
good enough for most of the machines.

2) I used config option for 2 reasons
        - to minimize impact on machines this is not needed.
        - didn't want to depend on <major, minor> split to decide on
           how many disks we can support.

3) The reason, I assigned all the disks to last major is to maintain backward
compatibility with current major, minor assignments. Hopefully "udev"
will cleanup all these.

My question is, what do we do for current 2.6 ? Hoping to address these
before distros start making 2.6 distros and adding their own stuff to support
this.

And also, is there a plan to support more partitions per disk ?

Thanks,
Badari



Christoph Hellwig wrote:

> On Mon, Dec 29, 2003 at 02:25:49AM -0800, Andrew Morton wrote:
> > Guys, I've had this patch for ages.  Badari seemed to say that it wasn't
> > the "right" way to do it.
> >
> > Can we get this nailed down please?
>
>  - I think the bitmap overhead was killing us on big x86 machines, right?
>    so that might need some swork.
>  - a config option definitly is the wrong way to go.
>  - I don't think assigning more numbers to the last major is a bad idea,
>    better assign them to the first one, maybe with a hole for what we're
>    using the other majors currently for, so when udev gets more mature
>    we can kill the additional majors.

