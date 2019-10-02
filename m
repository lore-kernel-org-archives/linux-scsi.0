Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EA7C10F14
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 18:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9973E21783
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 18:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJBSAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 14:00:20 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39585 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 14:00:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id v4so10839289pff.6
        for <linux-scsi@vger.kernel.org>; Wed, 02 Oct 2019 11:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=257ke6vJoBpBBblRtTnM9PI4FO78Xqk64Pq6Km5YiwY=;
        b=JVlXb09ux9Y/IDUFmutZ4ihgY8YF7KDcGMBNW5GqrWZGJFGXStYgR4ngSl7UOpZHqh
         WPPU7FbeLk6xy7vUmel+V86fVwTqMgp6t9GHdAPVXM24HhhId4Vqq1neo4Z9Yh5YHIKQ
         YWKi3BnHDX4arw42EJQ92T2AsFU1z8SbkJ4t+UwWgrmRQ7TJokhXMsgHyxkVz+IbnjMW
         FCbQhfFzs8WHVjDzsbWzeWXS+GFe7aGHpqWmhIwyN251Xg05dATO6kVGVs5M1rchzDXi
         2up76/D7le/YlJjxEbIdYwl/sbKxykVhjd6hCPnj7Sk6tkZ93wGoNSgOm8XS9lYazeY3
         xoRg==
X-Gm-Message-State: APjAAAV61MeCxMGrTqENX6dGMH66HS8HBRbtBYWqiAz7qGyff8EkoPZg
        LwwP//4i6SSv9PVPBty5KVo=
X-Google-Smtp-Source: APXvYqw5tB359rIurLCKqP9lvEtcOtjWuDUCs4AF2kPVGLgwp7Q6Q3G2yY2JOqptuVShpICw2in6VA==
X-Received: by 2002:a65:6709:: with SMTP id u9mr5221481pgf.59.1570039217745;
        Wed, 02 Oct 2019 11:00:17 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id r18sm116551pfc.3.2019.10.02.11.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 11:00:16 -0700 (PDT)
Subject: Re: [PATCH v3] scsi_debug: randomize command duration option
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de
References: <20191002032707.19918-1-dgilbert@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c15cbefb-87d9-e624-184e-c65ef386b79e@acm.org>
Date:   Wed, 2 Oct 2019 11:00:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002032707.19918-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/1/19 8:27 PM, Douglas Gilbert wrote:
> -			kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
> -		} else
> -			kt = ndelay;
> +			u64 ns = jiffies_to_nsecs(delta_jiff);
> +
> +			if (sdebug_random && ns < U32_MAX) {
> +				ns = prandom_u32_max((u32)ns);
> +			} else if (sdebug_random) {
> +				ns >>= 12;	/* scale to 4 usec precision */
> +				if (ns < U32_MAX)	/* over 4 hours max */
> +					ns = prandom_u32_max((u32)ns);
> +				ns <<= 12;

An explanation of how the scaling factor has been chosen is missing.

Is it user friendly to disable randomization silently if delta_jiff 
exceeds a certain value? How about restricting delta_jiff to e.g. ten 
times the SCSI timeout?

> +		} else {	/* ndelay has a 4.2 second max */
> +			kt = sdebug_random ? prandom_u32_max((u32)ndelay) :
> +					     (u32)ndelay;
> +		}

Are these (u32) casts necessary?

> +static ssize_t random_show(struct device_driver *ddp, char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_random);
> +}

Is the (int) cast necessary?

> +static ssize_t random_store(struct device_driver *ddp, const char *buf,
> +			    size_t count)
> +{
> +	int n;
> +
> +	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
> +		sdebug_random = (n > 0);
> +		return count;
> +	}
> +	return -EINVAL;
> +}
> +static DRIVER_ATTR_RW(random);

Is the "count > 0" check useful? I don't think that sysfs ever passes 
count == 0 to store callback functions.

Thanks,

Bart.
