From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 12:58:49 -0700
Message-ID: <20070731125849.501443c1.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
	<20070731093014.db9e0734.kristen.c.accardi@intel.com>
	<46AF794F.1020107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXGaUBo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 16:01:44 -0400
In-Reply-To: <46AF794F.1020107@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk

On Wed, 01 Aug 2007 03:02:55 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Kristen Carlson Accardi wrote:
> > I think what you are saying is that you'd like a way to use your HIPM
> > and DIPM without ALPM on the AHCI driver.  Fine - it's really easy
> > to add these levels later - if they don't make sense at the sysfs interface
> > we can add module params to specify the definition of "min_power" as 
> > being performed via HIPM and DIPM instead of ALPM - although as of yet we
> > have no evidence what so ever that this method actually adds value over
> > ALPM.
> 
> I don't really care whose PS implementation goes in.  Believe me.  I try
> to stay away from that.  I don't even like my previous implementation.
> 
> ALPM has unnecessary performance penalty && is not applicable to
> non-ahci controller.  Have you tested ALPM on non-intel ahcis?  There
> are a lot out there these days.

I have not personally, however there has been a lot of testing of this
hardware feature both on other OS and for this particular implementation
by the powertop community, which is composed of community members running
all sorts of hardware.  So far I've not received any bug reports
wrt non-intel AHCI.  As I mentioned several times, the default for ALPM
is to be off anyway.

> 
> I don't think the interface you're suggesting is a good one.  Do you?

I think if it's applicable to SCSI at all it is fine.  If it is not, then
I think we need to make do with the interface we are given.  I do not think
we should hold up a feature for libata sysfs integration.

> 
> >> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
> >> 'cool down' period before entering PS state which unnecessarily hampers
> >> performance and might increase chance of device malfunction.
> > 
> > "might increase"?  How about some actual examples of where you've shown
> > this to be a problem?
> 
> I wouldn't have used "might" if I had actual examples.  Well, feel free
> to disregard anything following the "might".  I just feel uneasy about
> jumping back and forth between PS and active states between consecutive
> commands.

I want us to be careful about spreading a lot of unease without data to
back it up.

> 
> > I can assert that I think ALPM is a good idea,
> > because I've never had a report of it causing problems.  Windows has 
> > been using this feature for a very long time - and you have to admit that
> > they have a pretty large market share.  Nobody is complaining about ALPM
> > increasing device malfunction, so unless you have proof it seems insane
> > to nak due to this. 
> 
> Is ALPM enabled by default?  How do they deal with the performance
> degradation?

I believe so, but I'm obviously not privvy to their implementation details.
