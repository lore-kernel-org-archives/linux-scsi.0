Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CACFC433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 15:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277EC207C4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 15:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410082AbgJPP27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 11:28:59 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:49707 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395234AbgJPP27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 11:28:59 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id A95E42EA04C;
        Fri, 16 Oct 2020 11:28:57 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id hFKK9n5f4d+J; Fri, 16 Oct 2020 11:21:41 -0400 (EDT)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 9D0922EAD00;
        Fri, 16 Oct 2020 11:28:56 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/4] scatterlist: add sgl_copy_sgl() function
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201016045258.16246-1-dgilbert@interlog.com>
 <20201016045258.16246-3-dgilbert@interlog.com>
 <e04e9a03-1bbc-54ad-659f-7ad176d81019@gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <ebf8e2fb-71ab-c5b0-19c1-7454b29d5d90@interlog.com>
Date:   Fri, 16 Oct 2020 11:28:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e04e9a03-1bbc-54ad-659f-7ad176d81019@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-16 7:17 a.m., Bodo Stroesser wrote:
> Hi Douglas,
> 
> AFAICS this patch - and also patch 3 - are not correct.
> When started with SG_MITER_ATOMIC, sg_miter_next and sg_miter_stop use
> the k(un)map_atomic calls. But these have to be used strictly nested
> according to docu and code.
> The below code uses the atomic mappings in overlapping mode.

That being the case, I'll add d_flags and s_flags arguments that are
expected to take either 0 or SG_MITER_ATOMIC and re-test. There probably
should be a warning in the notes not to set both d_flags and s_flags
to SG_MITER_ATOMIC.

My testing to date has not been in irq or soft interrupt state. I
should be able to rig a test for the latter.

Thanks
Doug Gilbert

> Am 16.10.20 um 06:52 schrieb Douglas Gilbert:
>> Both the SCSI and NVMe subsystems receive user data from the block
>> layer in scatterlist_s (aka scatter gather lists (sgl) which are
>> often arrays). If drivers in those subsystems represent storage
>> (e.g. a ramdisk) or cache "hot" user data then they may also
>> choose to use scatterlist_s. Currently there are no sgl to sgl
>> operations in the kernel. Start with a copy.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   include/linux/scatterlist.h |  4 ++
>>   lib/scatterlist.c           | 86 +++++++++++++++++++++++++++++++++++++
>>   2 files changed, 90 insertions(+)
>>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index 80178afc2a4a..6649414c0749 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -321,6 +321,10 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, 
>> unsigned int nents,
>>   size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
>>                  size_t buflen, off_t skip);
>> +size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t 
>> d_skip,
>> +            struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
>> +            size_t n_bytes);
>> +
>>   /*
>>    * Maximum number of entries that will be allocated in one piece, if
>>    * a list larger than this is required then chaining will be utilized.
>> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>> index d5770e7f1030..1ec2c909c8d4 100644
>> --- a/lib/scatterlist.c
>> +++ b/lib/scatterlist.c
>> @@ -974,3 +974,89 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned 
>> int nents,
>>       return offset;
>>   }
>>   EXPORT_SYMBOL(sg_zero_buffer);
>> +
>> +/**
>> + * sgl_copy_sgl - Copy over a destination sgl from a source sgl
>> + * @d_sgl:         Destination sgl
>> + * @d_nents:         Number of SG entries in destination sgl
>> + * @d_skip:         Number of bytes to skip in destination before copying
>> + * @s_sgl:         Source sgl
>> + * @s_nents:         Number of SG entries in source sgl
>> + * @s_skip:         Number of bytes to skip in source before copying
>> + * @n_bytes:         The number of bytes to copy
>> + *
>> + * Returns the number of copied bytes.
>> + *
>> + * Notes:
>> + *   Destination arguments appear before the source arguments, as with memcpy().
>> + *
>> + *   Stops copying if the end of d_sgl or s_sgl is reached.
>> + *
>> + *   Since memcpy() is used, overlapping copies (where d_sgl and s_sgl belong
>> + *   to the same sgl and the copy regions overlap) are not supported.
>> + *
>> + *   If d_skip is large, potentially spanning multiple d_nents then some
>> + *   integer arithmetic to adjust d_sgl may improve performance. For example
>> + *   if d_sgl is built using sgl_alloc_order(chainable=false) then the sgl
>> + *   will be an array with equally sized segments facilitating that
>> + *   arithmetic. The suggestion applies to s_skip, s_sgl and s_nents as well.
>> + *
>> + **/
>> +size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t 
>> d_skip,
>> +            struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
>> +            size_t n_bytes)
>> +{
>> +    size_t d_off, s_off, len, d_len, s_len;
>> +    size_t offset = 0;
>> +    struct sg_mapping_iter d_iter;
>> +    struct sg_mapping_iter s_iter;
>> +
>> +    if (n_bytes == 0)
>> +        return 0;
>> +    sg_miter_start(&d_iter, d_sgl, d_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
>> +    sg_miter_start(&s_iter, s_sgl, s_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
>> +    if (!sg_miter_skip(&d_iter, d_skip))
>> +        goto fini;
>> +    if (!sg_miter_skip(&s_iter, s_skip))
>> +        goto fini;
>> +
>> +    for (d_off = 0, s_off = 0; true ; ) {
>> +        /* Assume d_iter.length and s_iter.length can never be 0 */
>> +        if (d_off == 0) {
>> +            if (!sg_miter_next(&d_iter))
>> +                break;
>> +            d_len = d_iter.length;
>> +        } else {
>> +            d_len = d_iter.length - d_off;
>> +        }
>> +        if (s_off == 0) {
>> +            if (!sg_miter_next(&s_iter))
>> +                break;
>> +            s_len = s_iter.length;
>> +        } else {
>> +            s_len = s_iter.length - s_off;
>> +        }
>> +        len = min3(d_len, s_len, n_bytes - offset);
>> +
>> +        memcpy(d_iter.addr + d_off, s_iter.addr + s_off, len);
>> +        offset += len;
>> +        if (offset >= n_bytes)
>> +            break;
>> +        if (d_len == s_len) {
>> +            d_off = 0;
>> +            s_off = 0;
>> +        } else if (d_len < s_len) {
>> +            d_off = 0;
>> +            s_off += len;
>> +        } else {
>> +            d_off += len;
>> +            s_off = 0;
>> +        }
>> +    }
>> +fini:
>> +    sg_miter_stop(&d_iter);
>> +    sg_miter_stop(&s_iter);
>> +    return offset;
>> +}
>> +EXPORT_SYMBOL(sgl_copy_sgl);
>> +
>>

