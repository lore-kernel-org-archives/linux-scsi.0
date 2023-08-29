Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF41C71153
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 18:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbjH2S0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbjH2SZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 14:25:35 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DF010E
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 11:25:32 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id ECB43320099F;
        Tue, 29 Aug 2023 14:25:28 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 29 Aug 2023 14:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1693333528; x=1693419928; bh=hU
        kdarFqDMFljYY/0JJZpUb+/s6nrE2cPjefduS+uiE=; b=M/oGaustglWrxh63+A
        z+075cJwCVrwi+r70Oge7BxM3w0dqAGpyicflZ0TKrRWpbqqM6zhBhCqEItnrQ7h
        kWSqCnbGd3kEeY/Nvk47NXxH3cz/d5srkCR5+wUmsCfdGEdkT+AJyX8t8Un6a4Ud
        UTtFbQcci+HCdgOHSCWWbjw46qMFQkV+mxGK0X2mhGTYOHpDPAuZo5deXRK9w2Tu
        avN7u10hbqn4OqTbBaHJJQSd0vmbbTPqWEkPxJGSyVJhVjxVJVPt2OOzPNjIllhO
        fWYdRU7tcK8L3rMUybuf4SkoMGhy9VZs47Ql55gcTd7x0t6gAuzxNZgOgLvY8ipD
        MJpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693333528; x=1693419928; bh=hUkdarFqDMFlj
        YY/0JJZpUb+/s6nrE2cPjefduS+uiE=; b=WeMytH4UC9suwnad/RzyCD6NVBPzG
        LwZYt9fiACqqhczV0ym1XaelR8cvyYd3yRjGl14oZXkeHOAYd7DTxCozp57sWWrX
        O3Ygrue/U3gwaYcdnTIgr543MDa+TwaHInseZzd0rawdghVJwV6oE1LJ62p/9wHV
        NedAFS3GrK0Oa4+SZViPX0iK4X57z93+FO17vGyH4jQ8yi2vdW7i62MJI1yWYsGO
        /Ixp+gY2KIHhyvCuCHFuoOcWdtWJbDpQFNtkYgFS9HQxQQ/5bTd8349vtSAYn4jR
        8uyEKuMFvbedNRD7sQFnmxAP1xuC2s8f0tSBfjage3l9dwSJdtNRqGdKg==
X-ME-Sender: <xms:FzjuZCHzPn62iVKEmdDZ4dz_ry5v6icE6CvIeuE-MttczP9IsER6Jw>
    <xme:FzjuZDVHn1fIAaqee7kCpI14oeQMFTms3fb4sQaltSESe3UpkjGIJweAasHQYBAkr
    ORaqk2oEIorw90fdiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudefiedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeu
    feehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:FzjuZMJHB_v2pu1lHWx5BJJuZoFwzF5QVzR5vGBc5G_Sm5zAJCDoig>
    <xmx:FzjuZMFFTRQDbfKJbmfm62TWGi8lMcjORaSaNGHUuC7i59GiuI2BLQ>
    <xmx:FzjuZIXdwfmVeyRXQHvUtpumuF4i-8SWSLo_cO0eS-1w0je2GMFAAQ>
    <xmx:GDjuZPQ8VFGlVmil7BBxQx9XiTYiJeB0J3s8sEpGDf_JB7shD3NEmQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CF1D3B60089; Tue, 29 Aug 2023 14:25:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-701-g9b2f44d3ee-fm-20230823.001-g9b2f44d3
Mime-Version: 1.0
Message-Id: <c64100c9-659d-4575-bd2e-3b3730422599@app.fastmail.com>
In-Reply-To: <20230829163547.1200183-1-bvanassche@acm.org>
References: <20230829163547.1200183-1-bvanassche@acm.org>
Date:   Tue, 29 Aug 2023 14:25:07 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, "kernel test robot" <lkp@intel.com>,
        "Bean Huo" <beanhuo@micron.com>,
        "Avri Altman" <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Fix the build for the old ARM OABI
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 29, 2023, at 12:35, Bart Van Assche wrote:
> All structs and unions are word aligned when using the OABI. Mark the union
> in struct utp_upiu_header as packed to prevent that the compiler inserts
> padding bytes.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: 
> https://lore.kernel.org/oe-kbuild-all/202308251634.tuRn4OVv-lkp@intel.com/
> Fixes: 617bfaa8dd50 ("scsi: ufs: Simplify response header parsing")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
