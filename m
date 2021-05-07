Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DEEC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 03:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DC6613E8
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 03:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhEGDgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 23:36:25 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:43986 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhEGDgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 23:36:24 -0400
Received: by mail-pj1-f47.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so4631875pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 May 2021 20:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S82EZ1nFonLFiKnSLeneaY5i0EpRGKQ2NXnMG1Pc4t4=;
        b=Yk33gr7OdMUIxCW9x1GiJvuRKY2Y3cVJ91/8uLbHLSZ/xJhbATrYiZCJv84/DZFE+Z
         a1yhE/IkpVLZe1sElu4N6jqzNHmK4tKSzzCksJNEed1M1H/2vBmC+jhMcWcItbLn4v6A
         lKw+QjHWaPwRyer++tdbsFBVGgBctIjzZ0UtFEVqV1q7RuRqa2ACouo3R1O57ugH6Aqm
         NkeeWiwYG9hIbxXideXBi45AH1/YNbvJM5TAwm0DlcGbOYGUAUjhwsuVIVTZ1w5OU3f9
         vYdJ7WU2X9MZzKgQPoDFPb+07lE2nvdZ19kD4qeXd5o9I9kuq4skDnaqYyDoLWsIDwkF
         taqQ==
X-Gm-Message-State: AOAM530nSz4VFXKZcnf9evq7KTKUoplVXR4Zkw1Lf0X/i9cJ+k6sfaGE
        hTuY8cOzl6AZ+EPK8TdGct4=
X-Google-Smtp-Source: ABdhPJx3XOTyS4ShvV9gA8evgPgKYU3yF6HhN5kgriYEubG9pPziI/RBcE8IRecJ6mgVaLtCyY1DWg==
X-Received: by 2002:a17:90a:a604:: with SMTP id c4mr21849001pjq.81.1620358525286;
        Thu, 06 May 2021 20:35:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5aec:6a45:557b:c859? ([2601:647:4000:d7:5aec:6a45:557b:c859])
        by smtp.gmail.com with ESMTPSA id a18sm3236370pgg.51.2021.05.06.20.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 20:35:24 -0700 (PDT)
Subject: Re: [PATCH 102/117] ufs: Convert to the scsi_status union
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>, Yue Hu <huyue2@yulong.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-12-bvanassche@acm.org>
 <aa572642ad49f5c3642b026b97e8a58d@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a27ca7e4-ba70-9ea7-1871-c11962dac520@acm.org>
Date:   Thu, 6 May 2021 20:35:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <aa572642ad49f5c3642b026b97e8a58d@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/6/21 5:09 PM, Can Guo wrote:
> Thanks for the change, do you miss ufshcd_send_request_sense()?

Hi Can,

That's a good question. I can change the type of the
ufshcd_send_request_sense() return value but I'm not sure whether it's
worth it since that function only has one caller and that caller does
not care about the subcomponents of the SCSI status value. All it cares
about is whether or not ufshcd_send_request_sense() returns 0.

Thanks,

Bart.
