Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85764C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 23:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8352073E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 23:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayZaVkWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgHKXse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 19:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHKXsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 19:48:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004EEC06174A;
        Tue, 11 Aug 2020 16:48:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s15so73123pgc.8;
        Tue, 11 Aug 2020 16:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6hnkVFy1xwcKEBJMlpv+KBYaHij0G40KOlMLzuv7P8=;
        b=ayZaVkWcDEMYUXdD2imWZ67GI6Dlv4Kk8fS4TzfMm8L6iNU5fDG8JMvVQ9fMZzACe8
         EgZObzIUa3AMsPc95uBee68GUvuYWxSqhEM9QyNTJAeVmERtRuTuLUuwj+9VZ59KjPXh
         BwmtjqmRa9S/e44IMf4aGsAlrluZcn6NXiVwtFjAzRpfwHHNi5VipC6xZ/xqqcUVcnpP
         j9gBMslqjd0Ae9G0Bp/IHi1WMZLJEVs62fIdTn9TbqM1blaNIUvIj+PY+QToJUcf7Hbc
         VMfuMT5CgBFQBtlHzq7ZokYbduE2e9XIv7/W5xqp8AEbhX4dDjLVM1VlL4VReD/sF1hL
         4R1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6hnkVFy1xwcKEBJMlpv+KBYaHij0G40KOlMLzuv7P8=;
        b=G5e3tkEuyl//NDWxrttZS992MjjHhMHI95a3QZviI/gw2TYhxQ6p/u0h9VWXccJRdg
         d7t63XhfRlde1Do8n4ucdx6bIqgJsREDY4RAE7Uiiwdl+Gx5XTaRzMWB77xzyFIRWrCx
         5q4aQ36c87vVMuCKZh9tZK3LlKsO2uqMhdBrRyY+SlYuHag3e9m4eAOIr94X5pW9SmR8
         O8X6xqsRzULN4apBPjrdYdKcMATNxTUlMeGRq8VIuACgNB0AY4sbX8gh8cFqsmiIxNjG
         HATpTi0agMRlwT9HTF8wWppCrI65heA4FCP1d7npzw2oFmZzNFJKN7MLfxywS0KR4rLj
         1TaQ==
X-Gm-Message-State: AOAM5327jmfzkVaImFctpbMhEt0d2joGbHhCMzEvXuGVWA0gQKr0ami5
        Skxu6HVsQtIYTV4dHkoGZmjzHBX3
X-Google-Smtp-Source: ABdhPJxdYF1epYAD+LHkFwa3cMPsFYHjeugpbI3Lp/4/xlxJEOtsq4MnEGP+9yjt0BERsX4AJBd7Gw==
X-Received: by 2002:a63:584c:: with SMTP id i12mr2819131pgm.313.1597189711619;
        Tue, 11 Aug 2020 16:48:31 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t25sm186797pfl.198.2020.08.11.16.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 16:48:30 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <61317e13-195b-0aac-92e8-fd6836155fdb@gmail.com>
Date:   Tue, 11 Aug 2020 16:48:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/2020 9:26 AM, Muneendra Kumar M wrote:
> Hi Paolo,
> 
>> 3.As part of this interface user/deamon will provide the details of VM such
>> as UUID,PID on VM creation to the transport .
>> The VM process, or the container process, is likely to be unprivileged and
>> cannot obtain the permissions needed to do this; therefore, you need to
>> cope with the situation where there is no PID yet in the cgroup, because
>> the tool >that created the VM or container might be initializing the
>> cgroup, but it might not have started the VM yet.  In that case there would
>> be no PID.
> 
> Agreed.A
> small doubt. If the VM is started (running)then we can have the PID and   we
> can use the  PID?
Note: I'm not worried about this. The transport/lldd would be fine with 
the device being used for a while with no blkcg attribute set. When it 
finally does get set, it would initiate the creation of the 
corresponding fc wire app_id.  This will be something normal.

-- james

