Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A15C5479D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 17:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbjAKReN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbjAKRd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 12:33:29 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987C8D10B
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 09:31:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so20768994pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 09:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bZQ5mDIMUZ66jwUjiXiZj6hCFwx9Pjab4pgBfifiwzU=;
        b=dP9Px95nD70CjdDnDbcgiVGQFoLOLpve5GeapfjwEeR80CO9wlLpTpSc1RNrRf/cWJ
         5prbxDDX/fJfZXS7O0P3xltgUPyWObuAM3FNJUVc651i41XTLdxQtw+BEwwh04uXucW8
         my9uFJ6vnpii02ep/T2qDrlZJbHT4pSb3QqQPU5vs7Bgeids7XspVKq1GbtqFOrze56A
         P6vHlONhwlM25IqTkUq6OP+HnaoYTZ1iCj1snPf48Qc7sR+p0YVpyWnvmz6UT1g6mVeE
         EubXiM07FckoGS1xxjEpMFtnx2eUqzAz352Csr+OdrGVOc7elAXLHb5TBkP67DK0KBz9
         Boew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZQ5mDIMUZ66jwUjiXiZj6hCFwx9Pjab4pgBfifiwzU=;
        b=XFBZ383TaWc774QQm1aNd2N3nTEWOY752DMUhdRHsxgnDdaVHVnHqlhVDDRwYXfJTa
         YNrtR+H0d1kDUS9qGZ5xfiEwfaxgn+GhTGI3DGMrEbeVcbW1jo/maja8fE5EOsPMl24Z
         HdmXVsvf4MmwKBfcu+xQqthEUJGLAzyUokccIzZPqGsy41DRsRPRjRt2uMjjx6/uYb/6
         7fPsPqmdeTqoefE7huIlQ2LQnCussjzBn9zy7jKidDOoJbM3tvb0yFn3PttbVBFfoDLj
         1hUJtDllCGdk0i5YnjQnEdPZAC6/sCVfsQx+4UCewQnNrO8+pHnQuTP5Zo6RQ05mV7a0
         ITGA==
X-Gm-Message-State: AFqh2koqaoZ92XRSyUCI/34e3PNdJTNDm4HPbKGVci2wiHw8Qnd+sH9u
        dPg8IPgR/i6hVXh+HnsSFGzlUg==
X-Google-Smtp-Source: AMrXdXu4PLLTQf4yYEMPdu8Gp45I5AQ74wH63TbIM66CzLW281C+SLHfNPAeb7WrJeT9wfFTwahgyA==
X-Received: by 2002:a17:90a:4217:b0:223:2edd:3ef with SMTP id o23-20020a17090a421700b002232edd03efmr17370846pjg.2.1673458274051;
        Wed, 11 Jan 2023 09:31:14 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jx12-20020a17090b46cc00b00225a8024b8bsm9307818pjb.55.2023.01.11.09.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 09:31:13 -0800 (PST)
Message-ID: <638fe130-b2a3-88ba-9a65-445cbb4798b4@kernel.dk>
Date:   Wed, 11 Jan 2023 10:31:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: SG_IO ioctl regression
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20230105190741.2405013-6-kbuschmeta!com>
 <Y77J/w0gf2nIDMd/@x1-carbon>
 <Y77Vcz3dpll2WoV/@kbusch-mbp.dhcp.thefacebook.com>
 <Y77wk6vQKsf6zC3b@kbusch-mbp.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y77wk6vQKsf6zC3b@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/23 10:23 AM, Keith Busch wrote:
> On Wed, Jan 11, 2023 at 08:27:47AM -0700, Keith Busch wrote:
>> On Wed, Jan 11, 2023 at 02:38:56PM +0000, Niklas Cassel wrote:
>>> It appears that this commit breaks SG_IO ioctl.
>>
>> Thanks for the catch. I'll send either a fix or revert today.
> 
> The below will fix it. The code was corrupting the ubuf by assuming
> iovec type when copying the original iov_iter.

I'll fold this in.

-- 
Jens Axboe


