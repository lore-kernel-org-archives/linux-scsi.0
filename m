Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455FBC531DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354712AbjHQTf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354716AbjHQTe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:34:57 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C173583;
        Thu, 17 Aug 2023 12:34:55 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68859ba3a93so142097b3a.1;
        Thu, 17 Aug 2023 12:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692300894; x=1692905694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IkYsqPHeGOcAe37CZg+iCwOxJmQMW/Nix/GR+gPC8m8=;
        b=fQKFNz4FuxbA46PCG7yx07oXAb3QFu77NB2lG2TOYfullMgPzJPdTs+86NQP0kbP1+
         i9/vUIXE2MBJGhe60G5n4Ia7gD8sp5IeytSUKUnToFRk2G8bC5++8cETMtD+h5XMnUXe
         CpupGkIWo5AJdtDDiDtdejIerfbKYNhdqm3jyPsTB6LNQGj2E+PiRN73liYXwmze91P3
         Apvk0ZPHMj5NfwNyR/zNvQQE/42GihKLlPhvrDxJPqePHIgj3yPn1PtPryHXsf5cYC/E
         F6oCNyQTABReMSisYPFTpOmyoq4gfstfoYFdUbfx5ZoApgO0T2KXkRWmw4+8GNrcoxwT
         jrww==
X-Gm-Message-State: AOJu0YzxUjFmUbhsb9DfQxAQsqXvNpS7mV8Hvlxfpe0GlGZF7IsX7mVE
        SDcdganEXuqOtzZM98sMcoQ=
X-Google-Smtp-Source: AGHT+IFeklRJVVmmYbBY8aTEugS8kMUwppcWsIun0xyFNQhnrJsiAAyJMz42lF8lDR8S+wCivnC1zQ==
X-Received: by 2002:a05:6a00:1249:b0:676:20f8:be41 with SMTP id u9-20020a056a00124900b0067620f8be41mr529604pfi.16.1692300894418;
        Thu, 17 Aug 2023 12:34:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id e7-20020a62ee07000000b00689f3ae4ca8sm122959pfi.112.2023.08.17.12.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 12:34:53 -0700 (PDT)
Message-ID: <4f332520-329c-6355-3aa3-cd5e29716a06@acm.org>
Date:   Thu, 17 Aug 2023 12:34:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
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
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-18-bvanassche@acm.org>
 <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 12:00, Bao D. Nguyen wrote:
> In legacy SDB mode with auto-hibernation enabled, the default setting for the
> driver_preserves_write_order = false.
 >
> Using the default setting, it may be missing this check that is part of the ufshcd_auto_hibern8_update()->ufshcd_update_preserves_write_order().

If auto-hibernation is enabled by the host driver, driver_preserves_write_order
is set by the following code in ufshcd_slave_configure():

	q->limits.driver_preserves_write_order =
		!ufshcd_is_auto_hibern8_supported(hba) ||
		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;

Does this answer your question?

Thanks,

Bart.
