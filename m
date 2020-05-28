Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75413C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 15:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEE82075F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 15:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bootc.net header.i=@bootc.net header.b="Etdc4YUU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eGWvnwhj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404253AbgE1PRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 11:17:02 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58553 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404221AbgE1PQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 11:16:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B06FAABA;
        Thu, 28 May 2020 11:16:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 28 May 2020 11:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootc.net; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm2; bh=t
        d003DFyixtDY6qWdGDWXt7aHufyht8GTRmfiOc/DXo=; b=Etdc4YUU69IE99nuG
        3Zjzgos+3BKyj8EcQ1n9Ic8BahEemS4aHL5i92tzuajpC3uJZShDwKrX7hhPw+C4
        M76AsCF+Ca+Y6aR3lSAf4U8P2AW2i/xrHTFJ34wdQesJAPl8jkQCk3h/J4rtfBX3
        D1ljNzc1hP1+CkdmlYbTyvtsSnfdSqHFq8QjlOwffAn3CCJejEJq47tEk8ZU3GR/
        jZVgy3ojrH/A7+BhdSr2tS9vg+uvKKa/xLeCPXes0SBwIY5VhJOv9a4fk117yRRE
        tEumD8MblFP8qbt2g4GSSlk3ejSs/q1kSntnsir4PvJbmk8V2OoUG3wpG2Uj6ged
        9NN9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=td003DFyixtDY6qWdGDWXt7aHufyht8GTRmfiOc/D
        Xo=; b=eGWvnwhjCkbY0Iy+8g0V02MLEqTKQp5rI4iZpxDt+7QWTA+as54C88qvd
        MjoOtOwyqDxQyacV9vdu9AhNELnlIGb4FeDers2b0WXXJldAKPtQ/IZNChkQHzQc
        aMqvBr2jyBJZTn6OEmxCpPI8y14VeBl+9LJsVS4uc+3u0Z79SDYqY5CZji30xVD6
        fi88Uw32iWoZ/dGP4ghqbVWA+HHzWLaa+mwd8LfqU7mrJPnbHiGBy9wPE0XeJDu7
        Y91wb0sPsy5ohguWWSHy/yS//URl6bNMjbIxROlTlT4u0uo+Wf+qYStKE2Gqb8ns
        DqTPSZPlZmk7mR3MHbWcdTjFa2BCA==
X-ME-Sender: <xms:6NXPXqkoxWXG4okRtFNfhDir5vNCcpqWLdN_zHGKgWm1AMsPeAua_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddviedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepvehhrhhi
    shcuuehoohhtuceosghoohhttgessghoohhttgdrnhgvtheqnecuggftrfgrthhtvghrnh
    eptedvkeekkefhheetlefhgfejleeiiedtkedtuefgjeeijeettedtieeujeejkeehnecu
    kfhppeekuddrudekjedrheehrdekkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhothgtsegsohhothgtrdhnvght
X-ME-Proxy: <xmx:6NXPXh1CPMnNOj03LYWzAKvJuS6B0f7lYq727PaArUOqEgIhRVUIrQ>
    <xmx:6NXPXoqMKuIJvSvunz1O_AiAyMqIYgTVYdAACVxdSbgED5iELOQViw>
    <xmx:6NXPXuk-fQZ0RRffE0n0DNfAtjEVP7hSmYlCm9RnsJRjqP61ByADRQ>
    <xmx:6dXPXs_LpbXbBrOgQmmY79pTo6_s4chS2OZ8u-2Sy-BwVBnFevKT7w>
Received: from [81.187.55.88] (ripley.boo.tc [81.187.55.88])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A479306218B;
        Thu, 28 May 2020 11:16:55 -0400 (EDT)
Subject: Re: [PATCH] sbp-target: add the missed kfree() in an error path
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20200528102056.911825-1-hslester96@gmail.com>
 <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
From:   Chris Boot <bootc@bootc.net>
Autocrypt: addr=bootc@bootc.net; prefer-encrypt=mutual;
 keydata= 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
 1QBDj3S+cCP/8Pe5l3n1B7V4SkVPBQs/H/ClB6o=
Message-ID: <dcb29beb-0996-a141-89af-ac9c9c5fd5c0@bootc.net>
Date:   Thu, 28 May 2020 16:16:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/05/2020 15:53, Bart Van Assche wrote:
> On 2020-05-28 03:20, Chuhong Yuan wrote:
>> sbp_fetch_command() forgets to call kfree() in an error path.
>> Add the missed call to fix it.
> 
> Hi Chris,
> 
> The changelog of the code under drivers/target/sbp makes we wonder
> whether this driver has ever had any other users than its original
> author. Do you agree with this? If so, do you want to keep this driver
> in the kernel tree?

Hi Bart,

I think you might be right. I also don't have much time to maintain it
these days and the hardware I had is long dead. It probably should be
removed for everyone's sanity.

Best regards,
Chris

-- 
Chris Boot
bootc@bootc.net
