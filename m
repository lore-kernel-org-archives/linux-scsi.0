Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F468C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8CD23125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbhAMFlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:41:22 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48123 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbhAMFlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 00:41:22 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D6C7C1B5E;
        Wed, 13 Jan 2021 00:40:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 13 Jan 2021 00:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=K
        lCdViREDcC+bZwtCUmQ5DVAHLVsbLXQVOUnc3f4sdI=; b=bzi4TPIE5tst5shwW
        nwq8KeZBR97k0fb4kTTEZZVfBSOIU7m29kMH9WGB/SxVzzMI4prPdBtSPskcrorD
        gBnMVpHAhaMjUUotVdluM1MySxOLX1iuvyOxNf/V4Wi4rA0iNuSNwH/62FLqyrD0
        oifIt0sqM8stCblLhiiBf6WY2OZiO9ES7v/Y0AT+9ZcQym3fkqCEpm4YM3+AKeOR
        P99NWcWo9/AcqpZlvevUIqE2hLywjAmlCSf+xWTFWSJ6vZgjoprRaiJzzq53Pd38
        J+sSqM0yMPhhp3Ssxh5d0fyYa90OxsTQlyM4R0a3/YGqzX+Zg7MmjhcBz0mK1M98
        2g53Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=KlCdViREDcC+bZwtCUmQ5DVAHLVsbLXQVOUnc3f4s
        dI=; b=o2/gg4cud3yyFJ9ch0f/nK2M5CfWE1EEvfysPdk1HjCpaqlY6rCzzJNnc
        QqWnnRNdGaT5hAF36h/jDqMPphVYvt/NWtuxMAA2aXXJ6EPBjtEK1GtCZAfSdGMf
        99UWKNVBOsm8G4aN2BkihT0pKhLJpYHN+v5c1FzoR2wYfwwQ/jB3P+KnzHpk36L9
        6z/2cj9zv7iBh2nTTaiSXeY+2bs0H74XSRP2L+lkagfFqfIzkitpu19XLD5Zk+Xq
        pnrWTS52uW6Sz+aT8cLGcS7bCqU/EK1qEg8kHIZZRyVVET9af7n4Ki/MyPdjpSGL
        p9cHB4JUAtUGY8RAZpO14iezroIVA==
X-ME-Sender: <xms:0of-XwubfEt5Dm5K9__tK_6ISsBUYSZlFWOc3We51pKXwTIIspERzw>
    <xme:0of-X9cBdNdcViNFLBO-wSQDl0948sYKAM_gFm0tiP7QM8epUn_O4HhaApcYYTat4
    -AxObArC6YRLAmDBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtddugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:0of-X7xKoBFA0l4KHVepmyjfajWGQYtp0-vk5JhkXpBXt0Si3g_lmA>
    <xmx:0of-XzMmmLaOvr-Du98GCrw4DZh9vX_qxtVN3BBOxQNluSIImluptg>
    <xmx:0of-Xw_aYR57REvhMUgXVfKllM10LeWFjK9tccfsoPj_Zkpkv_ahsg>
    <xmx:04f-X0Z9ie1V_x1KNtEmzI7ETZ2nuI8fV-RZ0OiL5EJ_FBC9A7-nzg>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9BF42108005B;
        Wed, 13 Jan 2021 00:40:34 -0500 (EST)
Subject: Re: [PATCH v4 3/3] scsi: 3w-9xxx: Fix endianness issues in command
 packets
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200903034450.5491-1-samuel@sholland.org>
 <20200903034450.5491-3-samuel@sholland.org>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <8daed7eb-35c3-2890-385f-2f07b8ffe9a8@sholland.org>
Date:   Tue, 12 Jan 2021 23:40:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200903034450.5491-3-samuel@sholland.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/20 10:44 PM, Samuel Holland wrote:
> The controller expects all data it sends/receives to be little-endian.
> Therefore, the packet struct definitions should use the __le16/32/64
> types. Once those are correct, sparse reports several issues with the
> driver code, which are fixed here as well.
> 
> The main issue observed was at the call to scsi_set_resid, where the
> byteswapped parameter would eventually trigger the alignment check at
> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
> complain about an "Unaligned partial completion", and no further I/O
> could occur.
> 
> This gets the controller working on big endian powerpc64.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>

I believe I addressed all previous comments to this series in v4.
Is there anything preventing it from being merged? Do I need to resend it?

Regards,
Samuel
