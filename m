From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 12:36:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928193614.GB192475@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:51333 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267745AbUI1Tgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 15:36:35 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Tue, Sep 28, 2004 at 09:52:55AM -0700, Andrew Vasquez wrote:
> On Tuesday, September 28, 2004 12:54 AM, Jeremy Higdon wrote:
> > +static ssize_t
> > +qla2xxx_store_queue_depth(struct device *dev, const char *buf,
> > size_t count) +{
> > +	int			 depth;
> > +	struct scsi_device	*sdev = to_scsi_device(dev);
> > +
> > +	if (sdev->tagged_supported) {
> > +		depth = simple_strtoul(buf, NULL, 0);
> > +		if (depth > ql2xmaxqdepth)
> > +			depth = ql2xmaxqdepth;
> 
> Any particular reason why the ql2xmaxqdepth module-parameter is
> being used as a high-water limit?  The module-param is (was) used 
> as a global setting of queue-depth for all luns (quite inflexible).
> By overriding:
> 
> 	/sys/class/scsi_device/22:0:0:0/device/queue_depth
> 
> with a writable value, a user should be allowed to update the
> value to something higher (max(unsigned short)?) based on the 
> back-end storage.


I was trying to be conservative -- I didn't know the reason for
that limit.  By all means, let's remove it then.

Would you like me to regenerate the patch, or do you just want
to apply it to your internal source that will eventually be
fed back to us?

jeremy
