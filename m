From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] ipr: AF DASD raw mode implementation in ipr driver
Date: Thu, 09 Apr 2015 19:55:48 -0500
Message-ID: <55271F94.2090101@linux.vnet.ibm.com>
References: <201503261623.t2QGNxP3021634@d03av04.boulder.ibm.com> <1428614259.2448.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:45477 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbDJAzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 20:55:53 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 9 Apr 2015 18:55:52 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 4BB6519D8026
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2015 18:46:55 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3A0tZfp43450476
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2015 17:55:35 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3A0tnap005210
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2015 18:55:49 -0600
In-Reply-To: <1428614259.2448.3.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

On 04/09/2015 04:17 PM, James Bottomley wrote:
> On Thu, 2015-03-26 at 11:23 -0500, Brian King wrote:
>> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>>
>> This patch implements raw mode support for AF DASD in ipr driver
>> which allows for tools to send commands directly to physical
>> devices which are members of RAID arrays when enabled in the firmware.
>>
>> Signed-off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/ipr.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/ipr.h |    3 +
>>  2 files changed, 88 insertions(+)
>>
>> diff -puN drivers/scsi/ipr.c~ipr_sispipe drivers/scsi/ipr.c
>> --- linux/drivers/scsi/ipr.c~ipr_sispipe	2015-03-26 10:53:55.540578199 -0500
>> +++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 10:57:00.570080498 -0500
> [...]
>> @@ -6152,6 +6228,13 @@ static void ipr_erp_start(struct ipr_ioa
>>  		break;
>>  	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
>>  		break;
>> +	case IPR_IOASC_IR_NON_OPTIMIZED:
>> +		if (res->raw_mode){
> 
> Missing space here ... checkpatch would have picked this up; please use
> it.

Sorry about that. Will do.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


