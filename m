Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08F3C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiCFB17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiCFB16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:27:58 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C9F36140;
        Sat,  5 Mar 2022 17:27:08 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id z4so10601022pgh.12;
        Sat, 05 Mar 2022 17:27:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YJDgeDvQhKZ2qOQ8GA2jmea/tZMA9kta3RUKqi1vzVM=;
        b=mwPLDoNOWReFZ7oHQKsGtK6y4lJ8N8T/VZlpzwuX2YTeyUA8sOLipKQpTmjXBKYoH1
         U4oXS7nXdhJnkHzNEO5W8az2vNBY/3gNZIEhY+pKVv1Bs1oOyTQKQgUzqSGoZFqg6YaK
         J7EvL5uPHu+qhpF5N0juy+4MFZrl3Wj5+d3JTxLNAz0Jq3tLGsqMnqNQmijl+Iph7uSi
         2Xtb8e36uOVqMObxs+ec4bhv5IC3soK6O6Iucdp3LhInWeo/yjYTxWSredab/oHiUGxH
         SFFZtaCoXR+zFnGmHfaIB6rAwdyi4HMttQbuEcuMgLJ5XSzFf8ieRCRuEuDvPuzagLpO
         Ub0w==
X-Gm-Message-State: AOAM532KLnWn0J8jFZ9ozgWZX/Y8aReXDxtJvwbHweHmocIUl7W1TkDf
        pIXkNcbl21simVDLikLlBP4=
X-Google-Smtp-Source: ABdhPJx4NhtxfO6D2x0te3vbg2DKE/8f7WqfdL9zKmQdUmp7/QwUdvPdfhHQrvucP79o2SixBwiVlA==
X-Received: by 2002:a63:c144:0:b0:373:d6e7:e78f with SMTP id p4-20020a63c144000000b00373d6e7e78fmr4466247pgi.571.1646530027332;
        Sat, 05 Mar 2022 17:27:07 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm11818490pfl.141.2022.03.05.17.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:27:06 -0800 (PST)
Message-ID: <1b7af902-e9ca-13ce-80b1-2d1d749bdcdd@acm.org>
Date:   Sat, 5 Mar 2022 17:27:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 03/14] scsi: don't use disk->private_data to find the
 scsi_driver
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-4-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> Requiring every ULP to have the scsi_drive as first member of the
> private data is rather fragile and not necessary anyway.  Just use
> the driver hanging off the SCSI device instead.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
