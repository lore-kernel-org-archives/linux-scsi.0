Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A950C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 21:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E978E20708
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 21:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=hmh.eng.br header.i=@hmh.eng.br header.b="NdnDvTRs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XCOUxR50"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGEVbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 17:31:31 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38777 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728262AbgGEVbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 17:31:31 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 137BB5A3;
        Sun,  5 Jul 2020 17:31:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Sun, 05 Jul 2020 17:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=izaPxlNYW6tRrlCLyKFKKIHYirf
        xg32Q6VvhG/42yyg=; b=NdnDvTRsXHUIddcI/sr5lFQuoQe3ezqtCHN3B+Ki5Oq
        h6zZ0pOJE/AQiz4tIU/9sDpCUby8FH8LIImS/F5KcceYAG4qys3nybQk4npyF+7D
        DQnFbVtA4hZr66Xke/WBrDcrthGmZ1j3tQbtqhhdQBufrLKalkquXnNHGIrMNZR+
        bLWz0L94p9915FiOn/JKfe0a5+6VJn2FPRdddtiFiR6+HyRK3VzyEtr3Wrzx/BqT
        iuwUblOIZABRU4HgFFOJOosXur8xjuAyDMnbnoE1FyBS85CW65cX86B/zWpbXZAs
        +h/lCjNmRG6B9Q5vCC2YSlUAig9a8+OGK98hiGUstgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=izaPxl
        NYW6tRrlCLyKFKKIHYirfxg32Q6VvhG/42yyg=; b=XCOUxR50svzJpE3o6WMziv
        j9ssgm3Hvbst7jUCvjDerauwHgnnaznJ0r6NHsxH1IJJoNgP6WK7Xbjqf3lo1CEo
        uyJOwjkFTsWhJuGenGaItMa2ImVZaGyGklpxueK7eo07h46002KyxZ8x4tHC74+p
        HtQ0jNZlGftvjuhAbL9MW0t3u3jAIrpg5D0na1qzqCzjPQgZwx2P8W5DRB+V9l5X
        +iJbIuuMSc0ErZPC+Cxzc5MoHRP+p/Y8QjIFbWvlBzoPengQP6G9Z2y/+ROKI5X2
        TEm9NkNA1THQeWINhhleDxvRHY0X5Rhiz2yD7yyCu+x3l1pUDe6zLI9NfJk5v2JA
        ==
X-ME-Sender: <xms:r0YCXyR8tcB-0PPuwHLouFOOqV5La40pizXnGlzztwQNQ47hK_ya3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddugdduieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdttddttdervdenucfhrhhomhepjfgvnhhr
    ihhquhgvucguvgcuofhorhgrvghsucfjohhlshgthhhuhhcuoehhmhhhsehhmhhhrdgvnh
    hgrdgsrheqnecuggftrfgrthhtvghrnhepveduteejgeeiudefuefgieehleejkeefudfh
    jeefgeekheekvddvheehleegveeinecukfhppedujeejrdduleegrdejrdefvdenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhmhhhsehhmhhh
    rdgvnhhgrdgsrh
X-ME-Proxy: <xmx:r0YCX3xP9AutXuHBtVMIQbiB_q7NdgAIwsIFhgzbMgxba0tKTojx7A>
    <xmx:r0YCX_2XH1yaztNfWLisv9admQuZdsXdg42zVBNKemE39Fe6ghcoMA>
    <xmx:r0YCX-BwIGTKYTdvI_sJQhPf-X5HWFarcLOZXcYldekR5P9GDxurxw>
    <xmx:sUYCX4uC3EN7amxi8FAmtvlhsXOh2yHIY4_KpOWIZj6g4cl7LDTCdg>
Received: from khazad-dum.debian.net (unknown [177.194.7.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83656306AAA1;
        Sun,  5 Jul 2020 17:31:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by localhost.khazad-dum.debian.net (Postfix) with ESMTP id 2E5183400168;
        Sun,  5 Jul 2020 18:31:26 -0300 (-03)
X-Virus-Scanned: Debian amavisd-new at khazad-dum.debian.net
Received: from khazad-dum.debian.net ([127.0.0.1])
        by localhost (khazad-dum2.khazad-dum.debian.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 1PbQApQlj3rR; Sun,  5 Jul 2020 18:31:25 -0300 (-03)
Received: by khazad-dum.debian.net (Postfix, from userid 1000)
        id 2161D3400160; Sun,  5 Jul 2020 18:31:25 -0300 (-03)
Date:   Sun, 5 Jul 2020 18:31:25 -0300
From:   Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200705213125.GC8285@khazad-dum.debian.net>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618072138.GA11778@infradead.org>
 <9877e7de-d573-694b-2b75-95192756684b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618134904.GA26650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618134904.GA26650@infradead.org>
X-GPG-Fingerprint1: 4096R/0x0BD9E81139CB4807: C467 A717 507B BAFE D3C1  6092
 0BD9 E811 39CB 4807
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Jun 2020, Christoph Hellwig wrote:
> > For SSDs, I don't think an extra stop should ever be an issue.
> 
> Extra shutdowns will usually cause additional P/E cycles.

I am not so sure.  We're talking about enforcing clean shutdowns here
(from the SSD PoV).

A system reboot takes enough time that the SSD is likely to do about the
same amount of P cycles commiting to FLASH any important data that it
would trigger by a shutdown sequence, simply because it should not keep
important data in RAM for too long.  By extension, it would not increase
E cycles either.

OTOH, unclean shutdowns *always* cause extra P/E, and that's if you're
lucky enough for it to not cause anything much worse.

-- 
  Henrique Holschuh
