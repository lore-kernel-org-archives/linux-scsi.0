From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 14:02:43 +0000
Message-ID: <1237384963.3350.3.camel@localhost.localdomain>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <20090318134449.GA19448@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39705 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbZCROCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 10:02:52 -0400
In-Reply-To: <20090318134449.GA19448@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu

On Wed, 2009-03-18 at 09:44 -0400, Konrad Rzeszutek wrote:
> .. snip.. 
> >  static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  {
> >  	struct scsi_device *sdev;
> > +	char buffer[501];
> 
> Why '501' ? How did you come up with that number?

A random 500 bytes of data plus room for a string terminator?

> > +	int rc;
> >  
> >  	if (dev->type != &scsi_dev_type)
> >  		return 0;
> >  
> >  	sdev = to_scsi_device(dev);
> >  
> > -	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
> > +	buffer[500] = '\0';
> 
> Shouldn't that be buffer[501] ?

No, buffer[501] would be off the end of the reserved space.  The
definition char buf[501] allows you to access from buf[0] to buf[500].

James


