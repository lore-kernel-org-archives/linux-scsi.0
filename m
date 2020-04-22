Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3AFC55185
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704B72076E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qRc9bHqB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDVXMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbgDVXMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 19:12:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8144EC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 16:12:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id y6so1592537pjc.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 16:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gMm+RvacHtwoJdCqPhA1W06bx+lZhABUjRtrrEc2hQo=;
        b=qRc9bHqBrCSGk2Vo7e2p9iBzpNof05RX9SPiFs1hRbhlHKI6Knv6KCjDrmxK4bozGu
         f9X7tVApPrrFza4xcAFBk3q8L6KMOC8Yu6HWrT39u7QGYZT3mfDw8Xt6d3/+dIJ/SXhW
         kFMSl6TFLEo66vkRSo2enVg1UzCeNWkrXIW3ZpDyhIc5GDwaiOI9ifgkMdJBsqqt7keg
         +W0LTuJF3T7+x31+EfXXmXCrvHBA69bMYCNyOd4lEhBNiTAe/twsV/0NuGzt+RnleKrv
         yWYfbyV/VmGs9mu3Of78iGq4RSwG7TxAze97UVrFZWf1G3Pl3cPlxbqTA6O1NrhwXxSR
         C1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gMm+RvacHtwoJdCqPhA1W06bx+lZhABUjRtrrEc2hQo=;
        b=KFDog2UU+gCHGVZVAuUNEQGQ/z77U+Ml2UBuZYjEDxZs0MWGwzmm+fIpJfjvAZ6NWf
         FIej7pqSdQlgYGIit0RXMmYn04PZolnG1yBm//eI09hqTc2UHhJX6wFI32d1ELNPXjRK
         vFweL34+e+mdqT2Pcx69sSmGHaOB0c6KeDADVi8u83UXsaRzM+BUEonSr9FuV0DFpNS9
         uYAFJ2wcREncoz45i5sSXKVsWIwoWnU3dZMKUM5LjFxJ+7J/BXdODq911qo2QpgeBva0
         f3d+Hqwck96U7UVHMkgnIxSm4sIs2t0NYE9mRUxZ4OmhryWu1Riu69xe1lhmwQz1Qo/I
         +ZVA==
X-Gm-Message-State: AGi0PuYYiZ198NPxenPo8Y+KYQDHolO3FJHX4bOqhwRD4cVQ8bzSYfw+
        cl9shgBP+qNlf75Ps44/Gro=
X-Google-Smtp-Source: APiQypKWYnjDDlfwcobP+BBGX6sN8Gpv0AH6VYAk1MeQdzp/2OwOKwYgGANmwGzGYrEx3n29SWS/HQ==
X-Received: by 2002:a17:90a:1954:: with SMTP id 20mr1212099pjh.106.1587597125764;
        Wed, 22 Apr 2020 16:12:05 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i8sm583872pfq.126.2020.04.22.16.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 16:12:04 -0700 (PDT)
Subject: Re: [PATCH v3 11/31] elx: libefc: SLI and FC PORT state machine
 interfaces
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-12-jsmart2021@gmail.com>
 <630c8f13-884b-9f0d-429f-8a4a5cd0d515@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <d694e65d-630f-95cc-b65f-16ddcdc23954@gmail.com>
Date:   Wed, 22 Apr 2020 16:12:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <630c8f13-884b-9f0d-429f-8a4a5cd0d515@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 8:38 AM, Hannes Reinecke wrote:
...
> I would have expected the ports to be reference counted, seeing that 
> they are (probably) accessed by structures with vastly different 
> lifetime rules.
> It also would allow for a more dynamic port deletion, as you wouldn't 
> need to lock the entire function, only when removing it from the list.
> 
> Have you considered that?
...
> See? That's what I mean.
> You have event processing for that port, and additional nodes attached 
> to it. If all of them would be properly reference counted you could do 
> away with this function ...
...
> As mentioned: please add locking annotations to make it clear which 
> functions require locking.
> 
> And I'm not sure if reference counting the ports wouldn't be a better 
> idea; I can't really see how you would ensure that the port is valid if 
> it's being used by temporary structures like FC commands.
> The only _safe_ way would be to always access the ports under a lock, 
> but that would lead to heavy contention.
> 
> But I'll check the remaining patches.

Yes, we probably should have refcounting. Agree with your comments and 
will address them.

-- james

