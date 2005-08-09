From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] SPI transport class and generic Domain Validation for
	fusion
Date: Mon, 08 Aug 2005 21:19:17 -0500
Message-ID: <1123553957.8235.32.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C037B09A6@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56961 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932398AbVHICTh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 22:19:37 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C037B09A6@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Wade, Roy" <Roy.Wade@lsil.com>, "Cratin, Laura" <Laura.Cratin@lsil.com>, "Maloy, Joe" <Joe.Maloy@lsil.com>, "Pope, Steve" <spope@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <roger.hickerson@lsil.com>

On Mon, 2005-08-08 at 18:07 -0600, Moore, Eric Dean wrote:
> James:  I've not been able to review this patch, nor the other one you sent.
> On concern is whether spi transport handle asyn events?  Meaning will it do
> domain
> validation on RAID1 volume - for a new drive that was hot swapped with a 
> good disk?  In the driver look at mptscsih_event_process - this code is 
> handling a aync event from the firmware telling the driver to perform 
> dv on disk that was just added.  

Yes ... I think I told you this the last time you asked.  You just have
to plug in either spi_dv_device() or spi_schedule_dv_device() (if you're
in interrupt context) and it will kick off a dv of the underlying
device.

It is hard for me to ascertain what the firmware is doing from reverse
engineering the driver since you don't provide documentation.  However,
I can guess roughly from the original code what to do.  How do I trigger
this event to test it?

> Pls don't rush this into the kernel untill we have time to review, and/or 
> talk to our internal test teams on test effort, and/or talk to our customers
> explaning the risk in removing this code.

Well, apart from the update to do DV on underlying raid devices, which
is really all in the previous patch, nothing much has changed from the
diff I sent you on 11 April ... I haven't heard that you found any
problems in your previous four months of testing, how much longer do you
need?

The object of using the generic code is to try to pool resources on DV
since it's a rather complex and bug prone area.  I already know you have
several bugs in the fusion DV code, of which hanging the system when
there's a narrow segment in the domain is the most serious.  However, I
suspect we probably have different tests in our DV test suites, so if
yours turns up any problems in the generic DV, I'll be happy to fix it.

James


