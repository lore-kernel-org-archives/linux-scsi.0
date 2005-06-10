From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] convert fusion to SPI transport class and use generic D V
Date: Thu, 09 Jun 2005 21:40:39 -0500
Message-ID: <1118371239.5057.8.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C02A96495@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31929 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261380AbVFJCkt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 22:40:49 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C02A96495@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Wade, Roy" <Roy.Wade@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>

On Thu, 2005-06-09 at 17:27 -0600, Moore, Eric Dean wrote:
> Are you considering this for inclusion into the kernel?

No, that's why I said in the email:

> This code is more posted as an illustration of how to do 
> things than an
> actual patch for submission.  However, I've tested this and it does
> actually work:

> (1)We need to hold off on that till we sort out supporting 
> integrated raid first in the spi transport.  Also, can the transport
> support receiving asyn event form scsi lld for triggering dv on disk that
> was just added to degraded volume(raid 1)?  Also queising IO to
> the volume, is that supported; I believe that is, but just asking.

I thought the idea was we'd use the no_uld_attach flag.  dv can be
triggered from any event in the driver (it needs user context, but
there's a spi_schedule_dv_device that works from irq context via
workqueues).  And yes, quiescing is supported.

> (2) Does this patch dependent on the previous patch to work; e.g.
> "update spi transport class so that u320 Domain Validation works"
> Just wondering if there were any backward compatibility for this patch this
> to work.

Yes, it was the engine I used to validate the work.

> (3) I need to review our source to confirm what work arounds in our code are
> going to be
> backed out by using your generic dv.  I know of sep devices known to freeze
> the bus 
> when too large inquiry data is requested.  Wondering if generic dv will
> freeze the bus.
> Also known are mixed mode devices on the bus getting starved when qas is
> enabled, 
> e.g. u320 and non-u320 disk devices on same bus. 
> I'm not sure whether generic dv is disabling qas in that case.  
> I think there are other concerns, I will have to check and post them later.

I think you'll find the generic code is incredibly careful about inquiry
lengths.

DV is to a single device, it's hardly able to tell if there's a qas/non-
qas starvation issue.  However, with the transport class, QAS policy
becomes the province of the user.

James


