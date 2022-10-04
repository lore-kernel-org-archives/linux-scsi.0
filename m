Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C41C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 00:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJDAVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 20:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJDAVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 20:21:17 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88461255AF
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 17:21:16 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id 10so7528532pli.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2022 17:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ePeo67OueUShifC7omagh9Y9HGwV2S/D/PEZ8LZM2wI=;
        b=ZhgtrHe4DeIkT+Jtmy0FNXZa6sZvCBgyqJud2UVoQ5sRSxg6ZE0ZG3vkRFMU4cfMZ4
         7C0L49YvjhqGVWZB3sxLup0R5g7wXiiFAKI1/SxX6Xj97xEwUsF5nzpb7PwnoAx5waUD
         sGqN83oSlyvs9nmFwhYhdtR/DwLj+JCLH9EpevHlmXVUl+spL9MSsxyzYbeRnwAPdRID
         q4D/O3L94ho8G7R9lAA2eXTEJD05Bw4RlMI3PcDc0qunJZmahuZMeSGMXhZ34bdRd74D
         XkyxT0GDvnN01Mr+3HXZ0YaXsfRsVMTvqlz4O54BdEeIrjShCbFfuWe1aYdUwRlJejtI
         bigw==
X-Gm-Message-State: ACrzQf1Oqf5Yyb++dKIkY73mTAvZkUMP6JoGxBvmzUAEtjRtc5N+m0zI
        JTtrx98QXcA1G0xttYM+3B0D5Zr+zyY=
X-Google-Smtp-Source: AMsMyM62jf3k1osndDHhpnydaJ7VOfif+AnP1CSEX89pA7tPtLSt0zJG2Y6sI8KF7GrkpCJMM4mvww==
X-Received: by 2002:a17:902:f550:b0:178:5b6a:3a1c with SMTP id h16-20020a170902f55000b001785b6a3a1cmr24167849plf.36.1664842875901;
        Mon, 03 Oct 2022 17:21:15 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b188-20020a621bc5000000b005604b8f226csm4732241pfb.2.2022.10.03.17.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 17:21:15 -0700 (PDT)
Message-ID: <81761c95-5903-bf37-bdb8-27d14b3c8043@acm.org>
Date:   Mon, 3 Oct 2022 17:21:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-9-bvanassche@acm.org>
 <67bfe4a2175da74b686a4990a6ebe0b91017599f.camel@gmail.com>
 <af357394-7329-b218-ccf9-65944a35fc6e@acm.org>
 <27eaae3fe2b3eb715091f09b38e8d500bc9def52.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <27eaae3fe2b3eb715091f09b38e8d500bc9def52.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/22 14:21, Bean Huo wrote:
> Yes, install the whole series of changes, ufshcd_link_recovery() will
> be called during the system is in suspending in the case of SSU
> timeouts. in this case, outstanding_tasks should be 0?
  Hi Bean,

'outstanding_tasks' needs to be changed into 'outstanding_reqs' in patch 
8/8. My understanding is that ufshcd_link_recovery() calls 
ufshcd_complete_requests() indirectly. That causes the bits 
corresponding to completed requests to be cleared from outstanding_reqs 
but does not guarantee that outstanding_reqs will be zero.

Thanks,

Bart.
