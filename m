Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2394DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 23:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B6F2250E
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 23:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SUpGuGhy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgHEXib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 19:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgHEXi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 19:38:29 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169EC061575
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 16:38:28 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id e5so21046909qth.5
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 16:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tS465+e6GdpvKXllM7bMAFesYQVtVvr90Wm9oFWZvYA=;
        b=SUpGuGhyy9MWMCjSY3MQXKQwn2vphZjE9gR1oXTVpRbSBjybhZl3fCgneev4QSO3FI
         QlhGBfqL62kWE9DYryav6vu02+DI6jPWC9heHagIGcVqUoL+RIlBXokA0JXxecSJmbcl
         I8nRjS15+WQlEd1BP7F7ojPGi4uYE3afafjqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tS465+e6GdpvKXllM7bMAFesYQVtVvr90Wm9oFWZvYA=;
        b=Coc+haXZ7vwU6+6gr/jmdSFVyohcyegCli739CH1I4DCohuLO/PMbT5hIngxr5xpNZ
         AaYGFgxx/UynZswBsfQRI43ke84nn0sPgiJ3oevwVRsmELV/hVIF3nS/BLV/IbsrrTNW
         +05D1nkQ4+RNyj5kSTdnq6TLAZZenvL/aH0LpUI4yLAU/oD3eL0Bc5XKnO47LnXotKcB
         rkPd2RVqIOPScalBcrUgT9yMb1KrvyLGX/+cQQN8iuRxO62PN02QuE8KVvCrtKPmcAwl
         htona5D4nb/V7GExU1NC3xPZb52rP+f8ksjQFOFT2dsnWKXDiAxnOVh5BxnfdOG47GfI
         AlAw==
X-Gm-Message-State: AOAM532u9sXhrIsOBLGnlq0qYNNMSIfFyuVQHHQw8pWkTSGGOez18VMF
        eTdkQuNZawmuSzNEEUbf5dV+Cg==
X-Google-Smtp-Source: ABdhPJz4BHWcX7OF29gUAJUEkfOy/P6pLCcS6qg2O+FjGLpzvm8qQi14ba9FmEVrP9DSIu1QTDXWsA==
X-Received: by 2002:aed:33e7:: with SMTP id v94mr5922334qtd.18.1596670707359;
        Wed, 05 Aug 2020 16:38:27 -0700 (PDT)
Received: from [192.168.1.42] (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id t12sm2799399qkt.56.2020.08.05.16.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 16:38:26 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Hannes Reinecke <hare@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
Date:   Wed, 5 Aug 2020 16:38:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/2020 12:16 AM, Hannes Reinecke wrote:
> Well.
>
> Creating a VMID in the hotpath with a while() loop will be bogging 
> down performance to no end.
> I'd rather have restricted the ->queuecommand() function to a direct 
> lookup.
> If that fails (as the VMID isn't registered) we should kicking of a 
> workqueue for registering the VMID and return BUSY.
> Or tweak blkcg to register the VMID directly, and reject the command 
> if the VMID isn't registered :-)
>
> Cheers,
>
> Hannes

That's actually what's supposed to be happening. fastpath uses the uuid 
to look up a vmid tag. If no vmid tag, kick off the fabric traffic that 
will get one but don't wait for it to complete. Any io issued while that 
process is occurring will be not be vmid tagged.    I'll circle back on 
lpfc to make sure this is happening.

In the mean time - the most important patch to review is the cgroup 
patch - patch1.

If we wanted to speed the driver's io path up, one thing to consider is 
adding a driver-settable value on the blkcg structure.  Once the fabric 
traffic obtained the vmid, the driver would set the blkcg structure with 
the value.  In this scenario though, as the vmid is destroyed as of link 
down, the driver needs a way, independent of an io, to reach into the 
blkcg struct to clear the vmid value.  We also need to be sure the blkcg 
struct won't be on top of a multipath device or something such that the 
blkcg struct may be referenced by a different scsi host - I assume we're 
good in that area.

-- james
