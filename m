From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to st
Date: 18 Jan 2005 12:26:35 +0100
Message-ID: <20050118112635.GL43344@muc.de>
References: <20050118110613.GC43344@muc.de> <20050118112357.GA26306@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:521 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261278AbVARL0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:26:36 -0500
Date: Tue, 18 Jan 2005 12:26:35 +0100
Content-Disposition: inline
In-Reply-To: <20050118112357.GA26306@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

On Tue, Jan 18, 2005 at 11:23:57AM +0000, Christoph Hellwig wrote:
> > +#ifdef CONFIG_COMPAT
> > +static int st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct scsi_tape *STp = file->private_data;
> > +	struct scsi_device *sdev = STp->device;
> > +	int ret = -ENOIOCTLCMD;
> > +	if (sdev->host->hostt->compat_ioctl) { 
> > +
> > +		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, arg);
> 
> This seems to miss a cast for arg.  Also I think it would be really nice
> to have a little helper like:

Hmm, yes.

Well, there are so many warnings in the code currently anyways
that one more won't really hurt ;-) 

> 
> int scsi_compat_ioctl(struct scsi_device *sdev, unsigned int cmd,
> 		unsiged long arg)
> {
> 	struct scsi_host_template *hostt = sdev->host->hostt;
> 	if (hostt->compat_ioctl)
> 		return hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
> 	return -ENOIOCTLCMD;
> }
> 
> that all drivers could use.

I don't think this makes sense for three lines of code. 

-Andi

