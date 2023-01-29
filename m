Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF251C61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 02:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjA2CFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 21:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjA2CFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 21:05:38 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD1D206B9
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jan 2023 18:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674957937; x=1706493937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lMWivxvLhEfQDKorNEnMNpMAFprd1R9pddYdWXMbzJo=;
  b=TOEnp6Dup2h2qVybZ/KEuKwEl20cDPQ4ic4LqDftwXOnf9VI6IFee81w
   3c+s6Oy+mNkmNn1MVX6fVR2m3GeciPlzCYsPzL9Uc0oUbDdz2zo/I/Ae6
   AQ8ckY7PJZ2omgke2lviNdfQSsCpiA/UT/iNxCRFMZgSRFdLtMFLFjcJ/
   00P2hkWeog0G3+XUh8RQt4fwcUMOQgN5kdJDQMTY1+AhFhZ4pI514l/u5
   mmaKIQg18ft7Ft415+jtLiUhkMQ/KgddEk68jCg7jU1Zjt34uORzG/Nxy
   7JA+nXnoBfJZlRLZ9fYFA3c+Q2iFRV8nyAXlP7OvKeE2/jqCqa4tCz5V7
   g==;
X-IronPort-AV: E=Sophos;i="5.97,254,1669046400"; 
   d="scan'208";a="326286265"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2023 10:05:35 +0800
IronPort-SDR: Ws36KrCpP4eICZYRoc9z8VJe3UpZf+35f35qgFmBOMrm47GgIKdcYNP5GNXxD4gJgxmhMZiBzn
 9zqrmgZJ02MZOL8REW+5hDJuy9TEAFjWh4jFXp79ax5IDIUHrCrarspWYCCel9MCa2hi7XvZoC
 kuAZwu7bla24v2akRLqQQXmqyibBkP4g8GL3+nH6w+dRUhyMIyu8GYBnZtyVEt9BKNK1L4tXle
 I75npFMNdvEH8Legp0Rfd9BIIhYURfn6sy98pwnWp22gUeFEF2zawN8sUWwj7nUmht5fqLR0WP
 8U8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2023 17:23:03 -0800
IronPort-SDR: GMPtERHXj/zzgKXcUDS9sVbRNAaKaV0r19VVhaC4ICPA9DmwOy/REIXoNhOoTz1w+cAQv5/uN7
 R0NPHchUfWEm38Kkid5kQrvnLUNY1FJIKAoxbyAL/xMzW3HN0h0mmvMqpjMHJuXXFoTPFTqTle
 DUEwRBmCdpT8q9hYTt/F4q07wKsPu6S7qD389SEA1MkxYzGYhC14KhdCV+VHGIopOS9XgBgYe8
 LDt8HTJYDEWkOxGZp16HA7h076O47D/5/+q3RNRK006iZXN9wSLy3ibyXyIgyMcDZ7twwcSpHT
 SHQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2023 18:05:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P4F5W35r0z1RvTr
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jan 2023 18:05:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674957934; x=1677549935; bh=lMWivxvLhEfQDKorNEnMNpMAFprd1R9pddY
        dWXMbzJo=; b=ec2bLH+IUZYrP+pzBBc80pTKaFoRH8Q2df9F5NJBguMTqwFuPFh
        ThGxVPOqe8XBeW/MxwjeVfMmWw85ulzOL2mcfCDFPs+pKvEpv3nke9fnMA0Q+hke
        KHZfFNEfJoMvWLuJo0CJt5/6CbFDUqrInjKV1cUg3fU0Ir83XfD/RhoBmxQeDqJk
        uJxXCvxkJ94XhOgxmxyGR6Jgc2IDU9dwpLubAO+elu6F6zh9KYOhHAu+baOLf0mW
        8Uq/meSrcxfa0v9XqPpu91I7E94ad8FxkVaZlpbHakuBeYulW1cfvXdx3tAC1KlE
        IVqBf8YxKQvjBG40YffhJLn3PIHFQRRIALg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wvWMP35YY6VM for <linux-scsi@vger.kernel.org>;
        Sat, 28 Jan 2023 18:05:34 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P4F5T1WtTz1RvLy;
        Sat, 28 Jan 2023 18:05:32 -0800 (PST)
Message-ID: <976c4854-2c98-15f8-12bf-ee08ab86af96@opensource.wdc.com>
Date:   Sun, 29 Jan 2023 11:05:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 07/18] scsi: sd: detect support for command duration
 limits
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-8-niklas.cassel@wdc.com>
 <f0793325-3022-e7b8-672d-00f2f9ee0cd9@suse.de>
 <99e6b267-6e2e-2233-19c2-1acf7c9135b2@opensource.wdc.com>
 <f9fe4e54-563a-c8fa-23ae-88780c4edc54@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f9fe4e54-563a-c8fa-23ae-88780c4edc54@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/23 11:52, Bart Van Assche wrote:
> On 1/27/23 16:51, Damien Le Moal wrote:
>> On 1/27/23 22:00, Hannes Reinecke wrote:
>>> Hmm. Calling this during revalidate() makes sense, but how can we ensure
>>> that we call revalidate() when the user issues a MODE_SELECT command?
>>
>> Given that CDLs can be changed with a passthrough command, I do not think we can
>> do anything about that, unfortunately. But I think the same is true of many
>> things like that. E.g. "let's turn onf/off the write cache without the kernel
>> noticing"... But given that on a normal system only privileged applications can
>> do passthrough, if that happens, then the system has been hacked or the user is
>> shooting himself in the foot.
>>
>> cdl-tools project (cdladm utility) uses passtrhough but triggers a revalidate
>> after changing CDLs to make sure sysfs stays in sync.
>>
>> As Christoph suggested, we could change all this to an ioctl(GET_CDL) for
>> applications... But sysfs is so much simpler in my opinion, not to mention that
>> it allows access to the information for any application written in a language
>> that does not have ioctl() or an equivalent.
>>
>> cdl-tools has a test suite all written in bash scripts thanks to the sysfs
>> interface :)
> 
> My understanding is that combining the sd driver with SCSI pass-through 
> is not supported and also that there are no plans to support this 
> combination.

Yes. Correct. Passthrough commands do not use sd. That is why cdl-tools triggers
a revalidate once it is done with changing the CDL descriptors using passthrough
commands.

> 
> Martin, please correct me if I got this wrong.
> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

