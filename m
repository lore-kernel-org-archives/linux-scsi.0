Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B389C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CCD22C9F
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DA+gEK7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgHFSjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729326AbgHFSjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 14:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596739171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mSeGTx7DzZCh+sP0mMajVqXcmYXUD3jDyAI6XML2hko=;
        b=DA+gEK7caA5LZlZlH7Wffb3xW1+MIfnLYOGfolUUYfMhO6bdozEbq+tSUSuCGhhI1WT/q2
        xnLIa4iYQLdCOk2QBhh+J+D1LvmEkZcc2IqUZqORn1kJLu8ddu8SW4AjKFJp+pefVijVUJ
        5a7k1Kf635455DsUov3uRRvtK1qduA4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-Qwz5d9RMP6Gv6vYOukY9Ig-1; Thu, 06 Aug 2020 14:39:30 -0400
X-MC-Unique: Qwz5d9RMP6Gv6vYOukY9Ig-1
Received: by mail-wr1-f71.google.com with SMTP id 89so15105242wrr.15
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 11:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mSeGTx7DzZCh+sP0mMajVqXcmYXUD3jDyAI6XML2hko=;
        b=lPbE1d4RB2V+b4Acxz2FFXwb1nKdcVDmQFzd/zE4+Zul1tHckHsTSbmBYftXfr3PsJ
         HPGqbbSRHPqQEO/HMegFWZ9rzZ457KjswbazyWug+Tgnj0D295oV8Lm6uo2ApbL9oCd7
         oCcmFKJqFv8YO3DP0ptdu8P+A+B/Ty6uWrKeaXxpoXPDVH/2/7LXdyXuMG/0Hnp8Lw7G
         wxp3I4MeAGKJcPM0Wn3p7YQaxBxH7qSz3fx2wfykIBTmJu4PjXT5ZBcRPkw0DQLx0BqX
         SC9L2Df+VG+Uru6esIKjE/2q575tzq9rwjf7HIPfzRw+Y5hAPhcVP3nnVZxDu2HYpYe5
         zAsQ==
X-Gm-Message-State: AOAM533TZNsxsu20CRAL9iMkbEJPwG+zzNGIsxVcUNijnnElrm0wLZL+
        YIagpxDaB+lWMw8AOnHU98noITHgLPx2BxlhHtA6daNBy6GRGX5+r+6OI4likFJT+rDd6Fri5xb
        AaszdDF47wOc34M55fdPeOQ==
X-Received: by 2002:a1c:bc54:: with SMTP id m81mr9727202wmf.73.1596739168867;
        Thu, 06 Aug 2020 11:39:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUZrnC7JvhFi591C7Uz5OezHi646AYsSyAdUcX1XYvfQOWZF/0xWpBypiyG+geNAY+DUqVLQ==
X-Received: by 2002:a1c:bc54:: with SMTP id m81mr9727179wmf.73.1596739168590;
        Thu, 06 Aug 2020 11:39:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id o124sm7576150wmb.2.2020.08.06.11.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 11:39:27 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Tejun Heo <tj@kernel.org>
Cc:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <20200806144135.GC4520@mtj.thefacebook.com>
 <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
 <20200806144804.GD4520@mtj.thefacebook.com>
 <b7fb1e9a-49c4-f639-475a-791a195be46b@redhat.com>
 <20200806145901.GE4520@mtj.thefacebook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8850c528-725f-c89a-cdc6-a9abada80a69@redhat.com>
Date:   Thu, 6 Aug 2020 20:39:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806145901.GE4520@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 16:59, Tejun Heo wrote:
>> If I understand correctly, your only objection is that you'd rather not
>> have it specified with a file under /sys/kernel/cgroup, and instead you
>> would prefer to have it implemented as a ioctl for a magic file
>> somewhere else in sysfs?  I don't think there is any precedent for this,
>> and I'm not even sure where that sysfs file would be.
> It just doesn't fit in the cgroupfs. I don't know where it should go for
> this specific case. That's for you guys to figure out. There are multiple
> precedences - e.g. how perf or bpf hooks into cgroup and others that I can't
> remember off the top of my head.

perf and bpf have file descriptors, system calls and data structures of
their own, here there is simply none: it's just an array of chars.  Can
you explain _why_ it doesn't fit in the cgroupfs?

Paolo

