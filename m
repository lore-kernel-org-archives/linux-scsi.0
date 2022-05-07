Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0895EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  7 May 2022 04:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445508AbiEGFCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 May 2022 01:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbiEGFCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 May 2022 01:02:38 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8146138BE8
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 21:58:52 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 541778208CB;
        Sat,  7 May 2022 04:58:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a291.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 9D077821221;
        Sat,  7 May 2022 04:58:50 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1651899530; a=rsa-sha256;
        cv=none;
        b=nn12QXUtKpRLdXxVhaCuQhbab2LkKAXm/TQbGuqjSQQo9p3QjamgIlXSiquToMFEUXzyU5
        tstrrxnLhvT5NGL/ax3OyyNHPiIfkhlVSUJ7gbZUtqaFHz33Cb74MfOyDzM1N99NKZuFyv
        +/NUaVgldDeoAXQQIoCP2OrtBfPgIb+r6gt0q+TSnCllNaWgaytPfpgxE8cwoyeReSlBpG
        N4QPVYgAn/Gwmr99NgC26vOUiTyhigA5T1fZcDREhniQq/2Rtn8HiYorm6O1RijzRaseN7
        tROwqPOFgazXqUjCDjk2oYHcHzqH2MomvAUI2IvCmy0T6ggtXervDGfyMP/KkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1651899530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=iGQ0Wms1Ay5vKxGN666qhSAEcBfPIVf0MTu/0xBik88=;
        b=FPb9UT1WWAg1JLaVloYrPto7QolP+lcojOVqepC96BH9PIFTb2BTg603m02KOefCR80+Ch
        0Bf53Z7qrBLdsfp2Ol6L7OPaQKpqNqJPhqzrO3tWitV57kL4Hu3FcoZQxbJlmgeHVbtV48
        yIrhE0jO3lk3ru43CIMEfsw1hPPkLMdcBjgjxY65sfhJWoWUwbIjukkqbq8PGkIfjVzozn
        /KTvBG25G6jznf9iP5KZryDiyXhD7cGinkvMdoTc5FbBTx8oLUYxPvb8efmxr61V9d+x1l
        6X4CGxAkdr15/PBq/y75zDg0lmn+KJ8sjUlu6RsknPiiaGIlklP7wVC2QtP0aw==
ARC-Authentication-Results: i=1;
        rspamd-c4dc5ff8f-p427r;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Daffy-Hook: 275769ce35e00836_1651899531121_3867965153
X-MC-Loop-Signature: 1651899531121:3074769767
X-MC-Ingress-Time: 1651899531121
Received: from pdx1-sub0-mail-a291.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.106.158.137 (trex/6.7.1);
        Sat, 07 May 2022 04:58:51 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a291.dreamhost.com (Postfix) with ESMTPSA id 4KwFZd4l3nz3m;
        Fri,  6 May 2022 21:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1651899530;
        bh=iGQ0Wms1Ay5vKxGN666qhSAEcBfPIVf0MTu/0xBik88=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=Vn/44srBjH81c0wcJ669eX0jPxJBc8SRChBr8/+WnPJYvpw6HcKMVKywyeoxdfjKr
         XvOeyB85TM85cLXz1bKQ0nEd6FY3SlGhAbSgUhU9BlOQ1fFTuyuCroXOBf0+ma6+qz
         XUuCk8pl/7FvO0vvUNHY62IhUmYU2ChiYyn8OGjFvRvcZW6oTf9SUuPNJ1SZYseLX7
         ObBy1VjkNCKoeWMy4tnBlx0ReIvOu8LjwtqTr79ylw/UaKECHW1On7qZAbypdenTXK
         bYQ/YbqFvfesn2xKR4aTUV5b0xcixAjG191t27U6QN5CxEMR43ftzCrR6TG92aeuAI
         Kj++IP+6nimtA==
Date:   Fri, 6 May 2022 21:46:50 -0700
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
Subject: Re: [PATCH 4/4] scsi: bnx2fc: Avoid using get_cpu() in
 bnx2fc_cmd_alloc().
Message-ID: <20220507044650.q3rcdi3mzlfvp37i@offworld>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
 <20220506105758.283887-5-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220506105758.283887-5-bigeasy@linutronix.de>
User-Agent: NeoMutt/20220408
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 06 May 2022, Sebastian Andrzej Siewior wrote:

>Using get_cpu() leads to disabling preemption and in this context it is
>not possible to acquire the following spinlock_t on PREEMPT_RT because
>it becomes a sleeping lock.
>
>Commit
>   0ea5c27583e1c ("[SCSI] bnx2fc: common free list for cleanup commands")
>
>says that it is using get_cpu() as a fix in case the CPU is preempted.
>While this might be true, the important part is that it is now using the
>same CPU for locking and unlocking while previously it always relied on
>smp_processor_id().
>The date structure itself is protected with a lock so it does not rely
>on CPU-local access.
>
>Replace get_cpu() with raw_smp_processor_id() to obtain the current CPU
>number which is used as an index for the per-CPU resource.
>
>Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
