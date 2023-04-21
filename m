Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62712C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 01:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjDUBD1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 21:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUBD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 21:03:26 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1EFCF;
        Thu, 20 Apr 2023 18:03:25 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 1A6A32B066B4;
        Thu, 20 Apr 2023 21:03:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 20 Apr 2023 21:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1682039001; x=1682039601; bh=pk
        rWfhb7gpYeNRUXTFdCYjUNjl9GpqluqfVMyBD//HI=; b=S0T47FOQrHklns1CPC
        1NqHltqRJYnOADr+spNVgchWPrzOJ4r7lIeEtaYjSAa/tgarljR+QYbuEJ1NP+5O
        Z/NTo7pcpy//Xfs80iupBrzsz/YrbSfHylxQJGBTfpCscfjNR5qm8+Atu5CzK109
        j5G8ZiWk1wN7QghB+3DYmXTjzqUGOn6w4BGI+4uLLnUXGA1ydDijOJcWPR1yyLR+
        f3aAz5rGxDAFDwbAXnuPllU89I8DT9SaHZNsI6NeosiGdbK59nsyJesBTVrGrsVJ
        XhKzWY2PSs271yKePjiQ+6mRouV4sTkD+gsU7O1+advYradjKDpUmeFzJ7Jmz9mP
        zqgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1682039001; x=1682039601; bh=pkr
        Wfhb7gpYeNRUXTFdCYjUNjl9GpqluqfVMyBD//HI=; b=DDLCuns4O61jg9rK5T9
        Glcmd63YNnwh4KAPc3WDm1JrNMObuikw8B0pQEi0SxJ1MSxrAopdQxlpejBtxEKx
        ZDU582f+p2EVS6uvWwC2pPlnXbuga24ryqp86GfdVHxpLr+l4o6cKhNLNmkAOpUZ
        9G+3gj0etboTYJW3kKRFK2wMdViC20iqc+4h50zivEjf9/YjLJHxeLWZH/+9VrYb
        Bs5IG+bTCLsxAsbDhZKMKhAwFdnBIm18Nox0f58/OCKsK6anr6PLvNmijSn4WI0k
        QXzETl3dsw8jAXUFv4ZL2uwN0XFhZ81tp2wkLP21DnK6IUuBG1bE+T2vV6I2iRpx
        0aA==
X-ME-Sender: <xms:2eBBZDge3nFiqHh2i1Ab52yx5q5buijzHoh9y-XJX4r10ntLeSxh7A>
    <xme:2eBBZABKT74JSNKrXOBODotGVqo9w_QNLIrhw8cC8KzoQiKAxazdRFdNnGVJH_oig
    qIdAzY83UxlFOQ9YV4>
X-ME-Received: <xmr:2eBBZDHannPNf6eRf8Ft1FtDUXC9fBw1nuwJcfN-rTG1SNjfGaN8j5xzawfssYwlwThBsCysMWpP4JJGHOfmqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtfedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepvdegtdfgvdfhgfekvdektdfgfeeljeel
    gefgkedujeeiteehgefhgeethffgheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:2eBBZARZuto-5rJJEcJWanTKwNb8Wv_P-a5rUOCGBm51TGIB5wR8oQ>
    <xmx:2eBBZAxDRVH2IkehAAWhnJ_q4NefTVY0g-raYdMGJALVzjVrFg2PUg>
    <xmx:2eBBZG7wsIzoMhExjXsbyO2NyjrJcdx4pICaW7eR5EVJJISHBI2SlQ>
    <xmx:2eBBZM-1sf9yNuO-TLZxiogEKtwJr9Opf5yluWtzzLHZJFj_nK3CBrmGfKva4xRN>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Apr 2023 21:03:19 -0400 (EDT)
Date:   Fri, 21 Apr 2023 10:03:16 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, dgilbert@interlog.com
Subject: Re: blktests scsi/007 failure
Message-ID: <w7a2ldas7jrgv3s5zclvt6xck73p4cufym6binh5gs3wrj5gvq@qn2qbjwjc67u>
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
 <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
 <3xwglpdpmit2obtf5p475gojdoqe42rmteki5hvoavzwle6kqr@bl7xginwaeli>
 <yqe6sjp6ukfoafaoetwacddkpo2y5mk4hsnxgw377iwholxo52@psw2zzelcmig>
 <15edb8ec-704c-cf0c-00a9-014391ba15f9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15edb8ec-704c-cf0c-00a9-014391ba15f9@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 20, 2023 / 13:59, John Garry wrote:
[...]
> Do you know why you specifically were seeing this issue for v6.3-rc7? Is it
> just timing related? I seem to remember you mentioning debug configs
> earlier.

The test case failure was observed with v6.2 also. I did not try older kernels,
but I guess the issue has been existing for long time. The failure is observed
by chance, and the failure ratio increases when I enable kernel debug options. I
think the issue has been hidden, and unveiled with slow kernel and slow system.
Also I think the issue is timing related based on my observations.

> 
> It would be nice to see this issue fixed for 6.3 and earlier, but,
> considering the circumstances, it doesn't look straightforward.

Agreed. The fix patch can not be applied to kernel v6.3 or older version. This
is scsi_debug issue, and I'm not sure if it's worth back-porting effort to
stable kernels.
