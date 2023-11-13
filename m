Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21745C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 18:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjKMSwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 13:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjKMSwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 13:52:22 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1A310F4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 10:52:19 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cc37fb1310so35008005ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 10:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699901538; x=1700506338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EB+GHaPUiNYr7wZHS7gcy/pnCWVG1PC7BTiM8N4ahZc=;
        b=milY4X6NGOP0T64R3o3hzBxN4Qp/iTTVoWfBelg08q25c9NgshznabaLkv7d/JUQbT
         1+SeR8blA6T3mK+ZgECpw6UDgBeUwxpxShFJzjAjNxtzYzYY8Uz5WWx8paFuirrvQZuQ
         AOYmiBRITO9S/C+QCmMVPthyy5hTnDg2xx/1oa1nCT0bGxPuw10PeMKLoq01drZsdOPy
         wscRJfyMYHCHlhiV7EM0vYPUG6WuqKyb52bInh+NG4hPJp7nPa3GrnuuArYnzrqUWZ7j
         7Xjd77ntYxw6ZzwQpG7XcVq1ucHvsWIouA9YlrwuAtwC/PQv7oyHGdj5CfREPTysHjye
         7tfw==
X-Gm-Message-State: AOJu0YzO6ll3hOrMpuqowJ9+AKzns6J0w6Tcb7oYebWbtGNkJQnb1vaK
        eqntrWs6U8Zz1YitxDj+rQs=
X-Google-Smtp-Source: AGHT+IHdSLtltL1NodaqD3gGr1uy6PRjBsZ0aKvxdxdLhgopv+zOPFEhoxqJhAVD9Y09QFQzo9MzEg==
X-Received: by 2002:a17:902:cec1:b0:1cc:3357:2ee8 with SMTP id d1-20020a170902cec100b001cc33572ee8mr81805plg.25.1699901538375;
        Mon, 13 Nov 2023 10:52:18 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:7575:f839:a613:3f5b? ([2620:0:1000:8411:7575:f839:a613:3f5b])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902d3cc00b001c74df14e6fsm4316660plb.284.2023.11.13.10.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 10:52:17 -0800 (PST)
Message-ID: <5268cb26-227a-46fa-8200-563da3b02cc3@acm.org>
Date:   Mon, 13 Nov 2023 10:52:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] write_cache sysfs file broken for WCE setting
Content-Language: en-US
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk
References: <CAGnHSE=pipa-zi-kxWyPoow0wU04-N_eUopOaZWFftTsfLjEQQ@mail.gmail.com>
 <CAGnHSEk3bARZ=ed4D62mv=n-nQRoiPteCLZPdMhrW_O5ntzfCA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGnHSEk3bARZ=ed4D62mv=n-nQRoiPteCLZPdMhrW_O5ntzfCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/23 10:27, Tom Yan wrote:
> So I realized that I mixed up the queue write_cache and the sd
> cache_type sysfs files. cache_type is working fine.
> 
> But then I noticed that in commit
> 43c9835b144c7ce29efe142d662529662a9eb376, you define QUEUE_FLAG_HW_WC
> as 18, which is also the value of QUEUE_FLAG_FUA. Was it intentional?
> If so, what's the reason behind it?

Does the untested patch below help?

Thanks,

Bart.

[PATCH] block: Make sure that all queue flags have a different value

Queue flags QUEUE_FLAG_HW_WC has the same numerical value as
QUEUE_FLAG_FUA. Fix this by changing the QUEUE_FLAG_HW_WC definition.

Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Tom Yan <tom.ty89@gmail.com>
Fixes: 43c9835b144c ("block: don't allow enabling a cache on devices that don't support it")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  include/linux/blkdev.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eef450f25982..f59fcd5b499a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -538,7 +538,7 @@ struct request_queue {
  #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
  #define QUEUE_FLAG_SYNCHRONOUS	11	/* always completes in submit context */
  #define QUEUE_FLAG_SAME_FORCE	12	/* force complete on same CPU */
-#define QUEUE_FLAG_HW_WC	18	/* Write back caching supported */
+#define QUEUE_FLAG_HW_WC	13	/* Write back caching supported */
  #define QUEUE_FLAG_INIT_DONE	14	/* queue is initialized */
  #define QUEUE_FLAG_STABLE_WRITES 15	/* don't modify blks until WB is done */
  #define QUEUE_FLAG_POLL		16	/* IO polling enabled if set */

