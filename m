From: Martin Bligh <mbligh@google.com>
Subject: Re: [patch 07/25] scsi: cover up bugs^W^W^WFix up compiler	warnings
 in megaraid driver
Date: Wed, 23 May 2007 15:54:09 -0700
Message-ID: <4654C611.9070302@google.com>
References: <200705232141.l4NLfd1N001178@shell0.pdx.osdl.net> <1179960760.5569.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:57889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbXEWWyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 18:54:35 -0400
In-Reply-To: <1179960760.5569.45.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
>> From: Martin Bligh <mbligh@google.com>
>>
>> Fix up compiler warnings in megaraid driver
>>
>> [akpm@osdl.org: build fix]
>> Signed-off-by: Martin J. Bligh <mbligh@google.com>
>> Cc: James Bottomley <James.Bottomley@steeleye.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  drivers/scsi/megaraid.c |   22 +++++++++++++---------
>>  1 files changed, 13 insertions(+), 9 deletions(-)
>>
>> diff -puN drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver drivers/scsi/megaraid.c
>> --- a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver
>> +++ a/drivers/scsi/megaraid.c
>> @@ -73,10 +73,14 @@ static unsigned short int max_mbox_busy_
>>  module_param(max_mbox_busy_wait, ushort, 0);
>>  MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
>>  
>> -#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
>> -#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
>> -#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
>> -#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
>> +#define RDINDOOR(adapter)		readl((volatile void __iomem *) \
>> +							(adapter)->base + 0x20)
>> +#define RDOUTDOOR(adapter)		readl((volatile void __iomem *) \
>> +							(adapter)->base + 0x2C)
>> +#define WRINDOOR(adapter,value)		writel(value, (volatile void __iomem *)\
>> +							(adapter)->base + 0x20)
>> +#define WROUTDOOR(adapter,value)	writel(value, (volatile void __iomem *)\
>> +							(adapter)->base + 0x2C)
> 
> This is both unnecessary and wrong ... it coerces the iomem value and
> would squelch the useful warnings gcc would issue if base ever lost its
> iomem annotation.

Is there another, better, way to stop it spewing compile warnings like
something out of a horror movie?

M.
