From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/3] MidLayer updates - extending transport/attribute
	container changes
Date: Fri, 04 Feb 2005 16:57:32 -0600
Message-ID: <1107557853.5557.82.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12EAB1@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:40407 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266192AbVBDW5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 17:57:41 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EAB1@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 09:03 -0500, James.Smart@Emulex.Com wrote:
>   Updates the recent transport container patch for :
>   - allow device driver-specific attributes to be added to class objects
>   - exposes classdev to transport via setup function

I'm not very keen on this for two reasons:

1) The driver should be tampering with class attributes.  A class and
its attributes are the presentation of an interface.  If the driver has
something more to add then surely that's an indication that the original
interface is missing pieces (i.e. every driver should have this) or that
the driver is trying to export a different interface (and so, logically
should use a new class.  i.e. just add a transport_class to the driver
and everything will work nicely).

2) classdevs are sysfs's representation of the interface.  I'd rather
they weren't exposed any more than necessary internally to avoid the
urge to hack the interface.

James


