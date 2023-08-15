Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599D6C41513
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 15:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbjHOPmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbjHOPly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 11:41:54 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CFCE61;
        Tue, 15 Aug 2023 08:41:53 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bbc87ded50so33781295ad.1;
        Tue, 15 Aug 2023 08:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692114113; x=1692718913;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYx8/ZuGx8lkcy0N8m/2/xObBqot7iWm0DNawtdKEIQ=;
        b=JNBE7dH5BH6419W/jNNrmTF1s4NahnEeNKSMfYC99D5C4+Q/iFJ039zISoBUINGX8u
         N/ErDRTpmuWzlV0VOBR6GEOjWJgmKq6b5IJUoigH9bUx3cq3EfCKpTN+lZrq7iFsx++1
         v1DCMAC+YiIZdpV+uWxxDAzuCQkxegTGNRHR6BiUGKYhJSy7X6zAajnKa3IUqHXMJPKa
         kv6GdVhDOWpVEU+N5oIYaXnG6o9FeehzERoXIR6fSEPy3vLE9gL2/H/Nb85RpKQC2LpX
         Xl9pncWc9sMEDl+APfXMuvySDVTm9HGJSjES3FBXoBCAN6QaVsMp7gCp4ZyF7aF9DFBl
         BLRA==
X-Gm-Message-State: AOJu0YwpcZyt5ZeF8WkBRHmNzMkjiUAHiUyRMXH9O2T+im9xlT7DSLdW
        /K239l3CvmFLA1knDot+C/nvCdBXgXc=
X-Google-Smtp-Source: AGHT+IGfQIPurCfExSVAHEGBEHGbEI1D876oxVZ5c3Cry6fSkqo8tfAPKHwuypj+T7VzA+lbQHwOOQ==
X-Received: by 2002:a17:902:f7d2:b0:1b3:b3c5:1d1f with SMTP id h18-20020a170902f7d200b001b3b3c51d1fmr10470950plw.8.1692114113091;
        Tue, 15 Aug 2023 08:41:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a40d:28ad:b5b9:2ae2? ([2620:15c:211:201:a40d:28ad:b5b9:2ae2])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001b87bedcc6fsm11211946plg.93.2023.08.15.08.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 08:41:51 -0700 (PDT)
Message-ID: <b15e238f-f900-ec99-f718-925a08b590b8@acm.org>
Date:   Tue, 15 Aug 2023 08:41:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v8 9/9] scsi: ufs: Inform the block layer about write
 ordering
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-10-bvanassche@acm.org>
 <668f296c-48f3-02ef-5ac1-30131579ea8d@quicinc.com>
 <4b3d0fa7-cccb-b206-e48a-c5ee48560ea4@acm.org>
 <1c6dfd06-088d-7b3a-af01-b8c553f9fa18@quicinc.com>
Content-Language: en-US
In-Reply-To: <1c6dfd06-088d-7b3a-af01-b8c553f9fa18@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 20:20, Bao D. Nguyen wrote:
> How about this?
> - Make ufshcd_auto_hibern8_enable() a static function. It should not >   be called from the vendor drivers.
> - Mandate that vendor drivers must only update auto-hibernation >   settings via the ufshcd_auto_hibern8_update() api. This function 
is>   already exported, so only need to update the function comment to> 
  make it clear (updating the hba->ahit alone may result in abnormal
>   behavior).

That sounds good to me. I will look into implementing the above proposal.

Thanks,

Bart.
