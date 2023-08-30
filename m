Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF3AC83F17
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 00:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbjH3APh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 20:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbjH3AP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 20:15:29 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA68D7;
        Tue, 29 Aug 2023 17:15:24 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 5B1773200919;
        Tue, 29 Aug 2023 20:15:21 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 29 Aug 2023 20:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1693354520; x=1693440920; bh=KV
        03NR1kMUyJeQTOggm1GVkAX4I3pR0TZBWBF3vl04g=; b=f8hggdthmg7JXnrCYy
        iKEpfyY4pg/xHk2DO/x7oillZK2LxUvZ1QTLiXP4V9EvayMcoF7+fMk/HUIxfTSl
        cMQbTzbedal6NoF56GvUMAV7NfzZ2vJv6nxOCD2G+BL+zt7vaag+bjEiFpMoXjdX
        rzMkN3bUGsa39jcbN7V+Eq/65quZb8oY5SGfibvhxo0Gq3b2rc9ACobTu7+VBJR5
        Cm94sHDj0p90QsRvw2R8RlhVydBYy+TxXsQV5XzgWPI9tU4ZHPyX8udR6nMdKYlg
        Pm9nrlpR9l5Rmukw3T4155GCCrKq2y9SzVbaVHufYun1eYVsaMApJ33IIpVHr41R
        MSAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693354520; x=1693440920; bh=KV03NR1kMUyJe
        QTOggm1GVkAX4I3pR0TZBWBF3vl04g=; b=cuQbQSb4FZT5wGtffbUCb/O2cKxd0
        yRIbgrH32NCjHBUVEMUkMIIWSqZjEojNgp1VM36fAPntcSYKTsdzATUyejfVepM3
        pCjMJZOZXKy6t/2peZEHemyC07Wh9i94A6ida4lNZDWk/ixlWFkic3oFUironk2i
        FR/dSxUZdtrAzMUxmF/SKus+93JOAF/GcQjbk2Q5bxox6cxdV91uqvZat0mMhgku
        5Xkj6xqDsL4z2La1ZStgkWoZ71TIgbGKXO5T0l14tjOjGpO5vdlzO3tmsg6MVxq+
        aTx19H9+X4ydSAjplsyKAOQMuQe9gezLuFVCgMr9eMPdHkIO74evDlrdg==
X-ME-Sender: <xms:GIruZDqQaX3Ul_Tq0Sd7vXJMu3sYnUMRT5iE_JElhD10Phtylgfdkw>
    <xme:GIruZNqg9MaAJIW0nieKjUzyAwLCt9jYhouxveO5h5WVh9xFTj6XTyZkJK5yDa3MA
    iOarIcVtfbzp20D-Hs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudefjedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:GIruZAOxBMtFOONoNKpTUFoG5xQMABxDAeCPVym9PtItsIPHJfVuHg>
    <xmx:GIruZG58r7VoxAMS4ITZYrep6g58WPy6jOMeB0ndKYYZ-r2pLUsKpg>
    <xmx:GIruZC6TLlvTkhEVOk-rzFSV5IYZIgasDvSE0IOeI_WkQxuWn8ESFw>
    <xmx:GIruZCGY20JpNYbc0t5BvFevghE51MsjV_XJ3JzuZpLfRMBGCXQ6IQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 67E90B60089; Tue, 29 Aug 2023 20:15:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-701-g9b2f44d3ee-fm-20230823.001-g9b2f44d3
Mime-Version: 1.0
Message-Id: <31a63180-ffdc-4b5c-8bc6-3be4728a8463@app.fastmail.com>
In-Reply-To: <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
References: <20230829214517.14448-1-schmitzmic@gmail.com>
 <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
 <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
Date:   Tue, 29 Aug 2023 20:14:59 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Michael Schmitz" <schmitzmic@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-m68k@vger.kernel.org,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [PATCH] scsi: gvp11: add module parameter for DMA transfer bit mask
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 29, 2023, at 18:25, Michael Schmitz wrote:
>
>>> +module_param(gvp11_xfer_mask,  int, 0444);
>>> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
>>> +
>> I think the comment is the wrong way round, it should be
>> 0x00ffffff in this case, which also matches the default
>> mask for ZORRO_PROD_GVP_SERIES_II, in the match table:
>>
>> static struct zorro_device_id gvp11_zorro_tbl[] = {
>>          { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
>>          { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
>>          { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
>>          { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
>>          { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
>>          { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
>>          { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
>>          { 0 }
>> };
>
> gvp11_xfer_mask works inverse to what you'd expect (and inverse to what 
> a DMA mask usually is defined as). DMA can _not_ be used if (address & 
> gvp11_xfer_mask) isn't zero. See code in dma_setup() for details.
>
> All those definitions have a '~' prefix, for that very reason.
>
> I agree it isn't intuitive, and caused a little head scratching when 
> preparing this patch. But I believe it is correct.
>
> Now you could argue to shift the bit mask inversion to gvp11_probe() or 
> even dma_setup() instead to rule out such confusion in future, but that 
> would be an actual code change and would benefit from testing on at 
> least one of these boards IMO. Not sure how easy that will be.

Ok, I see now. Let's leave the patch as it is then.

Acked-by: Arnd Bergmann <arnd@arndb.de>
