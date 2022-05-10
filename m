Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03127C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiEJBNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 May 2022 21:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiEJBNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2022 21:13:47 -0400
Received: from crane.ash.relay.mailchannels.net (crane.ash.relay.mailchannels.net [23.83.222.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855812BA9B5
        for <linux-scsi@vger.kernel.org>; Mon,  9 May 2022 18:09:49 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 19AE75A0D78;
        Tue, 10 May 2022 01:00:11 +0000 (UTC)
Received: from pdx1-sub0-mail-a278.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 45DDE5A1224;
        Tue, 10 May 2022 01:00:10 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1652144410; a=rsa-sha256;
        cv=none;
        b=3PZgdd3jIeBrdDX0sv6aA9d1CAWzOHbZRO8XQ3m9r72RVjTZXnOnlE4gWVKA60/0i6bcJU
        CW+2bH+zwSdsCpBYQIsgjIbC4gyxwlBppl9lLLVO1yJeQFEJqQx4YV0YrhNRlNltbjPsKO
        EZ16GhatMOu4Zudpt5wpRZVP1s6VrKUqMzZK1aDA3iJiPycIa/LCMQtt4LK2UD57mFWkYg
        +dXGICsO0fROZji9PcFuYub/6TzJtlcVzxxSZYhtrf0w89qB58/cR1Arcx13m2zoRavL2P
        RG8/zNdDYG8s/HGeZsF75Y4/Yexs3z2UjaLszsELqEzb/HVlD5ZLc+v/GcPjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1652144410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=OkYsVEQbc5DO/sqSoctBIA2Dppvklnw/UbE5LoqMvBo=;
        b=9dUyqZ1rNUS3LIMbZvJNJk6T3I7k2k5tQKYgxgkz9eDj+wmrPCiXoVmrXYn1l0uzm5LlIE
        WrH0UUrCz/c+BlvwMy0mGheifmmi+Vds8nAkT68610MOaPObFmGBdIAxAvJBu1xcz0mj+Y
        muu9hAejL4R/EFgG18SeRNbvc4boTUOJqZNjKmTbI47EDq0d0hVcsm3otglJtofQj5MiQv
        1KRXgWvrUoihfNQFopEJGeB7cnJuhItqrAFDeSBjreONGOP2grkoiU+m8Xfv5t45ul4HCf
        +bFQ8lBzsK2aqRory8PWQ2JcXmOy78bdQLjrkqqSspXGCKJ5wMCmYtl48cj7RQ==
ARC-Authentication-Results: i=1;
        rspamd-554c8f6c56-2pv82;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Desert-Wide-Eyed: 4a875f752ba7591c_1652144410667_419043207
X-MC-Loop-Signature: 1652144410667:2618495434
X-MC-Ingress-Time: 1652144410666
Received: from pdx1-sub0-mail-a278.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.127.95.68 (trex/6.7.1);
        Tue, 10 May 2022 01:00:10 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a278.dreamhost.com (Postfix) with ESMTPSA id 4Ky07s2MGPz1Ny;
        Mon,  9 May 2022 18:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1652144410;
        bh=OkYsVEQbc5DO/sqSoctBIA2Dppvklnw/UbE5LoqMvBo=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=Kx/NtImp0B3LJ1QXpTJdrnlMpE9crtk1c84TIb3NeVjxKTb6VHqG6tWi9Q8nxnOZA
         KsP+xwhijgFhEtL/ZE7VSkPEfecwkFqEfBSglNxsz9suQKUyoRiWZfOM0FlRtC+rXC
         X5gWjMzqKMixY6dnRGscixUFRJue0xYQxmu/FSkIgRvEqQbiI+k9aBVazRfbgeAmiO
         QsOJkI2Jysu/PuL2yVuLbwC24l6Hrwg8bXujuo75CoWCTzcxl+q/pPkaJKkiFnsWM6
         DoEPcIOwq52Ipc5sW0HKm8NRnIG+OL8sEGUbzfLXU4J0yEXyXp6GyfzbZ7bTyto7ZW
         tEHeFvJV1cWEQ==
Date:   Mon, 9 May 2022 17:48:01 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@suse.de>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/4] scsi: fcoe: Use per-CPU API to update per-CPU
 statistics.
Message-ID: <20220510004801.w6hiyka7gi2vnto5@offworld>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
 <20220506105758.283887-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220506105758.283887-3-bigeasy@linutronix.de>
User-Agent: NeoMutt/20220408
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 06 May 2022, Sebastian Andrzej Siewior wrote:

>The per-CPU statistics (struct fc_stats) is updated by getting a stable
>per-CPU pointer via get_cpu() + per_cpu_ptr() and then performing the
>increment. This can be optimized by using this_cpu_*() which will do
>whatever is needed on the architecture to perform the update safe and
>efficient.
>The read out of the individual value (fc_get_host_stats()) should be
>done by using READ_ONCE() instead of a plain-C access. The difference is
>that READ_ONCE() will always perform a single access while the plain-C
>access can be splitt by the compiler into two loads if it appears
>beneficial.
>The usage of u64 has the side-effect that it is also 64bit wide on 32bit
>architectures and the read is always split into two loads. The can lead
>to strange values if the read happens during an update which alters both
>32bit parts of the 64bit value. This can be circumvanted by either using
>a 32bit variables on 32bit architecures or extending the statistics with
>a sequence counter.
>
>Use this_cpu_*() API to update the statistics and READ_ONCE() to read
>it.

LGTM, feel free to add my:

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
