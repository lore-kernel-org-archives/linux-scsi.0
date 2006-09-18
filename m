From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: AIC94XX discovery timeout problem details...
Date: Mon, 18 Sep 2006 00:35:06 -0700 (PDT)
Message-ID: <20060918073506.74938.qmail@web31807.mail.mud.yahoo.com>
References: <20060915072030.GA25595@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:34680 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751540AbWIRHfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 03:35:07 -0400
In-Reply-To: <20060915072030.GA25595@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com, linux-scsi@vger.kernel.org

--- malahal@us.ibm.com wrote:
> I chased the time out problem and found that the PORTE_BYTES_DMAED port
> event must be responded with a call to lldd_port_formed() which will
> update PHY_IS_UP and port-links fields in DDB 0. As there is a single
> thread handling PHY/port events as well as discovery, we really can't
> handle PORTE_BYTES_DMAED event until the discovery is complete. This
> results in SCSI commands timing out in the discovery thread no matter
> what I do!  This problem may be unique to Vitesse expander, read the PS
> section for details.
> 
> Tried using two threads, one for events and the other for discovery.

Malahal,

If you go back in the archives, and take a look at the SAS Stack
as I submitted it last year, you'll notice that this is exactly how
the code is: there is a separate event thread and a separate
discovery thread.

That is, from inception, my code has always had two separate threads,
one for events and one for discovery.

I wasn't aware that the code had been changed such that a single
thread handles events and discovery.  This is a very naive approach,
and a regression over the original code.

> That avoided the timeout problems, but the discovery thread would die
> after few iterations due to the event thread and the discovery thread
> racing each other for setting up and tearing down of sysfs objects.

Indeed, the situation presented in such circumstances is tricky.
These "races" have been dealt with in my (original) code.  Currently,
I don't experience any problems with my SAS Stack, as I maintain it.

If any of my original comments are still left in the code or the README
files, that would give you a hint of how such "races" are handled.

> I tried calling lldd_port_formed() with appropriate phy_mask from the
> notify_port_event() itself. That worked fine. It is just a hack for now!

This and your postscript below, tell me that you're coming around full
circle to how the original code works.  I'd suggest that you take a look
at the original code.

> Any comments, suggestions?

Good luck,
     Luben

> Thanks, Malahal.
> PS: I instrumented the code to use only a single PHY out of 4-phy wide
> port by prematurely returning from sas_form_port() for all PHYs except
> one. In other words, I ignored the PORTE_BYTES_DMAED event for all PHYs
> but one.  There were SCSI timeouts every time I did that except if the
> PHY I was using is phy3.  When I swapped cables, the PHY that worked
> changed too. I believe, it goes with a specific Vitesse expander PHY. Is
> it possible that the Vitesse expander uses a specific PHY to respond to
> some SCSI requests even though the adapter uses a different PHY while
> sending the request?  Is this behavior of communicating on two different
> PHYs for a single SCSI command is allowed in the spec?
> Also note that
> the discovery commands (SMP) just work fine.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


