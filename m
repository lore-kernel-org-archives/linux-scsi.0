Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571E9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 17:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbhK3R4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:56:00 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:45862 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbhK3Rz7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 12:55:59 -0500
Received: by mail-pl1-f182.google.com with SMTP id b11so15513430pld.12
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 09:52:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s9ztF7FD6BAYC6ys44ANvklLDM5qp3YyltYhzfKfXIE=;
        b=s7mocFr0ShIdXVlUuqq0L3mM133WzLdIHvMsVflCALgV52I9RYkVtNAtOkUVf9f4Lg
         vYzaCOGQl/Pl96n1/u5DGjoJ9QY90rE2Hkz4mXfJSC7xCyG9lGIzhrHl8cyh6WIuKGff
         VREXeO57JFYeU1R0nBqRch74LXG6FTd12wMSFd37oPaTSPU4/h2A9BSXdN+Guxmn+EKr
         jY4BnOssvxFsqUrmUIVR+NaHRa9xgrdLJesvJLBtDqsXLBMPd4dDiymF8wShMUCRLRDy
         0wfZNzqh6PcVzMh6sHEK74MH83fsP/Xl75LHFyQlElWCiGgDaB9wy79LtU3Te8dqpfk/
         U6pA==
X-Gm-Message-State: AOAM530saEYdglXkwV9dL/SMMCh1+uOpFsRDudwXNnTf0Czyu+fOwSzo
        hT4IhSl7ZTcfD6rBa5HUUZY=
X-Google-Smtp-Source: ABdhPJy1kM20ipq2rIIYmBX1I0A1D1C4h9EWfFWBVmNWQx2cLWqByG5M+iwQrbTpDV0sO5VAh2aYrQ==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr480678pjb.211.1638294760280;
        Tue, 30 Nov 2021 09:52:40 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id ip5sm3783950pjb.5.2021.11.30.09.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:52:39 -0800 (PST)
Subject: Re: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-14-bvanassche@acm.org>
 <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f63e8d59-1b2a-23a5-3083-f6bb3b4e8d76@acm.org>
Date:   Tue, 30 Nov 2021 09:52:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 12:54 AM, Bean Huo wrote:
> The concern of this patch is that it reduces the UFS data transmission
> queue depth. The cost is a bit high. We are looking for alternative
> methods: for example, to fix this problem from the SCSI layer;
> Add a new dedicated hardware device management queue on the UFS device
> side.

Are any performance numbers available? My performance measurements did not
report a significant difference between the 31 and 32 queue depths.

Thanks,

Bart.
