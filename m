Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB0CC001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 06:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjHBGtG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 02:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjHBGsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 02:48:42 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B948230DD
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 23:48:10 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 4B5C43200938;
        Wed,  2 Aug 2023 02:47:59 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 02 Aug 2023 02:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1690958878; x=1691045278; bh=kL
        6Pqymk9uEKonGdxhUow0aFc1zQ/a69+FqqadFi61A=; b=J8+aYhCcYJaOcCUSay
        vDDYFS3Y6ZWxWfXCUGGKwbeu4rdr6ENMDU8cToZyBstNNG8Vh90jcP/svP8YXpWv
        vpCgGfYsUVwbLr2d6G1FJcJwfUhYlT4bL635BSTC/ogCQYVQgaL/l/RBJQYJN7Bg
        KdBQgjyHvKXJBhqYmSOpz1RJAaA8kSjxHz/OqhdJ7GSFRFDGGaIILxAi6L1D/T7W
        3hS+bpG2DkcNA47QUdeYj0Gw9wssrR/offuIYXQW66g0k9LMzrCDDa4MtGdbK48z
        NpdnPuQ65otMJFE2iRAZU/qMChgQCWVpU4jKyKYTepB11lclmOBaq2y2LMMXetmf
        DMTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1690958878; x=1691045278; bh=kL6Pqymk9uEKo
        nGdxhUow0aFc1zQ/a69+FqqadFi61A=; b=xiA0AIrxPjAt/tMvA82OEWw5ZS9X9
        KzaHMYu+DAbmJMlUTt0iEy6Q0eA7s2V7qufbdOwHnJ1EyS7BJZZpZxIfepkM9y3E
        Tcvw2bBn995rotXB9xw2IOnYt7Gf5gAMN21BKvXWRCxI2fCKwYRonADqujrspwwx
        USYuZQdGbe4v/8HksOPaqRx1vSIK2RD2IXwaPGuFaSeTQL7F6/PGBC3IIOzJdYIb
        C6V40KYd1NSahhBWeS4ecgqwlivt7eJhEJG4FnmYgtoYwB5PxxpimqPxJ7mDeRIs
        7He2uPiuSC7cVntY0+2mvZtkK3MzP4J+D2q0StXUTtdD5qXLv00V+KIxw==
X-ME-Sender: <xms:HvzJZFLOEUVKZ6H0x8gSz5RWlbW-tEGCpAyfgDzVNhzxP_QgTLMTUg>
    <xme:HvzJZBKhgP8ZC-cIGHLbqIeyKJLKmTPFxiVeLHkUUeOJGfoA6n8goyDZVfcv694vk
    H9EO3ryr4aKfF6U2Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrjeejgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:HvzJZNsYc2q-yAk_CWtIiQIW5suv5JJYU4RkXYsze3ceX-XopMZaXw>
    <xmx:HvzJZGbDHdTpHorkFhbXhaYlWfGUdghERPKgu2VLm3Bls1gqBigKLw>
    <xmx:HvzJZMaaheDA31IJ994pW7oCKZCjOF2EKANmPmlUlt6kgW_dLdgvAg>
    <xmx:HvzJZJRqQP8wiqWHtnRqasnB_T4Qevkmh4kK_dXy8Dq5wkRK_DoWUQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E5836B60089; Wed,  2 Aug 2023 02:47:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-592-ga9d4a09b4b-fm-defalarms-20230725.001-ga9d4a09b
Mime-Version: 1.0
Message-Id: <1982f003-1c70-4f0b-8d66-d9e7420dbafd@app.fastmail.com>
In-Reply-To: <20230801232204.1481902-1-bvanassche@acm.org>
References: <20230801232204.1481902-1-bvanassche@acm.org>
Date:   Wed, 02 Aug 2023 08:47:37 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Nathan Chancellor" <nathan@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stanley Chu" <stanley.chu@mediatek.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bean Huo" <beanhuo@micron.com>,
        "Asutosh Das" <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>,
        "Can Guo" <quic_cang@quicinc.com>
Subject: Re: [PATCH v2] scsi: ufs: Fix the build for gcc 9 and before
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 2, 2023, at 01:21, Bart Van Assche wrote:
> gcc compilers before version 10 cannot do constant-folding for sub-byte
> bitfields. This makes the compiler layout tests fail. Hence skip the
> layout checks for gcc 9 and before.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me, I gave it a quick spin with
all versions from gcc-6 through gcc-10 to make sure this
works for all of them.
 
Tested-by: Arnd Bergmann <arnd@arndb.de>
