Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B7AC2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 16:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FEC217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 16:02:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqymz4bb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgBMQC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 11:02:28 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40557 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388287AbgBMQC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 11:02:27 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so2599015pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2020 08:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hVrsdnuvDqO8d5RxwZITUcgpQUZuGnOUAkOJjAWAeSc=;
        b=bqymz4bbnz/uGooKU++Gci42BVLC7ER6w5ypkEU/bnOQE4aLMaB/b3aDJwVKMwukzd
         fV6zOhyo5GnBTZs9VaDX+xKVzdyo18dUX6JVEJ92WNNy3QZ9zqKT2NM/aJhrDKkWqz97
         1iDBFKBr+ZSCEFUYuKQEu+VWhf1C3iNFDo22MnqyW5ZRbBqpwrVCrKpAACl3LcmnZlkg
         0HYAQaQj9WkyWR0MXg1qJ0az3Sli+tiGKRZix0b657WTYFt/twVjhdPuEdcYLBV4SPXa
         F6LlKb85xlzhwMwtH5Q+CIeHMBtQlL+pyQF4pfWOYqdcZcsFd9p/MGr488d3gfhVbD5/
         F/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hVrsdnuvDqO8d5RxwZITUcgpQUZuGnOUAkOJjAWAeSc=;
        b=Xux9cQ4ICCw8Y5t5HWpaONu6a/O2Oo7J+HK6XFLJS1rdieyIi0FpYL3XLjz3GfGoCa
         jO/q78aLsX8PVNuVw7qg/9o2lxMX8ePLOflI/O7m6rzMoDyQyc0bc05Wj2vgn0rGuHH/
         +/hBtc0x136OITEib671kLpHM9O+kFrWgype68sG0YKQLN0XcWF9nwTMSw58p9CaH66X
         LyPpj0GZ/v8hj5/te15THkwVrRoFCSWnSMYZa2t1/teqBKx/pKkLJFtvgZD4/DdVgrQ0
         PLFCwqSdL4RrxzLV7j6OInl4y4+sS+Ay3xbTHKaPsNjUSYmmq+8K2JPUQEG0e5Muy8Zr
         6OKg==
X-Gm-Message-State: APjAAAUE4eBX5hmKRyOmxhtpOs+kdLQAHhP3P7qVgfDGyS+Xd5YHYGCn
        4UbHzuC0e2XlmNr+kjWwg5em9May
X-Google-Smtp-Source: APXvYqymo4t6yus5lA4ARRP92do9uNCgs2FfdZcsXcYrS8KXnPV1WNFgmpmvw2ZHZHCYQsz6V8dw5A==
X-Received: by 2002:a17:90a:de05:: with SMTP id m5mr6000239pjv.10.1581609745934;
        Thu, 13 Feb 2020 08:02:25 -0800 (PST)
Received: from [10.230.31.62] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t16sm3875302pgo.80.2020.02.13.08.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 08:02:25 -0800 (PST)
Subject: Re: [PATCH v2 1/2] fc: Update Descriptor definition and add RDF and
 Link Integrity FPINs
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org
References: <20200210173155.547-2-jsmart2021@gmail.com>
 <202002131725.WpnYjjEN%lkp@intel.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <4b1a9f43-7d1a-ed12-8c49-bac9517a2e1a@gmail.com>
Date:   Thu, 13 Feb 2020 08:02:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202002131725.WpnYjjEN%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/13/2020 2:00 AM, kbuild test robot wrote:
> Hi James,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on mkp-scsi/for-next linus/master v5.6-rc1 next-20200213]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/James-Smart/lpfc-Add-Link-Integrity-FPIN-registration-and-logging/20200213-051448
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: i386-randconfig-g002-20200213 (attached as .config)
> compiler: gcc-7 (Debian 7.5.0-4) 7.5.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>     In file included from <command-line>:32:0:
>     ./usr/include/scsi/fc/fc_els.h: In function 'fc_tlv_next_desc':
>>> ./usr/include/scsi/fc/fc_els.h:274:4: error: implicit declaration of function 'be32_to_cpu'; did you mean '__be32_to_cpu'? [-Werror=implicit-function-declaration]
>        (be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
>         ^
>>> ./usr/include/scsi/fc/fc_els.h:286:17: note: in expansion of macro 'FC_TLV_DESC_SZ_FROM_LENGTH'
>       return (desc + FC_TLV_DESC_SZ_FROM_LENGTH(tlv));
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
>     cc1: some warnings being treated as errors
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

Can you tell me what it was that was built that failed.
This should have been addressed by the "#include <asm/byteorder.h>" at 
the top of the header.

I'm suspecting it's a non-kernel entity, so the header didn't resolve as 
it should (perhaps the suggestion should be used instead).

-- james

