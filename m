Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB3EC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 23:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C4B214D8
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 23:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKGXKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 18:10:07 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38162 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfKGXKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 18:10:07 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so3474531pfp.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 15:10:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kd9pBv698EC6jI0gkdbUOtcTmBRR4iLmrkou3uqZHio=;
        b=NoxpyWW43IN5RUS+xB/uh+6WVsspekfFhq+UL8EGVxVLTLlEQsGDrjE+ebwuBV7fKz
         iKiJJYD9wcSEeRYH9U1yhFwxIMYzBB0ZTsbrdICoChwBV9SVSFlOA64urqlyGJVR2OEM
         Ylm1Vb7d1iIm3YUQ4Tga6GskRhLlGlSnsMXpUpivTkDpcdsPD8/GXh2R/IZbIsL+ezRV
         kG5818l8iiDm/iOaT51iplNUD5BVq2E2lF+fP9VYHWWldNzNOsGgbyoRDcbUguBXzX8r
         Q5Wxm3ksX6xUH7ZZODt86TmAsXDHCgUrL+UuSlVCmIaQD5d/Jw6vEG89SA0cwH7jd03Y
         oTBQ==
X-Gm-Message-State: APjAAAXKWi9Et3DwNTuUwWZ8X0LDYj3M6P6ld6RprvIvpTWvY3dfyxMb
        jZreM/RTbc+Xyzl/LdodQac=
X-Google-Smtp-Source: APXvYqzH59aFg7vTI64NU2Zi1Qw4BCSToYkBOWS2MZemTCwu7fJIgcAA1aJzVueQ+MZmUtUL1ZjfXg==
X-Received: by 2002:a62:e306:: with SMTP id g6mr7694077pfh.32.1573168204871;
        Thu, 07 Nov 2019 15:10:04 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k9sm4270656pfk.72.2019.11.07.15.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 15:10:04 -0800 (PST)
Subject: Re: [PATCH v2 2/2] scsi: qla2xxx: don't use zero for
 FC4_PRIORITY_NVME
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        David Bond <DBond@suse.com>
References: <20191107224839.32417-1-martin.wilck@suse.com>
 <20191107224839.32417-3-martin.wilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b6c01b11-bd01-6462-a91a-98373706ebf8@acm.org>
Date:   Thu, 7 Nov 2019 15:10:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107224839.32417-3-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 2:48 PM, Martin Wilck wrote:
> Avoid an uninitialized value (0) for ha->fc4_type_priority being falsely
> interpreted as NVMe priority. Not strictly needed any more after the
> previous patch, but makes the fc4_type_priority handling more explicit.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

