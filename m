Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99C4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 13:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiBVNhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 08:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiBVNhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 08:37:11 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8648D8D
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 05:36:40 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id ci24-20020a17090afc9800b001bc3071f921so2505610pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 05:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=LT7HejzwjBrk3suvkyvTyT0S/5EeRt7U2ag6qdDuIZc=;
        b=z1LSgxt1GDEQGlWEr6CCejdlXi8Dhn4UvyCfTXw7LWNiaYRgkL7ILvocxFxUVY/+F4
         QIQnSToY8u3dxnXZpCSPcn1Wb9zBuGhHuT36yn6uphjuuNU7JPJbhuXRhtQYS23kGpVA
         u6fKrZQByGH1YGln+cOG+NAPdseTCYT/7e09AOvO9TtoMkv8SnCtSauGJfZFIZ7d9WPE
         lizXgvtxXYA/eq3phBkI4GvwmtaTW++tdKVo+/QF84ynvioodjDHcFjXSnpDsOke/Bqz
         FFl2o00qZWPHqflfMx6lxqhckUGnpyxUtCAQqBlcmsCtPYI1oNY1qKXzjU/2r98KkY0O
         ziXA==
X-Gm-Message-State: AOAM531ox79uJSJy/tn1feDwyOiWkzvQwQAs5Ppdx+/DGydP/fBc8VWy
        5UOrXQ8hLb9budZJXDMV8qQ=
X-Google-Smtp-Source: ABdhPJxsy4+eJxDuKwA6r50FsH++l4njAGmfGvkULkCMoVdbq9ljOSzLoPWPIpP3hNAs5LLtngwIBQ==
X-Received: by 2002:a17:902:7207:b0:14d:938e:a88e with SMTP id ba7-20020a170902720700b0014d938ea88emr22973069plb.42.1645537000042;
        Tue, 22 Feb 2022 05:36:40 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g1sm15628074pfu.32.2022.02.22.05.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 05:36:39 -0800 (PST)
Message-ID: <ccd1f277-f9f8-cb4a-980e-6f9450f4e145@acm.org>
Date:   Tue, 22 Feb 2022 05:36:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC v1 0/5] Add SCSI per device tagsets
To:     "Melanie Plageman (Microsoft)" <melanieplageman@gmail.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20220218184157.176457-1-melanieplageman@gmail.com>
Content-Language: en-US
In-Reply-To: <20220218184157.176457-1-melanieplageman@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/22 10:41, Melanie Plageman (Microsoft) wrote:
> Currently a single blk_mq_tag_set is associated with a Scsi_Host. When SCSI
> controllers are limited, attaching multiple devices to the same controller is
> required. In cloud environments with relatively high latency persistent storage,
> requiring all devices on a controller to share a single blk_mq_tag_set
> negatively impacts performance.
> 
> For example: a device provisioned with high IOPS and BW limits on the same
> controller as a smaller and slower device can starve the slower device of tags.
> This is especially noticeable when the slower device's workload has low I/O
> depth tasks.

The Cc-list for this patch series is way too long. Cc-ing linux-scsi and
the most active SCSI contributors would have been sufficient.

Is the reported behavior reproducible with an upstream Linux kernel? I'm
asking this because I think that the following block layer code should
prevent the reported starvation:

/*
  * For shared tag users, we track the number of currently active users
  * and attempt to provide a fair share of the tag depth for each of them.
  */
static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
				  struct sbitmap_queue *bt)
{
	unsigned int depth, users;

	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
		return true;

	/*
	 * Don't try dividing an ant
	 */
	if (bt->sb.depth == 1)
		return true;

	if (blk_mq_is_shared_tags(hctx->flags)) {
		struct request_queue *q = hctx->queue;

		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
			return true;
	} else {
		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
			return true;
	}

	users = atomic_read(&hctx->tags->active_queues);

	if (!users)
		return true;

	/*
	 * Allow at least some tags
	 */
	depth = max((bt->sb.depth + users - 1) / users, 4U);
	return __blk_mq_active_requests(hctx) < depth;
}

Bart.
