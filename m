From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sat, 19 Aug 2006 22:26:54 -0400
Message-ID: <44E7C86E.1030302@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27291 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751637AbWHTD1C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 23:27:02 -0400
In-Reply-To: <44E6FC57.5050502@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> How big of a number do you need ?  48 bits ?
> We can up to 64bits, but I'd reserve 8bits for a "type" field.
> (ugh, sounds like I'm redefining naming authorities...)
> 
> On a side thought - is the mac address really the right thing to
> use for a vendor id. Wouldn't you be extracting the vendor id from
> the mac address ?
> 

I was looking for a persistent per hba value for some other long reason
that we can work around in userspace so I take back that comment.

Are you only sending the vendor id to match some vendor specific
userspace code with the event? Currently, for iscsi we only send the
host no then match the driver, host and some driver or vendor specific
code by using the host no and proc_name attr. This is because for
software iscsi and iser we do not know the pci device that will be used.
For software iscsi it could be a bonded device or multiple devices
depending on tables getting updated. What would we use for the vendor id
in this case? Is there a null value or some special unused one we can
abuse or why do you need the vendor id value if you can look that up in
sysfs by just following the host no to the scsi host dir then going to
the pci device?
