Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19488C6FA8F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 22:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjH2WGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 18:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238830AbjH2WFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 18:05:47 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12433132;
        Tue, 29 Aug 2023 15:05:45 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 2E9563200951;
        Tue, 29 Aug 2023 18:05:44 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 29 Aug 2023 18:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1693346743; x=1693433143; bh=n4
        +LqOxV9x7zOhvxyuDhHD7aHn1YAjQnTQK98pjvt30=; b=eP7m6cm0f/tMSWRIlx
        7F9QPolnrJC4QuR/J3ObIua5wIgsL8k5ipB/2cDt9RaEudMM2LZz4Bv2HOWN1Ojq
        W3QoMBUmB1YRjKLtBrT4kgBYVB/xVVmJq8pwKMbwUD0JA17wZ7sBogZlu15vHJ7A
        HX9FVIN+p3UZPEmYDG01yLPTYSe8QmXDbEY/KYH4UmyIa+uhjgGr7PdbTJtl0Lpx
        mp30OA+Nqvp5GlMTPIis29TrOwXhCdxeP4+ZaI0WWTUYUbQ9C0W68aYkG9bgP7qo
        qFYgBMTmz5mUtIOKXg93dTGkUiroBHm6Vbjo4XCuaxQwdmjPEyaRe1lDu8PXsfIF
        vAHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693346743; x=1693433143; bh=n4+LqOxV9x7zO
        hvxyuDhHD7aHn1YAjQnTQK98pjvt30=; b=RYIkXnqmnlLPa0n9E0UJ23wS20fla
        xGnuRbz1zR6JGbtEQ8lmg0/Vzoy0jTAp5wbWSrn19hLD4MqIbBxwHSfFEU2Pf9sP
        sf19ned/eACTE+2AqqLAKh2jGtTZ62E6P8QI1lGiMpin68NX88qg7bXYrs9Dhae4
        A7Go0EVirYX5APQ2c6AxYMJQ1MxM/+ZI76KX7MqxxMh22WXJFBkN0G/ULDCHVUPi
        rjxdbO9wqsPNJzc7K+C5x+QblEoN6c+5sfv97KERpb54fy706J+wM1hlCEHvJv6y
        6HM2nUQLx2urGrHssfuiYepPn2b6yIGEsqJiKLJ8+IZyljjRw7e3DZUJg==
X-ME-Sender: <xms:t2vuZO5KWY_WqkTbQgUkfQylspUpICkqif2_mQsKQeflbfpy841jvw>
    <xme:t2vuZH7XtAGLqQ9mL_UQAiraA5bSiNh7F3SZhVSF5uDPfZKMpVEBGdOg6TimsV2Yj
    MggFmZ9zV6amVB_A8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudefjedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:t2vuZNdMIxd3ierFJsGN_OJUCs8vvK8aTlrpHU2ZvS-ScFi9nOcQIg>
    <xmx:t2vuZLJNKB4Q2ZBsiVm5Xzvfs9eZrScCynednckBnWyu2d51AbK4Pw>
    <xmx:t2vuZCLFUkUweNX2TZX2EmGS--6CTzyjYsmm0SBBb8faVcsi4z4Hbg>
    <xmx:t2vuZJWU0LCWV9gsJEpy7kjNVZE7ud4sWhRsAHymFdYN_-4YhDbJ5w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4FB49B60089; Tue, 29 Aug 2023 18:05:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-701-g9b2f44d3ee-fm-20230823.001-g9b2f44d3
Mime-Version: 1.0
Message-Id: <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
In-Reply-To: <20230829214517.14448-1-schmitzmic@gmail.com>
References: <20230829214517.14448-1-schmitzmic@gmail.com>
Date:   Tue, 29 Aug 2023 18:05:22 -0400
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

On Tue, Aug 29, 2023, at 17:45, Michael Schmitz wrote:
> SCSI boards on Amiga. There now is no way to set a non-default
> DMA mask on these boards.

It might help to mention here in which cases the default mask
is actually wrong.

> +module_param(gvp11_xfer_mask,  int, 0444);
> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
> +

I think the comment is the wrong way round, it should be
0x00ffffff in this case, which also matches the default
mask for ZORRO_PROD_GVP_SERIES_II, in the match table:

static struct zorro_device_id gvp11_zorro_tbl[] = {
        { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
        { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
        { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
        { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
        { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
        { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
        { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
        { 0 }
};

      Arnd
