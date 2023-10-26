Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A254EC25B67
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 16:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjJZQhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjJZQhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 12:37:16 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4518A;
        Thu, 26 Oct 2023 09:37:14 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6b9af7d41d2so1073344b3a.0;
        Thu, 26 Oct 2023 09:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698338234; x=1698943034;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F2GButUnQaUYkKuAbRORO7YrrsqmLreMcWNWKY2mI5I=;
        b=XJTP/A2aJq8WCObY4KZm2/PEIRBLSZR6noypD7aG8IsVN7GHXQgsxkf9LNXZxJLaxe
         6jluZwz2+e1qByt/r2vKFpu1w2mbKAXxZY2wQkJ0JPz15nfI5Bfio00iDTNrEhhhgifR
         zIYxIl0YgHZpbkssYQPFLI38puM1KIWjZ4MK3KhaQb/HFZX1Qg10E1N/YMfA7jYpiaY7
         eSJutlyss92KFPujbzMpf8uaGmvW/3aBlJb50NwGnzJaiPRpJ15SlmfKGkWQQZ6hbxRd
         tS54/WHNt2AXzEIeWsQaQ7f2NOTBLiBbPMTn5KtE7mXpeUlIYkxc1FnAND8q/pgsBp0j
         DViw==
X-Gm-Message-State: AOJu0Yxf8X5Bei8HoKYmB/NOIxgFqheSwkHJvTASn4c1ZvdL2FtiZcu2
        1GJSI9oeBi5cAWVu5dTj+DE=
X-Google-Smtp-Source: AGHT+IExXX4vmu9OxACroS816DASZXWzVyQQ8xal9W0sJmo/8dSfpk/9NKSJlWmUvtP40qVgt5UtuA==
X-Received: by 2002:a05:6a20:c192:b0:17b:2f9:4146 with SMTP id bg18-20020a056a20c19200b0017b02f94146mr344229pzb.43.1698338234096;
        Thu, 26 Oct 2023 09:37:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4dcf:e974:e319:6ce8? ([2620:15c:211:201:4dcf:e974:e319:6ce8])
        by smtp.gmail.com with ESMTPSA id i3-20020aa787c3000000b006be047268d5sm11757401pfo.174.2023.10.26.09.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 09:37:13 -0700 (PDT)
Message-ID: <25c8fc74-2583-4e04-8d0e-c65360a1e285@acm.org>
Date:   Thu, 26 Oct 2023 09:37:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora>
 <DM6PR04MB65750819B84D422BD238D2CDFCDEA@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65750819B84D422BD238D2CDFCDEA@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 11:50, Avri Altman wrote:
> This issue is known for a long time now.
> Whenever we needed to provide performance measures,
> We used to disable that mechanism, hacking the kernel locally - one way or the other.
> I know that my peers are doing this as well.

The Android 14 kernels have this patch since May (five months ago). None
of the OEMs who use this kernel branch have complained so far.

Thanks,

Bart.

