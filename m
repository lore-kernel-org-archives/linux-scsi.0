From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: AIC94XX discovery timeout problem details...
Date: Tue, 19 Sep 2006 17:32:31 -0400
Message-ID: <1158701551.4170.50.camel@mulgrave.il.steeleye.com>
References: <20060915072030.GA25595@us.ibm.com>
	 <20060918073506.74938.qmail@web31807.mail.mud.yahoo.com>
	 <20060919205902.GA4326@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25068 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752085AbWISVch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 17:32:37 -0400
In-Reply-To: <20060919205902.GA4326@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org

On Tue, 2006-09-19 at 13:59 -0700, malahal@us.ibm.com wrote:
> I am planning to process port/phy events in two phases. Phase-I sets up
> asd_sas_port, asd_sas_phy lists and calls the LLDD with a correct
> phy_mask. Phase-II is done in the thread context by queuing to the scsi
> work queue that involves setting up sysfs objects.  Still there would be
> just one thread setting up/tearing down sysfs objects that should avoid
> any races.

Erm ... just a minute, I don't understand what the problem is.  The
reason you can handle both in a single event thread is because the
PORTE_BYTES_DMAED event either triggers discovery or wide port formation
(if it's the discovery of another phy in the port).

It sounds like the scenario you have is that discovery is kicked off
before the wide port is formed (I actually see this a bit in my LSI
expander as well).  This shouldn't be an issue: we're perfectly entitled
to do discovery on a single phy if we so choose and not form the wide
port until after discovery is completed.

We really need to debug this.  In your PS you wrote:

> PS: I instrumented the code to use only a single PHY out of 4-phy wide
> port by prematurely returning from sas_form_port() for all PHYs except
> one. In other words, I ignored the PORTE_BYTES_DMAED event for all PHYs
> but one.  There were SCSI timeouts every time I did that except if the
> PHY I was using is phy3.  When I swapped cables, the PHY that worked
> changed too. I believe, it goes with a specific Vitesse expander PHY. Is
> it possible that the Vitesse expander uses a specific PHY to respond to
> some SCSI requests even though the adapter uses a different PHY while
> sending the request?  Is this behavior of communicating on two different
> PHYs for a single SCSI command is allowed in the spec? Also note that
> the discovery commands (SMP) just work fine.

However, SAS specs require us to open connections for SMP and receive
the responses through the connection we opened.  The target is
specifically prohibited from responding outside of this protocol
boundary.  The theory behind this is that the Host controls port
formation ... until we open multiple connections between the source and
target ports, the actual connection remains narrow.  All of this should
support the current discovery model.

I suppose the only way to confirm what's going on would be with a SAS
analyser.  Does the host send multiple OPEN's even before the
PORTE_BYTES_DMAED is responded to?

James


