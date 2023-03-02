Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB429C678D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 18:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCBS02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 13:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjCBS01 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 13:26:27 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E434E5CA;
        Thu,  2 Mar 2023 10:26:26 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id i3so187673plg.6;
        Thu, 02 Mar 2023 10:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+txZTEiibZ+nqdSC1qRUdvlCmIk4PHdIvIM4/ficDNI=;
        b=0Ol6/8gB1we9n9pwslc4vykYxw3hk1V4WI5CbNlhwDQ2iQ8NnBZtMcIjt58UCQIm3/
         QiaOCrfjnTn2GDXk8yVtK1/iy+AbYEfcuOwIQdC/YwxbtdLBVCJ3of0zH0DxnNiqwr8b
         TwtnF9ZVso+Iaas5LWhBxkfxf4NofHHqPp5S0mT38s4iWk99Ij8MQkfpS9QRcELC7WaJ
         wvXzTpb+oteytqPEv7o4dTRfL1a+f/KX3ltssZLpNLO/fqK1SoPe9nLxNk+WnCakMu57
         guipK3jLCJ+IyrCQ1v35OrTVCaNgOgMkl/uxFNF+wUN0N+9toZG49fdoMlxET9sJvDdx
         DXSQ==
X-Gm-Message-State: AO0yUKWt34ck5caQTNJJxBlBX+wPQpkDOxgbdUZX0KatuU83/QftXEqe
        0nTZIFLwMl826xtor3bfXM0=
X-Google-Smtp-Source: AK7set88FRm0x2uOaOlcVOx+geu8dwUp27SFZ97PN1xu1vKTOvUOVw22OH1pjNS506n6T9L2Mx/IZg==
X-Received: by 2002:a17:90b:1d0e:b0:237:9858:ebbf with SMTP id on14-20020a17090b1d0e00b002379858ebbfmr12532938pjb.30.1677781585800;
        Thu, 02 Mar 2023 10:26:25 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:ee04:e3cd:c905:c9ed? ([2620:15c:211:201:ee04:e3cd:c905:c9ed])
        by smtp.gmail.com with ESMTPSA id w20-20020a17090aea1400b00233e7f0e7dfsm2009558pjy.4.2023.03.02.10.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 10:26:25 -0800 (PST)
Message-ID: <c719261e-203e-18f2-b72a-de0c64011efe@acm.org>
Date:   Thu, 2 Mar 2023 10:26:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
 <ad8b054a-26a5-ea60-9c66-4a6b63ca27ef@acm.org>
 <54fb85ac-7c45-f77f-11d7-9cb072f702fb@opensource.wdc.com>
 <569dc9d2-3e6c-0efc-560c-bfcacfbfbda7@acm.org>
 <8e3643a5-80bd-8c02-8e83-a2c1341babcc@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8e3643a5-80bd-8c02-8e83-a2c1341babcc@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/23 18:03, Damien Le Moal wrote:
> But that is the issue: zones in the middle of each domain can be
> activated/deactivated dynamically using zone activate command. So there is
> always the possibility of ending up with a swiss cheese lun, full of hole of
> unusable LBAs because the other domains (other LUN) activated some zones which
> deactivate the equivalent zone(s) in the other domain.
> 
> With your idea, the 2 luns would not be independent as they both would be using
> LBAs are mapped against a single set of physical blocks. Zone activate command
> allows controlling which domains has the mapping active. So activating a zone in
> one domains results in the zone[s] using the same mapping in the other domain to
> be deactivated.

Hi Damien,

Your reply made me realize that I should have provided more information. 
What I'm proposing is the following:
* Do not use any of the domains & realms features from ZBC-2.
* Do not make any zones visible to the host before configuration of the 
logical units has finished. Only make the logical units visible to the 
host after configuration of the logical units has finished. Do not 
support reconfiguration of the logical units while these are in use by 
the host.
* Only support active zones. Do not support inactive zones.
* Introduce a new mechanism for configuring the logical units.

This is not a new idea. The approach described above is already 
supported since considerable time by UFS devices. The provisioning 
mechanism supported by UFS devices is defined in the UFS standard and is 
not based on SCSI commands.

Bart.

