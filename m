Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FF5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 18:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68ABE6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 18:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhHLSUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:20:21 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:45592 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhHLSUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 14:20:20 -0400
Received: by mail-pl1-f179.google.com with SMTP id d17so8317629plr.12
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 11:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69jCmH06MUcs1BCur7IUpaJRZDrnX1fbpOC211ok7/k=;
        b=e99i3+FQEDUp3VfRlicgJZpGbCTEogrDyLPh7PQ1QM4fcDgdeKTcy6NpnreS5fH+Ey
         MulJoyyztg6zfq8KkcwsfE1QQKFQmnuNXlGSC1VAhyfHGgH9aXstg+NPfLqmt7CSjjJJ
         w7372gvA2xVpKPteCdy9OFQa2wMpT5aoItNWIsfWhFc3kRCorHcr8ODGo6qRrQrlNGDT
         UqyqJO/NHZZe/HGrDG3LPTHv9exNdScu77l4m6trZNbUKQbVlZj2zYQOZu4WTubGboK+
         5XBiEXthxWaGfMJtdiyE9e6K7pLBR445tf7435m7Pt3NqI4eHiMdMe/DeJINIFFP6xhp
         W7EQ==
X-Gm-Message-State: AOAM530oUdjcYmBX772ASJJIqlRxLbIr7iDzRNMcCT8tQi9ybCfgGuuH
        hblH2mhtf6KsgVsFNW9GSOnu0b+Bh/Hqyy/Z
X-Google-Smtp-Source: ABdhPJz4aqiavwt6lyBb7IZPDsWDr5B3K0ikEg98IgcyO22H9HkZPDLNVX1bP7ugU0RQ7Vp3oIJ4nA==
X-Received: by 2002:a65:578a:: with SMTP id b10mr5026569pgr.135.1628792394917;
        Thu, 12 Aug 2021 11:19:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:f9eb:d821:2884:27fd])
        by smtp.gmail.com with ESMTPSA id y64sm4677007pgy.32.2021.08.12.11.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 11:19:54 -0700 (PDT)
Subject: Re: [PATCH v5 01/52] core: Introduce the scsi_cmd_to_rq() function
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-2-bvanassche@acm.org> <20210812122818.GD19050@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <715baa9b-2f39-4b1a-2cbb-e5c925cc94fe@acm.org>
Date:   Thu, 12 Aug 2021 11:19:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812122818.GD19050@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/21 5:28 AM, Christoph Hellwig wrote:
> This seems to miss a cover letter and about 40 or your 52 patches.  No
> idea how I am supposed to review it.

Hi Christoph,

Could this be an issue related to the server that supports your email 
inbox? As one can see here, the lore list server received all 53 emails: 
https://lore.kernel.org/linux-scsi/a6563829-2e1e-8117-de45-876004a288ff@acm.org/T/#t

Thanks,

Bart.


