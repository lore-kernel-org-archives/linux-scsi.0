Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2F5C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA17321835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAWEoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:44:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46278 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgAWEoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:44:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so785212pll.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:44:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ZxgDylF718HoB+bPvw6qTbg2lWPho/gJhdVKa/DlYc=;
        b=DBltVOSB7Q6ojZ2qngUfzewPvV1zXxWNGV6K6JipRq3v4mYsrL+hf+An7E6tGf4kgx
         uaUWqbrgR3pbMQRPkBF6AS6WYkSra0hmMgO2rKmqlMjkNnh7Xpiu6zS/g9wt0XZcHDv5
         koIiF3h875JpRbhEVZ2XumPUSPNAk2UXA55faTOAFnWBcYpKEXE9uD4+PA0NutIIbDrL
         Civ3sfbFAaY7ybUc3erd4igGw3NRZkJpBRK+Ax80OgF7JUaiNOfuwvIlrRb0f4/J1ywy
         kGkCGlYggIoUiDl0U/61BCWiLs0LlfIA6MnxP8wA057fZrKYKGCCcmQrmKXV6nxOrSAy
         Kk9w==
X-Gm-Message-State: APjAAAVzqF16ps9a4pC8rsJHUgWIeNIwH7UVFmTs9SzpRou9ma7myTnD
        QRj6JV7b9F0uhuvuskBjvcSnBQmV
X-Google-Smtp-Source: APXvYqyXi7oT2JBIz9hGjXz6xRcRSecvF1sGpPqN5HqhqAF7zStg+CbugMavprmX6/GErRtJyx5ArA==
X-Received: by 2002:a17:90a:8042:: with SMTP id e2mr2415528pjw.16.1579754653969;
        Wed, 22 Jan 2020 20:44:13 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:d957:4568:237a:bc62? ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id c14sm585556pfn.8.2020.01.22.20.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 20:44:13 -0800 (PST)
Subject: Re: [PATCH] scsi: add attribute to set lun queue depth on all luns on
 shost
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200121235302.9955-1-jsmart2021@gmail.com>
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
Message-ID: <eba0f027-f2d0-7209-c34d-78b0b93a9a78@acm.org>
Date:   Wed, 22 Jan 2020 20:44:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121235302.9955-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-21 15:53, James Smart wrote:
> +static int
> +sdev_set_queue_depth(struct scsi_device *sdev, int depth)
> +{
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	int retval;
> +
> +	retval = sht->change_queue_depth(sdev, depth);
> +	if (retval < 0)
> +		return retval;
> +
> +	sdev->max_queue_depth = sdev->queue_depth;
> +
> +	return 0;
> +}

'sht' is only used once, so I'm not sure whether it is worth it to keep
that local variable.

> +static ssize_t
> +store_host_lun_queue_depth(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct scsi_host_template *sht = shost->hostt;
> +	struct scsi_device *sdev;
> +	int depth, retval;
> +
> +	if (!sht->change_queue_depth)
> +		return -EINVAL;
> +
> +	depth = simple_strtoul(buf, NULL, 0);
> +	if (depth < 1 || depth > shost->can_queue)
> +		return -EINVAL;
> +
> +	shost_for_each_device(sdev, shost) {
> +		retval = sdev_set_queue_depth(sdev, depth);
> +		if (retval != 0)
> +			sdev_printk(KERN_INFO, sdev,
> +				"failed to set queue depth to %d (err %d)",
> +				depth, retval);
> +	}
> +
> +	return count;
> +}

Returning -EINVAL from all error paths makes it impossible to tell the
difference between a value that is out of range and queue depth changes
not being supported. Should another error code be returned if
sht->change_queue_depth == NULL?

> @@ -992,12 +1037,10 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
>  	if (depth < 1 || depth > sdev->host->can_queue)
>  		return -EINVAL;
>  
> -	retval = sht->change_queue_depth(sdev, depth);
> +	retval = sdev_set_queue_depth(sdev, depth);
>  	if (retval < 0)
>  		return retval;
>  
> -	sdev->max_queue_depth = sdev->queue_depth;
> -
>  	return count;
>  }

How about splitting this patch into two patches: one that introduces the
function sdev_set_queue_depth() and a second patch that introduces the
lun_queue_depth sysfs attribute?

Thanks,

Bart.
