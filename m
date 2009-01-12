From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 19:12:20 +0200
Message-ID: <496B79F4.9080900@panasas.com>
References: <496B62B8.3030402@panasas.com> <496B76CE.4070000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:11933 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbZALRM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 12:12:26 -0500
In-Reply-To: <496B76CE.4070000@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>

Randy Dunlap wrote:
> Boaz Harrosh wrote:
>> Remove the dark ages /* define debug_print */ in code, to use
>> a Kconfig option. With a system like Kconfig, in code, commented out,
>> configuration options are slavery and hard work.
>> (version control, manual edit ... need I say more)
>>
>> I've used an "int" config bit-mask so more areas of code can be
>> selected with one Koption, but mainly so that allmodconfig will
>> not turn it on.
>>
>> bit-1 - will turn on prints for libiscsi.
>> bit-2 - will turn on prints for libiscsi_tcp & iscsi_tcp.
>>
>> More iscsi drivers should use more bits.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/Kconfig        |   15 +++++++++++++++
>>  drivers/scsi/iscsi_tcp.c    |    7 -------
>>  drivers/scsi/iscsi_tcp.h    |    6 ++++++
>>  drivers/scsi/libiscsi_tcp.c |    7 -------
>>  include/scsi/libiscsi.h     |    3 +--
>>  5 files changed, 22 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index d25d21e..6ef42f6 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -352,6 +352,21 @@ config ISCSI_TCP
>>  
>>  	 http://open-iscsi.org
>>  
>> +config ISCSI_DEBUG
>> +	int "ISCSI debug prints"
>> +	depends on SCSI_ISCSI_ATTRS
>> +	default 0
>> +	help
>> +	  This is a bit-mask that turns some debug printing to Kernel's
>> +	  Messages file. Each bit turns on another area of the code:
>> +	  1 - Turn on prints from iscsi libraries.
>> +	  2 - Turns on prints from iscsi_tcp operations.
> 
> Is this bit 1, bit 2, or value 1, value 2?  Not clear to me.
> If it's bit numbers, what about bit 0?
> 
> 
Yes you are right! Not clear at all I will fix it

<snip>

Boaz
