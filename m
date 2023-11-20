Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA84C197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 18:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjKTSsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjKTSsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 13:48:20 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A53C8
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 10:48:17 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cf50cc2f85so18537435ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 10:48:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700506097; x=1701110897;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3gW5sRUixES398BTvDtoT9krn61F3xYwLnsRZ5mMW4=;
        b=t/Bhk4g7YgX2e0m5w60U8ZgOdrHl7xIISSGVYs8gWehWtC6VPSxF4s2n2qGqNXR+S9
         XNwviuahtl77KqaCmZP2lqaaVJtbdbDj2PqTfR96EvTBMe62Z0Nii9Ep7L2esGRqYJ5t
         yrd79RGNxsSLN94yGH4uYxRHgZZYfA/4nJaIjPTnalgORfWFt5lUFbBoNPf4rDelKm4n
         6Fy23kdehJ4vLh4wPXfPp+Elz/LY8KsP1OVyMrxWyR97DLsnGvkkIRA2pHw1wZNaw3tM
         OLOfUSbe5U1gi3wi6J3UTviKwGvYghynkWvO12gj6PrsQwgBYHnw+UVBz/Ar6m4IHrm4
         qOWg==
X-Gm-Message-State: AOJu0YzOt0FucZGsd3hFtsFK+xavfs9eQ8AprChUxHHdybLdF90yPsRL
        naiEIWmPIS+G+qhI5AN3kTGsmuQSOaQ=
X-Google-Smtp-Source: AGHT+IGbd/9zGKzabnWCIGvSETiKw5URFemS6BL2NHl21ef8dA6/Yc4hxhaec8f9qoku0/T6RetA9Q==
X-Received: by 2002:a17:902:9042:b0:1ce:5b6f:49e9 with SMTP id w2-20020a170902904200b001ce5b6f49e9mr8053840plz.3.1700506097037;
        Mon, 20 Nov 2023 10:48:17 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:1f10:3e70:e99:93ed? ([2620:0:1000:8411:1f10:3e70:e99:93ed])
        by smtp.gmail.com with ESMTPSA id t3-20020a1709028c8300b001bc930d4517sm6377331plo.42.2023.11.20.10.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 10:47:49 -0800 (PST)
Message-ID: <f2800c9e-85ad-4c97-b12b-bc2b6ba792ed@acm.org>
Date:   Mon, 20 Nov 2023 10:46:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: make fault-injection dynamically
 configurable per HBA
Content-Language: en-US
To:     Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
References: <20231118124443.1007116-1-akinobu.mita@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231118124443.1007116-1-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/23 04:44, Akinobu Mita wrote:
> The UFS driver has two driver-specific fault injection mechanisms.
> (trigger_eh and timeout)
> Each fault injection configuration can only be specified by a module
> parameter and cannot be reconfigured without reloading the driver.
> Also, each configuration is common to all HBAs.
> 
> This change adds the following subdirectories for each UFS HBA when
> debugfs is enabled.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
