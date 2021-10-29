Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F93C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 16:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E0061040
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 16:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhJ2QSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 12:18:16 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:46949 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhJ2QSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 12:18:14 -0400
Received: by mail-pj1-f51.google.com with SMTP id lx5-20020a17090b4b0500b001a262880e99so7700898pjb.5;
        Fri, 29 Oct 2021 09:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jKXUH2KRwO4V5xMJ+T8M1TeZFj9xrcQY7R7PFnzsrsY=;
        b=OANPD5sxHFUQB/TDEZ+FW3yz8+VZH3+byP6StQ7h2q1gCTWw1z3qSBUxwfwJjJ/VIr
         lVudrMOVk7n4GIPbIUc9XtSDTKfejS7qEIdDUJtvXpGcim5v2TfsHdYWCpL5jwyLNbe2
         e2kMZ3ObzsRq78F/Tz6/9q0OSTiToZzZfVGyTaWcBo1RDk2kFQgeWbwHO+fyBm/QYvTB
         8vFMBCg6zIXk9I3TtZm64YMP7ELt2VonxL6xYMM5V2QI/EX93+dTjSaXVRnYJUfltgL9
         dc8AtR5uvaVyfytvZjT48/ieZF9vtVKl4glqrBLL17Dpxk56TFwsD7dcga6tm9bU27WH
         D1tg==
X-Gm-Message-State: AOAM533/KxIi8ae2giFvYTsCVJNdTMShTMsJSfGoB7pj21g9AVDjkyNa
        s/NEdQ6lVyXgqsrJzhapjz4=
X-Google-Smtp-Source: ABdhPJwmiz+YImWEBzmpCqKfSuiQbDI0Gd4nWkdhrFsTjLBkZ9Q+upPQOIKIxvtxSPGosOf0hyw62g==
X-Received: by 2002:a17:903:248f:b0:141:5a79:ae48 with SMTP id p15-20020a170903248f00b001415a79ae48mr10311651plw.12.1635524145387;
        Fri, 29 Oct 2021 09:15:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7346:8d3b:12d0:7278])
        by smtp.gmail.com with ESMTPSA id a7sm7087948pfo.32.2021.10.29.09.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 09:15:44 -0700 (PDT)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Hannes Reinecke <hare@suse.de>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5edcab45-afc6-3766-cede-f859da2934d1@acm.org>
Date:   Fri, 29 Oct 2021 09:15:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 10:51 PM, Hannes Reinecke wrote:
> Also Keith presented his work on a simple zone-based remapping block device, which included an in-kernel copy offload facility.
> Idea is to lift that as a standalone patch such that we can use it a fallback (ie software) implementation if no other copy offload mechanism is available.

Is a link to the presentation available?

Thanks,

Bart.
