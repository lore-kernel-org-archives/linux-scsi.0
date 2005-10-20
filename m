From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 16:10:56 -0400
Message-ID: <4357F9D0.3090602@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de> <1129828959.2807.18.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19436 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932519AbVJTULD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 16:11:03 -0400
In-Reply-To: <1129828959.2807.18.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, jejb@steeleye.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On 10/20/05 13:22, Arjan van de Ven wrote:
>>We are not going to implement SDI in the kernel.  Long before SDI or
>>it's predecessor, HP CSMI were designed we made it clear we're not going
>>to accept wide ioctl-APIs, especially when they're even bad for old
>>ioctl API standards.  The CSMI spec has been passed around in an early
>>phase and been totally rejected, 
> 
> 
> Just to say AYE on this:
> 
> the problem with these things is that they define an IOCTL interface,
> while a library level interface would have been a LOT better. By far.
> That way the spec doesn't define the implementation, but only a real
> INTERFACE while allowing flexibility and compatibility. IOCTLs are just
> very very much the wrong layer to put such an interface. (just as
> posix/sus specify the (g)libc interface and not the kernel interface,
> although of course they impact it somewhat and glibc can for several
> things do a straight pass-through to the raw kernel interface).

Hi Arjan, how are you?

As I mentioned already, you do not have to take section 4 of SDI
literally.  If you implement section 5 of SDI, the back end, then
the front end is ajustable: sg/sysfs/whathaveyou1/whathaveyou2, etc.

Here is an excerpt sent by me to another storage engineer:
--cut--
Example of include/scsi/sdi/sdi.h (back-end):

/* This struct describes section 5 of the SDI spec */
struct sdi_functions_struct {
	int (*sdi_get_driver_info)(struct sdi_header *header,
				   struct sdi_driver_info *info);
	int (*sdi_get_controller_config)(struct sdi_header *header,
					 struct sdi_controller_config *config);
	/* the rest of the stub SDI functions defined here */
	...
};
	
/* This struct describes the provider */
struct sdi_provider_struct {
	char *provider_name; /* some name, whatever, may not be necessary */
	...
	struct sdi_functions_struct sdi_functions;   /* see above */
	...
};

And then the _calling_ of those functions is either via sg or sysfs
or whatever makes people happy (done in drivers/scsi/sdi.c).

Dispatching of those is driver/fw/hw/whatever dependent depending on
the provider and what they registered.

This will live in drivers/scsi/sdi.c and include/scsi/sdi/sdi.h
--cut--

You see?  You don't need IOCTLs, yet you can be fully compliant
to the spec so that already existing user space management programs
can transition with minimal change to their code (over to the front
end: sg/whatever).  This cuts down production costs in testing,
verification/etc.  Makes things cheaper to deploy and customers
are happy.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
