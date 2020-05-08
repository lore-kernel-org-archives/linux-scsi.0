Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEDEC54E49
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 20:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8BE218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 20:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kali-org.20150623.gappssmtp.com header.i=@kali-org.20150623.gappssmtp.com header.b="M4wNj8Yo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgEHUS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 16:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726906AbgEHUS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 16:18:27 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CDEC05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 13:18:26 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id k133so9327401oih.12
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 13:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali-org.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MlAF25STO+yL73T826E97sego/sVxlAzSPlYezFQQ8Y=;
        b=M4wNj8YoS4oXNM+w8CGcPv9cdsOnbF6k1MPswMkN4CdLOM5RdeVNUzYv+X5YCsEnzi
         xYZkEqKyVkGQEcxj/htYstjJ0wc1UIMuy0eUZoj1S6c8w9/bLDzVsmynO2XBu3+96nsQ
         uTSZDLsiyHW6NO8wGBT0nID4rhBc8bn+w+QDfNFEDWU2PEw9Se4UdhcUZ/BC3XQtiHEg
         VX3cEytz5wr13F0Oqqg20fRXPEplfSqoouLHNDjXWfhvsocPckRpWOgxvOZFD4Y0nThi
         mk3oVyl/MLOkyL/WZSUXJvtQGIttYyRjdD0zLZFrCloBLZ31RPdgnhrBzpnBYPzoUp97
         4+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MlAF25STO+yL73T826E97sego/sVxlAzSPlYezFQQ8Y=;
        b=oTAA4jLK1PS+y0k3TqeIudavMU2R7J5DlrBAg0o9DtljxwWi1DmZQYwsyF8wTHFw80
         qYzcEK1STvfQ/F9BEFSC6sSSeI30Op3EkaGCxccMCmEe/SOoq1NWXxEPYmHs5p2Y5tQw
         8y8nBP++kDjUKGIih2jTKSMbBymtEFZ3rI+bn1/lYheUnin6r10CSBalaTlPRoMV9Xcl
         oPJpeSWIc4SQFBoPFWXvBH28Er1dFtbP0URfcsDBKMAl3/dJnO4KxsZQ0V28D4tDOPdK
         6KG+GTM919iPaFC/LKILSbXKtrvYWok/+cIG77UMikwgYSRkLaBml710bQod5gUk/ZsD
         /8fA==
X-Gm-Message-State: AGi0PuaPoURLVqGq/xibzNhHwHvW1ckNoEzSzbwafuf4iMDzFBSIPBfr
        l8Xpbys5ow+zi5aFcE6D0blpFA==
X-Google-Smtp-Source: APiQypKS8r9Jmzko+elY+jhmRk/eq+lV7F00Vg+u5ZpDoj3UGL6QIMuIZ1vm2RILFJAOf49KcfGPog==
X-Received: by 2002:aca:d585:: with SMTP id m127mr11865717oig.27.1588969105589;
        Fri, 08 May 2020 13:18:25 -0700 (PDT)
Received: from Steevs-MBP.hackershack.net (cpe-173-175-113-3.satx.res.rr.com. [173.175.113.3])
        by smtp.gmail.com with ESMTPSA id q12sm632331otn.57.2020.05.08.13.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 13:18:24 -0700 (PDT)
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
To:     Eric Biggers <ebiggers@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com> <20200507180838.GC236103@gmail.com>
From:   Steev Klimaszewski <steev@kali.org>
Message-ID: <150ddaaf-12ec-231e-271a-c65b1d88d30f@kali.org>
Date:   Fri, 8 May 2020 15:18:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507180838.GC236103@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/7/20 1:08 PM, Eric Biggers wrote:
> On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
>> Hi Thara,
>>
>> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
>>>
>>> On 5/1/20 12:51 AM, Eric Biggers wrote:
>>>> From: Eric Biggers <ebiggers@google.com>
>>>>
>>>> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
>>>>
>>>> The standards-compliant parts, such as querying the crypto capabilities
>>>> and enabling crypto for individual UFS requests, are already handled by
>>>> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
>>>> However, ICE requires vendor-specific init, enable, and resume logic,
>>>> and it requires that keys be programmed and evicted by vendor-specific
>>>> SMC calls.  Make the ufs-qcom driver handle these details.
>>>>
>>>> I tested this on Dragonboard 845c, which is a publicly available
>>>> development board that uses the Snapdragon 845 SoC and runs the upstream
>>>> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
>>>> phones.  This testing included (among other things) verifying that the
>>>> expected ciphertext was produced, both manually using ext4 encryption
>>>> and automatically using a block layer self-test I've written.
>>> Hello Eric,
>>>
>>> I am interested in testing out this series on 845, 855 and if possile on 865
>>> platforms. Can you give me some more details about your testing please.
>>>
>> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
>>
>> A basic manual test would be:
>>
>> 1. Build a kernel with:
>>
>> 	CONFIG_BLK_INLINE_ENCRYPTION=y
>> 	CONFIG_FS_ENCRYPTION=y
>> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
>
> - Eric

I took a look into this as well - is v12 the latest of the fscrypt
inline crypto patches?

I see a EXPORT_SYMBOL_GPL(fscrypt_inode_uses_inline_crypto) but it seems
like it should be EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto)
otherwise you end up with


WARNING: modpost: "fscrypt_inode_uses_inline_crypto" [vmlinux] is a
static EXPORT_SYMBOL_GPL


when you have something like CONFIG_F2FS_FS=m


Apologies but I'm not sure where the original patchset is to send as a
reply to them.

