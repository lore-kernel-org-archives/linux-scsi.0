From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 6 Mar 2006 11:35:55 -0800
Message-ID: <20060306193555.GA2316@us.ibm.com>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com> <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60563 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751999AbWCFTl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 14:41:58 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k26Jfu17015941
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:41:56 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k26JfuvE107174
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:41:56 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k26JfuKO017105
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 14:41:56 -0500
Content-Disposition: inline
In-Reply-To: <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-03-03 at 19:01 -0800, Tarte, Robert wrote:
> > Am I correct in assuming that this is a problem that needs to be worked
> > around in aic94xx in the short time period, but will eventually be fixed
> > in some other way?  My impression from reading this thread is that most
> 
> Yes ... udev and persistent identifiers will fix this and render it
> unnecessary, but currently, while the distros lack the infrastructure
> the scan needs to be as deterministic as possible
> 
> > people (including myself) are in agreement that devices in a
> > network-like topology (fabric, tree ... other) can legally present
> > themselves in a non-deterministic amount of time and in a
> > non-deterministic order.  It seems clear that it is the responsibility
> > of some other entity (kernel, user program) to synchronize and sort out
> > drive mappings.  Is this a fair assessment?  It would be simple enough
> > to hold off scan until discovery is done (we have implemented this in
> > another driver).  It's not perfect, but it should satisfy 99%+ of
> > typical configurations.  Hopefully we can move to a better (and
> > thoroughly discussed!! ;-) solution in the future.
> 
> 99% is good enough for me currently.
> 

Can you clarify this? Are you indicating that the 99% is only ok for debug
purposes or as a permanent solution. It would seem that if I want my system
to always boot that I would need to utilize an initramfs solution on top
of the driver solution.

Alexis already created a patch that has some pieces in common with the
older adp driver to try and sync discovery, but we did not post as it was
failing on a x260 which has an expander configuration. Currently I believe
she is trying to port this to your patch series. Is this effort worth
continuing?

-andmike
--
Michael Anderson
andmike@us.ibm.com
