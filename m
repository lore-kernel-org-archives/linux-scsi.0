Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED2EC77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Apr 2023 12:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjDTMgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjDTMgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 08:36:00 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Apr 2023 05:35:53 PDT
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D12E65B2;
        Thu, 20 Apr 2023 05:35:53 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id A2BE02B06749;
        Thu, 20 Apr 2023 08:26:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 20 Apr 2023 08:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1681993608; x=1681994208; bh=3k
        qM7vX2DJRzHASlFHsZJyyE3jOWWWXPGfOIoDUnoG0=; b=fT9TchauBy11NjStx+
        quzttsF6w437Bya2IEHwY703MFIH370JBxCZ8y7L/J/9//+O3OMdCZFRXOCuZDOo
        ZGdGSzs41FtOT350hCAMnMb//PDdY2aPFdHbLCrhjZDAAYcyrM8wCtwLNGkUhmDP
        izk/enrakBKP1MLtmnjeBb4nb8WeBz8wme2yTkwq/CmiEXcqMQ5JJTjjREbb9e0Z
        gkmUJ2Kwk238v7XTtsGJeLxf4hi2OfEOZ5Dx6SDIrByjhjza/hZJknK0SR7MszWO
        WwVWjgp7xwR4lq6Y+YnJsU55OBe4iAKbtlc+edEE0nkigQ2CbV7gBJiU+XuyRV+R
        V3iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1681993608; x=1681994208; bh=3kq
        M7vX2DJRzHASlFHsZJyyE3jOWWWXPGfOIoDUnoG0=; b=EKTBeYbvL6nLO5VaAmE
        SXtMLFvnE37S0DUTQ8b5Gl2xWa8XkMEKBr4nKZXawlu3KIItFU1WT+U0f5jDscjd
        gF2rVtsSJLmGixPqCEwlHM8lsGin5TDVDtOUESSiMEfGVWhaFB5yDTIBuGxx9q7v
        3H49gRdLXSy+fMNYRNrJpof23r/GySnpfbvyla69w8tHXTDsmBHAK5E4YPpAt7kh
        +CjYJbxqgxIgr1MCPLPeQAnAIEimngh0O6gAX9NaI+kGp58XgdRidIToHGjKLEYE
        f3U+9fZNs+SkIffz2XMq9FMclQKcvh/9ikxAaZ/uN0KFeScOjs5ajSYjRx3X1exv
        /Jg==
X-ME-Sender: <xms:iC9BZJBngizTYhmtcVpqGgIbRRQXo9JCvJsI93ouDJhi4BekItYteQ>
    <xme:iC9BZHiUR73gc9m1xqQ0YpWEpNw6dD_daabvwQlj1Zb4C47e1lC2s1PNpfGS7_Up5
    EmcsgtUa5lvKw8kXDU>
X-ME-Received: <xmr:iC9BZElf3swDdMS_J7-KOCo7tCWvBc493072a8kL-LtJK72R3tzEcd1RdsaX8nSsb22cbpThVfIkWg56j0rJhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepffehffetgfdugeffffelvdfgjefgkedv
    hfehgeefveffgfffvedtueekgeevvefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhi
    nhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:iC9BZDyUeW7-kQzWP-pR6XoCJq3VmXltYlCMj3q6_Z554X7vFHr8nw>
    <xmx:iC9BZOTJhTCNyuiaAxVjlrCMbato0LqdicRFt-zpH-wPJ6N8CMSI4w>
    <xmx:iC9BZGZqcDOSH9H3W0i5P1bP3eXDA4aZBb8q7dilwQhuNeqSH6dLvw>
    <xmx:iC9BZJevYuCKfzpYmazJ_pC4fxGBF3d98f6LOZ2_7xAhcO2f7-VLau62vqRIeLjR>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Apr 2023 08:26:47 -0400 (EDT)
Date:   Thu, 20 Apr 2023 21:26:43 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: blktests scsi/007 failure
Message-ID: <yqe6sjp6ukfoafaoetwacddkpo2y5mk4hsnxgw377iwholxo52@psw2zzelcmig>
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
 <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
 <3xwglpdpmit2obtf5p475gojdoqe42rmteki5hvoavzwle6kqr@bl7xginwaeli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3xwglpdpmit2obtf5p475gojdoqe42rmteki5hvoavzwle6kqr@bl7xginwaeli>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 14, 2023 / 17:58, Shin'ichiro Kawasaki wrote:
> On Apr 14, 2023 / 09:33, John Garry wrote:

[...]

> > The failure may be due to one of my changes. Please see
> > https://lore.kernel.org/lkml/5bdbfbbc-bac1-84a1-5f50-33a443e3292a@oracle.com/
> 
> Thanks for the notice. I think your changes were applied to 6.4/scsi-queue,
> which I've not yet tried. Then it should not be related to your changes.

I took a closer look in your changes for kernel v6.4, and noticed that it might
affect the scsi/007 failure I observed with kernel v6.3-rcX. I did some trials
and found these:

- On kernel v6.3-rc7 without your changes, the test case scsi/007 fails with
  unexpected read command success (The failure I found and reported).
- On kernel v6.3-rc7 with your changes until "scsi: scsi_debug: Dynamically
  allocate sdebug_queued_cmd" [1], scsi/007 fails and causes system hang.
  Kernel reported "BUG sdebug_queued_cmd". When I reverte [1] from the kernel,
  the failure symptom is same as v6.3-rc7 (no hang, no BUG).
- On kernel v6.3-rc7 with your changes including [1] and "scsi: scsi_debug:
  Abort commands from scsi_debug_device_reset()" [2], scsi/007 passes.

[1] https://lore.kernel.org/lkml/20230327074310.1862889-7-john.g.garry@oracle.com/
[2] https://lore.kernel.org/linux-scsi/20230416175654.159163-1-john.g.garry@oracle.com/

Your fix [2] intended to fix the BUG that [1] caused, but it also fixed the
scsi/007 failure I found :)


To understand the failure deeper, I added debug prints in scsi_debug, using
kernel v6.3-rc7 with your changes just before [1]. This kernel does not have the
fix [2], then it does not abort commands at device reset. When scsi error
handler does BDR, bus device reset, scsi_debug does not cancel the hrtimer for
the commands issued to the scsi_debug. This hrtimer is alive across the reset.
When that hrtimer expires, scsi_debug completes the command that issued _after_
BDR. The hrtimer for the command before BDR completes the command after BDR
since those two commands use the same scsi_cmnd and rq objects reused. Then the
command issued after BDR completes earlier than expected, and results in the
unexpected read command success and scsi/007 failure.

After applying the fix [2], scsi_debug cancels hrtimers at reset. Then, the
hrtimers started before reset do not affect the commands issued after reset.

These findings mean that the scsi/007 failure I found with kernel v6.3-rc7
indicated the bug in scsi_debug, and the commit [2] fixed it. Now I don't think
blktests side fix for scsi/007 is required. Good :)
