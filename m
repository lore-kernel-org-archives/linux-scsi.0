Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5207AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33585207BB
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="HlTEYtDI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KUSmzLAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHCDm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 23:42:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47449 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbgHCDm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 23:42:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D07565C0106;
        Sun,  2 Aug 2020 23:42:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 Aug 2020 23:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=N
        sR/8P0IqNjuSnppL2Zoxnnoe3Icu4h6eNp7eKuYboI=; b=HlTEYtDIhIPcrCas6
        ygRkU0vagNN1SrtO0K4haGFv02dypgip7XziBpxDJHnvZNexOTHRFPdcf70jl6xP
        FOp39MfPzu7vHbgJfIQAFD3aUlKf9ytvLw3ODi+mGfWQLRYT4eOyRN6kApj2Tf7u
        cHVuuZvLapXsdFcgQkB+AUWzBXncyXksopCfAtgI7sd29a04inhWRuGQY7sBbFO+
        89Uvaa3iCI2zdaDW5p1Xq5yrkrzGa0MiliAuRLnOZh2FNwwzR5JX+/Btx8azIUOA
        eeSaSTrwgbJeVPEZB33DXeW3iutuI0+LpZP3S2CKhdPWQb7CmRdDFA0pVgg0gpi0
        vNtoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=NsR/8P0IqNjuSnppL2Zoxnnoe3Icu4h6eNp7eKuYb
        oI=; b=KUSmzLArAleV9CEltM1oQ3C5pl2Jt/F3RQrahlO9xp5Uf6m8+uC8zW8+/
        uz7Nyk2FP2ECOr8Uhks/bPkpDXRIuAYMSPzL0g9g/ZcqD22fICPYz1IwkViID/JK
        YWk2Qfefp0j0hJZyf3wTwyjIT29wsfnpt0rgqi+CxeveTWRX3kb4lbkQBvTdpAuk
        eBkr5/hDf1icvRDZEDD4b47/JqBeYFAI9u0ZAFywr4av97HgXi1Imr/+usgwFZOD
        6WvYFN1O/AImOgQ12V9NNQu7RdRNNydMdvYBFtTYact9apbbJlEmVRx8tyGnQa3s
        N7Pm2ULTWmHwigEuB0Ts2/+7x7sKA==
X-ME-Sender: <xms:v4cnXxgiEwXIWR45nuIKMmChEajfIo3bOndcjhqRjM1JFOHV9HtwhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeefgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:v4cnX2Aw3d90Cs7SS-gTcBHMJUmaIEUAfY2SFROuFHVKx16nBWG2Ww>
    <xmx:v4cnXxExhNoFq18c6zQxJlZV7MLWpIDjJopRY1KC9lc5PWVvDl8RDg>
    <xmx:v4cnX2SW7Qyz49pI0YWpVsARNmKq1S_W_tzTXkz9ZjThbW4dzyrZRw>
    <xmx:v4cnX5_jZHmde-DYjWPFTjqV4Psux76MRl2fIL8Sxt7dpnenw9dA-A>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0063F30600A6;
        Sun,  2 Aug 2020 23:42:54 -0400 (EDT)
Subject: Re: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200730220750.18158-1-samuel@sholland.org>
 <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <29ea8d0f-bcab-9ffd-0e2f-f022911f4bf2@sholland.org>
Date:   Sun, 2 Aug 2020 22:43:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/31/20 2:29 AM, Arnd Bergmann wrote:
> On Fri, Jul 31, 2020 at 12:07 AM Samuel Holland <samuel@sholland.org> wrote:
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
>>
>> Changes since v1:
>>  - Include changes to use __le?? types in command structures
>>  - Use an object literal for the intermediate "schedulertime" value
>>  - Use local "error" variable to avoid repeated byte swapping
>>  - Create a local "length" variable to avoid very long lines
>>  - Move byte swapping to TW_REQ_LUN_IN/TW_LUN_OUT to avoid long lines
>>
> 
> Looks much better, thanks for the update. I see one more issue here
>>  /* Command Packet */
>>  typedef struct TW_Command {
>> -       unsigned char opcode__sgloffset;
>> -       unsigned char size;
>> -       unsigned char request_id;
>> -       unsigned char unit__hostid;
>> +       u8      opcode__sgloffset;
>> +       u8      size;
>> +       u8      request_id;
>> +       u8      unit__hostid;
>>         /* Second DWORD */
>> -       unsigned char status;
>> -       unsigned char flags;
>> +       u8      status;
>> +       u8      flags;
>>         union {
>> -               unsigned short block_count;
>> -               unsigned short parameter_count;
>> +               __le16  block_count;
>> +               __le16  parameter_count;
>>         } byte6_offset;
>>         union {
>>                 struct {
>> -                       u32 lba;
>> -                       TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
>> -                       dma_addr_t padding;
>> +                       __le32          lba;
>> +                       TW_SG_Entry     sgl[TW_ESCALADE_MAX_SGL_LENGTH];
>> +                       dma_addr_t      padding;
> 
> 
> The use of dma_addr_t here seems odd, since this is neither endian-safe nor
> fixed-length. I see you replaced the dma_addr_t in TW_SG_Entry with
> a variable-length fixed-endian word. I guess there is a chance that this is
> correct, but it is really confusing. On top of that, it seems that there is
> implied padding in the structure when built with a 64-bit dma_addr_t
> on most architectures but not on x86-32 (which uses 32-bit alignment for
> 64-bit integers). I don't know what the hardware definition is for TW_Command,
> but ideally this would be expressed using only fixed-endian fixed-length
> members and explicit padding.

All of the command structures are packed, due to the "#pragma pack(1)" earlier
in the file. So alignment is not an issue. This dma_addr_t member _is_ the
explicit padding to make sizeof(TW_Command) -
sizeof(TW_Command.byte8_offset.{io,param}.sgl) equal TW_COMMAND_SIZE * 4. And
indeed the structure is expected to be a different size depending on
sizeof(dma_addr_t).

I left the padding member alone to avoid the #ifdef; since it's never accessed,
the endianness doesn't matter. In fact, since in both cases it's at the end of
the structure, it could probably be removed entirely. I don't see
sizeof(TW_Command) being used anywhere, but I'm not 100% certain. The downside
of removing it would be TW_COMMAND_SIZE becoming a slightly more magic number.

Regards,
Samuel
