From: malahal@us.ibm.com
Subject: Re: AIC94XX discovery timeout problem details...
Date: Tue, 19 Sep 2006 13:59:02 -0700
Message-ID: <20060919205902.GA4326@us.ibm.com>
References: <20060915072030.GA25595@us.ibm.com> <20060918073506.74938.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:65454 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752046AbWISU7F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 16:59:05 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8JKx40O020198
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 16:59:04 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8JKx4kH268036
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 14:59:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8JKx4TV027551
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 14:59:04 -0600
Content-Disposition: inline
In-Reply-To: <20060918073506.74938.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi@vger.kernel.org

I am planning to process port/phy events in two phases. Phase-I sets up
asd_sas_port, asd_sas_phy lists and calls the LLDD with a correct
phy_mask. Phase-II is done in the thread context by queuing to the scsi
work queue that involves setting up sysfs objects.  Still there would be
just one thread setting up/tearing down sysfs objects that should avoid
any races.

Would appreciate any suggestions or issues with this approach.

Thanks, Malahal.

Luben Tuikov [ltuikov@yahoo.com] wrote:
> --- malahal@us.ibm.com wrote:
> > I chased the time out problem and found that the PORTE_BYTES_DMAED port
> > event must be responded with a call to lldd_port_formed() which will
> > update PHY_IS_UP and port-links fields in DDB 0. As there is a single
> > thread handling PHY/port events as well as discovery, we really can't
> > handle PORTE_BYTES_DMAED event until the discovery is complete. This
> > results in SCSI commands timing out in the discovery thread no matter
> > what I do!  This problem may be unique to Vitesse expander, read the PS
> > section for details.
> > 
> > Tried using two threads, one for events and the other for discovery.
> 
> Malahal,
> 
> If you go back in the archives, and take a look at the SAS Stack
> as I submitted it last year, you'll notice that this is exactly how
> the code is: there is a separate event thread and a separate
> discovery thread.
> 
> That is, from inception, my code has always had two separate threads,
> one for events and one for discovery.
> 
> I wasn't aware that the code had been changed such that a single
> thread handles events and discovery.  This is a very naive approach,
> and a regression over the original code.
> 
> > That avoided the timeout problems, but the discovery thread would die
> > after few iterations due to the event thread and the discovery thread
> > racing each other for setting up and tearing down of sysfs objects.
> 
> Indeed, the situation presented in such circumstances is tricky.
> These "races" have been dealt with in my (original) code.  Currently,
> I don't experience any problems with my SAS Stack, as I maintain it.
> 
> If any of my original comments are still left in the code or the README
> files, that would give you a hint of how such "races" are handled.
> 
> > I tried calling lldd_port_formed() with appropriate phy_mask from the
> > notify_port_event() itself. That worked fine. It is just a hack for now!
