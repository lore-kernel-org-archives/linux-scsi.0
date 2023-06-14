Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E0BEB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 18:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjFNSkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 14:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbjFNSkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 14:40:07 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582911BF7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 11:40:05 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b3a6469623so29124535ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 11:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686768004; x=1689360004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nO82OBnKtHFm6HAxjmmrK3kMSNljBsYANGI1frzP6uo=;
        b=KerWtghZDrf7ZUQt7clNEwj1+6HxoZ1UYXBQQDgb/9IQjIeA2/hVT2D5MmuuewFaSY
         G0fwRIBNRwWqib1SZUuRJFEdlKoyrCsDHRUl6umV/F0Xh7GEBNKAri3Ho4oZQJVXMVV5
         4KO7O+j3lWF4j3ESBydb52mrLjHIzE6EsVjcXCYbV8hQVQ2sfjsign/vsRXjBOpXSK/L
         3Re4MGZQhIPECX5gqYh+Y2tKxvZZtnwy6rH1Q4sXIgUxyHhSmk3SjGGvZftvCIhxCB/M
         1fH+iZwF0LHnggz9MnJdHgGwCxty0pu8S1bTMaOkwYLd2yCq6uK0i0jQBBySiVfzvIwQ
         K9Fg==
X-Gm-Message-State: AC+VfDwazs/50IvQZE19D11oegcEG5Lckfjt1THSPkxH9A22ddyocUoE
        TWKmIb2CLGHgbGM8Di77DWI=
X-Google-Smtp-Source: ACHHUZ7Xovu85Dy5DqQZyVnhVpS0AL2hxPSNiJF9h+WGb7o3qSlvNFyqdw3NLQrbXjE91+kJ1MZrZw==
X-Received: by 2002:a17:902:ed8b:b0:1b3:c7c1:8ded with SMTP id e11-20020a170902ed8b00b001b3c7c18dedmr8030307plj.27.1686768004609;
        Wed, 14 Jun 2023 11:40:04 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b001a80ad9c599sm2154699plg.294.2023.06.14.11.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 11:40:04 -0700 (PDT)
Message-ID: <f12734bc-ea43-288a-33f3-f9735a06daa7@acm.org>
Date:   Wed, 14 Jun 2023 11:40:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
References: <20230613170327.61186-1-adrian.hunter@intel.com>
 <c3b42f98-31f8-39f4-4540-cccf0bfe31cd@acm.org>
 <f7e5a3d9-3caa-e75d-5069-3763d3ca8951@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f7e5a3d9-3caa-e75d-5069-3763d3ca8951@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/23 21:54, Adrian Hunter wrote:
> On 13/06/23 21:22, Bart Van Assche wrote:
>> On 6/13/23 10:03, Adrian Hunter wrote:
>>> Add PCI ID to support Intel Arrow Lake, same as MTL.
>>
>> The patch looks good to me but the "same as MTL" text in the patch description looks confusing to me?
> 
> The code change is using the same driver data as MTL: [ ... ]

Information about whether only the MTL code is reused or whether the UFS 
controller is identical to the MTL UFS controller would be welcome. 
Anyway, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
