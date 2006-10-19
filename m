From: malahal@us.ibm.com
Subject: Re: [PATCH] fix to serialize unload and discovery
Date: Thu, 19 Oct 2006 14:20:49 -0700
Message-ID: <20061019212048.GA26234@us.ibm.com>
References: <20061019032337.GA19570@us.ibm.com> <20061019205823.48812.qmail@web31802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:17089 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1946514AbWJSVUv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 17:20:51 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9JLKpG3007022
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 17:20:51 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9JLKo2j302898
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 15:20:50 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9JLKoN6019901
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 15:20:50 -0600
Content-Disposition: inline
In-Reply-To: <20061019205823.48812.qmail@web31802.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Lubin, I am not sure if you are referring to your version of the driver
or the mainline version! If I read the mainline version correctly,
sas_deform_port() actually removes a phy from a port and also removes
all attached devices if it is the last phy in the port.

When a phy/port is gone, an event is posted to the work queue to
eventually call sas_deform_port(). Let me know if I misunderstood the
mainline version.

Thanks, Malahal.

Luben Tuikov [ltuikov@yahoo.com] wrote:
> --- malahal@us.ibm.com wrote:
> > sas_discover_domain() and sas_deform_port() assume that they are single
> > threaded and never run in parallel.
> 
> This is indeed not true.
>
> > That is mostly true as we have a
> > single threaded work queue to handle discovery and other events.
> 
> Hint: when the port is gone, it is gone...
> 
> > The
> > only race I find is unloading a module will call sas_deform_port()
> > without watching if there is a discovery event is in progress. This
> > patch will stop queuing further events, flush the queue, and then call
> > sas_deform_port() to avoid the race.
> 
> You need a much more elaborate (read: general solution, aka algorithm)
> framework to solve this.
> 
> Needless to say, I don't observe these bugs and errors in my version
> of the SAS Stack.
> 
>     Luben
> 
