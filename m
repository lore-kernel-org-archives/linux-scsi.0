Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729F6C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6B223119
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2DkH10R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgHFRYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:24:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54603 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729747AbgHFREF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596733444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7qKFUHSsfOckbuEfcX39ZxDjhilcGHcHy9F4F6zJkzI=;
        b=W2DkH10RyRXmgg7Sb5eAHA+wnJ+9HT0Rpjw9TSCADPOZUmE/Pa0GD7bRzRVG7VosVmMqA4
        +oh0CkjQkBOxFqMob5+PYY1dSAhZoyPLzSaWmHRxdPBmPOWuiUeuhphag2F92pmMZpli8y
        AJ21tsoqTSrss4YQhE5ugPnpPASZFs0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-3STr7eyJP7CgHhP2PG_ldg-1; Thu, 06 Aug 2020 10:32:54 -0400
X-MC-Unique: 3STr7eyJP7CgHhP2PG_ldg-1
Received: by mail-wr1-f70.google.com with SMTP id k11so14361291wrv.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 07:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7qKFUHSsfOckbuEfcX39ZxDjhilcGHcHy9F4F6zJkzI=;
        b=A7d98Mxs0n5oD1N8cIysYP17Ff8dHlmrKi05uyfcRPPArlmCwIudjXaPRAYrnufuAS
         7usSFlnoN6auzZB4QH/rYTHswCe9aZK7bNkRvsQs5kdeXSt1SJRNVl6NE5KGRfW9JAo8
         mG61MCq/eUw8awavW1NKI2g2ASRH4WkwuRp5aGcBGZK6V/AKNuurm2Y8HwiKhghB2ep9
         8OSyRCzZNNMPsno+s+BqJIoiKZkN7JxAsLeq6NvKETQo8tMjx9E5vsIcF1UQGNizs+aR
         0RwdAqfsW/MjZ8s32QZlyyzq10o8x9LxX6JUZLv+inU7oi1Dl/2Q8EwzQ2Qo17ruEkqI
         Uvdw==
X-Gm-Message-State: AOAM530uk2TywpcYR71M+/6o9Bhr2NuqoffX7wZ+l5iGIaThUk44ERLI
        BedZgkVwtxsZyaLRjPapexwsblkGODm4ytuHSUT/wGUuqcKrgD44/GsJeK0DM/S2xetOrelc5nd
        +HCR8Px7tMwRHxxgMd4L6oA==
X-Received: by 2002:a1c:ed15:: with SMTP id l21mr7896412wmh.37.1596724372834;
        Thu, 06 Aug 2020 07:32:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWx4MVPYaeGnZL6EeXHk2gJPIjnNWzSre55OUOWTug9CIFO+ByMhVAxH//yvWgSm2IOf2nZw==
X-Received: by 2002:a1c:ed15:: with SMTP id l21mr7896330wmh.37.1596724371700;
        Thu, 06 Aug 2020 07:32:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id s205sm7033405wme.7.2020.08.06.07.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 07:32:48 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
Date:   Thu, 6 Aug 2020 16:32:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 14:34, Muneendra Kumar M wrote:
> 3)	As part of this interface user/deamon will provide the details of VM such
> as UUID,PID on VM creation to the transport .

The VM process, or the container process, is likely to be unprivileged
and cannot obtain the permissions needed to do this; therefore, you need
to cope with the situation where there is no PID yet in the cgroup,
because the tool that created the VM or container might be initializing
the cgroup, but it might not have started the VM yet.  In that case
there would be no PID.

Would it be possible to pass a file descriptor for the cgroup directory
in sysfs, instead of the PID?

Also what would the kernel API look like for this?  Would it have to be
driver-specific?

Paolo

> 4)	With VM PID information we need to find the associated blkcg and needs to
> update the UUID info in blkio_cg_ priv_data.
> 5)	Once we update the blkio_cg_ priv_data with vmid all the io’s issued from
> VM will have the UUID info as part of blkcg.

