Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DE6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 19:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84202177B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 19:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifaV5Tc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHFTUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:20:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgHFTUq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 15:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596741644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xksIODSgQJFquFghXdjFt8DevhlwMpk62x6LENq6tTk=;
        b=ifaV5Tc//frOkcL0RgM5wqmVLNjmfnK0guaSG+kiUy3dtZoxenNRGQp2TrFnKfG6LI4EI3
        W/b4kjCdduBtK1dZY8AQTLU320zGCufewJH4fc88fEUMBUxheKSZpoKe6nXNiT8GgJwhWm
        cwUfXhum4eR2SumN2pDbF7TKxpogwxw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-t4Ylnl2sNEunG7BGWYI2Hw-1; Thu, 06 Aug 2020 15:20:43 -0400
X-MC-Unique: t4Ylnl2sNEunG7BGWYI2Hw-1
Received: by mail-wm1-f71.google.com with SMTP id h205so4487168wmf.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 12:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xksIODSgQJFquFghXdjFt8DevhlwMpk62x6LENq6tTk=;
        b=q8/FtcX/dMHqigLpjQxD9kBtJ4KA+Onid47/3hY0p84d7nFVdSX+CykDC2J+QGgWz8
         p6RD5r2qzBNOOjPsa4XYxFqSiOdunKlCvkSjonJN/OsfNXmozeCsAyvc2Tbl5noUlxwL
         /hYZ5mjHw12tQPvX4OEgNYh4Ga17KItJJzoxzxab/JNee7GkRUD6nGGam3sKKNk7GxHX
         s1jLSuNTd33Dwi2me5a4wFUDDBe+iZAGrheSwR0fr1BCmboFfx1S3fEp9hvtfpn2+yXp
         5B7GkTXZzXztr0s0J4M3iOksCoQzUWHD9zlMhBzTb0iQmtuhOwwTxLUT4GGzyMS7pioD
         LGnw==
X-Gm-Message-State: AOAM531JJnZ52wBwYaKHG9OAvFyCjZB9svJx2rPIs5AZrSxnGUerz1oJ
        qi2BYVhMYT7NVoJDfk55wqaSvW54Yjd3SSqNT9OfRTlT4CYVL4t6kPe8LAMCKppBA6VwWeAf9OQ
        FfcAUvWnpHtPgvUWOKy97Tg==
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr9107890wrr.426.1596741640884;
        Thu, 06 Aug 2020 12:20:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF2qvBkdbbAz82ivFuJFBiv5/5fq62E6i55Jt9AKWyBEns1rJTE6V6YIA9dfKiZ/KoJtfe/w==
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr9107873wrr.426.1596741640567;
        Thu, 06 Aug 2020 12:20:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id d11sm7576859wrw.77.2020.08.06.12.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:20:40 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Tejun Heo <tj@kernel.org>
Cc:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
References: <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <20200806144135.GC4520@mtj.thefacebook.com>
 <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
 <20200806144804.GD4520@mtj.thefacebook.com>
 <b7fb1e9a-49c4-f639-475a-791a195be46b@redhat.com>
 <20200806145901.GE4520@mtj.thefacebook.com>
 <8850c528-725f-c89a-cdc6-a9abada80a69@redhat.com>
 <20200806184920.GG4520@mtj.thefacebook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2522463-daf1-ea45-1dbc-2e31eb8bced2@redhat.com>
Date:   Thu, 6 Aug 2020 21:20:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806184920.GG4520@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 20:49, Tejun Heo wrote:
>> perf and bpf have file descriptors, system calls and data structures of
>> their own, here there is simply none: it's just an array of chars.  Can
>> you explain _why_ it doesn't fit in the cgroupfs?
> What's the hierarchical or delegation behavior?

If a cgroup does not have an app identifier the driver should use the
one from the closes parent that has one.

> Why do the vast majority of
> people who don't have the hardware or feature need to see it? We can argue
> but I can pretty much guarantee that the conclusion is gonna be the same and
> it's gonna be a waste of time and energy for both of us.

I don't want to argue, I want to understand.  My standard is that a
maintainer that rejects code explains a plan for integrating with his
subsystem and/or points to existing code that does something similar,
rather than handwaving it away as something "that I can't remember off
the top of my head".

Thanks,

Paolo

