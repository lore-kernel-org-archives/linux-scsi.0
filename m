Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05338C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0E1420786
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="efUcfZmT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E6HEgKua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgG2Eum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:50:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35205 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgG2Eul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 00:50:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 577015C0144;
        Wed, 29 Jul 2020 00:50:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 Jul 2020 00:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=0
        +i4N+QEtcyehcuM/VlfuAk7ughsQ44fkbwCF4dCToE=; b=efUcfZmTRoQsI57xe
        o6ytKCadtnu/KvMc28Bxh0g7qqIwyzGLPt2MGnVEguFYMK1dXF+2AtKivSm3zFTH
        qCP+psYx8UZ6BL4lzvhas8vE6U/eeWXngc8QMgLrudfUdhvoT5plb+0kXwcpW8dH
        r/SstsQ0cs3vuMaXhV8O8khPDEtB3Dqc/otM+vyMLtNwYRfnbYEfZV+5rOqhvjzQ
        lvps7UEbpEVZLXlzWcd8mVjBiISCgzrCLk581WUdloFfYXo54iMALplOM6YodFpw
        2plRQPEtLNpf2g2MMQ3PU0G7INSfh/73mYoNqy/hOzykcNKT1bANUzsVoaQk4V8h
        pe+ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=0+i4N+QEtcyehcuM/VlfuAk7ughsQ44fkbwCF4dCT
        oE=; b=E6HEgKua8ZonGzH70XUNJjaPm2+w+1aH3ZQ4ldCNHMg8JUZDQu98jy/j7
        dobUQFzpCiwiUcR4Rt8rxnNkPsmHBS6qU5O8X5XVTphjYbSxzh60/nAG/mEnQd1z
        7xGCXGTtW/H0g06NnWWEncuc8QG6/aQD4v9T2A1LUaWUbMFc+L4YFgPT6Nh4ipe4
        U1MKyKAQ9RGa/PNxRJXnbrxL6u8mm2dXav9d8EM39aAmsJ/n/JRO1fMaMlvjZTAq
        sax4ytLzeJGqLVitlOLx8dywNqa7fX0brKHASxO4EqERTWUntHurAF2dGaOYVjq0
        M3kLAR9HDn8qINGIhBVltXo6y7CeQ==
X-ME-Sender: <xms:HwAhX5R5GThthn1NgdpSoQQVGOEwUKbdyNMV6wKa92FOGE1PIJ_3lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieefgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:HwAhXyzYeXpNwIgpsigN28agLXcQH_Ht_EJaAzCQNlykFfg5_STfZQ>
    <xmx:HwAhX-3qCAaBrybvxpWTnf7R3FKH993ESmZJ3eHkiie_hLpoTz8b-w>
    <xmx:HwAhXxBhPPJcK7PFqd5uyXy9VM8-ae47pGMXO1T9UwbcqfAikmqpKw>
    <xmx:IAAhX1ti0Kd6eSccrx2DTQhLd8iYeCw9m9Jwbf0fiK6QeCYWI3IDyA>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59331328005A;
        Wed, 29 Jul 2020 00:50:39 -0400 (EDT)
Subject: Re: [PATCH] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200726191428.26767-1-samuel@sholland.org>
 <CAK8P3a3yj=ySNCn7YtEXxWiRK0FtG+5ftkV+vb3s82yRi7cdLw@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <351cf74c-1b82-1acf-26c5-682ac4c3fb90@sholland.org>
Date:   Tue, 28 Jul 2020 23:50:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3yj=ySNCn7YtEXxWiRK0FtG+5ftkV+vb3s82yRi7cdLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 2:18 PM, Arnd Bergmann wrote:
> On Sun, Jul 26, 2020 at 9:15 PM Samuel Holland <samuel@sholland.org> wrote:
>>
>> The main issue observed was at the call to scsi_set_resid, where the
>> byteswapped parameter would eventually trigger the alignment check at
>> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
>> complain about an "Unaligned partial completion", and no further I/O
>> could occur.
>>
>> This gets the controller working on big endian powerpc64.
>>
>> Signed-off-by: Samuel Holland <samuel@sholland.org>
>> ---
>>  drivers/scsi/3w-9xxx.c | 35 +++++++++++++++++------------------
>>  drivers/scsi/3w-9xxx.h |  6 +++++-
>>  2 files changed, 22 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>> index 3337b1e80412..95e25fda1f90 100644
>> --- a/drivers/scsi/3w-9xxx.c
>> +++ b/drivers/scsi/3w-9xxx.c
>> @@ -303,10 +303,10 @@ static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
>>
>>         /* Initialize sglist */
>>         memset(&sglist, 0, sizeof(TW_SG_Entry));
>> -       sglist[0].length = TW_SECTOR_SIZE;
>> -       sglist[0].address = tw_dev->generic_buffer_phys[request_id];
>> +       sglist[0].length = cpu_to_le32(TW_SECTOR_SIZE);
>> +       sglist[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
> 
> This looks like it would add a sparse warning, not fix one, unless you also
> change the types of the target structure.

Yes, I meant to change the structure types as well. All of the command
structures sent to the card are little-endian. I pulled this bugfix patch out of
a series of unrelated changes, and I missed the header changes. I'll send a v2.

>> @@ -501,7 +501,7 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
>>             Sunday 12:00AM */
>>         local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
>>         div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
>> -       schedulertime = cpu_to_le32(schedulertime % 604800);
>> +       cpu_to_le32p(&schedulertime);
>>
>>         memcpy(param->data, &schedulertime, sizeof(u32));
> 
> You dropped the '%' operation, and the result of the byteswap?

schedulertime is the remainder from the previous line, so it is <604800 already.
You're right about that being the wrong function -- I meant to use cpu_to_le32s
to swap it in place, to avoid needing a second variable.

>> @@ -1004,7 +1004,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>>                                full_command_packet->header.status_block.error,
>>                                error_str[0] == '\0' ?
>>                                twa_string_lookup(twa_error_table,
>> -                                                full_command_packet->header.status_block.error) : error_str,
>> +                                                le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,
>>                                full_command_packet->header.err_specific_desc);
>>                 else
> 
> This looks correct, but the error value has already been copied into the local
> 'error' variable, which you could use for simplification. As 'status_block' is
> defined as a native_endian structure, this also introduced a sparse warning.

I'll use 'error' in v2, thanks for the hint.

>> @@ -1012,7 +1012,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>>                                full_command_packet->header.status_block.error,
>>                                error_str[0] == '\0' ?
>>                                twa_string_lookup(twa_error_table,
>> -                                                full_command_packet->header.status_block.error) : error_str,
>> +                                                le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,
> 
> Same here
> 
>        Arnd
> 

Cheers,
Samuel
