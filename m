Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D10C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 12:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FA9217BA
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 12:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="PNW4u+dx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mL4JuWTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2MBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 07:01:11 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:45771 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfK2MBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Nov 2019 07:01:11 -0500
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Nov 2019 07:01:10 EST
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id C9AFC646;
        Fri, 29 Nov 2019 06:44:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 29 Nov 2019 06:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=4
        e2fQd04m1vD23T4e+mMcwBXh6jch9xWoh1g3p5EFNM=; b=PNW4u+dxBIB7GYjUc
        5cVpZNCZbEQ158cwoGvGOmH8UqFc9yCSQSRiUpp2xV4fGEp7gWbDSh+soLvM/Q9m
        4/ElHSwYwU0ADCSsDjkXti2e1yVb8LSYgQzPrCoFkCKZSK+9IlRTwBM4GXXBnmYi
        /xqWXwFvaiDVm5+38ZX2qslsGxD3hVLF2CrpB1gHXuKh9xOXcKcoP/hjmubacWRp
        +yRIzcUCLJ/VbKK776HJAGPEt3ih0AkwbxzWRNBzR2ZfHV88zMiN11HIPzjqAVkt
        r3/D3SJevnlEWWtxJljIexyrC46VNiIWcmXb6ADd0J7pLKuse5ZXNetN0f21zv6Y
        UfcAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=4e2fQd04m1vD23T4e+mMcwBXh6jch9xWoh1g3p5EF
        NM=; b=mL4JuWTOb40bZlY0aKiockV256QmMxMSGFBsYwqSuFFj8BYxJecUwu0zR
        D9JNQAPErJ0v9SwTltEmJaueQWICGpNAwP6spWoyGUVe8evZv1F4gJIM5QZoMg66
        3F18RZO6ymMfOGE2NKP6cfamgTMvW/x9q5LyLnwydxCZxJSlLCThJkVciD+1ChPH
        Tgo9ho29XvG+wPLkUYHGDztyC+e5YRWQKOYczkxV5X6qiYxNnI3Ki+6MG5D6utOQ
        AwYzEpLd7DuCvC7y75jTzEKYKsakJUMM3QUmObGmoFbqykrC/wvK6/Pm0Q6QeCbM
        A4o3zxAADVexQIigQGwvJ9CY4A5Aw==
X-ME-Sender: <xms:rwThXf6LqYyUpA4XOYTv8LZUzEwI0-X9q6NyyGFmJnqGe7BQDFemSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepuegvrhhn
    ugcuufgthhhusggvrhhtuceosghspghlihhsthhssegrrghkvghfrdhfrghsthhmrghilh
    drfhhmqeenucfkphepudejiedrudekledrieekrddukeelnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpegsshgplhhishhtshesrggrkhgvfhdrfhgrshhtmhgrihhlrdhfmhenucevlh
    hushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:rwThXZLEQyvD35ShVq7905tfxTAjhpSIpeFkjUadDZsOTfYITzaOcA>
    <xmx:rwThXRfLuOLAeyid7IieP9YyJboN_VL-DRzb42Ksj_z7h2Zb3q3Qbg>
    <xmx:rwThXUcsWMkatz2g7m8shZwvlHOWP_UJJwdlWGch7cpuvZ5Ygt02fg>
    <xmx:sQThXfANaxN2Q1ld4f-QZIHWTiaDs0WByWyGaKE3QzzLbCfj_6vPSv7Yep0>
Received: from [192.168.1.20] (vol21-h02-176-189-68-189.dsl.sta.abo.bbox.fr [176.189.68.189])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D64730600A7;
        Fri, 29 Nov 2019 06:44:45 -0500 (EST)
Subject: Re: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
To:     Ming Lei <ming.lei@redhat.com>, Andrea Vai <andrea.vai@unipv.it>
Cc:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
 <20191125151535.GA8044@ming.t460p>
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
 <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
 <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
 <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
 <20191128091712.GD15549@ming.t460p>
 <f82fd5129e3dcacae703a689be60b20a7fedadf6.camel@unipv.it>
 <20191129005734.GB1829@ming.t460p>
From:   Bernd Schubert <bs_lists@aakef.fastmail.fm>
Message-ID: <3c57bba1-831b-fc97-d5f7-e670f43fbbdc@aakef.fastmail.fm>
Date:   Fri, 29 Nov 2019 12:44:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191129005734.GB1829@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> Trace attached. Produced by: start the trace script
>> (with the pendrive already plugged), wait some seconds, run the test
>> (1 trial, 1 GB), wait for the test to finish, stop the trace.
>>
>> The copy took 73 seconds, roughly as already seen before with the fast
>> old kernel.
> 
> This trace shows a good write IO order because the writeback IOs are
> queued to block layer serially from the 'cp' task and writeback wq.
> 
> However, writeback IO order is changed in current linus tree because
> the IOs are queued to block layer concurrently from the 'cp' task
> and writeback wq. It might be related with killing queue_congestion
> by blk-mq.

What about using direct-io to ensure order is guaranteed? Pity that 'cp'
doesn't seem to have an option for it. But dd should do the trick.
Andrea, can you replace cp with a dd command (on the slow kernel)?

dd if=<path-to-src-file> of=<path-to-copy-on-flash-device> bs=1M
oflag=direct

 - Bernd
