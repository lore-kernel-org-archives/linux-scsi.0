Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFF9C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B7D2080C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbgFSObI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:31:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32801 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgFSObD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 10:31:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id b201so4522551pfb.0;
        Fri, 19 Jun 2020 07:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eS+eTyAnDjmjG5xsA2jATG0/F8Fy3/HayP+anlrhxlQ=;
        b=EST5H3fUPoLvN4am7NFuOXqAKO/n9j2Pb4BvDevucZbab8hYDckQhWHFi1A/KqnRZX
         oG4ya9e+3HOaPnEEPttZ6cL66BcVDQxLyqGIcVBj+FAU7ayqsKpLtyJRhVAGEHkzldz7
         QiapefcQeLUp6A45n4BZsVdTnhWdLvRRRX2P8VjIKfRUHwVomXGRgnzFbu3wvP/zFkAI
         L3IJODzxIvwtYxE9gmKU82BmIrhY8CZhQxJxbWrNNgAOhPXZSFuil0+dZpFBvXC2ZgOn
         8Z8xLgi3o0KU235D2f4E2DjTP53W68+8roeQNowJCpCMQkby2D+R3zTCIybvpvDVlyKC
         QnLA==
X-Gm-Message-State: AOAM533qoiOHSC3Xn9iXblcQha4zpDG8sFjkLzfLS6drFn0Dj+wxJOYj
        v0d7ssasghCtgUD6AIQnk28=
X-Google-Smtp-Source: ABdhPJyP9/UwHXC7d8zTIQdsvKh6psIRlBalaUg5cDkNDuVzdba2MtRHCzU2R0Bn5j53J7hU8oFxsA==
X-Received: by 2002:a63:8dc4:: with SMTP id z187mr2995522pgd.199.1592577062762;
        Fri, 19 Jun 2020 07:31:02 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id gq8sm5394853pjb.14.2020.06.19.07.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:31:01 -0700 (PDT)
Subject: Re: [RFC PATCH ] scsi: remove scsi_sdb_cache
To:     Bean Huo <huobean@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     beanhuo@micron.com
References: <20200619131042.10759-1-huobean@gmail.com>
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
Message-ID: <acdceada-b183-e41a-8645-aa3716b55236@acm.org>
Date:   Fri, 19 Jun 2020 07:31:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619131042.10759-1-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-19 06:10, Bean Huo wrote:
> @@ -2039,7 +2024,6 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
>  		real_buffer[1] = data->medium_type;
>  		real_buffer[2] = data->device_specific;
>  		real_buffer[3] = data->block_descriptor_length;
> -		
>  
>  		cmd[0] = MODE_SELECT;
>  		cmd[4] = len;
> @@ -2227,7 +2211,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>  			goto illegal;
>  		}
>  		break;
> -			
> +
>  	case SDEV_RUNNING:
>  		switch (oldstate) {
>  		case SDEV_CREATED:

If these whitespace changes are left out, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
