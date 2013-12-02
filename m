From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] drivers: scsi: scsi_lib.c: add prefix "SCSILIB_" to macro
 "SP"
Date: Mon, 02 Dec 2013 18:14:33 +0800
Message-ID: <529C5D89.8050809@gmail.com>
References: <528AEFB7.4060301@gmail.com>  <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>  <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>  <52955913.3060809@gmail.com> <529B60FF.7030601@acm.org>  <529BD584.7060504@gmail.com> <1385945387.20150.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57271 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3LBKOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 05:14:38 -0500
In-Reply-To: <1385945387.20150.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Bottomley@parallels.com, linux-scsi@vger.kernel.org, rkuo <rkuo@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 12/02/2013 08:49 AM, James Bottomley wrote:
> On Mon, 2013-12-02 at 08:34 +0800, Chen Gang wrote:
>> On 12/02/2013 12:17 AM, Bart Van Assche wrote:
>>> On 11/27/13 03:29, Chen Gang wrote:
>>>> the macro "SP" is too common to make conflict with some architectures,
>>>> so recommend to add prefix for it.
>>>>
>>>> The related warning (with allmodconfig for hexagon):
>>>>
>>>>     CC [M]  drivers/scsi/scsi_lib.o
>>>>   drivers/scsi/scsi_lib.c:46:0: warning: "SP" redefined [enabled by default]
>>>>   arch/hexagon/include/uapi/asm/registers.h:9:0: note: this is the location of the previous definition
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>> ---
>>>>  drivers/scsi/scsi_lib.c |   16 ++++++++--------
>>>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>> index 7bd7f0d..f78e21b 100644
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -43,28 +43,28 @@ struct scsi_host_sg_pool {
>>>>  	mempool_t	*pool;
>>>>  };
>>>>  
>>>> -#define SP(x) { x, "sgpool-" __stringify(x) }
>>>> +#define SCSILIB_SP(x) { x, "sgpool-" __stringify(x) }
>>>>  #if (SCSI_MAX_SG_SEGMENTS < 32)
>>>>  #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
>>>>  #endif
>>>>  static struct scsi_host_sg_pool scsi_sg_pools[] = {
>>>> -	SP(8),
>>>> -	SP(16),
>>>> +	SCSILIB_SP(8),
>>>> +	SCSILIB_SP(16),
>>>>  #if (SCSI_MAX_SG_SEGMENTS > 32)
>>>> -	SP(32),
>>>> +	SCSILIB_SP(32),
>>>>  #if (SCSI_MAX_SG_SEGMENTS > 64)
>>>> -	SP(64),
>>>> +	SCSILIB_SP(64),
>>>>  #if (SCSI_MAX_SG_SEGMENTS > 128)
>>>> -	SP(128),
>>>> +	SCSILIB_SP(128),
>>>>  #if (SCSI_MAX_SG_SEGMENTS > 256)
>>>>  #error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
>>>>  #endif
>>>>  #endif
>>>>  #endif
>>>>  #endif
>>>> -	SP(SCSI_MAX_SG_SEGMENTS)
>>>> +	SCSILIB_SP(SCSI_MAX_SG_SEGMENTS)
>>>>  };
>>>> -#undef SP
>>>> +#undef SCSILIB_SP
>>>>  
>>>>  struct kmem_cache *scsi_sdb_cache;
>>>
>>> Sorry but the "SCSILIB_SP" name doesn't look very descriptive to me.
>>> There are probably better choices possible. How about using e.g.
>>> SG_POOL() instead ?
>>>
>>
>> That sounds good to me, I will send patch v2, tomorrow (today I have
>> to do some another urgent things, if this patch is also urgent, please
>> help send). :-)
> 
> No, this is the wrong thing to do.  Exported headers should be namespace
> protected, so the thing wrong is what's exporting the problem to us,
> namely hexagon.
> 

If one issue occurs, normally, both sides need improvement.

For our issue:

 - need try to keep uapi no touch ("arch/hexagon/uapi/asm/registers.h").

 - improving our module is much easier than improving hexagon.

 - for 'SP', it is really short enough to like a register name.
   SG_POOL seems more suitable for our 'sgpool' related operations.


It will be better to improve hexagon too, but it is not quit easy (maybe
have to bear it), it is uapi :-(


Thanks
-- 
Chen Gang
