Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EE7C2BB84
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 16:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF2E21532
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 16:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgIGQ50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:57:26 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50782 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730770AbgIGQ5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 12:57:18 -0400
Received: by mail-pj1-f66.google.com with SMTP id b16so6975410pjp.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 09:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dA6rDnMFg0mD99hNAnDr1PDwwL0USk4CT5i18qEYCdo=;
        b=qlMYk9VAcR27w8QnbOaXgGkq5Pt0eXMuN6ZilfkN5XUir1t9+8vxEXunJv1fTjUvut
         tfZ+3WMA7ckSE9vsXHQ16mGLUp29xWZILYLEi/3aAbqaM4kDrToXtSTCEtww160coG1X
         dou3qfcgLdWpDm9cINebfOpGx2NL39OP1UKJJtByQMZdZiXURvdw133jdu9c7Bsd0SeB
         nSx/sLBX2SCr5Aem4ALqISQ5twdGb6PyPTvKrS+KzVPohrWy7+ILKaEvDmhLIYbEsAvH
         u/HMuX55KADx+rlnWIkZhIJ3Ll1bseBcvgqD7PS6LS0eWNjbUZu/ans8HXe5bgjoSW3I
         Ue6w==
X-Gm-Message-State: AOAM532A+luFebRHyNp3JHOtBj6ZbvVf8U5aHyuB2/g5A2+t+rfxw3mV
        i2HgI5EPPGP0uoX99Shxt6pka1XKfCE=
X-Google-Smtp-Source: ABdhPJwPJtLIEztJd3DaNQrnye4+G/ZgvbmdIRHA6TfsCk6wrHrSnUL8p78NF2sDq9UwJefcpiry8g==
X-Received: by 2002:a17:902:968d:: with SMTP id n13mr20232738plp.260.1599497836191;
        Mon, 07 Sep 2020 09:57:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ff58:da99:dd6f:be14? ([2601:647:4000:d7:ff58:da99:dd6f:be14])
        by smtp.gmail.com with ESMTPSA id s19sm15680112pfc.69.2020.09.07.09.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:57:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: take module reference during async scan
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
References: <20200907154745.20145-1-thenzl@redhat.com>
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
Message-ID: <8dbf8936-0b56-b3c3-c62e-657bd2c931c8@acm.org>
Date:   Mon, 7 Sep 2020 09:57:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907154745.20145-1-thenzl@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-07 08:47, Tomas Henzl wrote:
> During an async scan the driver shost->hostt structures are used,
> that may cause issues when the driver is removed at that time.
> As protection take the module reference.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a757..c9cc0862c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1825,6 +1825,8 @@ static void do_scan_async(void *_data, async_cookie_t c)
>  
>  	do_scsi_scan_host(shost);
>  	scsi_finish_async_scan(data);
> +
> +	module_put(shost->hostt->module);
>  }
>  
>  /**
> @@ -1848,6 +1850,12 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  		return;
>  	}
>  
> +	/* protection against surprise driver removal
> +	 * module_put is called from do_scan_async
> +	 */
> +	if (!try_module_get(shost->hostt->module))
> +		return;
> +
>  	/* register with the async subsystem so wait_for_device_probe()
>  	 * will flush this work
>  	 */

Shouldn't scsi_autopm_put_host(shost) be called if try_module_get() fails?

Please also update the following comment in scsi_scan_host():

	/* scsi_autopm_put_host(shost) is called in scsi_finish_async_scan() */

Thanks,

Bart.


