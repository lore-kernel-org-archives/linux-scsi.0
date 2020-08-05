Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C07C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6EB320792
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="FGaykwiF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="U809+Xbe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHEBop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:44:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40233 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgHEBom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:44:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CDDA65C0095;
        Tue,  4 Aug 2020 21:44:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 04 Aug 2020 21:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=u
        06P7z6m1kNpgFr6hDrql2GLhGDNcpuRMO8kmQxO9IY=; b=FGaykwiFqALI4h2Po
        lviK7TdIblwkKnY7+gXH8B+Bvhcs5VtlAX/uvDjTDLaqaD6EEFyJmhVYcBTHUfWx
        NR+gB9cwXW5RnR5NRTTHkuCMHUD/WK3RwhhUjaBz2u10qp429qEpIpEBjsXiMtEd
        uvDKrsWkcQ9A9/ervYmB9Yb9OE1hsTdH6tC6jqshe8ypRf22odD6c9xeADX3iL9z
        SP5ePgo+9Vf0wY9b9MMFlfiGWzS7tW9jo6tChVfMJprHmaKf875C/U7e1lzX8YQb
        QJyXBZIAFz5mjkcMUUQ7qfPcTmU2z52uZNfJQnGL6d8xqahZpS76wLGjtp/Mog8q
        24CQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=u06P7z6m1kNpgFr6hDrql2GLhGDNcpuRMO8kmQxO9
        IY=; b=U809+Xbe4uwlrO6wxTgLkC2OPuDQKNYrquk4RBg9QoikXlOFSoGJyM9OW
        ECjZtYZOI0EQ7F21ujvgXrrrPBpu7I2aOTnUSDlA7wacAeCWQQS+rhq+yu4WCxoh
        X4X5Xfl2KWKmui3GoHRPo1Sb40f+Du4OGoO5lTbi6CgT7CEeA/HbNhBYTB0dY7vy
        FEbASgvS2kV9cknMpu3UILjOMELA3IjfPvTp1x0XaE9kgJ09A57WgJzCivQVsh9r
        4l5Kz6jINoPdW23BE9juF1lXGW/8xfCZ3BBwZ4/Zr7b3CFlDXTuRykQe/0DIcXsK
        WfpasqVmb/pHtrfygwDxfcuvBzCLw==
X-ME-Sender: <xms:Bw8qXwhWOeGDSCOwzubO2tXpMXRKk4nAIss6JAoZD5Li_ULTjSfEVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeejgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:Bw8qX5DtCvBBmFz01qoxKKdyXSly1m9oRs-YJX9l6qVkL4pTQ2eAkw>
    <xmx:Bw8qX4HeNt5vv9RqGAHuLLFuVTMj-4jgUk9d_VsuG_GmwxnM0a50qw>
    <xmx:Bw8qXxQPFCua0ZpfuoOUvki510f8vhthjpa5O2JX_77UOEB6GMfIMw>
    <xmx:Bw8qX4_UZ4O6_Zdd5f7kvDD_41aLKJfD-lCnUpd6qKS6_hS41nw7Og>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08CB830600A3;
        Tue,  4 Aug 2020 21:44:39 -0400 (EDT)
Subject: Re: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200730220750.18158-1-samuel@sholland.org>
 <CAK8P3a2p7dWhhCqAYF_Zos-X-zBK+id-xO5hPu2fRTbNyPo9Xg@mail.gmail.com>
 <29ea8d0f-bcab-9ffd-0e2f-f022911f4bf2@sholland.org>
 <CAK8P3a0xSyyaLHziuv4JKimUggF96frwLPKmjQ4G9VBWRW2EMg@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <0bd43d61-4d9a-40cb-27c6-18aaf7f58b48@sholland.org>
