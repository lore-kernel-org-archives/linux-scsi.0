Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E401C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 21:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjAXVs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjAXVs1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 16:48:27 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800BD46D71
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674596906; x=1706132906;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kelf/B7Mre/rO8p2LUaVznqJP+lT5xhWFA7LxVASojo=;
  b=ZFSXC3n1ubdRh+0YR+pgr+vFvqKoIZM+GEYQNDKVifXyY2I1yxWBIMLJ
   MV2d4Ce3C/eixIiol6ex3aJkuc5TWc62OTqlUx84+6S3VKGrVkOZpN1eD
   vkRMSArpbHGjHhMpRWzXdsDJhVn4OuO5Qk9bI4LgP67QZK9VSTh36FonT
   ikZ8Uh5VOMWOz3GRWVZMzYKFc1u1vQVb5aomx7sIvfiydm9OI+jT6aV/6
   OqZ3azlQPa+BwR8PhOpVItRhl+hPG272eVtWvPPZvoKTeJ1VBNd9nbS8l
   dCAquXkGFJRgZIUs4RCuP20teV03s0P9iBq5DSi9/D6jVyZl59jl5Jgdu
   w==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="226654646"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 05:48:25 +0800
IronPort-SDR: WlS6wIqmBg8kQeErO9nEMoQSqTKgfJVwQbF1EQFWoVFlYMkqNELvQzm9Tf7/ryChLm6kR0mbif
 Kf6P3/bEyA4+6LSauAxMiw6WgtQ+WYCihL+NIikmuFYD1NjYdSuhLaqLiVngurVyN5FmNFmxTJ
 Wx5BTOeuaDZwGtKT5OC844Me0qiKGoONoOALO+qPavOG+t21ZB62vCXpU9W4HlATwJ3Ula6o83
 yDdADM6DYb9PuB9Qn068JE0TUZjvWGIh1sjaFMwq5/mRvFlCePyQ3cLFrEt2DzVU8QEp1i46XA
 Hyc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:00:13 -0800
IronPort-SDR: NgU5XQVpxXP+mI9Q2HKGI+TSkj3hCdtla0mmAbrva2eugEYOvhMcyhNJSeMqy16aO8+6n99iym
 5mRuVC9I8yaE/VpbP5CnQ8cu1ZUtx0dVvVVBRNEpNpuJbo2q3KEHVpF6E4PlJcu8jK3TG4YZES
 Ijqsx136yGGvq3HFNEXSzuXzPhmULxyj2hSto2vdBaElwDYpPl+Pbl2hPdU9J8MnQI4oR7v37v
 ILOwU5CjTYeQ5N+SKGiuC4RNCA0++KApT8UExZqVzqV49TvmFBUU6YDH8YLHYkC2b2q3BujIaq
 Utc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:48:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1gZd3gHCz1RvTp
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:48:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674596904; x=1677188905; bh=Kelf/B7Mre/rO8p2LUaVznqJP+lT5xhWFA7
        LxVASojo=; b=o7+SAaye3ovIJEx5yIxrl0iIQ2yovZz/yt2uXCVwOzqDRmqpU3H
        7sHMdAoi7gRPGGZa0BpXYOCgaZUTjMUroPSvxAVRTtA0Kg/1sx6FpDMRH1JefFlX
        rr5UalzjPfq3+9faQ3kjG0AabVC6iMnhBiYa2zh/HEuA/VWjSELcknWhFBiZ4tvK
        eI6wjY0ErKAi79CqESS70rDKyDrb/YSz4Erca1s311ag2UQuK5QYAF70r2azAlmh
        P36bwsorzn4+ERERaNUF81cpbZxX5lGHM+KH73nFc79UpSUGZj7NW1alyNjgSpQq
        af+VcPapJ4jWVSvEOinaLGFtDU51jE7GS9Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v9etl_U44f0f for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 13:48:24 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1gZb2T1kz1RvLy;
        Tue, 24 Jan 2023 13:48:23 -0800 (PST)
Message-ID: <6329e4fb-536b-00da-b38c-b6cb95f68994@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 06:48:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
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
 <bd75a7d8-7664-eff5-d417-a2fa8708fb05@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <bd75a7d8-7664-eff5-d417-a2fa8708fb05@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 05:36, Bart Van Assche wrote:
> On 1/24/23 11:27, Bart Van Assche wrote:
>> Implementing duration limit support using the I/O priority mechanism 
>> makes it impossible to configure the I/O priority for commands that have 
>> a duration limit. Shouldn't the duration limit be independent of the I/O 
>> priority? Am I perhaps missing something?
> 
> (replying to my own e-mail)
> 
> In SAM-6 I found the following: "The device server may use the duration 
> expiration time to determine the order of processing commands with
> the SIMPLE task attribute within the task set. A difference in duration 
> expiration time between commands may override other scheduling 
> considerations (e.g., different times to access different logical block 
> addresses or vendor specific scheduling considerations). Processing of a 
> collection of commands with different command duration limit settings 
> should cause a command with an earlier duration expiration time to 
> complete with status sooner than a command with a later duration 
> expiration time."
> 
> Do I understand correctly that it is optional for a SCSI device to 
> interpret the command duration as a priority and that this is not mandatory?

This describes the expected behavior from the drive in terms of command
execution ordering when CDL is used. The text is a little "soft" and sound
as if this behavior is optional because CDL is a combination of time
limits AND a policy for each time limit. The policy of a CDL indicates
what the drive behavior should be if a command misses its time limit. In
short, there are 2 policies:
1) best-effort: the time limit is a hint of sorts. If the drive fails to
execute the command before the limit expires, the command is not aborted
and execution continues.
2) fast-fail: If the drive fails to execute the command before the time
limit expires, the command must be completed with an error immediately.

And CDL also has a field, settable by the user, that describes an allowed
performance degradation to achieve CDL scheduling in time. That is, most
important for the best-effort case to indicate how "serious" the user is
about the CDL limit "hint".

So as you can see I think, the SAM-6 text is vague because of the many
possible variations in scheduling policies that need to be implemented by
a drive.

-- 
Damien Le Moal
Western Digital Research

