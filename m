Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7251BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 01:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348960AbiFABRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 21:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240650AbiFABRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 21:17:35 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4236AA47
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 18:17:33 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 770C76C0B6B;
        Wed,  1 Jun 2022 01:17:32 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 00FC76C1F8C;
        Wed,  1 Jun 2022 01:17:31 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1654046252; a=rsa-sha256;
        cv=none;
        b=L8rMjzQzvh1m8NioFteABavyfkEpAGlOANnCm622kZKWlMmLkaEqXbry5deFyu1A7Fh+Kz
        XfihPXQt6lcM7nX04IfBd3XEBdqBLq9/+6Ey0fYQ1DSxHlET6uTSo5HI0fd97o4QDEck3y
        XmDoVY6GkJ/nMjQGJZiWZOjsx6q2ou7JVJLmiT03LFRlypjzsg8Z3jX+u5xWtY73X3JAhT
        KtJ/SUvN4yVoP+f5ORlb4Md1Kr5Xe9ti6FtD1siv9hxTpNxcwqomLKHJQ+s8UbWiKZsmxX
        ORuk9NARE+A8jR3NmBb386h7JIe6S6Xwv5khMgxYJASjbpZEsrRlu8VYk8tkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1654046252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=67QV2syKHfujLqDY+ow0Q8tEmOltRA1ZVBk3hYSQpeg=;
        b=AM5OEmbT/zkkB+Ip4E5NyO35Y0RGx+116ccxhhu345YW5A6LwbMQQF/AaAS/F3eWUL4rSB
        FEqLdz2D+iZyxzc3+fsEkPWAdhmscfnmUY4oHcFMZOM1Iowq6LGNeXan5F3HJZYy25K/Kj
        Ozbp5vUVm04ChDcQ56iEx4qsRY7fb84r9Cq7rkuribVBeuYqCAmN7po+gAjwiqA/FZagfG
        54dzLf7xbDk6SMcopgNjwnUazrVQND5632Bunkq8k0VbsIWuykNFwOk45YBKerCK6GuJK8
        oKM5NMxiXo9JUvpM0Gy0BTPPgElUuGLvqo1pcVnssWo8czwytcqdsTLMQSvBJQ==
ARC-Authentication-Results: i=1;
        rspamd-77f9f854d9-b48pf;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Minister-Tank: 2b880eed2c6af33a_1654046252278_305331953
X-MC-Loop-Signature: 1654046252278:2946322889
X-MC-Ingress-Time: 1654046252278
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.124.238.93 (trex/6.7.1);
        Wed, 01 Jun 2022 01:17:32 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LCWTk6xp9z3H;
        Tue, 31 May 2022 18:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1654046251;
        bh=67QV2syKHfujLqDY+ow0Q8tEmOltRA1ZVBk3hYSQpeg=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=cijgYHKX1/SO5ka0O6E4UNpWZN3PoGgf9VrysAaQnNUHsxwV9C4Tc7MVWEhcnZshX
         YrQSOyLWDejJF0llOZQTTCzhXaZSAHEBclzTaYNReeinUcCTgpKBkMvTZnQuar9GzG
         VwkH2gMH/puJaaufEDxGEJhTx3OAqQdOi+EM9AwQySF69jGkj+HsYQyMr7wzLwNKqX
         0s1Ew9sj4KJAiYr4Th13iz0Lzbql9VjP15bqwDnSIq2xT8aS+9aXywYdWfMWMkLyRi
         AE73paoKvtHj+a3rMUpidS4Jq7WhJeSxkxjVuejqmdlw+7+d67JIDLqG845rkr4VSP
         3R9YObSxDu7tQ==
Date:   Tue, 31 May 2022 18:04:07 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
Message-ID: <20220601010407.kar45dc75pqcuhhl@offworld>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
 <20220531145231.opypdzrlrg23ihil@offworld>
 <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
 <YpYxfSYDbCJEh9PG@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YpYxfSYDbCJEh9PG@linutronix.de>
User-Agent: NeoMutt/20220429
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 31 May 2022, Sebastian Andrzej Siewior wrote:

>On 2022-05-31 16:12:05 [+0100], John Garry wrote:
>> Sorry, maybe I was not clear, but I was just asking if there was a good
>> reason to disable interrupts at source while handling the interrupt, and not
>> the change to stop using a tasklet.
>
>Without reading the patch first: You need to disable the interrupt
>source while the tasklet/ threaded interrupt is handled. Otherwise the
>interrupt will keep coming and the tasklet/ threaded interrupt will have
>no chance to make progress. So the box will lock up. This is often
>overseen on fast machines because the interrupt needs a few usecs to
>trigger and so the CPU is able to make a little bit of progress between
>each trigger.

In addition it keeps current semantics wrt ksoftirqd, so no guarantees
this runs in irq context in the first place.

Thanks,
Davidlohr
