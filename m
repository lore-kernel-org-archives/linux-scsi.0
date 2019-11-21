Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431AEC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFC1208A1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ddHJcx4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKUAIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 19:08:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40843 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfKUAIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 19:08:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id q15so2113642wrw.7
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 16:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:in-reply-to:from:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=boSRjTkS8/PqTPvpr5o5YoKVt1JwCd5HZudbs4rgl20=;
        b=ddHJcx4RuML45IKilYdUYJPmXRQ4TBuFRpaZMB5Z/wkFsr/tkaeaHDiMTnIbJhYR+M
         3YAsLvHHxU+QNk6lXHjCcx8G6GjIKoD45ULaPNFplos9teoXAqouFe7FK9THcUqxTvv+
         p21/hMnx3Ga6esu9NCLJqmNCQBn/zsVbOan4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:in-reply-to:from
         :message-id:date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=boSRjTkS8/PqTPvpr5o5YoKVt1JwCd5HZudbs4rgl20=;
        b=X4dPdPVgw5v1edSt4T94ieRegwCCFLq7P/IyE3wI/SiZiJF3TKc65VQsId+6SAAUeM
         P/09KzPdgyQP9NF4FaJGc0R0r7YvtYkSaXgc7Z1RkWy0oNTJi/d5iRNT/eucS4+Igaa0
         uhYXRULYxNsViv7jlEmJmummWgQQNckLsReq/povySiXV8ozuw4KoS88ezQYMxVwOcPZ
         XmewnIu14PonJCB7hjRpkwpf8cSRWGJ4hwMaxRICQ1RnJdymASIxDm5XuwqkWuOKFhqM
         WS+mYXivWigYYL4cye+9gZAqBXhYU+njbq7RLjJaC3mMPuluhCZmedjUuRSnD+/Dr7+t
         lU0g==
X-Gm-Message-State: APjAAAU6L9iAmZ/sk3DcS79/DfWfn1KSckRvt1W3O89dTPtUF81p2LR6
        UfxODtCdyUtBiezxG7BEQErjddmin7ALs73gXiRrExTQi5kHsjyZRpm2jDJmbuynMbdN9qGWdxY
        096iCQbdtA30D8jko3v/sJKOh77EvQQrZzn67Em4sVIDOk+J9bpHeNrUScRYBAdMIW9jhnXWy2J
        oGTi6IaSg=
X-Google-Smtp-Source: APXvYqxpBMY2Vjgo3amFM4h29OX4jvNSVqkYFbx66U4VOA1vruDXsZdmyOYKMBrJMfl3BPOZlp36kA==
X-Received: by 2002:adf:f5c6:: with SMTP id k6mr6712211wrp.245.1574294907705;
        Wed, 20 Nov 2019 16:08:27 -0800 (PST)
Received: from [135.142.48.175] ([192.19.220.253])
        by smtp.gmail.com with ESMTPSA id u13sm883539wmm.45.2019.11.20.16.08.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 16:08:27 -0800 (PST)
Subject: Re: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for
 SSD
To:     linux-scsi@vger.kernel.org
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
In-Reply-To: <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Message-ID: <fb154344-9f36-f09d-2dfa-7b940b89cf93@broadcom.com>
Date:   Wed, 20 Nov 2019 17:08:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Ordinarily I'd prefer a host template  attribute as Sumanesh proposed,
>but I dislike  wrapping the examination of that and the queue flag in
>a macro that makes  it not obvious how the behavior is affected.

I think we can have a host template attribute and discard this check
altogether, that is not check device_busy for both SDD and HDDs.

As both you and Hannes mentioned, this change affects high end controllers
most, and most of them have some storage IO size limit. Also, for HDD
sequential IO is almost always large and
touch the controller max IO size limit. Thus, I am not sure merge matters
for these kind of controllers. Database use REDO log and small sequential
IO, but those are targeted to SSDs, where latency and IOPs are far more
important than IO merging.
If this patch is opt-in for drivers, so any LLD that cannot take advantage
of the flag need not set it, and would work as-is


Thanks,

Sumanesh

On 11/20/2019 10:00 AM, Ewan D. Milne wrote:
> On Wed, 2019-11-20 at 11:05 +0100, Hannes Reinecke wrote:
>> Hmm.
>>
>> I must admit I patently don't like this explicit dependency on
>> blk_nonrot(). Having a conditional counter is just an open invitation to
>> getting things wrong...
>>
> This concerns me as well, it seems like the SCSI ML should have it's
> own per-device attribute if we actually need to control this per-device
> instead of on a per-host or per-driver basis.  And it seems like this
> is something that is specific to high-performance drivers, so changing
> the way this works for all drivers seems a bit much.
>
> Ordinarily I'd prefer a host template attribute as Sumanesh proposed,
> but I dislike wrapping the examination of that and the queue flag in
> a macro that makes it not obvious how the behavior is affected.
> (Plus Hannes just submitted submitted the patches to remove .use_cmd_list,
> which was another piece of ML functionality used by only a few drivers.)
>
> Ming's patch does freeze the queue if NONROT is changed by sysfs, but
> the flag can be changed by other kernel code, e.g. sd_revalidate_disk()
> clears it and then calls sd_read_block_characteristics() which may set
> it again.  So it's not clear to me how reliable this is.
>
> -Ewan
>
>
