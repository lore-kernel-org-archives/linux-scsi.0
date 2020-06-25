Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A96BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F46A20768
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ea3gxSWi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407812AbgFYXZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406798AbgFYXZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 19:25:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC6BC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:25:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so650607pje.0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=c+/EjVBEZVp/y7wbiiS6Pl5a7KIYfdvdYemdOyEbkUY=;
        b=Ea3gxSWidXT1+YBvWlsgj3hYKOtGYlzF5LWC0KUl89s9c7Y6T6gfH/CraZK+77vRsJ
         xFt3uOV8GL573yPwgr/dfwAs/KYIt3kbLTtkgwbGoAHYKqOjAiTx9HQ44drNgzVfgXEW
         6vrjsQUrqVH4HVXePYcfjEr7BGs8dpB8xpOGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=c+/EjVBEZVp/y7wbiiS6Pl5a7KIYfdvdYemdOyEbkUY=;
        b=H0fza+GN0YmXmMJYDny7AlyqIGwfLn0z8Aq0lYNuXAcjochScF3TPfbyPr00tj8M0E
         70NGSVzn40lGDFB9COLLz+ipw6Jk+9hb5xrhwxopsCz87lMtO9OL8J9q8FtwyM2em46Z
         lrWqopOLtJ/MB8FGmiHGE/NuzW5+OuaWyC9ScFzQQJn5uPA5Lb0i4OyFMq+MaygpPfNk
         NMGwNqBcfEklCVBW+X7oqhF0MAm9r3Qc0/MnZ5LQMPgDrVP/nNoOheyd+OmSTRRjEZC6
         7ZCpXK0JDq4WkeKfOyquonnWCjTf0NZ72xkFPMOKjsFgFk14jWx3XRsZHfdcVX8Ba8Bs
         rVnQ==
X-Gm-Message-State: AOAM533ZxDqSCDgxD66s6ha65Yf5gFcxjpfYaf5pqduP5AvioONaSRlX
        jqpFXPwcA9oPppam/SKRIQxHBQ==
X-Google-Smtp-Source: ABdhPJyqVcldJ/zsxbzk1VeKH8M69zfK6PbbT6sDqh/dIDYF84GH7YDnkYxdcHTba60KNsZ84POUrA==
X-Received: by 2002:a17:902:10e:: with SMTP id 14mr157020plb.213.1593127534159;
        Thu, 25 Jun 2020 16:25:34 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 21sm4765460pfu.124.2020.06.25.16.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 16:25:33 -0700 (PDT)
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Shyam Sundar <ssundar@marvell.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
 <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com>
 <CA+ihqdiA7AN05k5MjPG=o8_pf=L-La6UigY4t0emKgJMXm=hnQ@mail.gmail.com>
 <BYAPR18MB2805AEA357302FCFA20D2B57B48F0@BYAPR18MB2805.namprd18.prod.outlook.com>
 <351333B3-F666-420F-A9D3-DB86D2617156@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <7c33c4fb-d3ec-cd2e-4de3-ecb95ffec8b8@broadcom.com>
Date:   Thu, 25 Jun 2020 16:25:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <351333B3-F666-420F-A9D3-DB86D2617156@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/11/2020 10:42 AM, Shyam Sundar wrote:
> Seems like this (and a previous email) never made it to the reflector, resending.
>
> The suggestions make sense to me, and I have made most of the recommended changes.
> I was looking for some guidance on placements of the sim stats structures.
>
>> On May 29, 2020, at 11:53 AM, Shyam Sundar <ssundar@marvell.com> wrote:
>>
>> James,
>>       I was thinking of adding a structures for tracking the target FPIN stats.
>>
>> struct fc_rport_statistics {
>> uint32_t link_failure_count;
>> uint32_t loss_of_sync_count;
>> ....
>> }
>>
>> under fc_rport:
>>
>> struct fc_rport {
>>
>> /* Private (Transport-managed) Attributes */
>> struct fc_rport_statistics;
>>
>>       For host FPIN stats (essentially the alarm & warning), was not sure if I should add them to the fc_host_statistics or
>> define a new structure under the Private Attributes section within the fc_host_attrs/fc_vport.

my initial thought was the same

>>
>>       In theory, given that the host stats could be updated both via signals and FPIN, one could argue that it would make sense
>> to maintain it with the current host statistics, but keeping it confined to transport will ensure we have a uniform way of handling
>> congestion and peer congestion events.

but then I have the same thoughts as well. And the commonization of the 
parsing and incrementing makes a lot more sense.

>>
>>      Would appreciate your thoughts there.
>>
>> Thanks
>> Shyam
>>     
>>


I would put them under the Dynamic attributes area in fc_host_attrs and 
fc_rport.
fc_host_attrs:
fpin_cn              incremented for each Congestion Notify FPIN
cn_sig_warn     incremented for each congestion warning signal
cn_sig_alarm    incremented for each congestion alarm signal
fpin_dn             incremented for each Delivery Notification FPIN 
where attached wwpn is local port
fpin_li                incremented for each Link Integrity FPIN where 
attached wwpn is local port

fc_rport:
fpin_dn             incremented for each Delivery Notification FPIN 
where attached wwpn is the rport
fpin_li               incremented for each Link Integrity FPIN where 
attached wwpn is the rport
fpin_pcn           incremented for each Peer Congestion Notify FPIN 
where attached wwpn is the rport

For the cn_sig_xxx values, the driver would just increment them.
For the fpin_xxx values - we'll augment the fc_host_fpin_rcv routine to 
parse the fpin and increment the fc_host or fc_rport counter.

-- james


