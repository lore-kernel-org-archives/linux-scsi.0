Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753B2E7AD77
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 17:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjJCRjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjJCRjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 13:39:37 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D9C95
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 10:39:35 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3ae214a077cso849160b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 10:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696354774; x=1696959574;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+cTWx3+VP6BG58Dc5PvoLOiJIHI60lc/cFAIkA4QIE=;
        b=cUxU6RUVX0WX5Npe1jkgZIt784iCEy0rIxzZwqfN2J9+97eKBJlUC6f9Ad0w9Nq1H1
         6U+nl7yclfIkeveYU40q20xdgQsGq0081OvHdvKl0CBpu4bkTw6H81nvHGGz2qWwqXQj
         sY/Jjh+asKu1jVRVU5bSMm/Lc/n+b51cwlmtALAGbeyaot6SB2hPxIBgRlJIicXPEVWt
         H2OoHdv/6MR8XzYlrDo5xajCMx93HlhI72PCyZjtF4SzaTl4P7+CJb+pOGWl4vLFGEJP
         U9/RcdyEUOjUUWfg3moQ+4l6tEa9mTQ3D3WeBcbzern1b928rcu8ovbf2UBeE64nAYEK
         PBwA==
X-Gm-Message-State: AOJu0YyOVHnWiBcgvq5ua2uP+Dtyq2AyIY/0tvvyr1iLrpv9aHZnEKTu
        5KO/v8tdNkK+wGJKZ0jN1Xc=
X-Google-Smtp-Source: AGHT+IHjsMTWIEkf6ko+7I1BFtB23x4t9qY4ihcDbI+Arjlo13aVVeGmtnx9p+0P4KFXWg/8rOMNxQ==
X-Received: by 2002:a05:6808:3084:b0:3ae:5357:ad43 with SMTP id bl4-20020a056808308400b003ae5357ad43mr251253oib.52.1696354774436;
        Tue, 03 Oct 2023 10:39:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:fc96:5ba7:a6f5:b187? ([2620:15c:211:201:fc96:5ba7:a6f5:b187])
        by smtp.gmail.com with ESMTPSA id l187-20020a633ec4000000b005703a63836esm1650248pga.57.2023.10.03.10.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 10:39:33 -0700 (PDT)
Message-ID: <4f67647d-b60e-4e76-b4b3-c79cac7951d0@acm.org>
Date:   Tue, 3 Oct 2023 10:39:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: Do not allocate scsi command in
 scsi_ioctl_reset()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231002155915.109359-6-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 08:59, Hannes Reinecke wrote:
> As we now have moved the error handler functions to not rely on
> a scsi command we can drop the out-of-band scsi command allocation
> from scsi_ioctl_reset().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
