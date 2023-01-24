Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728FBC54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 21:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjAXVgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjAXVgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 16:36:19 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC7A47422
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674596178; x=1706132178;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MaeulGlWcam/cauFGlIbI6QYkQXS6fmIFOQvrLj/zE0=;
  b=eeomJP67K7YbHEXPZxFjK6ViC0uP+2hjtbKr9DwNZxheHUbS26w1Ho9h
   W/mCO6IrnykA7z4Q3GrvXCkQk63D5YBwF0USJy2+pMyQuc2VBAfAybGhL
   5/abdq2cvGIG5eB28lmm6V9tXZRooSNzRu8GvYreHxL3lIYZGdVAF05k8
   rzDk7qWkxSSINp3YuOyuQpcWXM2X81OmHf31OBTm60lwVyoqAsWqVWrNl
   HdcbhYfI/ASP/axggRKHeDiz/Qckqh44RPxgzX9Ah8sAFcInaVF9cl7Gk
   JB24nY5j54QpjOuqXN8hm7oPjpiABPJ2ns/Leq9WxEFyCGq/m+8AHw1xt
   g==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="325971138"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 05:36:18 +0800
IronPort-SDR: dlX/U18xCwzTO0XOH4PzezVLija+rUXPXOk2PmRq517B4vfNNqghbDujehc6hESnnTsIsa5Tzs
 rJtqfmsGGo1BaR4mPFYEH3il50xCfhoyfcVi+4D+H7ZWUs9jsvY5NZ/x+67t0aOXyO93uWGNQN
 zlTgdV2Z+uLGywKIMcJQDs0u6NtulwIe9VewCASjwDS5UUPaY0yp66K0egOapWanl/rrTsqhlb
 6VS7Dna8Ae1FrpvMlS8bRSvi7ZXI8hLyUYgk61dAPMxCf1ZngZ4hioFSW+3BQ5AkLAEoS19nhr
 en4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 12:48:06 -0800
IronPort-SDR: B3KdVpaweSEEQ/hK60oIVsHZMGjYP/JtBOmoSEQHPNySvXuy9rPSQpANFM/u+fcjNPALoAoARi
 9CS9YgherRgx6S9uiz0aoP45T8Khg/vDl8lF9dWYugMFILidMcHV/1V6zdFhNHa4LS8H/ei9fN
 KUFqcsISQTUealWl6nCRZaUBH0IrrgjPTFWtxIiF6pFVm1tPGI6gSTL9QgfUjmvhV09NhYR5fs
 UezKBNjQ1JuYRcmC2EChRJp10Rz37QWBN+pKt6rcqOJx9CYVE/RIlQbNHa3HnnF3581f8jQCQo
 T4c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:36:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1gJf0z98z1RvTr
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:36:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674596177; x=1677188178; bh=MaeulGlWcam/cauFGlIbI6QYkQXS6fmIFOQ
        vrLj/zE0=; b=fTeMqXQcxQcQK0CIxga3PorH3O7ZyjYWi/8Yfxhw7qngxvQlnBg
        J0CR8JEsMcV7DArmgahGzPa5aNcNBjk8IWVRjNP7lG60Wk1PmNkVA1sgw8Y4k+qa
        4JcHpKrt9I1yCblUZfFgShtOAeDfIaTQhrDfzQ4rP/GabBZmeDm6ZzDgf/j8iyRw
        tvX8vJ1h1Vtd+1/XyGsxD8scqvS1H6YEg08fA3GHxeLaRfr7ySCC55k5ZGkiXSMw
        RUHqHO2VOWF9DH8OoxQcvaYOQDVEH5TSIQ5OAYBC+pTnmdzsz8cyqj0wzUntgjJt
        w1a4XR9kYLJ7U7d+wTvnsBtEDtnzkW7qs8A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f7n4cpnHWpGD for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 13:36:17 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1gJc1Rgvz1RvLy;
        Tue, 24 Jan 2023 13:36:15 -0800 (PST)
Message-ID: <b585cc43-8584-a980-6b52-224d8692b66a@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 06:36:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
 <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
 <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 04:59, Keith Busch wrote:
> On Tue, Jan 24, 2023 at 11:29:10AM -0800, Bart Van Assche wrote:
>> On 1/24/23 11:02, Niklas Cassel wrote:
>>> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
>>> report command that failed due to a command duration limit being
>>> exceeded. This new status is mapped to the ETIME error code to allow
>>> users to differentiate "soft" duration limit failures from other more
>>> serious hardware related errors.
>>
>> What makes exceeding the duration limit different from an I/O timeout
>> (BLK_STS_TIMEOUT)? Why is it important to tell the difference between an I/O
>> timeout and exceeding the command duration limit?
> 
> BLK_STS_TIMEOUT should be used if the target device doesn't provide any
> response to the command. The DURATION_LIMIT status is used when the device
> completes a command with that status.

Yes, exactly :)


-- 
Damien Le Moal
Western Digital Research

