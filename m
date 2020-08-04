Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA3DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 16:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678D42070A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 16:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OYgrInFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgHDQWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 12:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbgHDQWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 12:22:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD90C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 09:22:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g8so3233803wmk.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 09:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=qlVlWXa1wxPqdkzcFMn6iX8PIilxlndHQKkVUY/bL9M=;
        b=OYgrInFCRsHFoy7aVDvdt3f2t4xS+Pwnm7zjjIyUpAskE+fNhUwqmS6nWUmHQryNKI
         XeCWrqAYoQ7K8puHI+InJ6PNCPI0cFT/MuN+VdliR1ViBMAIAmdyGkoV+kpB3bod7n+m
         JFYKUdJlprUNmJ+efpktIvVBWRxmOEy1eLJJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qlVlWXa1wxPqdkzcFMn6iX8PIilxlndHQKkVUY/bL9M=;
        b=ilc/jco3DOA8tE0lewKZ7bYqOtV5mia/TKgx5LUln8ntGsqUpfqRdklmJrCUDFHSgL
         vmzmrlomxGGNID5urnABt2iGXsBgsUxJc7oh37Ka0z4VI5oVfh+FzY7UZuYTWN6Qo8bj
         mFN51XdIp4mYhHJFkcXbhOG4gA5T0TYI9WVSlBT4ZDo7gkKiMIxsu50JgzncxQyPz+Wj
         4xMrVeRIYPv8EBp3ChQo5Ofhb/Lqow6k87V43g0JD4mdwJJjZJBsi5bT+pfmpVIW8kLq
         3NmGiJmW2gq3BE9sgL4Ds61c5v+5JyQ8I2vvYx06pnCdNuW7s4lBzRjwGWWj8lh2N3Pj
         wluQ==
X-Gm-Message-State: AOAM531D2cxfCNJoEtp+E5fO2gf+rRAojirDug9GtkOSVd2EwWp0hfFq
        xXFiic21p0XHH01MQrcvV1D4Y2VlN4b/enZHkHLe58lLL3GhmVwauc9+F2QsndYdX0erYJ1rRwQ
        jHL4rlRhIqOc++0f7b1fRduJQthXHpX+FHLz0P4eljU5BN8T35UGkJzj0u4F76QLWrGoTUwQ+Cl
        gsW5g=
X-Google-Smtp-Source: ABdhPJzAKdV4/ms4lUdDnFOZPoCdEYNbaXA9GLbvwGfp/CiiFShnA5cv6PSmG8fuFNM8q1fwzCy7Iw==
X-Received: by 2002:a7b:cc12:: with SMTP id f18mr4530126wmh.129.1596558124073;
        Tue, 04 Aug 2020 09:22:04 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p8sm33145605wrq.9.2020.08.04.09.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 09:22:03 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: nvmet: avoid hang / use-after-free again when
 destroying targetport
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200729231011.13240-1-emilne@redhat.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <f84d19c8-b8d5-43ab-3289-28b5f3587b03@broadcom.com>
Date:   Tue, 4 Aug 2020 09:21:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729231011.13240-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 7/29/2020 4:10 PM, Ewan D. Milne wrote:
> We cannot wait on a completion object in the lpfc_nvme_targetport structure
> in the _destroy_targetport() code path because the NVMe/fc transport will
> free that structure immediately after the .targetport_delete() callback.
> This results in a use-after-free, and a crash if slub_debug=FZPU is enabled.
>
> An earlier fix put put the completion on the stack, but commit 2a0fb340fcc8
> ("scsi: lpfc: Correct localport timeout duration error") subsequently changed
> the code to reference the completion through a pointer in the object rather
> than the local stack variable.  Fix this by using the stack variable directly.
>
> Fixes: 2a0fb340fcc8 ("scsi: lpfc: Correct localport timeout duration error")
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>

Thanks Ewan

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james
