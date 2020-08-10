Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3351CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E5C20716
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RO+FebPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgHJJDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 05:03:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726029AbgHJJDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 05:03:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597050221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/9m7JEtZbYuMt5YcDCLBGylUSaNSuF5Mkc1WI8Cn+fo=;
        b=RO+FebPJ0UYdOTXdNZGuFFh1DmujIqlhEOOKL3eI6AvRcd0MAazMFK+ogl0ZsHbYy0cxgK
        3ZU0Ki87d0OrUFGoMwZBQnO08YGTDSU+aeTMQGLWdOUBaoJ4h/cdecz3Z6DdUrfNrzBayq
        tzDi7oFAS/PR8HdIMKAoWZvA4NDJfFA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-6eeqE4_fOs2CKyodw_Bg-w-1; Mon, 10 Aug 2020 05:03:40 -0400
X-MC-Unique: 6eeqE4_fOs2CKyodw_Bg-w-1
Received: by mail-wr1-f71.google.com with SMTP id w1so3971276wro.4
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 02:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9m7JEtZbYuMt5YcDCLBGylUSaNSuF5Mkc1WI8Cn+fo=;
        b=PZy+sHiP8UjC3PVhhY74TQrzhZ+Tlxj3j0548uKgi/dOpwzEbYiVAqrR48lvt6unwS
         msKvoyiDLexcvM0Z+GjVyBo/rqJ7nKWyunTp6Tq4VAqKJbOhu8c1rMs3wZcJzmhwDfHo
         9RRRit6pHNSKF6J2A+l/Evz47m0QHfQycnqRtNvrBkS7Evp0MdBRBSOBQorSHAyLU+yu
         Mq8QtjgS9mamqBF+W2+AbOfYm8ArBDQTh4YrO0s/vaz+2Ypf/Joz+KhHd9qH11EQxfzS
         pkWiP7kRGuwPzW0ixIcBpH5EQOzbSDBYtluxdgVx43YJtDIkv/LAwFkON+CM6BeQus6e
         BiDw==
X-Gm-Message-State: AOAM530X7OSuGp1LvC41CSt08FVmI3uLwCkXuvS7GuDESssKngOVOYji
        P54OCxzsSZLQUiIr5qCe7ya0pPUnERH8oplMbB23LLxR8s4sC+xbkZgmWXSs8GCVggjCLS5hQBs
        Ba5+GRyvzdgEW66NvYjZAZw==
X-Received: by 2002:a1c:7315:: with SMTP id d21mr23479797wmb.108.1597050219040;
        Mon, 10 Aug 2020 02:03:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYEgMgN35SVKncppQRg6rGUD9vKxifyZB/6Mz510U+kR2NPs6GV4U8xJgmPCxnD398IJtcDQ==
X-Received: by 2002:a1c:7315:: with SMTP id d21mr23479771wmb.108.1597050218752;
        Mon, 10 Aug 2020 02:03:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d6c:f50:4462:5103? ([2001:b07:6468:f312:5d6c:f50:4462:5103])
        by smtp.gmail.com with ESMTPSA id g18sm21449525wru.27.2020.08.10.02.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 02:03:38 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com>
 <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
 <e76b12c664057adb51c14bf0663bb2f7@mail.gmail.com>
 <b471b84f-25e9-39cb-41e0-1cc1af409a8a@redhat.com>
 <7e76e1464e794a79861ea9846e0a5370@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <053466c4-7786-38aa-012f-926b68c85c8c@redhat.com>
Date:   Mon, 10 Aug 2020 11:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7e76e1464e794a79861ea9846e0a5370@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/08/20 14:17, Muneendra Kumar M wrote:
> And I was talking about at the below one PIDS(3627) .And with the help of
> these PIDS I was able to reach blkcg.
> Correct me if iam going in a wrong direction.
> And even when I run the below command it pointed me to the same pid.
> cat
> /sys/fs/cgroup/blkio/machine.slice/machine-qemu\\x2d7\\x2dtestmmkvm1.scope/tasks
> 3627  -->/usr/libexec/qemu-kvm -name testmmkvm1
> 3655 --> [kvm-nx-lpage-re]
> 3658--> vhost-3627
> 
> And I was talking about the above PIDS(3627) to be passed to the interface
> along with UUID.

The cgroup exists even before the VM is started and waiting for the PID
to appear would be racy.  The PID is *not* a representation of the VM,
the cgroup is (or at least it's the closest thing).

Using the PID would lead to an API that is easy to misuse.  For example
say you have a random QEMU process that has not been placed in a cgroup,
for whatever reason.  If someone doesn't understand that the API uses
the PID just as a proxy for the cgroup, they could end up classifying
*all traffic from the host* with the VMID.  If the API uses cgroups as
the fundamental concept instead, it's much harder to make this mistake.

>> There is no need for any daemon, and I'm not even sure which daemon would
>> be handling this.
>
> Iam talking about FC transport daemon.
> One of the feature of this daemon is to track all the running VM's and push
> the appid information to the blk cgroup via the interface provided by the
> fabric

There is no need for this daemon.  The cgroups can be initialized by
whatever takes care of starting the VM, for example libvirt.  How would
the daemon learn about the VM PIDs and UUIDs, besides?

Paolo

