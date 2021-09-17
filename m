Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE2EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 16:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E5F61212
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 16:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhIQQK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 12:10:29 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:44666 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhIQQK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 12:10:28 -0400
Received: by mail-pf1-f174.google.com with SMTP id b7so9585397pfo.11
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 09:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JD4Mwf7iD3Br9BSFHUr338UHcGfpPzdal76Z0srIK3w=;
        b=3YSfDrG8l1LSj9DVlwx9O+piuS84I0MH6/lZ3KvLS6Yu2o8PjYRoVFOX0wrX7f76W0
         gsNvGFM2+td91n/pL3DtGqexGyWsCi18kQ/LS3m7YW277TlwUDY2tXdiY3tnuc/53zqY
         CH9ia1Q59N/wvBfb9YzkzuT96BVuiSQ1drnS6fyDmuyZRCEVnS9aO4prDMFvIWrh5pJN
         Uz5F1JWqg5+2a0y/pXe5ZnZ8v3q/aenhw6TANcIBOsWGdZg1GbCqpSleNVEHCsHgkcaI
         7w7oJwQmCQJ934Z5AnIINDppDtz9dJrmOWyQvl6cIFGLJ3JtCq14Rqs6p2QwXiBI0pF0
         sYHg==
X-Gm-Message-State: AOAM533XiYbMM7VdUe8EG8kSfpnKJ3nRscYRXWA2kZJSbcroxTyrS661
        0q9WXCOY4ZriAlqCOI5W+msRfmZAfR4=
X-Google-Smtp-Source: ABdhPJwktDsZ9OpdJVKcuUcjyGdH6oDgfZ2pn0kqyPQ5IyBgcn4DysZfyKSQG9MztMe634wtBWu5yg==
X-Received: by 2002:a62:1717:0:b0:440:527f:6664 with SMTP id 23-20020a621717000000b00440527f6664mr10213332pfx.73.1631894945376;
        Fri, 17 Sep 2021 09:09:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id v64sm1683560pfv.19.2021.09.17.09.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 09:09:04 -0700 (PDT)
Subject: Re: [PATCH V4 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210916170211.8564-1-adrian.hunter@intel.com>
 <20210916170211.8564-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8a3ab601-81c4-8386-b7c8-5bea2ed99002@acm.org>
Date:   Fri, 17 Sep 2021 09:09:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916170211.8564-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/21 10:02 AM, Adrian Hunter wrote:
> -static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
> +static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
>   {
[ ... ]
> +	/* The command queue cannot be frozen */
> +	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);

hba->cmd_queue shares a tag set with the request queues associated with SCSI
LUNs. Since this blk_get_request() call happens from the context of the error
handler before SCSI requests are unblocked, it will hang if all tags are
in use for SCSI requests before the error handler starts.

Bart.
