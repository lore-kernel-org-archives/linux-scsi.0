Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEB1CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 23:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA00121D7B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 23:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXCkpb1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfJYXEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 19:04:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53286 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfJYXEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 19:04:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id n7so3796449wmc.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 16:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SF2xbLp7P3CJc2fTZ8kKR4Taz0ZESlIvku4TwnIuy+Q=;
        b=CXCkpb1CAaG1i788ADmKkFhG2RlKHLWVo5WQZrKA/Vkj3Zej1ou3tx+RT6lXoXV/ly
         mnB3+7sBmp9joDAUDBCtiCP4YQiXB9mwouhAvd/HlNFTrNn9FQADm/P5HLlbJFvMHPeq
         VC5/7chDnlE7zBsrL6CZUMoG+FH4Eb7SBazl5B22pD8yEcFvyDUFtUQ2naiuDwtpSM37
         oE1Tjbzvvl54oyjsvKCPt7NWaNdqikzwEswaS1p4id3SiW1pcmq9uGjkAahqxAnE58jd
         S+6jPJaPplpY3aJGmkV5RqGE8gjGis20SPAHjCPCTRoEmfg/aqwsb1xk3wgBgiMCCseL
         i3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SF2xbLp7P3CJc2fTZ8kKR4Taz0ZESlIvku4TwnIuy+Q=;
        b=BkoXlWrKz0nqlj8FyNLOncYsmJ63m92Qq97FdRVq6thQotCVUy2JkW/v9zl+sleXlt
         XCthD5BJX9vq8oCwYMCZATV4gjAl9ATVmD4YLtrMmKBjvk8rgmfNCflfVIcuOAQnUOBU
         N+LRwoGtBS747aDQgj64urX0M6LmGLblw80jB2ha91Gu7Kh7IYwILkiUGz5AzZpp26wo
         byzstXhUD725ZluCKOZrv/5j2N7BrhJ0IxhcB+Avtnpqr0bbKo/yo/D9o/g6RBbRP40H
         W6UWS8O8afpUnIT9c1HW+9lDqPblIzOYAScl02pmlSOSYaGvA+TXv6Gof37vbc5DsN1T
         Hhuw==
X-Gm-Message-State: APjAAAVfj6YzNZJZ5qeDXI8RJSYOTISKI2JJ4PspBH0S51SoNJg+sAIr
        QK3LmRm++oHZAFjuNipTPS4=
X-Google-Smtp-Source: APXvYqzCLLduQLj/GLDNKT4wIdrpFBLmutEt4PqTmZUHCAP7xXGqyH4fhT4HsBxnQNm75Z95pfkDFg==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr861293wmb.138.1572044662147;
        Fri, 25 Oct 2019 16:04:22 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o189sm5258258wmo.23.2019.10.25.16.04.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 16:04:21 -0700 (PDT)
Subject: Re: [PATCH 01/32] elx: libefc_sli: SLI-4 register offsets and field
 definitions
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-2-jsmart2021@gmail.com>
 <20191024162202.z3g5g4cwjbzotd5a@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <a57e5cbb-8228-dae7-72a4-8fd34b1aca9a@gmail.com>
Date:   Fri, 25 Oct 2019 16:04:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024162202.z3g5g4cwjbzotd5a@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks. We mostly agree with the comment written and will work on the 
changes.

Exceptions or answers to questions are inline below.

-- james


On 10/24/2019 9:22 AM, Daniel Wagner wrote:

>> +	SLI4_INTF_VALID_SHIFT = 29,
>> +	SLI4_INTF_VALID_MASK = 0x0F << SLI4_INTF_VALID_SHIFT,
> 
> Should this a 32 bit value? This overflows to 34 bits.

agreed

> 
>> +
>> +	SLI4_INTF_VALID_VALUE = 6 << SLI4_INTF_VALID_SHIFT,
>> +};
> 
> Just style question: what is the benefit using anonymous enums?  The
> only reason I came up was that gdb could show the name of the
> value. Though a quick test didn't work if the value is passed into a
> function. Maybe I did something wrong.
> 
> I am asking because register number is a define and then the shift and
> mask are enums.

In newer code I've seen the preference being anonymous enums. But in 
looking for why or when to use what, there wasn't much guidance or 
reasons.  As in my other email, we had older defines. In newer code we 
used enums. So we have a mix. At this point, there's so much volume it's 
not worth making it one way or the other.


>> +/**
>> + * @brief MQ_DOORBELL - MQ Doorbell Register
>> + */
>> +#define SLI4_MQ_DB_REG		0x0140	/* register offset */
> 
> Are the other registers defines also all offsets? Just wondering if
> the comment is pointing out that these values are special or not.

yes.  We'll clarify them as well.



