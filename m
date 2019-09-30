Return-Path: <SRS0=m3i9=XZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137F3C32792
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 15:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E354F2075D
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 15:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbfI3PrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 11:47:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44840 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731945AbfI3PrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 11:47:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id i14so7590770pgt.11
        for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2019 08:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZNr0Qdh4Y7E67NTsHM3E6/5AZa/J2JZ5VwPUfwnEjA=;
        b=ZbQtmd34IJyGMT1kvJ3Fe8fCfV0BExml/ZqVIajp2W7SE+m/pFVgp+5wnTcMYL04fe
         22h9C/vibeS1QuUttn/XEIzXPogWIws29MYMeqn+2PuJYh1adrdYvjSTg4gZHlrdNZUc
         lXYZHOEdZHwn1mRi8/JxT17gKJfDAZd+Hp3sp65keDypXyLO8Qz7l0mdNtt/7rffFTxr
         Hm6PS3ZLrYdkZlhs+KvbDcyGkQHoygMhlZqej6Vz8+DSKRdnKjMbdOyms1hQD8MDJ+KY
         eSj7THeKGOtztnmQ8Wzd2YZnQZXAoJgFcRm0fvFAsnp5eYY53X2VhQFTxRv9kPOqVOKt
         Wy3Q==
X-Gm-Message-State: APjAAAUVJJXRoJe62Id3q+9mOWyv1rx1ZHEOuTO9amXrHMgoEDY1aJMu
        EjEgZlNxo6UilM+A3Hb4Fm8=
X-Google-Smtp-Source: APXvYqytf+9PLCOhmsuYlNDe13504m2tQusldaMTyRGpSDDZrSWNT0Z1gVEfIiAg0JRsyxGKLbTYhA==
X-Received: by 2002:a17:90a:3847:: with SMTP id l7mr27817157pjf.118.1569858421523;
        Mon, 30 Sep 2019 08:47:01 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l1sm21874669pja.30.2019.09.30.08.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:47:00 -0700 (PDT)
Subject: Re: [PATCH v2] scsi_debug: randomize command duration option + %p
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de
References: <20190927140425.18958-1-dgilbert@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <743e705b-1314-c8cb-1a75-acc5029ee890@acm.org>
Date:   Mon, 30 Sep 2019 08:46:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927140425.18958-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/19 7:04 AM, Douglas Gilbert wrote:
> Add an option to use the given command delay (in nanoseconds)
> as the upper limit for command durations. A pseudo random
> number generator chooses each duration from the range:
>        [0..delay_in_ns)
> 
> Main benefit: allows testing with out-of-order responses.

Please clarify which code you want to test. I think out-of-order 
response handling in the SCSI core and block layer core is already being 
triggered by many storage workloads.

> @@ -4354,9 +4357,21 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   		ktime_t kt;
>   
>   		if (delta_jiff > 0) {
> -			kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
> -		} else
> -			kt = ndelay;
> +			u64 ns = (u64)delta_jiff * (NSEC_PER_SEC / HZ);

Has it been considered to use jiffies_to_nsecs() instead of open-coding 
that function?

> +			if (sdebug_random && ns < U32_MAX) {
> +				ns = prandom_u32_max((u32)ns);
> +			} else if (sdebug_random) {
> +				ns >>= 10;	/* divide by 1024 */
> +				if (ns < U32_MAX)  /* an hour and a bit */
> +					ns = prandom_u32_max((u32)ns);
> +				ns <<= 10;
> +			}
> +			kt = ns_to_ktime(ns);

Is it really necessary to use nanosecond resolution? Can the above code 
be simplified by using microseconds as time unit instead of nanoseconds?

> +MODULE_PARM_DESC(random, "1-> command duration chosen from [0..delay_in_ns) (def=0)");

Would this description become more clear if it would be changed into 
something like the following: "If set, uniformly randomize command 
duration between 0 and delay_in_ns" ?

> +static ssize_t random_show(struct device_driver *ddp, char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_random ? 1 : 0);
> +}

Since sdebug_random is either 0 or 1, is the "? 1 : 0" part necessary?

> +static ssize_t random_store(struct device_driver *ddp, const char *buf,
> +			    size_t count)
> +{
> +	int n;
> +
> +	if (count > 0 && 1 == sscanf(buf, "%d", &n) && n >= 0) {
> +		sdebug_random = (n > 0);
> +		return count;
> +	}
> +	return -EINVAL;
> +}

Has this patch been verified with checkpatch? I'm asking since 
checkpatch should complain about "1 == sscanf(...)". See also commit 
c5595fa2f1ce ("checkpatch: add constant comparison on left side test").

> @@ -5338,7 +5373,7 @@ static int __init scsi_debug_init(void)
>   		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
>   		dif_storep = vmalloc(dif_size);
>   
> -		pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
> +		pr_err("dif_storep %u bytes @ %pK\n", dif_size, dif_storep);
>   
>   		if (dif_storep == NULL) {
>   			pr_err("out of mem. (DIX)\n");

Is it useful to print the kernel pointer 'dif_storep'?

Thanks,

Bart.


