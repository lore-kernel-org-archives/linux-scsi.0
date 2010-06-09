From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add writeq definition if needed
Date: Wed, 09 Jun 2010 10:45:23 -0700
Message-ID: <4C0FD333.1080500@linux.vnet.ibm.com>
References: <20100608224308.499532262@linux.vnet.ibm.com> <4C0FB247.7000007@linux.vnet.ibm.com> <1276100428.4343.272.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54642 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab0FIRpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2010 13:45:31 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o59HW2E6017548
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 13:32:02 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o59HjTL7074362
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 13:45:29 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o59HjRxp024108
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2010 13:45:28 -0400
In-Reply-To: <1276100428.4343.272.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: ben@decadent.org.uk, linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>


On 06/09/2010 09:20 AM, James Bottomley wrote:
> On Wed, 2010-06-09 at 08:24 -0700, Wayne Boyer wrote:
>> Compiling the driver will fail on 32 bit powerpc and other
>> architectures where writeq is not defined.  This patch adds a
>> definition for writeq.
>>
>> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/ipr.h |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> Index: b/drivers/scsi/ipr.h
>> ===================================================================
>> --- a/drivers/scsi/ipr.h	2010-06-08 10:06:48.000000000 -0700
>> +++ b/drivers/scsi/ipr.h	2010-06-08 15:14:42.000000000 -0700
>> @@ -1860,4 +1860,12 @@ static inline int ipr_sdt_is_fmt2(u32 sd
>>  	return 0;
>>  }
>>
>> +#ifndef writeq
>> +static inline void writeq(u64 val, void __iomem *addr)
>> +{
>> +        writel(((u32) (val >> 32)), addr);
>> +        writel(((u32) (val)), (addr + 4));
> 
> Are you sure this is what you want?  The point about writeq is to do an
> atomic write of a 64 bit quantity.  Doing two writel's loses the
> atomicity (and can confuse some hardware if not done in the right
> order).  If this code above works correctly, why bother with the writeq?
> 

We do want to issue 8 byte MMIO writes where we can for the new adapters
for better performance.  We want to use writeq on platforms that support
it.  I did test the driver using this define with the new hardware and it
does work as expected.

-- 
Wayne Boyer
IBM - Beaverton, Oregon
LTC S/W Development - eServerIO
(503) 578-5236, T/L 775-5236
