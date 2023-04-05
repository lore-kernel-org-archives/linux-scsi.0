Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF09C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Apr 2023 22:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDEW3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Apr 2023 18:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDEW3j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2023 18:29:39 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4334310C8;
        Wed,  5 Apr 2023 15:29:38 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D8E47582237;
        Wed,  5 Apr 2023 18:29:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 05 Apr 2023 18:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680733774; x=1680737374; bh=0hvdTrqnIesfwKwVq3biOhVWklyP7PuBB8v
        wBclqcXE=; b=IPp+MnqRTTn2N3vo6dlles7qSJybzgJBtGedU7ArVmfm98PRps1
        ysXZ3RJjjMsXtT+cIAhg5aSMTY+WXe+fIt616o4yicnIRSI/9Ld4wdlt5QUnfOlj
        LsRrcbIeun2wHjykL/2UDc2MYH6v1u1pxWFH7cSdT8okDz9CmTKTeV5e6mf4yRd3
        /x7nDB3n3DU0CQfnrQIkY5imJeUTj4lkuq6SrySmX70DyZGy6VBv5ocqBAfRMgEl
        /rl4RRPX88V2Q6ZvvPIczhADDw5RaBe6yJFb3dhFEbRmwcwkJITlOgXbp3wwhexn
        FndoTzGqo3NjiVRPgPxwY4wdKHL1yRtL5ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=i3db14652.fm2;
         t=1680733774; x=1680737374; bh=0hvdTrqnIesfwKwVq3biOhVWklyP7PuB
        B8vwBclqcXE=; b=JcCcM8Seu/Bh6214t3XI5cK0zyL7dg39sz8nnX1B1UPlCXoL
        gdzUZNAJmpbmsdUvHmOTs99SqfIn4gjPjIPVkWu8ouLGnwGjiho1tXob7mpAE4rv
        4F6sa53NCV4KDpWeXG0Ws0JBcRtFX0DaxiRNkxOL+wjeJg0mFe2k/22pZCD0o1XU
        WpC0JOtcItxF8K7TX6x6pq9MNeK6Vg1w3yR/JCUbKhKIgCLoO8Ipm41eS+so6g1Z
        p03R2uurm2OVJ6mfWa7WaZno9gsndIqfZid73nQmUlbtXhKXTieEJRLTCKoTzp2q
        46spHIN0zCdtNag5s4LwFoKJ9fQHAX0UHN+QZg==
X-ME-Sender: <xms:TfYtZHLAdghiXg-PzztIWq6FvuRpVXQ44Khif8DBv__firBZcOw-Zw>
    <xme:TfYtZLJ4hNjC0q5fjPHb2Ocbr3F_qwbs1L0b5d4U7alWybB1pJb6yJkeD7uGYssX-
    9NrKNPuVfNuOZ5jPjU>
X-ME-Received: <xmr:TfYtZPunT8yMHXDDLF6TAQLFmVq2wVlcwhb_hX5tSuSpStl5D5h7_lRZ0bT3PBmva1hiFJfu-Os7wCpPe3sdqelLOaRkcrYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejvddgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeffrghm
    ihgvnhcunfgvucfoohgrlhcuoegulhgvmhhorghlsehfrghsthhmrghilhdrtghomheqne
    cuggftrfgrthhtvghrnhepteefiefhieetgfevhfegfeehffetteduieetudfgleetvdff
    udelveejfefhfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepughlvghmohgrlhesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:TfYtZAZ0HVncHW_8sn3-0_lMi9HLVzug-mragr37Q2RPjbB3xijvAw>
    <xmx:TfYtZOaOk80OEjjPzUCCR3NG2LfrCWftqEDoCQSHzWEHwhhBXRxDeQ>
    <xmx:TfYtZEAYJct45crcqaVI-X01Xp6JqTh_AQXeVMpOKbAXX2cjhlFPyw>
    <xmx:TvYtZLSmM-oHr3AxtvQe2FtoYRhW_2BBEL4vq8Im_0ucS4dwEHTF6w>
Feedback-ID: i3db14652:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 18:29:30 -0400 (EDT)
Message-ID: <e61cd958-2cea-a03e-2581-a8cea1940028@fastmail.com>
Date:   Thu, 6 Apr 2023 07:29:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 18/19] ata: libata: set read/write commands CDL index
To:     Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-19-nks@flawful.org> <ZC29XNMS9CnQZn74@google.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@fastmail.com>
In-Reply-To: <ZC29XNMS9CnQZn74@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/23 03:26, Igor Pylypiv wrote:
> On Tue, Apr 04, 2023 at 08:24:23PM +0200, Niklas Cassel wrote:
>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>> For devices supporting the command duration limits feature, translate
>> the dld field of read and write operation to set the command duration
>> limit index field of the command task file when the duration limit
>> feature is enabled.
>>
>> The function ata_set_tf_cdl() is introduced to do this. For unqueued
>> (non NCQ) read and write operations, this function sets the command
>> duration limit index set as the lower 2 bits of the feature field.
>> For queued NCQ read/write commands, the index is set as the lower
>> 2 bits of the auxiliary field.
> 
> CDL index is lower 3 bits, not 2 bits.

Yes, typo. We will correct that.

> 
>>
>> The flag ATA_QCFLAG_HAS_CDL is introduced to indicate that a command
>> taskfile has a non zero cdl field.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> ---
>>  drivers/ata/libata-core.c | 32 +++++++++++++++++++++++++++++---
>>  drivers/ata/libata-scsi.c | 16 +++++++++++++++-
>>  drivers/ata/libata.h      |  2 +-
>>  include/linux/libata.h    |  1 +
>>  4 files changed, 46 insertions(+), 5 deletions(-)
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks.

