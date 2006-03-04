From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 22:09:33 -0600
Message-ID: <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2279 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750834AbWCDEJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 23:09:36 -0500
In-Reply-To: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-03-03 at 19:01 -0800, Tarte, Robert wrote:
> Am I correct in assuming that this is a problem that needs to be worked
> around in aic94xx in the short time period, but will eventually be fixed
> in some other way?  My impression from reading this thread is that most

Yes ... udev and persistent identifiers will fix this and render it
unnecessary, but currently, while the distros lack the infrastructure
the scan needs to be as deterministic as possible

> people (including myself) are in agreement that devices in a
> network-like topology (fabric, tree ... other) can legally present
> themselves in a non-deterministic amount of time and in a
> non-deterministic order.  It seems clear that it is the responsibility
> of some other entity (kernel, user program) to synchronize and sort out
> drive mappings.  Is this a fair assessment?  It would be simple enough
> to hold off scan until discovery is done (we have implemented this in
> another driver).  It's not perfect, but it should satisfy 99%+ of
> typical configurations.  Hopefully we can move to a better (and
> thoroughly discussed!! ;-) solution in the future.

99% is good enough for me currently.

> 
> > 2. The minimal attachment to the sas transport class doesn't do
> > expanders.  This needs to be fixed up by patching better expander
> > support into the class.  The way to do this is probably to pull the
> > domain_device into the sas transport class.
> 
> What exactly needs to happen in order for expanders to be supported?
> Who is planning to make those changes and do they need any help?  

I'll do this ... well, try ... not actually having a configuration with
expanders makes it rather hard but I can at least write most of the code
and give it to someone with a more complex topology to test.

> > 3. The object lifetimes are all basically infinite (this will probably
> > fixed by 2)
> 
> There seems to be some controversy over whether this is a problem or
> feature.  Is this a show stopper for driver integration, or is this
> something that can be fixed later?

it's currently a bug.  infinite lifetimes leak memory on hot
unplug/plug.  It's really just a question of tying the objects to their
corresponding refcounted implementation, which in turn means eliminating
as many of them in favour of the sas transport class objects and then
working out what the appropriate callbacks are for all the rest.

James


