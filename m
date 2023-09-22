Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1FECD4844
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 16:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjIVQmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjIVQmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 12:42:16 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EED9122;
        Fri, 22 Sep 2023 09:42:10 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c5cd27b1acso20636765ad.2;
        Fri, 22 Sep 2023 09:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400930; x=1696005730;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4MrrEIeCKU4oem/iikvYQNvrRwn615ysBhzFPLSRX0=;
        b=wSAGv7jHKhyg0BzhSLFcUnOo2VZc5Zgjt8U4AuB19VWKK4OXgoyLk4DVBRP+fRcLk5
         pWeYco8zmwz6+uKdfPveC8/PI/CFMKMsjGl3D+3QZJ3cxLWOwrn3vLWvrWuu6Toc4Aem
         QDodN+OZpjHf3zqzOgoZTIWQqjTQ1nzDYvcj7DihTiPGAEn0RMCV1+CfoQLHKVQZq+Rp
         v5h3bUcB0XuSdZwMq66R9mZ2D7JFs4bVzEMcdR98X5l8IuRIgXZ4cabZtBFckAAK37dH
         rVClmdBWGD566+7tqTaJPqCiAhGWcfa/Q5ALxAvLBxBT0KOZ+ln6jF3k2n7LVQgIHOlf
         o36w==
X-Gm-Message-State: AOJu0YwT45Sc8ckpQj+yQDGMF9I0+Y9b+sezsD6ROGsmfZQhJkQcrqEb
        oDW+w+hPvBoUk7754FHZFh8=
X-Google-Smtp-Source: AGHT+IHqZ2wfa/pSXxIa3x5k+rQFvBxChJZLZQjHFSn8F7MTmikNFDUAJNbjFdyhCC968c5xtyjI2w==
X-Received: by 2002:a17:902:f682:b0:1c3:9aaf:97be with SMTP id l2-20020a170902f68200b001c39aaf97bemr8688plg.56.1695400929815;
        Fri, 22 Sep 2023 09:42:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:70e9:c86f:4352:fcc? ([2620:15c:211:201:70e9:c86f:4352:fcc])
        by smtp.gmail.com with ESMTPSA id c20-20020a170902c1d400b001b03a1a3151sm3718252plc.70.2023.09.22.09.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 09:42:09 -0700 (PDT)
Message-ID: <841c0cf2-48f6-4a3c-a991-aaa5a737a9af@acm.org>
Date:   Fri, 22 Sep 2023 09:42:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
Content-Language: en-US
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org, rpearsonhpe@gmail.com,
        matsuda-daisuke@fujitsu.com, shinichiro.kawasaki@wdc.com,
        linux-scsi@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230922163231.2237811-1-yanjun.zhu@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230922163231.2237811-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 09:32, Zhu Yanjun wrote:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> This reverts commit 9b4b7c1f9f54120940e243251e2b1407767b3381.
> 
> This commit replaces tasklet with workqueue. But this results
> in occasionally pocess hang at the blktests test case srp/002.
> After the discussion in the link[1], this commit is reverted.
> 
> Link: https://lore.kernel.org/linux-rdma/e8b76fae-780a-470e-8ec4-c6b650793d10@leemhuis.info/T/#t [1]
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> CC: rpearsonhpe@gmail.com
> CC: matsuda-daisuke@fujitsu.com
> CC: bvanassche@acm.org
> CC: shinichiro.kawasaki@wdc.com

Shouldn't the Cc-list occur before the Signed-off-by tag? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
