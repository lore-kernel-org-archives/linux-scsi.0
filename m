From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 19:01:14 -0800
Message-ID: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:49562 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751594AbWCDDBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 22:01:15 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]

My comments are related to the statement at the end of your email:

	"However, my basic though is that once we can get the critical
issues
	sorted out, this driver can go in."

> ).  Unfortunately, the driver itself still has the following critical
> issues
> 
> 1. Discovery order is non-deterministic (it starts one thread per
port,
> so the threads race for discovery)

Am I correct in assuming that this is a problem that needs to be worked
around in aic94xx in the short time period, but will eventually be fixed
in some other way?  My impression from reading this thread is that most
people (including myself) are in agreement that devices in a
network-like topology (fabric, tree ... other) can legally present
themselves in a non-deterministic amount of time and in a
non-deterministic order.  It seems clear that it is the responsibility
of some other entity (kernel, user program) to synchronize and sort out
drive mappings.  Is this a fair assessment?  It would be simple enough
to hold off scan until discovery is done (we have implemented this in
another driver).  It's not perfect, but it should satisfy 99%+ of
typical configurations.  Hopefully we can move to a better (and
thoroughly discussed!! ;-) solution in the future.

> 2. The minimal attachment to the sas transport class doesn't do
> expanders.  This needs to be fixed up by patching better expander
> support into the class.  The way to do this is probably to pull the
> domain_device into the sas transport class.

What exactly needs to happen in order for expanders to be supported?
Who is planning to make those changes and do they need any help?  

> 3. The object lifetimes are all basically infinite (this will probably
> fixed by 2)

There seems to be some controversy over whether this is a problem or
feature.  Is this a show stopper for driver integration, or is this
something that can be fixed later?

> There's a host of minor details, and I think the ultimate goal needs
to
> be to turn Luben's sas_class into an adjunct to the transport class
that
> handles drivers with domain devices.
> 
> However, my basic though is that once we can get the critical issues
> sorted out, this driver can go in.
> 
> Comments?
> 
> James

