Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837DDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 19:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiBNTq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 14:46:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiBNTq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 14:46:56 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E611B329
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 11:46:39 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id i6so29120104pfc.9
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 11:46:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o/bcdmKORB3FHs951r4NvBJoe81wQvvsN5Q5Oc54A3o=;
        b=I7JePGbWCFhkf/9PfyPbpw9rT2pLRzLyTxap34pl5MD1N6jtylbke7NBQ6fPWEV6fX
         B+CdAHBo2MnhiQ51ocHI12lTU7bpqJqFLFAIhKjinpRXTSR29f+YDErjSHee94avsMqf
         gWIRX+WBxXQNitwAK2hQaDVm6c6gE4HX/KSgHY2R9pSbbRdBEOHiefqFus/QKZdH6BFa
         9E+zFNXLikNDm2zXOLWiZnBJrf5q1jQe6jZi1lPVZRq8F+2JCtFS6ez9hP53Kyky66lO
         6st1hVgotrqUbJbY+a1rMJKGEGXSbDkiC6+gAhXgxVDhRnWVOL/3GxVWcm1c3qenceA+
         FDng==
X-Gm-Message-State: AOAM533a2136U/cGdVnAEhpaNxMvbCaSo0RN8hebYz8b7FRjC9L+0/fi
        CinNsvT4f4Ni37sgzwp3UsXtQDKSsbk=
X-Google-Smtp-Source: ABdhPJzuN7RZfb2h4oIoxln+e/VtGS9f7BmMLBgGSsTEioSY+6uXImEu34sAMpmAlMK7BEy8TEYYDQ==
X-Received: by 2002:a63:4717:: with SMTP id u23mr512857pga.74.1644867130549;
        Mon, 14 Feb 2022 11:32:10 -0800 (PST)
Received: from ?IPV6:2600:1010:b05a:bf8:cd06:5464:d61e:f6b4? ([2600:1010:b05a:bf8:cd06:5464:d61e:f6b4])
        by smtp.gmail.com with ESMTPSA id v12sm3486951pfu.155.2022.02.14.11.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 11:32:09 -0800 (PST)
Message-ID: <c2e38183-fda7-65b1-3429-2b11061562c1@acm.org>
Date:   Mon, 14 Feb 2022 11:32:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2] scsi: ufs: Fix runtime PM messages never-ending cycle
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20220214121941.296034-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220214121941.296034-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/22 04:19, Adrian Hunter wrote:
> Kernel messages produced during runtime PM can cause a never-ending
> cycle because user space utilities (e.g. journald or rsyslog) write the
> messages back to storage, causing runtime resume, more messages, and so
> on.


Thanks!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
