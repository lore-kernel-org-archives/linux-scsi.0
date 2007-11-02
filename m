From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 2/4] block layer varlen-cdb
Date: Fri, 02 Nov 2007 08:32:12 +0200
Message-ID: <472AC46C.2050707@panasas.com>
References: <472A12D6.805@panasas.com> <472A1552.6030700@panasas.com> <20071101184000.GM15111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18390 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251AbXKBGfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 02:35:09 -0400
In-Reply-To: <20071101184000.GM15111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Pete Wyckoff <pw@osc.edu>

On Nov. 01, 2007, 20:40 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, Nov 01, 2007 at 08:05:06PM +0200, Boaz Harrosh wrote:
>> @@ -287,8 +287,13 @@ struct request {
>>  	/*
>>  	 * when request is used as a packet command carrier
>>  	 */
>> -	unsigned int cmd_len;
>> +	unsigned short cmd_len;
>> +	unsigned short varlen_cdb_len;  /* length of varlen_cdb buffer */
>>  	unsigned char cmd[BLK_MAX_CDB];
>> +	unsigned char *varlen_cdb;      /* an optional variable-length cdb.
>> +	                                 * points to a user buffer that must be
>> +	                                 * valid until end of request
>> +	                                 */
>>  
> 
> Try this instead:
> 
>  	unsigned int cmd_len;
> -	unsigned char cmd[BLK_MAX_CDB];
> +	unsigned char _cmd[BLK_MAX_CDB];
> +	unsigned char *cmd;
> 
> Then initialise cmd to the address of _cmd.  If you need to override it
> later (ie patch 3), you can.
> 

I agree this is probably the cleanest implementation but when Boaz and I
initially discussed this approach he convinced me that LL block devices assume
that req->cmd_len <= BLK_MAX_CDB and it is unsafe at the moment to expose them
potentially larger commands.

