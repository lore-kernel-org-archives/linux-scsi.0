From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: add message to error table
Date: Wed, 28 Jan 2009 08:24:50 -0800
Message-ID: <498086D2.8050405@linux.vnet.ibm.com>
References: <20090123165823.748742817@linux.vnet.ibm.com> <4979FBB1.8050103@linux.vnet.ibm.com> <1232893083.4586.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33503 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZA1QYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 11:24:52 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0SGN7Th017802
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 11:23:07 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0SGOpBw184786
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 11:24:51 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0SGOpps012696
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 11:24:51 -0500
In-Reply-To: <1232893083.4586.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-01-23 at 09:17 -0800, Wayne Boyer wrote:
>> Adds a message to the error table for an error that wasn't previously handled.
>>
>> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/ipr.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> Index: linux-2.6/drivers/scsi/ipr.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-22 15:50:59.000000000 -0800
>> +++ linux-2.6/drivers/scsi/ipr.c	2009-01-23 08:55:23.000000000 -0800
>> @@ -354,6 +354,8 @@
>>  	"9076: Configuration error, missing remote IOA"},
>>  	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
>>  	"4050: Enclosure does not support a required multipath function"},
>> +	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
>> +	"4070: Logically bad written to device"},
> 
> Neither from the change log nor from the actual text can I tell what the
> problem is ... is there a word missing (like block or sector)?
> 

After some discussion, I've come up with a more descriptive message and
better change log.  Updated patch below...

> James
> 


Adds a message to the error table for an error that wasn't previously handled.
In some cases the I/O Adapter will detect an error condition and mark a block
as "logically bad".

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-26 12:29:01.000000000 -0800
+++ linux-2.6/drivers/scsi/ipr.c	2009-01-27 14:32:08.000000000 -0800
@@ -354,6 +354,8 @@
 	"9076: Configuration error, missing remote IOA"},
 	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4050: Enclosure does not support a required multipath function"},
+	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4070: Logically bad block written on device"},
 	{0x06690200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9041: Array protection temporarily suspended"},
 	{0x06698200, 0, IPR_DEFAULT_LOG_LEVEL,

-- 
Wayne Boyer
IBM - Beaverton, Oregon
LTC S/W Development - eServerIO
(503) 578-5236, T/L 775-5236
