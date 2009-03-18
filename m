From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 10:36:12 -0400
Message-ID: <20090318143612.GA19745@mars.virtualiron.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu> <20090318013621.26548.10529.sendpatchset@chandra-ubuntu> <20090318134449.GA19448@mars.virtualiron.com> <1237384963.3350.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:53928
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756411AbZCROhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 10:37:12 -0400
Content-Disposition: inline
In-Reply-To: <1237384963.3350.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu

On Wed, Mar 18, 2009 at 02:02:43PM +0000, James Bottomley wrote:
> On Wed, 2009-03-18 at 09:44 -0400, Konrad Rzeszutek wrote:
> > .. snip.. 
> > >  static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
> > >  {
> > >  	struct scsi_device *sdev;
> > > +	char buffer[501];
> > 
> > Why '501' ? How did you come up with that number?
> 
> A random 500 bytes of data plus room for a string terminator?

No no. I was thinking why the length of 500 bytes. why not 256 for example.
It doesn't matter that much really, but I am curious to why.

> 
> > > +	int rc;
> > >  
> > >  	if (dev->type != &scsi_dev_type)
> > >  		return 0;
> > >  
> > >  	sdev = to_scsi_device(dev);
> > >  
> > > -	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
> > > +	buffer[500] = '\0';
> > 
> > Shouldn't that be buffer[501] ?
> 
> No, buffer[501] would be off the end of the reserved space.  The
> definition char buf[501] allows you to access from buf[0] to buf[500].

Ugh. You are right. I need some more coffee.
> 
> James
> 
