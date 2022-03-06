Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E88C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiCFBjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCFBjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:39:33 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AC9F06;
        Sat,  5 Mar 2022 17:38:43 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id e13so10922298plh.3;
        Sat, 05 Mar 2022 17:38:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U9I2rFGB98fZYE4sGu+BT692OTjGlxaTpqRICKy8OEg=;
        b=jm8Gfj1dgCfX1qhZnkNGWsC6+9jnXnZWMhxjcBPakVFmCpgGeoR5FerSBUPv0OJW4W
         8LPWUAbsvRhvS4o5rzNPUoVgpy1vfz3H03Z8U+w9cJ2Cg8G78+w6mtEtT93aZPOtLiSJ
         cki8qcznd5mBZy4DrHhHQRX1kvVxMFMBCkxCREeACe75h3efk11TK8vv98XT+1F58BlG
         /6GlsV2n8Qvb3NaFiJhl6pTW6jdaMktSB85StBOHrItoShNIfQBGHfmymR7PCPk35Nc5
         IWtNDs+ASrKNsB5YT1iLcUBpX8lfT2Op48spgxwRNpnGugqgmDD/DGkwkh3MKVqu/fOp
         nrAg==
X-Gm-Message-State: AOAM5339FhDaW6/8qKdurekdgfjnvcY72+lQh2uEx42fD/QOmszKM4KO
        4rbsixRD6kSMf8rFQ+yGfhA=
X-Google-Smtp-Source: ABdhPJw8RbajLCPyfDXTf0eKFPkTSqQ+v+Vo5XuBfW5yQEVVE5pMdFEI3/3QP6lSL+lcgnk6fcuKyA==
X-Received: by 2002:a17:903:11c9:b0:151:888b:e1f with SMTP id q9-20020a17090311c900b00151888b0e1fmr5739687plh.78.1646530722423;
        Sat, 05 Mar 2022 17:38:42 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id rm8-20020a17090b3ec800b001bb82a67816sm8279848pjb.52.2022.03.05.17.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:38:41 -0800 (PST)
Message-ID: <7ff2340d-892b-94b5-ec39-355a8f8adc73@acm.org>
Date:   Sat, 5 Mar 2022 17:38:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-5-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> +	/*
> +	 * This device is mostly just used to show a bunch of attributes in a
> +	 * weird place.  In doubt don't add any new users, and most importantly
> +	 * don't use if for any actual refcounting.
> +	 */
> +	struct device	disk_dev;

Isn't "weird place" subjective? How about mentioning the sysfs path explicitly 
(/sys/class/scsi_disk/H:C:I:L)? How about explaining why no new sysfs 
attributes should be added to that device instance?

Thanks,

Bart.
