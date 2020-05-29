Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B92BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 14:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F8102073B
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 14:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgE2OAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 10:00:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33622 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2N77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 09:59:59 -0400
Received: by mail-pf1-f194.google.com with SMTP id n15so1427000pfd.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2020 06:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0JhDhkCRLmNi4bI8LXSKcDnl8daFhaVAs8wwIz31bxY=;
        b=p1Tk7dAjox4rYjW7RjKNZqmbLogNwWr75clbNeBndSI/g4TfQtMtftEvhqcZuNjkox
         0ehWftZYNfGrV+v0z0X3PMUumqe+SYQ0GZa8Hihh5IRwjlDyFTBnm9KYp/bi+mLDqq59
         XLNQRfYdv/W3Za0qI91B/pCEr4RDtFWNbndusLbVPMdAtZJIkOzy4YMsqVncqTNqOSkx
         AoKNgXu1NA1ImpCPegOSzcMrhilLgOY6C8xCIy4mwZuoiSiYTpqPntH+OBtzKewwPDek
         doNIgaB6HzCU6RpEThb9COKjnkhF8k1mIPB1ZwabdVLTqm69HL86vUEC+s/CHXf27UTU
         u74g==
X-Gm-Message-State: AOAM531aNvI8NLG16Vif8c1YuTe2eW6gtkcjSTemGR0pkAvr9T3BlOrN
        NFTpyx8DK57QPIMVcxyfVHgJEgPX
X-Google-Smtp-Source: ABdhPJwjJveWLgU4emw1qbls0anWHmMZTeKGDZ4QYaTQsfR+i6t8V3fyOwJIDL+Ib0+Ot1aauUITMQ==
X-Received: by 2002:a63:534d:: with SMTP id t13mr8638458pgl.32.1590760798318;
        Fri, 29 May 2020 06:59:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9d55:11e:7174:3ec6? ([2601:647:4000:d7:9d55:11e:7174:3ec6])
        by smtp.gmail.com with ESMTPSA id w185sm969695pfw.145.2020.05.29.06.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 06:59:57 -0700 (PDT)
Subject: Re: [PATCH] scsi_debug: implement 'sdebug_lun_format' and update
 max_lun
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org
References: <20200529133942.146413-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <d8e4690c-b7be-9aca-1a31-052ab93f4d01@acm.org>
Date:   Fri, 29 May 2020 06:59:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529133942.146413-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-29 06:39, Hannes Reinecke wrote:
> -/* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
> - * or "peripheral device" addressing (value 0) */
> +/* If REPORT LUNS has luns >= 256 it should choose "flat space" (value 1)
> + * instead of "peripheral device" addressing (value 0) */
>  #define SAM2_LUN_ADDRESS_METHOD 0

How about introducing an enumeration type instead of using #define?

>  /* SDEBUG_CANQUEUE is the maximum number of commands that can be queued
> @@ -666,6 +666,7 @@ static bool have_dif_prot;
>  static bool write_since_sync;
>  static bool sdebug_statistics = DEF_STATISTICS;
>  static bool sdebug_wp;
> +static int sdebug_lun_format = SAM2_LUN_ADDRESS_METHOD;

How about using an enumeration type instead of 'int'?

> +static ssize_t lun_format_show(struct device_driver *ddp, char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_lun_format);
> +}

How about inserting a blank line after this function definition?

> +static ssize_t lun_format_store(struct device_driver *ddp, const char *buf,
> +				size_t count)
> +{
> +	int n;
> +	bool changed;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {

Isn't the recommended coding style to place constants at the right side
of comparisons? How about leaving out the superfluous parentheses? Such
parentheses may hide bugs because these suppress compiler warnings about
using assignments in if-conditions.

> +		if (n > 2) {
> +			pr_warn("only formats 0 and 1 are supported\n");
> +			return -EINVAL;
> +		}

How about introducing a symbolic name for the constant '2'?


> +	if (sdebug_lun_format > 2) {
> +		pr_warn("Invalid LUN format %u, using default\n",
> +			sdebug_lun_format);
> +		sdebug_lun_format = SAM2_LUN_ADDRESS_METHOD;
> +	}

How about using a symbolic name instead of the constant '2'?

>  	if (sdebug_max_luns > 256) {
> -		pr_warn("max_luns can be no more than 256, use default\n");
> -		sdebug_max_luns = DEF_MAX_LUNS;
> +		if (sdebug_max_luns > 16384) {
> +			pr_warn("max_luns can be no more than 16384, use default\n");
> +			sdebug_max_luns = DEF_MAX_LUNS;
> +		}
> +		sdebug_lun_format = 1;
>  	}

How about changing the constant '1' into a symbolic name?

Thanks,

Bart.