Date:   Tue, 4 Aug 2020 20:45:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0xSyyaLHziuv4JKimUggF96frwLPKmjQ4G9VBWRW2EMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/20 9:02 AM, Arnd Bergmann wrote:
> On Mon, Aug 3, 2020 at 5:42 AM Samuel Holland <samuel@sholland.org> wrote:
>> On 7/31/20 2:29 AM, Arnd Bergmann wrote:
>>> On Fri, Jul 31, 2020 at 12:07 AM Samuel Holland <samuel@sholland.org> wrote:
>>>>
>>>> The main issue observed was at the call to scsi_set_resid, where the
>>>> byteswapped parameter would eventually trigger the alignment check at
>>>> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
>>>> complain about an "Unaligned partial completion", and no further I/O
>>>> could occur.
>>>>
>>>> This gets the controller working on big endian powerpc64.
>>>>
>>>> Signed-off-by: Samuel Holland <samuel@sholland.org>
>>>> ---
>>>>
>>>> Changes since v1:
>>>>  - Include changes to use __le?? types in command structures
>>>>  - Use an object literal for the intermediate "schedulertime" value
>>>>  - Use local "error" variable to avoid repeated byte swapping
>>>>  - Create a local "length" variable to avoid very long lines
>>>>  - Move byte swapping to TW_REQ_LUN_IN/TW_LUN_OUT to avoid long lines
>>>>
>>>
>>> Looks much better, thanks for the update. I see one more issue here
>>>>  /* Command Packet */
>>>>  typedef struct TW_Command {
>>>> -       unsigned char opcode__sgloffset;
>>>> -       unsigned char size;
>>>> -       unsigned char request_id;
>>>> -       unsigned char unit__hostid;
>>>> +       u8      opcode__sgloffset;
>>>> +       u8      size;
>>>> +       u8      request_id;
>>>> +       u8      unit__hostid;
>>>>         /* Second DWORD */
>>>> -       unsigned char status;
>>>> -       unsigned char flags;
>>>> +       u8      status;
>>>> +       u8      flags;
>>>>         union {
>>>> -               unsigned short block_count;
>>>> -               unsigned short parameter_count;
>>>> +               __le16  block_count;
>>>> +               __le16  parameter_count;
>>>>         } byte6_offset;
>>>>         union {
>>>>                 struct {
>>>> -                       u32 lba;
>>>> -                       TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
>>>> -                       dma_addr_t padding;
>>>> +                       __le32          lba;
>>>> +                       TW_SG_Entry     sgl[TW_ESCALADE_MAX_SGL_LENGTH];
>>>> +                       dma_addr_t      padding;
>>>
>>>
>>> The use of dma_addr_t here seems odd, since this is neither endian-safe nor
>>> fixed-length. I see you replaced the dma_addr_t in TW_SG_Entry with
>>> a variable-length fixed-endian word. I guess there is a chance that this is
>>> correct, but it is really confusing. On top of that, it seems that there is
>>> implied padding in the structure when built with a 64-bit dma_addr_t
>>> on most architectures but not on x86-32 (which uses 32-bit alignment for
>>> 64-bit integers). I don't know what the hardware definition is for TW_Command,
>>> but ideally this would be expressed using only fixed-endian fixed-length
>>> members and explicit padding.
>>
>> All of the command structures are packed, due to the "#pragma pack(1)" earlier
>> in the file. So alignment is not an issue. This dma_addr_t member _is_ the
>> explicit padding to make sizeof(TW_Command) -
>> sizeof(TW_Command.byte8_offset.{io,param}.sgl) equal TW_COMMAND_SIZE * 4. And
>> indeed the structure is expected to be a different size depending on
>> sizeof(dma_addr_t).
> 
> Ah, so only the first few members are accessed by hardware and the
> last union is only accessed by the OS then? In that case I suppose it is
> all fine, but I would also suggest removing the "#pragma packed"
> to get somewhat more efficient access on systems that have  problems
> with misaligned accesses.

I don't know what part the hardware accesses; everything I know about the
hardware comes from reading the driver.

The problem with removing the "#pragma pack(1)" is that the structure is
inherently misaligned: byte8_offset.io.sgl starts at offset 12, but it may begin
with a __le64.

Regards,
Samuel
