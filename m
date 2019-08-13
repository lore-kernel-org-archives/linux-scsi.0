Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC1CC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 22:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606DC2067D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 22:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfHMW6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 18:58:10 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43099 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfHMW6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 18:58:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4B9C920423A;
        Wed, 14 Aug 2019 00:58:08 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pbtf2Ikur-Zt; Wed, 14 Aug 2019 00:58:01 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 741C320414F;
        Wed, 14 Aug 2019 00:58:00 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 03/20] sg: sg_log and is_enabled
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-4-dgilbert@interlog.com>
 <20190812142305.GC8105@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <6c2854ab-aeef-e0dc-e756-c065745f82c3@interlog.com>
Date:   Tue, 13 Aug 2019 18:57:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812142305.GC8105@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:23 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:35PM +0200, Douglas Gilbert wrote:
>> Replace SCSI_LOG_TIMEOUT macros with SG_LOG macros across the driver.
>> The definition of SG_LOG calls SCSI_LOG_TIMEOUT if given and derived
>> pointers are non-zero, calls pr_info otherwise. SG_LOGS additionally
>> prints the sg device name and the thread id. The thread id is very
>> useful, even in single threaded invocations because the driver not
>> only uses the invocer's thread but also uses work queues and the
>> main callback (i.e. sg_rq_end_io()) may hit any thread. Some
>> interesting cases arise when the callback hits its invocer's
>> thread.
>>
>> SG_LOGS takes 48 bytes on the stack to build this printf format
>> string: "sg%u: tid=%d" whose size is clearly bounded above by
>> the maximum size of those two integers.
>> Protecting against the 'current' pointer being zero is for safety
>> and the case where the boot device is SCSI and the sg driver is
>> built into the kernel. Also when debugging, getting a message
>> from a compromised kernel can be very useful in pinpointing the
>> location of the failure.
>>
>> The simple fact that the SG_LOG macro is shorter than
>> SCSI_LOG_TIMEOUT macro allow more error message "payload" per line.
>>
>> Also replace #if and #ifdef conditional compilations with
>> the IS_ENABLED macro.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 252 +++++++++++++++++++++++-----------------------
>>   1 file changed, 125 insertions(+), 127 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 6615777931f7..d14ba4a5441c 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -57,6 +57,15 @@ static char *sg_version_date = "20190606";
>>   
>>   #define SG_MAX_DEVS 32768
>>   
>> +/* Comment out the following line to compile out SCSI_LOGGING stuff */
>> +#define SG_DEBUG 1
>> +
>> +#if !IS_ENABLED(SG_DEBUG)
>> +#if IS_ENABLED(DEBUG)	/* If SG_DEBUG not defined, check for DEBUG */
>> +#define SG_DEBUG DEBUG
>> +#endif
>> +#endif
> 
> IS_ENABLED is mostly useful for checking it from C-level if statements.
> No need to use this from cpp.  But even more importantly we generally
> try to avoid cpp checks that aren't driven from Kconfig.  Please make
> these an actual CONFIG_ options.

Another reviewer (called James) didn't like #ifdef_s (at file scope).

Surely it is simpler to allow an experienced C programmer to add

#define DEBUG 1
   or
#define SG_DEBUG 1

to the driver source code than to add to the existing Linux config
nightmare with a new config parameter:
   CONFIG_CHR_DEV_SG_DEBUG

$ grep "^CONF" <linux-stable>/.config | wc
2480

on my system.
Linux: where too much is never enough.

>>   static int sg_read_oxfer(struct sg_request *srp, char __user *outp,
>> -			 int num_read_xfer);
>> +			 int num_xfer);
> 
> This looks like a random unrelated change.

Separate patch maybe :-)

>> -#define SZ_SG_HEADER sizeof(struct sg_header)
>> -#define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
>> -#define SZ_SG_IOVEC sizeof(sg_iovec_t)
>> -#define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
>> +#define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
>> +#define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
>> +#define SZ_SG_REQ_INFO ((int)sizeof(struct sg_req_info))
> 
> Doesn't look related to the patch.  But more importantly there should
> be no point to cast or even have the macros wrapping the sizeof to
> start with.

Well I find it useful as I spend a fair bit of time re-reading
my code. To me a dozen upper case letters is easier to decode
than a sea of parentheses.

And the tide is moving back against "unsigned" types, at least in
C++. It is now regarded as a mistake the way STL introduced lots
of "unsigned" types and they are looking at whether they can move
some of them back to int.
Closer to home, I use ints wherever possible and the kernel seems
to favour them with negated errno return values. However the compiler
mindlessly warns about signed/unsigned comparisons when an int is
compared to a sizeof(). [If it had half a brain, it would check the
_value_ of the sizeof, and realize that often, even on an 8 bit
machine, there is no reason for the warning.]

Then there is the "Fortran rule" in checkpatch.pl (i.e. no lines
than 80 characters). "(int)sizeof(struct sg_io_hdr)" is 30 characters
long and that length often pushes simple conditionals like:
     if (A > B)
onto two lines which IMO is stupid.

Doug Gilbert
