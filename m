Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749E5C83F14
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Aug 2023 00:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjH1A2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Aug 2023 20:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjH1A2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2023 20:28:41 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76BE119
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 17:28:37 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 74E405C0053;
        Sun, 27 Aug 2023 20:28:35 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sun, 27 Aug 2023 20:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1693182515; x=1693268915; bh=xc
        LVCCbMQLt60fTvFnyYMrc/Kwbs+EjRtjdgfwIaROM=; b=H47qwOLn27JM1wpEW5
        9fTk16w9O1yEUkTdXNdi4STyWHUl1q6Fiz8C394ug9pqk3lfeamLd5FPU+VQldYP
        U09/iJtHAg288Iuw5qD1zzCDfqWTkXvDND9R0wcH6zARd8bNZA0tvKz/cEZqH7T9
        3XFwutNWlMmoOyYRYES5zcUQF45FUW2J7XHRv4ZZdBOor16j2gr1/jghhHU4jeRl
        c5HgWsq/gYClsnvymomDSDID0E5VEvRV8WPN+3zUaodangrOmTHwlywrHs87QZNp
        ZGIJVEkbBrcGNivvQRPYHgZBY3eIQIH17i9C4JItqlL4WlaBpRao+OnCcL6/Ph3t
        m36Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693182515; x=1693268915; bh=xcLVCCbMQLt60
        fTvFnyYMrc/Kwbs+EjRtjdgfwIaROM=; b=kPsW61YspQ3sZum7Yn9f1mwgvw9Ce
        FrERhDnwx8x7sChl+nzSWa52n7uBTOS6n7RiSiIzQacgnYZEp9DoOwGYXUPsRCgy
        EVfNX7Vm7LN1fam/i/tdzrGhMe+2hBFmwqLwTWmAtLs9JXHiWjXoAoPRMBkOax0R
        zi7fliYuO6WxIdXfjm7AxYR69Qi3XQ/nxmvUYq33+VMMogffnJdp9Q9nFbThNAxe
        LP+8k2Dgf2NbL4chhuzq/0CSSC93h+NNHOyHmx6texv6a9QW2E5WJ5MIWmJYcWOe
        3/fvIhBoULaLPqKn9XHNqSU4rvKwkTt+aLO8T7hb0SDZ8FsaN2wELtp2g==
X-ME-Sender: <xms:MurrZHx_q1hvW1SrI8iFNEmfmeFsDI78_Tnj7EodXNRsmVEEsy7p0g>
    <xme:MurrZPTL1CsH4x6XtRBiP4aB0IToUUNzT2fxgtuJjuPpRLovfKMFBC9DOTVY7gXE3
    QnUjvwREotzwovbuBk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudeffedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:MurrZBVnKG1cu_ve950MYczoB9-UaNxU80gQYgGycnrESkgT1wfMkA>
    <xmx:MurrZBguEEn1YPy5OLXp84yFrjx0hBxUhllS5gvimWIyvxknB2Itzw>
    <xmx:MurrZJD0sC_F1VMMbcSp7towjdHmAQz6MsDpd-_E2UX-gyqArE4_2A>
    <xmx:M-rrZN7Kfd90TZJg_TJ2tLJkiI1bYs-RA1hokefLNF-gpJqLozRUyA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2E0BFB60089; Sun, 27 Aug 2023 20:28:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-647-g545049cfe6-fm-20230814.001-g545049cf
Mime-Version: 1.0
Message-Id: <2e916711-e2ce-47d2-bdf5-0524dae7e207@app.fastmail.com>
In-Reply-To: <20230827233042.12945-1-bvanassche@acm.org>
References: <20230827233042.12945-1-bvanassche@acm.org>
Date:   Sun, 27 Aug 2023 20:28:13 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, "kernel test robot" <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stanley Chu" <stanley.chu@mediatek.com>,
        "Can Guo" <quic_cang@quicinc.com>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Asutosh Das" <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Bean Huo" <beanhuo@micron.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>,
        "Avri Altman" <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Fix the build for big endian 32-bit ARM systems
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 27, 2023, at 19:30, Bart Van Assche wrote:
> Although it is not clear to me why, this patch fixes the following build
> error for big endian 32-bit ARM systems:
>
> include/linux/build_bug.h:78:41: error: static assertion failed: 
> "sizeof(struct utp_upiu_header) == 12"
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: 
> https://lore.kernel.org/oe-kbuild-all/202308251634.tuRn4OVv-lkp@intel.com/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

The fix makes sense, but I think the description is wrong:
The weird struct padding on Arm randconfig builds happens
with CONFIG_AEABI disabled (implying the old OABI),
regardless of CONFIG_CPU_BIG_ENDIAN.

> -			union {
> -				__u8 tm_function;
> -				__u8 query_function;
> -			};
> +			__u8 tm_or_query_function;
>  			__u8 response;

The problem on OABI is that any struct or union is word
aligned. I would assume that marking the union as __packed
also addresses the problem here, but I have not tested that
and your patch seems fine.

There are bugs like this in many places of the kernel where
the struct alignment actually matters but is broken on OABI,
but the machines that used to run OABI kernels in the
past also run a very small set of drivers in practice.

On my own build test setup, I have made CONFIG_AEABI dependent
on !CONFIG_COMILE_TEST, which prevents me from running into
this problem (and others) on randconfig builds. Maybe I should
try again to send that upstream.

     Arnd
