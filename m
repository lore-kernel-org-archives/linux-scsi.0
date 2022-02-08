Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72600C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344012AbiBHW0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387408AbiBHWXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 17:23:53 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC10C03E957
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 14:22:35 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 421875C011A;
        Tue,  8 Feb 2022 17:22:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Feb 2022 17:22:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xqw4uakrvPBTWLlFl
        2UyWnh4fhUw+9VU3cBD59Eae6s=; b=mgmU/FRYRnvkBm9OLRR0Zw/kv00b0gh/w
        rDL3mv51XWQ1kWPq84eqj9PN1ATvSUxWJsQp1OXIcLY7cCkoLD2OO9o44hK4YBkp
        iC7Ohr1ptoiLfRcHlfq4vGEUVz7skew9JMAjhIFl7ytvKmnHkS9VWEyY0T02BDyb
        /hzv9D8GUuiyInhE4geckVdKFkREf2hnk6E+/82I5sHVUioGo1npKHJ/2Ye3Jqtn
        NuCjc6fZ9B1o2b2sRSEkWk7NamYx8IvT1UuyIDdHByUI2FIlLOtnamuLqXq7sMMc
        irlFziB7wyJm9Pgs1s18P3B436frWS5mkRDZomOC+9x3c1pFF81nw==
X-ME-Sender: <xms:Ku0CYs1m4Va0w0eOiKWskaKnh5jnj9ryZT978vMtOH_4LKA3Hnh0Ag>
    <xme:Ku0CYnEPR1M8BtIoeZ0KCJlYljgQpUBFpqxq0aq2zQBTchFq80fxjAL9jq6voz0TU
    MFmxq8NghV_P4FZEkA>
X-ME-Received: <xmr:Ku0CYk5xrX5WzWr-QcyOLD4pmgDsABAc_ykLsffbPTCSg0-41x1lQMUHNpwfdy4CMZAtvl9jpdyU_VdxiQ0AXFkYsh4O-1yhgvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:Ku0CYl2-cCD1lEWDeiVOBWqLBMo25rgaEBvALva8_mbXIjcr6rYf5w>
    <xmx:Ku0CYvFfCHuKTmsJCZ0f01qoul2rMdlx_W27VNASJWDfmNotJwnvhQ>
    <xmx:Ku0CYu_71dk7-6uVdvnL0_wyJ5ehBP2FaJiW42ryyNdTs7Ph0pC_yw>
    <xmx:K-0CYgNxL8alOR3X9WOI3QqmOaxiSvDk5xYvxCgJzJp-LyS1uQFtRA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 17:22:31 -0500 (EST)
Date:   Wed, 9 Feb 2022 09:22:34 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
In-Reply-To: <20220208172514.3481-6-bvanassche@acm.org>
Message-ID: <a94b9ac6-85c5-d267-21e8-10b22c9b43c9@linux-m68k.org>
References: <20220208172514.3481-1-bvanassche@acm.org> <20220208172514.3481-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I see that v2 is the same as v1. Is the "v2" wrong, or the patch content 
wrong, or something else?

Regards,
Finn
