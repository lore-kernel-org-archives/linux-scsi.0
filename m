From: Mathieu Fluhr <mfluhr@nero.com>
Subject: Re: Inquiry data and emulated SG devices
Date: Thu, 18 Oct 2007 14:44:48 +0200
Message-ID: <1192711488.3254.11.camel@de-c-l-110.nero-de.internal>
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no>
	 <4716B56A.1090501@shaw.ca>  <4716B786.80804@garzik.org>
	 <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
	 <4717302D.4050107@garzik.org>
	 <1192708650.3266.38.camel@de-c-l-110.nero-de.internal>
	 <1192709602.13229.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s1.mailresponder.info ([193.24.237.10]:3060 "EHLO
	s1.mailresponder.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbXJRMp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 08:45:56 -0400
Received: from moonfish.nero.com (193.47.77.31)
          by s1.mailresponder.info with MERCUR Mailserver (v4.02.30 ODAtMjQzOS03MTc5)
          for <linux-scsi@vger.kernel.org>; Thu, 18 Oct 2007 14:45:00 +0200
In-Reply-To: <1192709602.13229.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>, ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-10-18 at 08:13 -0400, James Bottomley wrote:
> On Thu, 2007-10-18 at 13:57 +0200, Mathieu Fluhr wrote:
> > On Thu, 2007-10-18 at 06:06 -0400, Jeff Garzik wrote:
> > 
> > > The SCSI midlayer makes a lot of "if scsi version <= 2" choices.  In the 
> > > case of ATAPI, we do not want to force ATAPI down the path of ancient 
> > > SCSI devices, as this disables some MMC features that modern ATAPI 
> > > devices support.
> > 
> > If I fully understand your point, if this faking code wasn't present,
> > and if the inquiry data was left as it is, all modern ATAPI devices
> > would be considered as really old SCSI devices. Am I right?
> 
> Not really.  Firstly, a lot of ATAPI devices report the correct
> compliance level and secondly, the consequence of reporting no
> compliance (level 0) is that the mid layer will be very careful to use
> the most minimal command set it can (the usual consequence of sending a
> USB device a command it doesn't understand is to have it crash).
> 

Ok, then, what about what the standard is saying regarding the ANSI
version field? Quoting to the latest MtFuji draft (Section 17.7.1):
 "The ANSI Version field shall contain a non-zero value to comply with 
  this version of the Specification for a SCSI logical unit or zero for
  an ATAPI logical unit."

and this is exactly how we see that the logical unit is a real SCSI one
or an ATAPI one.

> However, this will have no effect for at least CDs:  The sr driver is
> only interested in the MMC compliance level not the SCSI compliance
> level.

We are not using the sr driver to perform our SCSI commands, as it is
filtering which CDB is allowed and which isn't. As we have some
vendor-specific SCSI commands (like the one for changing booktype), we
are using the sg driver to be able to use them.



> > As far as I saw in libata-scsi.c there a SCSI-to-ATAPI and ATAPI-to-SCSI
> > translator that automatically transform the command sent... Am I also
> > right on this point?
> 
> The former only, I believe.

Absolutly... but if the inquiry data buffer gets modified by the
midlayer, after that I am not able anymore to setup correctly the
commands for the _real_ interface. (once again, the blank command
example).

Mathieu

