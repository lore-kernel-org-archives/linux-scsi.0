Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1854CCDB483
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 17:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345405AbjJSRxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 13:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345222AbjJSRxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 13:53:39 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A342F121;
        Thu, 19 Oct 2023 10:53:37 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6be0277c05bso15683b3a.0;
        Thu, 19 Oct 2023 10:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738017; x=1698342817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/pnmV4hicLXP/6Ru+XsMab+OgzjO0ZpY/C3JEID8Lk=;
        b=a3BQf6tt925KQlo7fbzgOtqRCoNdxC9JW2gWo4E1V4fSuRGedTbIvurPDdN3lKyEFx
         9i+VhGwppFplfPqFmT+EaMtktYLMeXOhqPyIhn/3FQEF6ik2+XruD8VuCRQGhwpSitIE
         nYj1bpePhLW+IcrhFo1w8p4UGi87P3qHnQhAfGBS0Kp6adPVlnl43hhCiuhlScNtWIva
         2DX4ZQUm/3O7ZEL3Ouj/NfZJiVzT2xAwSC/NltdHi2Ud7dV1ugTwxrNpxrYDWhU09Rdz
         mFPcnhlOOdbhYU3MJvJGbnNBf4Bh/DcFFh5vlvuurZDp+8q0iiDwgwQeWvI8aBw1mQDW
         ZNjQ==
X-Gm-Message-State: AOJu0Yy8OBIadJW6JSU2V2Zl01JT6qUafluTUiVc2ABUS8eBKI6csgOJ
        W8cCWkzJwwd8gDR7Wze9zqdFBYpZtpw=
X-Google-Smtp-Source: AGHT+IGIK+dxGEmGcMusKWzi2UrUW8IZeSWou26+cjjL/7nV/t0KUb1wbvMvyfgsj+b+DBCQ1cjk5w==
X-Received: by 2002:a05:6a20:918f:b0:15e:10e:2cc3 with SMTP id v15-20020a056a20918f00b0015e010e2cc3mr3066450pzd.60.1697738017008;
        Thu, 19 Oct 2023 10:53:37 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3306:3a7f:54e8:2149? ([2620:15c:211:201:3306:3a7f:54e8:2149])
        by smtp.gmail.com with ESMTPSA id 63-20020a17090a09c500b00262eb0d141esm76566pjo.28.2023.10.19.10.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 10:53:36 -0700 (PDT)
Message-ID: <47a5508c-cb80-4398-aa9c-e905be06ad1d@acm.org>
Date:   Thu, 19 Oct 2023 10:53:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/18] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-6-bvanassche@acm.org>
 <9ee7edc0-5edb-4e17-abae-bb7ffcf0f147@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9ee7edc0-5edb-4e17-abae-bb7ffcf0f147@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/18/23 17:24, Damien Le Moal wrote:
> On 10/19/23 02:54, Bart Van Assche wrote:
>> +void scsi_call_prepare_resubmit(struct list_head *done_q)
>> +{
>> +	struct scsi_cmnd *scmd, *next;
>> +
>> +	if (!scsi_needs_preparation(done_q))
>> +		return;
> 
> This function will always go through the list of commands in done_q. That could
> hurt performance for scsi hosts that do not need this prepare resubmit, which I
> think is UFS only for now. So can't we just add a flag or something to avoid that ?

Hi Damien,

The SCSI error handler is only invoked after an RCU grace period has 
expired. The time spent in scsi_needs_preparation() is negligible
compared to an RCU grace period, especially if the
.eh_needs_prepare_resubmit pointers are NULL.

Thanks,

Bart.

