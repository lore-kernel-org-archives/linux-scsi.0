From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 21:38:59 +0100
Message-ID: <46477763.5020400@simon.arlott.org.uk>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>	 <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:45964 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbXEMUjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 16:39:08 -0400
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 13/05/07 17:10, James Bottomley wrote:
> On Sun, 2007-05-13 at 12:06 -0400, Dave Jones wrote:
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index e62d23f..0f6c370 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
>>  config SCSI_WAIT_SCAN
>>  	tristate
>>  	default m
>> -	depends on SCSI
>> +	depends on SCSI_SCAN_ASYNC
> 
> No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
> wait scan to be built in, which isn't the idea at all.

Try it. It doesn't force it to be built in.

> Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
> can alter this at boot time, so you could need the wait scan module even
> with it set to N.

static int __init wait_scan_init(void)
{
    scsi_complete_async_scans();
    return 0;
}

Could that not be built-in to SCSI as a sysfs attribute, rather than using 
a module to tell the kernel to do something? It looks like someone might 
want to call scsi_complete_async_scans() more than once too - if they also 
don't allow modules to be unloaded then they can't.

-- 
Simon Arlott
