Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE93C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 17:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B8C720869
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 17:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfKHRCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 12:02:48 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35172 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHRCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 12:02:48 -0500
Received: by mail-pf1-f195.google.com with SMTP id d13so5021424pfq.2;
        Fri, 08 Nov 2019 09:02:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZotNkLJwYYaK+jnVoyW+G7A5ruO+3o9PUSU80sFgcAA=;
        b=Bdeu1t1FdhF5UIXIVT2YZkCImBf/dIgSXYSuRUQkcP1DkUbEo3GjXJAzoFcuYdTdNL
         9TrZX0kdPNPniOAyqPLZ/zIxCHWCrn7yLDlmvzZ+hr4uJ6JSwx1KPkTuYcO0gs8jKVI8
         +hdcEVTC5TYl8evCnoxNxNWooGpxuo9T6pyZL4WfY/dSBcpxNd7w60r4nuF4l6fsNt+7
         Y6CybYXSMuJ0KR1lv+6abU2HsJq/Uwi7+F6IKsHvmZuX4GmZahLsNs93lCCiuezIMbqv
         cvJfFMZlfspBFzd60hPRN0J1Q4Oe2joY5Ccsf6x/x0Fl9U6/Al83zc5z7nr1XYJRzBce
         oscA==
X-Gm-Message-State: APjAAAXXU4ApgJqCB2wvfr9iUaevDBmdy+gnSEpnU0F/LREkgLOdnsNo
        u+HddSv8qLEeOEmXfdmqKj4=
X-Google-Smtp-Source: APXvYqwTLAEMR3L0uPg73tUgg7WZUrtzRvWjSFSf8CoGfRZw6I1qsA/6edqrh4s4bncyEEdVRFXPSA==
X-Received: by 2002:aa7:930c:: with SMTP id 12mr13377900pfj.33.1573232567390;
        Fri, 08 Nov 2019 09:02:47 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id n21sm3803675pjq.13.2019.11.08.09.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 09:02:46 -0800 (PST)
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <05e7e1e7-ac6e-eeb2-e764-00936e8a9647@acm.org>
Date:   Fri, 8 Nov 2019 09:02:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108082901.417950-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/19 12:29 AM, Damien Le Moal wrote:
> Prevent recursion into the IO path under low memory conditions by using
> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

