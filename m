From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 08 Dec 2004 14:01:21 -0600
Message-ID: <1102536081.4218.0.camel@localhost.localdomain>
References: <60807403EABEB443939A5A7AA8A7458B7F5071@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53148 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261419AbULIBMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2004 20:12:52 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B7F5071@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, Matt Domsch <Matt_Domsch@Dell.com>, brking@us.ibm.com, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Wed, 2004-12-08 at 13:42 -0500, Salyzyn, Mark wrote:
> James Bottomley writes:
> >The real way I'd like to handle this is via hotplug.  The hotplug event
> >would transmit the HCTL in the environment.  Whether the drive actually
> >gets incorporated into the system and where is user policy, so it's
> >appropriate that it should be in userland.
> 
> The problem is the aac based cards generate events (AIFs) that are
> picked up by the driver. To go all the way to userland to interpret
> these events and back to the driver is a waste and a source of failures.
> Only the Firmware knows when an array zeroing has completed in order to
> bring the device online.

Hotplug is the standard way of handling configuration changes (whether
requested or forced).  There's value to handling things in a standard
manner.  If the current implementation needs improving, then you're free
to do it (and it would benefit far more than just SCSI...).

So the firmware calls the SCSI API which triggers the hotplug event and
adds the device ... there's no problem.

> >This same infrastructure could be used by fibre channel login, scsi
> >enclosure events etc.
> 
> I would need to emulate an SES to propagate array changes?

No.  Merely that the hotplug API would also be usable by SES (and other
things).

James


