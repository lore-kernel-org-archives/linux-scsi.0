Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BA3C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1642067D
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="tu9NneHp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cWW6BWrU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgHIAPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 20:15:48 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57397 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgHIAPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 20:15:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9BB1BB60;
        Sat,  8 Aug 2020 20:15:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 08 Aug 2020 20:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=y
        vOPStliDSglBNmDnBR6AYqxqz09pbG16uf9qIobP9Y=; b=tu9NneHpzFHCfUUFy
        nsp69Qbe1EDlYhZld10jheHFWTlV1Q2x4CFOzdIGa+fhNtCb/s0mr9kxy++jX4lI
        f8tOM8l/x3cM9SgnN4Z6F4hfte/XR9JYGh6CteFZ4Tnf12SUqFWtp25rNlC8TV59
        /VBIcJDXpIFhu8UFBOLWFFINhyY39TItxNSZcY1r1BHUalhtiyhsXh/3lA24ncoy
        njKj9FxUi27sR6der5GJkqpBz3i9Vi8WRLrw+xJJmFGhj5D29T4NVM0x45863QcI
        hZ2scZvA11TyAWTQIruySsg1mCHNrqmmsCjB5tbyeoY2UgrjNDiI7hMoyixlUaiM
        N5L4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=yvOPStliDSglBNmDnBR6AYqxqz09pbG16uf9qIobP
        9Y=; b=cWW6BWrUeVKqVtUbaNVcNcuEiOLtGUK10d+yf4zi5cbB6prRy5wfUjSfo
        /lQlSHTtB8CUwxqsAABb4i+210pr29+keB7DJEEWp4lMDeDc1BUseqnlsyc25XDd
        HPKa0bwWMRQrAA8R5MdQB9mSeo9kcZFy0KJkZT5QPT+RtY2mn/XCQcAUC9UFnGlm
        T113VsW3zfE25yEs1j0Cou39xvKxn1TWZjF/GmAye+M2wCcWWqbk2Za77Uz8KAJh
        fhFC5rJQbbeVqctGM9p/g3RESiGi7CMnckfOgsVQ6B9uOQ7Vv1MtEVoAwnJB+q6c
        wTs3jfSD0D/XYw4kSu3aFXBxaRLZw==
X-ME-Sender: <xms:LkAvX1Zhn2aGkjAWiT1ry6Csjz6_Kwa-zjAD5QDhPIRC6chHZQa4Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeehgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpedvleejhfdtfeduveeiueelffehvdegieelhfegheevvdeugfeftdei
    ieefveelkeenucffohhmrghinhepghhnuhdrohhrghenucfkphepjedtrddufeehrdduge
    ekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:LkAvX8bRjXqpSbDUw5fJ5zDLprl_XsqM2IX2U_FtFSVHmwl9Oh_SAw>
    <xmx:LkAvX3-NwqZDeIz1UJZnmcYInNCqoJAAoWFv5Qv7JImOIuEhYXQLcw>
    <xmx:LkAvXzrF7aOzM12uXH3xug_bcLigThwmkFY450rVfyQVztlosv5gew>
    <xmx:L0AvX31eL35nKWLFgzuMy0Wyoz0ll7w3yTz_QW4QzErElvk5kYiS0g>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 614B73280059;
        Sat,  8 Aug 2020 20:15:42 -0400 (EDT)
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
 <0bd43d61-4d9a-40cb-27c6-18aaf7f58b48@sholland.org>
 <CAK8P3a3bPb+-i2YbHmn84MEuCe4xG_BKP15vNO1B1kTkYZ+=pg@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <3493a479-3468-02e4-6eed-3645875b7841@sholland.org>
Date:   Sat, 8 Aug 2020 19:16:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3bPb+-i2YbHmn84MEuCe4xG_BKP15vNO1B1kTkYZ+=pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 2:17 AM, Arnd Bergmann wrote:
> On Wed, Aug 5, 2020 at 3:44 AM Samuel Holland <samuel@sholland.org> wrote:
>> On 8/3/20 9:02 AM, Arnd Bergmann wrote:
>>> On Mon, Aug 3, 2020 at 5:42 AM Samuel Holland <samuel@sholland.org> wrote:
>>>> All of the command structures are packed, due to the "#pragma pack(1)" earlier
>>>> in the file. So alignment is not an issue. This dma_addr_t member _is_ the
>>>> explicit padding to make sizeof(TW_Command) -
>>>> sizeof(TW_Command.byte8_offset.{io,param}.sgl) equal TW_COMMAND_SIZE * 4. And
>>>> indeed the structure is expected to be a different size depending on
>>>> sizeof(dma_addr_t).
>>>
>>> Ah, so only the first few members are accessed by hardware and the
>>> last union is only accessed by the OS then? In that case I suppose it is
>>> all fine, but I would also suggest removing the "#pragma packed"
>>> to get somewhat more efficient access on systems that have  problems
>>> with misaligned accesses.
>>
>> I don't know what part the hardware accesses; everything I know about the
>> hardware comes from reading the driver.
> 
> I see now from your explanation below that this is a hardware-defined
> structure. I was confused by how it can be either 32 or 64 bits wide but
> found the
> 
> tw_initconnect->features |= sizeof(dma_addr_t) > 4 ? 1 : 0;
> 
> line now that tells the hardware about which format is used.
> 
>> The problem with removing the "#pragma pack(1)" is that the structure is
>> inherently misaligned: byte8_offset.io.sgl starts at offset 12, but it may begin
>> with a __le64.
> 
> I think a fairly clean way to handle this would be to remove the pragma
> and instead define a local type like
> 
> #if IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT)
> typedef  __le64 twa_address_t __packed;
> #else
> typedef __le32 twa_addr_t;
> #endif

I would be happy to implement this... but __packed only works on enums, structs,
and unions[1]:

In file included from drivers/scsi/3w-9xxx.c:100:
drivers/scsi/3w-9xxx.h:474:1: warning: 'packed' attribute ignored [-Wattributes]
  474 | typedef __le64 twa_addr_t __packed;
      | ^~~~~~~

[1]:
https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-packed-type-attribute

> The problem with marking the entire structure as packed, rather than
> just individual members is that you end up with very inefficient bytewise
> access on some architectures (especially those without cache-coherent
> DMA or hardware unaligned access in the CPU), so I would recommend
> avoiding that in portable driver code.

I agree, but I think this is a separate issue from what this patch is fixing. I
would prefer to save this change for a separate patch.

Regards,
Samuel
