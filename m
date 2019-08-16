Return-Path: <SRS0=RKta=WM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3B1C3A59D
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 19:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B77C2077C
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 19:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Kt8Af6t2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfHPT46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Aug 2019 15:56:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39695 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfHPT46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Aug 2019 15:56:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so3631706pfn.6
        for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2019 12:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=XDxicx1OP6wHEEPTkhNVlA3uTUHqZWelhtfoFqZM2P0=;
        b=Kt8Af6t2TxX8A/GfqjYGndn7iKVncQRUE/WtDfk34SccDPKUlp8oE0OfzeXlicZgd1
         MZkAnjryNIIBET4U9oMiljfG5WZQihr426LGa+oGRSZ1UWP3k32khcfHIwNd5Ci+/ZM1
         gjlslkRx7BZZth5fjw/7UlDQ/wI2WtQ9eJV1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XDxicx1OP6wHEEPTkhNVlA3uTUHqZWelhtfoFqZM2P0=;
        b=WyAgFm8pvxA+FvNqcyo0zhn9SUkmYqbIDMUoxPGcZEu/cXWSW826iZoS1oSU6VLYch
         CsnP1cWlIf5Il7dx4SRcPqSHOT/9UVwEjL+y8lyj4FkcVG+nLqIf9vFlDbfLDuidRN+q
         p04JbGbbeHBkBfCmWQmHr3iwTYvKwF4zJ+kDfQL8XZBQbTtESu9KUYzQhKjuEqdwLPwL
         VKdFi3HYvXdDyRXbjOyn9gQP/pn4/qxVR/drntHlHE1flw99N8IhI+LA/OTxOU/nPvol
         4dYKErgFcZCrOoTu7QEMPcg9oooJuwwXqgP7kEcgEP5lzkS362dNJZKrLdZ4dVwa2FGG
         SoCQ==
X-Gm-Message-State: APjAAAVI2LMgoGcLo7rnzqu8wchmcnyJ0bcbsrZuNGBEsYzql1Vk+lzv
        qsTAMe/HIWC0QLVsNX8ReHAz8Q==
X-Google-Smtp-Source: APXvYqwc8GYCB3OP3WP4dI74ppom+NhRyeIPQBp2bN1x7NdcjYCvPOlHYRPGpuPIMWxIqu5f1ZsFjw==
X-Received: by 2002:a17:90a:234e:: with SMTP id f72mr8875479pje.121.1565985418002;
        Fri, 16 Aug 2019 12:56:58 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u26sm7784201pgl.79.2019.08.16.12.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:56:57 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: remove redundant code
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190808013525.13681-1-huangfq.daxian@gmail.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <32a8659f-cc3e-ae7d-7a38-3ffae3e22a3e@broadcom.com>
Date:   Fri, 16 Aug 2019 12:56:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808013525.13681-1-huangfq.daxian@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/7/2019 6:35 PM, Fuqian Huang wrote:
> Remove the redundant initialization code.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>

Looks good!

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

