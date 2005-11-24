From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata test-unit-ready for ATAPI devices
Date: Thu, 24 Nov 2005 11:47:40 -0500
Message-ID: <4385EEAC.90107@pobox.com>
References: <20051116044841.GA11722@havoc.gtf.org> <20051116100117.GA22225@htj.dyndns.org> <437B2A24.9050508@pobox.com> <pan.2005.11.24.14.50.34.891596@riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:63627 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932448AbVKXQrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Nov 2005 11:47:43 -0500
In-Reply-To: <pan.2005.11.24.14.50.34.891596@riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

Willem Riede wrote:
> On Wed, 16 Nov 2005 07:46:28 -0500, Jeff Garzik wrote:
> 
> 
>>Tejun Heo wrote:
>>
>>>On Tue, Nov 15, 2005 at 11:48:41PM -0500, Jeff Garzik wrote:
>>>
>>>
>>>>The following patch clears the "I was just reset" condition from an
>>>>ATAPI device, and waits for it to come online, before continuing with
>>>>the probe.
>>>>
>>>>Not checking this into any upstream-bound branch, as I'm not yet
>>>>convinced of its value.
>>>
>>>
>>>How about the following one?  It doesn't make libata wait for the
>>>device to become ready before trying to configure ATA stuff.  It just
>>>makes sr wait for the device to become ready before performing SCSI
>>>configuration.  Maybe both are needed?
>>
>>[thinking out loud]  My rationale for doing TUR in libata was to clear 
>>the UNIT ATTENTION that libata caused through software/hardware reset. 
>>Once the UNIT ATTENTION was cleared, my rationale for waiting for the 
>>NOT READY(BECOMING READY) condition was simply symmetry with other 
>>libata probe tasks, which similarly wait for device readiness.
>>
>>However, given that sr is already coded to clear "the initial startup 
>>UNIT_ATTENTION", I tend to think your patch is more appropriate, and my 
>>patch should not be applied at all.
> 
> 
> I don't know when this code would get executed - if it is only at boot I
> don't mind, but other than that, in the osst driver, I need to know if the


This is only at boot.

	Jeff


