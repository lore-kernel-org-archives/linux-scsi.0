From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: smp_utils 0.93 beta, adds sgv4 interface
Date: Thu, 20 Dec 2007 12:46:22 -0600
Message-ID: <1198176382.7309.11.camel@localhost.localdomain>
References: <4769F3AB.6050405@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [76.243.235.52] ([76.243.235.52]:51408 "EHLO
	accolon.hansenpartnership.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbXLTSqg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 13:46:36 -0500
In-Reply-To: <4769F3AB.6050405@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org


On Wed, 2007-12-19 at 23:46 -0500, Douglas Gilbert wrote:
> smp_utils is a package of command line utilities for invoking
> SMP functions to monitor and manage SAS expanders. SMP is the
> Serial Attached SCSI (SAS) Management Protocol (SMP). A SAS Host
> Bus Adapter (HBA) includes a SMP initiator (along with a SSP and
> STP initiator). A SAS expander contains a SMP target.
> 
> Previous versions have supported two interfaces: the "mptctl"
> pass through used by MPT Fusion SAS HBAs and the "smp_portal"
> sysfs attribute pass through used by Luben's aic94xx driver.
> 
> This beta adds preliminary support for an interface based on
> the scsi generic version 4 ("sgv4") interface. It works, apart
> from a few shortcomings, with the MPT Fusion SAS driver found
> in lk 2.6.24-rc4 . My aic94xx based hardware refuses to
> work with the mainline driver (but works with Luben's
> driver) so I'm unable to test it with the "sgv4" interface. I
> would be grateful if someone would test it and tell me how it
> fairs. Since the sgv4 interface essentially talks to the
> linux SAS transport layer, other SAS HBAs may work as well.

I'm pleased to report that it works just fine for me with my aic94xx
setup and the sgv4 interface and a couple of LSI expanders (which,
unfortunately don't take all the commands ... it looks like you're using
the SAS2.0 set).

I'll also plug in my mpt1068 and see if I can get it to function through
the sgv4 interface as well.

One of the things which might be useful would be for SAS hosts to
respond to SMP requests so they could also be managed with these tools.
To do this, we'd have to put a SMP interpreter for them inside the
transport class, probably just for a minimal set of SMP frames ... what
do people think about this?

Thanks for doing this,

James


