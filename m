Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A32C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 21:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbjAXV3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjAXV3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 16:29:34 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724D40BFA
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674595773; x=1706131773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y1q6V757IBYa1qj4S9xlMkp5Y7al5XQnblfFT2qlxr4=;
  b=a05UMlSZWrxNP8hoYjk9OKmxjOamEHMqn6LoKghabnXKZh0FEoHUlBUU
   h9aUyNTxH+oNqLkDJH15QX1rjuSj4eCNs76I/IJ0rSdbXrp2Ru12EJkaM
   +CwzJ4oph1lNHfh/kqeCvadYFbyZ/lp6x5uFWNq690d6w2+t2tUAeZmWg
   HJGrLWpQI4IDXWixCTPFm5TP2NYflQIaNUL8Vu28NdkRm9mefwCEMMxLB
   QyVJgNdqGgWyvrX62CsH/RuCKGwkDHNl7EgYZcZXohfj4u7PyLFjYLa9V
   On8f15Z6KLvJE6M1PQYUTE/KIJF8NPUx4zpKCjXqxAeKc9AwoR6D2M1XX
   w==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="325970813"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 05:29:31 +0800
IronPort-SDR: DBQ9pL03se91BCrL0zqfEpZA8OBdxLDLd6Rg9ETTaxDjV2afywIHCVHq+WHNEDG9cQnTNXllzH
 Z4rBYoJw+/LWtbOIyJheoEDSFDK98XeWELK39x0yeEfOhGQoQ/ckkHxUYMjBiTQNQ7hLhAiM0X
 ROVUDYB0+2DNdcTA/aQgc7uwy8xZlJc4I99g81CD43cLC6l9mdmBceF6I0Dbn7xtlM/JftuJ6r
 BYOuyHy/1PLPWMpC9aX9ogaOgtKMGoGL8cjCgbtaxFVwhSL929iYbiVALuD3faixGsKk6BPvqm
 UL0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 12:41:20 -0800
IronPort-SDR: hNTvZJT8okAs2H45XOHC7Hp4iiVJxW8WcZN0aOzs1ru9RL8k0ZhkdqCbqVTyHoXBWXnTM+EwUc
 Ih4lQglLotosAS0nTTgHUTk7OWsYZRFX8iLdfoDTaDSJGyx4c2P72ngww3u7zh8SKf/z9G53IO
 z0B+eBp4fRYM3zgaor2+zW+KWYlws5CuDNA59PHsLasXzd6gyJSz2DB9fBAXiRvK19ASakrOiH
 ER9/dpoSfAVCGJOQ7DxZBEnziyMRM5HC1F9/agia2RRFX57mDMxVS0KBwtbXTgOy4He6bzVirK
 Vjk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:29:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1g8p75GYz1Rwrq
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:29:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674595770; x=1677187771; bh=Y1q6V757IBYa1qj4S9xlMkp5Y7al5XQnblf
        FT2qlxr4=; b=Dqe4tD5eQ+r5R/8/MmgKrz+YIj3354ZaeHpI/ROEmJMt09i/JBh
        k2V0nRWL5GbbuLSWNjPGwBlLMGHVLI7yA22l6v6MHwmGDdlBIdnQMnbbWsDBfUWY
        5QEIaEeg8ma7PCiW32sVi9oTQ8EAN5AZkMsv+ehFRbRQKeC8GYNS5iHpcJdwI8Dl
        8tz50exHMjxVivD3rHLxsUgha6tu65syi9YZ0g7dmMyrsLHZP61IdBmOnLWVIYHq
        cZJ2JUm5IguZBocydKWkj8sMymEv3BMfYuHIo6MY75cLTk+OBm22t3f3gzyEwTnA
        vnyIpS14x3ERrP8wYaTlv7zaiJwMiaQ6tmg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nvjrEHB4HCje for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 13:29:30 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1g8m2bz3z1RvLy;
        Tue, 24 Jan 2023 13:29:28 -0800 (PST)
Message-ID: <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 06:29:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
To:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 04:27, Bart Van Assche wrote:
> On 1/24/23 11:02, Niklas Cassel wrote:
>> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
>> be executed using duration-limits targets. The duration target to apply
>> to a command is indicated using the priority level. Up to 8 levels are
>> supported, with level 0 indiating "no limit".
>>
>> This priority class has effect only if the target device supports the
>> command duration limits feature and this feature is enabled by the user.
>>
>> While it is recommended to not use an ioscheduler when using the
>> IOPRIO_CLASS_DL priority class, if using the BFQ or mq-deadline scheduler,
>> IOPRIO_CLASS_DL is mapped to IOPRIO_CLASS_RT.
>>
>> The reason for this is twofold:
>> 1) Each priority level for the IOPRIO_CLASS_DL priority class represents a
>> duration limit descriptor (DLD) inside the device. Users can configure
>> these limits themselves using passthrough commands, so from a block layer
>> perspective, Linux has no idea of how each DLD is actually configured.
>>
>> By mapping a command to IOPRIO_CLASS_RT, the chance that a command exceeds
>> its duration limit (because it was held too long in the scheduler) is
>> decreased. It is still possible to use the IOPRIO_CLASS_DL priority class
>> for "low priority" IOs by configuring a large limit in the respective DLD.
>>
>> 2) On ATA drives, IOPRIO_CLASS_DL commands and NCQ priority commands
>> (IOPRIO_CLASS_RT) cannot be used together. A mix of CDL and high priority
>> commands cannot be sent to a device. By mapping IOPRIO_CLASS_DL to
>> IOPRIO_CLASS_RT, we ensure that a device will never receive a mix of these
>> two incompatible priority classes.
> 
> Implementing duration limit support using the I/O priority mechanism 
> makes it impossible to configure the I/O priority for commands that have 
> a duration limit. Shouldn't the duration limit be independent of the I/O 
> priority? Am I perhaps missing something?

I/O priority at the device level does not exist with SAS and with SATA,
the ACS specifications mandates that NCQ I/O priority and CDL cannot be
used mixed together. So from the device point of view, I/O priority and
CDL are mutually exclusive. No issues.

Now, if you are talking about the host level I/O priority scheduling done
by mq-deadline and bfq, the CDL priority class maps to the RT class. They
are the same, as they should. There is nothing more real-time than CDL in
my opinion :)

Furthermore, if we do not reuse the I/O priority interface, we will have
to add another field to BIOs & requests to propagate the cdl index from
user space down to the device LLD, almost exactly in the manner of I/O
priorities, including all the controls with merging etc. That would be a
lot of overhead to achieve the possibility of prioritized CDL commands.

CDL in of itself allows the user to define "prioritized" commands by
defining CDLs on the drive that are sorted in increasing time limit order,
i.e. with low CDL index numbers having low limits, and higher priority
within the class (as CDL index == prio level). With that, schedulers can
still do the right thing as they do now, with the additional benefit that
they can even be improved to base their scheduling decisions on a known
time limit for the command execution. But such optimization is not
implemented by this series.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

