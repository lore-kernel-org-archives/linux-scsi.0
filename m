Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3911C55179
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 15:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4849C21D47
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 15:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465800AbgJWP1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 11:27:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43595 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462196AbgJWP1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 11:27:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id r10so1505942pgb.10;
        Fri, 23 Oct 2020 08:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BLVFBML2Vwax1XyDeMppx9C3lOBX85F9Q67T1CeljKY=;
        b=PW7flJX+qlxsMTWjY8G8NIIrIK34rAfZdykbHO3sgOht/xqz678v2jiPwLqHDgSnwY
         WuBYNtZCVdTHlvLqUB8yhJkcXTc/LsSZHUDtU7TyVdz6JMsb5nhBV6F9m/Xel+TkQ3j5
         d+Gj2pWOr24Rnsylx6FB0A2hqRI3oephUxKE2kPN/PwaUf/TU9Nxs8yy/hLNQcckKdbP
         pw14y4nGg8Fss320J1DzKuY866UlSBJ9VfZGulCian5EaHnZo0moL13tz5vyw5QzWBAR
         tn0qi29TrBaqYSAn9VAB0iMgxFmTe/Qdg+VOLMwP7NX6ylFPWfsXgGBESwodNCsSLzmp
         0gmg==
X-Gm-Message-State: AOAM530F7pTzSMc2ZGovDX5V2q8hC2FCALIz/1P6r0UhXnpNppnTE8Ko
        gF9eBgVruTrs76vmyO5azxSdE8NAxV1KPw==
X-Google-Smtp-Source: ABdhPJxKO0uOkptR8CUzV7g074wD+rgIs0xpvIRLo8ZQpNiEBUz3XTXUQ4A03M1xKLM9YaBFCJL6oA==
X-Received: by 2002:a17:90a:e997:: with SMTP id v23mr3037101pjy.195.1603466834441;
        Fri, 23 Oct 2020 08:27:14 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u21sm2243209pfk.89.2020.10.23.08.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 08:27:12 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
To:     Chanho Park <chanho61.park@samsung.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
 <20201020070516.129273-1-chanho61.park@samsung.com>
 <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
 <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
 <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
 <008a01d6a830$1a109800$4e31c800$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6e204521-74e4-cc6c-27e7-3a290c492793@acm.org>
Date:   Fri, 23 Oct 2020 08:27:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <008a01d6a830$1a109800$4e31c800$@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/20 9:59 PM, Chanho Park wrote:
>> Please use udev or systemd instead of adding code in the UFS driver that
>> is
>> not necessary when udev or systemd is used.
>>
> 
> What I mentioned was how it can be handled when we mount rootfs directly from kernel.
> 
> 1) kernel -> initramfs (mount root) -> systemd
> 2) kernel (mount root) -> systemd
>   -> In this case, we normally use root=/dev/sda1 from kernel commandline to mount the rootfs.
> 
> Like fstab can support legacy node mount, ufs driver also needs to provide
> an option for using the permanent legacy node. If you're really worry about > adding a new codes for all UFS driver, we can put this as controller specific> or optional feature.

The only code that should occur in the UFS driver is code that is specific
to UFS devices. Since the functionality in this patch is not UFS specific,
it should be added elsewhere.

Additionally, since this functionality can be implemented easily in user
space, I think it should be implemented in user space instead of in the
kernel. Even when not using systemd or udev, it is easy to implement a loop
that waits until a certain LUN or WWID appears.

Bart.
