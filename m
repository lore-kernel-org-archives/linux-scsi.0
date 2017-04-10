From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 1/2] scsi: sd: Separate zeroout and discard command
        choices
Date: Mon, 10 Apr 2017 09:13:43 +0200
Message-ID: <20170410071343.GA5658@lst.de>
References: <20170405114111.26864-1-martin.petersen@oracle.com> <1491595147.2559.26.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49100 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdDJHNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 03:13:45 -0400
Content-Disposition: inline
In-Reply-To: <1491595147.2559.26.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>

On Fri, Apr 07, 2017 at 07:59:08PM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-05 at 07:41 -0400, Martin K. Petersen wrote:
> > +static ssize_t
> > +zeroing_mode_store(struct device *dev, struct device_attribute *attr,
> > +		   const char *buf, size_t count)
> > +{
> > +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EACCES;
> > +
> > +	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
> > +		sdkp->zeroing_mode = SD_ZERO_WRITE;
> > +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
> > +		sdkp->zeroing_mode = SD_ZERO_WS;
> > +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
> > +		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
> > +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
> > +		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
> > +	else
> > +		return -EINVAL;
> > +
> > +	return count;
> > +}
> 
> An additional question about this function: if the shell command "echo" is used
> without command-line option -n to modify the "zeroing_mode" sysfs attribute then
> a newline character will be present in buf. Does the above code handle newline
> characters correctly?

It ignores the newlines.  But we have a helper called sysfs_streq
to possible ignore it.  It might be a good idea to move the various
sysfs files in scsi to use it.
