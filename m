Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6CAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DE02311A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKDegik7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgHFRP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:15:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23101 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730003AbgHFRPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0c1/Bp7ocDdt7QI3/o/M8hE809LAqDVMjlZbaureeIM=;
        b=MKDegik76yyiNGG6MA2l3+Kmr9KZeq6u495om6zAE440852XlNVKZL+CLNH0i7uECtXjbJ
        xHJG1eaKh4RO3OUe1BcZXlUNHZvY3wB5nBESe9GfLCwL029rx0tD6f4Ol9Y0CVXKOfzqMF
        v6OE+4MmoAXO1bQgdFyGgMfw6i3QQZY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-eiYz7o0xNSuW2Saq1O_loA-1; Thu, 06 Aug 2020 10:46:49 -0400
X-MC-Unique: eiYz7o0xNSuW2Saq1O_loA-1
Received: by mail-wr1-f72.google.com with SMTP id f7so14873921wrs.8
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 07:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0c1/Bp7ocDdt7QI3/o/M8hE809LAqDVMjlZbaureeIM=;
        b=tTc3YeEeAPetZqiAJe4tmFl0yTI3aEIk54michkYuNXRs8twTYtIhY0Z7rXg8QE1kd
         iMjBWfV4PPmqam3vnxms+ayZza54Idqq6fr9xWH7qyPqqpQnUmg2z6waNpWzRuxomTZ9
         7ktaYSkHguwHY+6VCd5m9nQzdfuSKVzb7UrF+2DDfCjRXgBe7ul68+8pT+2P65w4WeGk
         UP/8YIolLWFzOXSiui1EFINmZaerwcAySWP9wISVMNvpAs2AIwMCqXJBp/uh8/+V0whm
         jhdJIr4Ns/zDtwfI4ByerF/5T/55mgE3LR2JrEeo8BrjKYWVwG7/bhHcW2+0VqLs0LhE
         KNnA==
X-Gm-Message-State: AOAM532o+Cm413OA7D6WLkxAIwjbB2E7/QQSTkQzja4FrTj+Ru55O0f6
        pVMJPXuLyOIeV1NtnUwZk9yu3+rc+UP/mY/3frvJiedt+6QcHnLwu1kU6BCDLFlpO1tSaKauX1x
        MKzDPUJ4QH1pvoJTHA7Jqqw==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr8442424wmk.153.1596725207728;
        Thu, 06 Aug 2020 07:46:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylL3roPS5v+IqXA0mUMSU8r5ytNbRCIB5DavoUedvjg0VapQysCXkty8XEJjSczhb154Tyvg==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr8442408wmk.153.1596725207529;
        Thu, 06 Aug 2020 07:46:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id a22sm6461054wmb.4.2020.08.06.07.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 07:46:47 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Tejun Heo <tj@kernel.org>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     James Smart <james.smart@broadcom.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
Date:   Thu, 6 Aug 2020 16:46:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806144135.GC4520@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 16:41, Tejun Heo wrote:
>> 1)	blkcg will have a new field to store driver specific information as
>> "blkio_cg_ priv_data"(in the current patch it is app_identifier) as Tejun
>> said he doesn’t mind cgroup data structs carrying extra bits for stuff.
> 
> I'd make it something more specific - lpfc_app_id or something along that
> line.

Note that there will be support in other drivers in all likelihood.

Paolo

