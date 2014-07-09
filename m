From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/6] scsi: use 64-bit value for 'max_luns'
Date: Wed, 09 Jul 2014 09:30:19 +0930
Message-ID: <87a98j765o.fsf@rustcorp.com.au>
References: <1401785937-43581-1-git-send-email-hare@suse.de> <1401785937-43581-6-git-send-email-hare@suse.de> <20140625122856.GA3221@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625122856.GA3221@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
> On Tue, Jun 03, 2014 at 10:58:56AM +0200, Hannes Reinecke wrote:
>> Now that we're using 64-bit LUNs internally we need to increase
>> the size of max_luns to 64 bits, too.
>> 
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>> Reviewed-by: Ewan Milne <emilne@redhat.com>
>
> I just noticed that this has changes to the module param code.
> These should be split into a separate patch and be ACKed by the modules
> maintainer.  I'd still love to take the change through the SCSI tree to
> be able to get this into 3.17 easily.
>
> moduleparam changes below:
>
>> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
>> index 204a677..21e2ba6 100644
>> --- a/include/linux/moduleparam.h
>> +++ b/include/linux/moduleparam.h
>> @@ -381,6 +381,11 @@ extern int param_set_ulong(const char *val, const struct kernel_param *kp);
>>  extern int param_get_ulong(char *buffer, const struct kernel_param *kp);
>>  #define param_check_ulong(name, p) __param_check(name, p, unsigned long)
>>  
>> +extern struct kernel_param_ops param_ops_ullong;
>> +extern int param_set_ullong(const char *val, const struct kernel_param *kp);
>> +extern int param_get_ullong(char *buffer, const struct kernel_param *kp);
>> +#define param_check_ullong(name, p) __param_check(name, p, unsigned long long)
>> +
>>  extern struct kernel_param_ops param_ops_charp;
>>  extern int param_set_charp(const char *val, const struct kernel_param *kp);
>>  extern int param_get_charp(char *buffer, const struct kernel_param *kp);
>
>> diff --git a/kernel/params.c b/kernel/params.c
>> index b00142e..2b2a9dd 100644
>> --- a/kernel/params.c
>> +++ b/kernel/params.c
>> @@ -253,6 +253,7 @@ STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
>>  STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
>>  STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
>>  STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
>> +STANDARD_PARAM_DEF(ullong, unsigned long long, "%llu", kstrtoull);

Thanks Christoph!

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
