From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: scsi: Drivers not ready for sg-chaining
Date: Sun, 10 Feb 2008 18:08:40 +0200
Message-ID: <47AF2188.2030400@panasas.com>
References: <478F8435.5000907@panasas.com>  <478F878F.6040807@panasas.com> <1202658166.3136.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5739 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbYBJQIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 11:08:45 -0500
In-Reply-To: <1202658166.3136.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Feb 10 2008 at 17:42 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-01-17 at 18:51 +0200, Boaz Harrosh wrote:
>> All below drivers are not sg-chain ready do to incomplete software.
>>   Once fixed they can move back to SG_ALL. For now they are stuck on
>>   SCSI_MAX_SG_SEGMENTS.
>>
>>   Affected drivers/files:
>> 	drivers/scsi/aha152x.c
> 
> This seems to process an element at a time and should be fixed by
> sg_next()
> 
>> 	drivers/scsi/esp_scsi.[ch]
> 
> As does this.
> 
>> 	drivers/scsi/imm.c
> 
> And this.
> 
>> 	drivers/scsi/in2000.h
> 
> And this (.c not .h)
> 
>> 	drivers/scsi/pcmcia/nsp_cs.c
> 
> This uses a software table, so should be fine.
> 
>> 	drivers/scsi/ppa.c
> 
> This does element at a time, so should be fixed by sg_next()
> 
>> 	drivers/scsi/tmscsim.c
> 
> as does this.
> 
> Given where we are in the cycle, it's probably best just to set SG_ALL
> to 128 so there's no possibility of problems.  Individual drivers can
> make the tradeoff on how they handle larger lists going beyond this.
> 
> James
> 
> ---
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index d1299e9..530ff4c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -6,6 +6,7 @@
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
>  #include <linux/mutex.h>
> +#include <scsi/scsi.h>
>  
>  struct request_queue;
>  struct block_device;
> @@ -25,12 +26,15 @@ struct blk_queue_tags;
>   * NONE: Self evident.	Host adapter is not capable of scatter-gather.
>   * ALL:	 Means that the host adapter module can do scatter-gather,
>   *	 and that there is no limit to the size of the table to which
> - *	 we scatter/gather data.
> + *	 we scatter/gather data.  The value we set here is the maximum
> + *	 single element sglist.  To use chained sglists, the adapter
> + *	 has to set a value beyond ALL (and correctly use the chain
> + *	 handling API.
>   * Anything else:  Indicates the maximum number of chains that can be
>   *	 used in one scatter-gather request.
>   */
>  #define SG_NONE 0
> -#define SG_ALL 0xff
> +#define SG_ALL	SCSI_MAX_SG_SEGMENTS
>  
>  #define MODE_UNKNOWN 0x00
>  #define MODE_INITIATOR 0x01
> 
> 
> James
> 
> 

My patches *do not* attempt to fix the sg_chaining support. They only
make all the drivers that use SG_ALL to use SCSI_MAX_SG_SEGMENTS.
One by One, and not globally as your suggestion.

This is for two reasons.
1. So drivers can be individually fixed and in the patch that fixes them
   they can go back to SG_ALL.

2. Those drivers that have been using SG_ALL correctly and were converted
   to support sg-chaining are not penalized because of bad/old drivers

3. Some drivers in this patchset are converted to use a real internal
   driver limit. That does not necessarily match SCSI_MAX_SG_SEGMENTS.
   In the event that SCSI_MAX_SG_SEGMENTS wants to change.

The bulk of the patchset is very much mechanical and is not dangerous
and was ACKed by the more important maintainers. (That is where the
changes are more then trivial). So I don't see why they cannot get
a proper review and be accepted. Instead of doing the safe but the
wrong thing, cross tree.

Boaz
