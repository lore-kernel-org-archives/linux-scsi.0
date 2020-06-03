Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4F2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 13:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B7320679
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 13:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dRwvImId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgFCNek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCNej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 09:34:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847C3C08C5C0
        for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2020 06:34:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l27so2210009ejc.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2020 06:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=JhoMw3YkQpCseFSsh/lVmeFHj2TYb955rgd4sIpGDw4=;
        b=dRwvImIdqP196cKPZv0g9rBkpfV6Yf6mwGv20iBgvLuMc1StUpUhgTRBKvMpxOKzkq
         MDlm0rXRugI/E1j84RRRZNT+qardRrxBTaMTXsL/zJWlkbCmWNcn4fH9ybBObQk+vHHW
         r3sLTlz+xWYM33r/XfdAJTgSSiNS62wPN/vbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=JhoMw3YkQpCseFSsh/lVmeFHj2TYb955rgd4sIpGDw4=;
        b=fB0yLvJraVhTH2wZA+H/PZBAg1JmP9wlnz87hGGE+oN0OGLpyjB7MYRfHu6sPkNvgp
         jE9AVlj1onPf0z+HnjOq1h6R17NqKxa7e+z/cQOwxePBWK757eNStjJcSL465MXCUtW0
         2rgNMJl0QIuHhrkTvWyiC3NK+b2rWigutuKBA1xAaBKpPJPn9ddrK6EBAyflfUHKdU7r
         CauuQrHx/JNgiGVx9NOPzNA8sWGQ4WY3SRvLQjZ2UAjvYNPtFbrvIM9lDqLwjz8nqV70
         /px8Jr7zkBlluc9vaS2C2Eia4uUFHh3ABrtdu6UfaR60q3RvlZUg6657rpzA4U2nqimg
         XlFA==
X-Gm-Message-State: AOAM531W6OQ56sCdyLoiLVRX3Y36Or2gr23P/aePy++NYPo+HXpAa87J
        zFEJDX1KwW47F6xOucdfG1bJKU3fDrEoCF0f80ZnRw==
X-Google-Smtp-Source: ABdhPJwKKAgiK1gE/ZW8FEEq6vj7DAUATxy+ips4f8JzLgMIh//phQkBGbaQKVR8QGqMH7Vk+glpPxWCbEa3pmFOWhs=
X-Received: by 2002:a17:906:5645:: with SMTP id v5mr11075782ejr.533.1591191278202;
 Wed, 03 Jun 2020 06:34:38 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com> <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJb9Wzm0098wwdcUnfhuPbO5i84ZwGnJavmp64zHeA=
Date:   Wed, 3 Jun 2020 19:04:35 +0530
Message-ID: <08525d33fafb0a10c427838621fb571f@mail.gmail.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by JBOD
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     xiakaixu1987@gmail.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoming Gao <newtongao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung
caused by JBOD
>
>
>> when kernel crash, and kexec into kdump kernel, megaraid_sas will hung
>> and print follow error logs
>>
>> 24.1485901 sd 0:0:G:0: [sda 1 tag809 BRCfl Debug mfi stat 0x2(1, data
>> len requested/conpleted 0X100 0/0x0)]
>> 24.1867171 sd 0:0:G :9: [sda I tag861 BRCfl Debug mfft stat 0x2d, data
>> len reques ted/conp1e Led 0X100 0/0x0]
>> 24.2054191 sd 0:O:6:O: [sda 1 tag861 FAILED Result: hustbyte=DIDGK
>> drioerbyte-DRIUCR SENSE]
>> 24.2549711 bik_update_ request ! 1/0 error , dev sda, sector 937782912
>> op 0x0:(READ) flags 0x0 phys_seg 1 prio class
>> 21.2752791 buffer_io_error 2 callbacks suppressed
>> 21.2752731 Duffer IO error an dev sda, logical block 117212064, async
>> page read
>>
>> this bug is caused by commit '59db5a931bbe73f ("scsi: megaraid_sas:
>> Handle sequence JBOD map failure at driver level ")' and can be fixed
>> by not set JOB when reset_devices on
>
>Broadcom: Please review.
>
>Thanks!
>
>--
>Martin K. Petersen	Oracle Linux Engineering

We are working on it and will update you at the earliest.

Thanks,
Chandrakanth Patil
