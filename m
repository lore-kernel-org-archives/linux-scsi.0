Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CD2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 17:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJRRwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 13:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJRRwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 13:52:04 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F03BD9F;
        Tue, 18 Oct 2022 10:52:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 79E675C00C3;
        Tue, 18 Oct 2022 13:51:58 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Tue, 18 Oct 2022 13:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1666115518; x=1666201918; bh=II
        O0D0kV0kC6d6t3CNBJiQk8iztHZYQDVT51yInx5rI=; b=of0lhuBsdewkvzroYm
        pr0kZIH+RZYDL0Wo1FEHRDsFfoAphN+8W8rUKeN8uzEfDSb8XKDcATTjBZpqoLJW
        88Y7jFe5e9VIFfsk2XnMsIVMI7H+lfAHT//YQDZ2kOHZ3k951+KbZZe2+D0mOpBr
        X4qqRj7eu+F/h8A0g8tj3QO+fKTo2TwB6u1WSLL77r4WjiC9QKUDwoc9rqyLlLlK
        vP5Szbd3J0PNcwW6UBAj8Q5S9KlVYVWsSwrqhGMIMkeBKF8cuT5NwnTSWX29GCBc
        CjkXtjE4ptHNpjE95qgLsJNzWnBKHwtwA1D59QV6vNfgSsW9Uv1c8SgZNqDm3af+
        e5BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666115518; x=1666201918; bh=IIO0D0kV0kC6d6t3CNBJiQk8iztH
        ZYQDVT51yInx5rI=; b=UlYD9bS4qeEFSLLB8jrYCOXfE1W0mURHWCxl88c41f9+
        tBx+9MFYwyL9ZlMmA2YuLuZQVrk26YhNRjnFnsT2EnmGAjEq5UyLGyMf0flLyhqA
        kHxfYc3du40h92bDBq+Sp5hX6hbfv0vbjiTj/UBQ0D2KaW69h8K75HGUlu9NWLuo
        TpZyaoE6jsNTAuCMaY6E71Kqo/xvoONP4rfJqLWFEU3ss0r5lx0UjmiYPxlIoHo/
        Ax15WvLX8TmFmwSXLxZE6it7VebwKk3l/+d8LFgeSyWRdUfSpWtZxjNvdO9HAi5f
        PTGvvXeM8WN1DzzVel/n9PuGjhSd8GhkXuxrdc6Y4A==
X-ME-Sender: <xms:vedOY03aEm5RuxN5Xgvx6YPvdnhK13e1paPXdR3HIcfwziU1_zbPUA>
    <xme:vedOY_E8Ghu9XMOF8I87KHM2YLAxOx4eoJTunFqXfzFty2_0MuZswbT5lE45c5H-c
    7ElpB4EaVasIYndaYc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfufhv
    vghnucfrvghtvghrfdcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrf
    grthhtvghrnhepleevgfegffehvedtieevhfekheeftedtjeetudevieehveevieelgffh
    ieevieeunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshhvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:vedOY87QeEC3wngQQwliN65m7qefEXgtxl_qvb4x-fbxg4Z5_v1leg>
    <xmx:vedOY91n1WXlMFwwMuIDMjkhxWK-0N3O0tH2hUMhATS4zxFuzm1O_w>
    <xmx:vedOY3GLLblXHQNZSKQg_GkDD9_u4rHAEQ8V5QZ3rVz4yBXTX2ijLQ>
    <xmx:vudOY85sz46vghWdJ52Ypq9szSb6fusZeMeGDI12o9KVugypb75Aig>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 63129A60082; Tue, 18 Oct 2022 13:51:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <d818d314-2b00-4667-9188-8d942665032c@app.fastmail.com>
In-Reply-To: <20221018135720.670094-5-hch@lst.de>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-5-hch@lst.de>
Date:   Tue, 18 Oct 2022 19:51:36 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "hch@lst.de" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>
Cc:     "Hector Martin" <marcan@marcan.st>,
        "Keith Busch" <kbusch@kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] nvme-apple: remove an extra queue reference
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2022, at 15:57, Christoph Hellwig wrote:
> Now that blk_mq_destroy_queue does not release the queue reference, there
> is no need for a second admin queue reference to be held by the
> apple_nvme structure.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sven Peter <sven@svenpeter.dev>

