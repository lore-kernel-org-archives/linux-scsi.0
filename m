Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A71C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E99723119
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZpMPoF8n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgHFRSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:18:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730352AbgHFRSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c62S3FDTWB5DNi2bOV+bb/p0i2olIR+ZCvofXOklb84=;
        b=ZpMPoF8niP9S60gwa+E5AMO22tX+bgkm2her7dqWgneT9mKAZmeC/VG22NW44lF/LJiQSs
        Cqr9kHok792Jx8qMaZtQTq7eXXnoqB4Ux8C8VNJ6utk56J5/dJkN3jCZfZknP3m3jRCfOJ
        ZeVnlYa2KsI4DPT/1uorAF6OQTU9zi8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-7K_e_523PNasL47-jJRw1w-1; Thu, 06 Aug 2020 10:54:24 -0400
X-MC-Unique: 7K_e_523PNasL47-jJRw1w-1
Received: by mail-wr1-f71.google.com with SMTP id m7so14881884wrb.20
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 07:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c62S3FDTWB5DNi2bOV+bb/p0i2olIR+ZCvofXOklb84=;
        b=l4+5fd9WCH7ww50gEgv+8dd5mBvPQ8irQfemoPuWB9ba87ZHOQN6O6w/ypgUXDQjMC
         XB2/rf79KjwJrbpok5uXQnq1Tm+8adLOAPTNQ4Vq7QbFBy+RMk1CKbsMJmGbps/kvxm3
         SNra8p0EYFBcsTokJpvWI3w1Ia99j1a6jzXf16R1/VpQQE/w1n/Bovf/G5JadKQ0kq2s
         Qnbn9LfDlpelIEKFZtQPIK5hLnXQR6G/PjJrxzKRWXsOSEqSz7OXW3LuABntPRiy/D6G
         Z7DDEZtLHNqVMomAF+lR95X3R9JKda3//Mb3XOCBCZLm9a1N3P+yu8qBg5nYDG7NIf/C
         Oz3g==
X-Gm-Message-State: AOAM5317+8WoQJ2e69H3eScQOr+zimK/NTe4P5PsPUXJl9bDAduvu3Gr
        ylDqvREiSxlvEN9LP/U0EDPr6O+kZjM1VpKmQYD0Adrbs0o58rYkj8ncYxJWCDKfK6YKCUNidFr
        7VZBJ1y19OESOfPTmiHjvQA==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr7411131wrx.270.1596725663036;
        Thu, 06 Aug 2020 07:54:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD+D3J81jrieJNsTVbB0yypLvKEuKreAdqQ1W1MwebvzezGKzsMF5xpnsIr3VQgks1ctNfaA==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr7411105wrx.270.1596725662738;
        Thu, 06 Aug 2020 07:54:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id k15sm6939002wrp.43.2020.08.06.07.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 07:54:22 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b7fb1e9a-49c4-f639-475a-791a195be46b@redhat.com>
Date:   Thu, 6 Aug 2020 16:54:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806144804.GD4520@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 16:48, Tejun Heo wrote:
>>> I'd make it something more specific - lpfc_app_id or something along that
>>> line.
>> Note that there will be support in other drivers in all likelihood.
> Yeah, make it specific to the scope, whatever that may be. Just avoid names
> like priv which doesn't indicate anything about the scope or usage.

So I guess fc_app_id.

If I understand correctly, your only objection is that you'd rather not
have it specified with a file under /sys/kernel/cgroup, and instead you
would prefer to have it implemented as a ioctl for a magic file
somewhere else in sysfs?  I don't think there is any precedent for this,
and I'm not even sure where that sysfs file would be.

Paolo

