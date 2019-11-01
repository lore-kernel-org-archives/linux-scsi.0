Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A6CCA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D13F217D9
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKAQfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:35:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37291 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfKAQfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:35:23 -0400
Received: by mail-pf1-f195.google.com with SMTP id p24so919333pfn.4
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NLg+tusNpdbKV+oWdsmXmgDGwedjWb8bP0huZf6fXfU=;
        b=XO5IibbRLdDxv66+JwA3c79tnmcHzvp8b/oq7Uotl2qSIor9LcFNV2rUC4LGm5gf/C
         yL5n4pv7QaRkSZ0m/YBUtaEr4c22dAfOo0sXUoSH7p/78yhW/WBytT7SJAtdjajvKPlT
         RLmIAQFlhhukihKCRMZtERdV8B90PFElAjnqsOG/xr/+Aj4g72vlb+Y6afRc3hxKL5AR
         azqqjP4lArs28lLhaTHv/61TPRIwUcn5/tX7KuermxMtQlFpRWvuZtogeYlpjygcbDMc
         Ic5Y4onj6bZPHo21exH5fLfMKTPSmYRnOGvuD+aI41R4fvsFaNoeg7d5fADEgd3PiL5C
         Xbbg==
X-Gm-Message-State: APjAAAUUxkaXIQqf7QBcCrGU+v4PPDdK9bPQ8TWTvtHbhaaY7OqOl5qS
        yovM0TxjsMfQwi2cQf7TJNKYh1aeL5w=
X-Google-Smtp-Source: APXvYqzQyDcwo6ryyNb81XINJSwTZnKtshQ9VTb1SZkg1Jzi80zp084Rvsp14FqKjuxDix6Uqqjjmw==
X-Received: by 2002:a17:90a:98d:: with SMTP id 13mr16272622pjo.98.1572626122221;
        Fri, 01 Nov 2019 09:35:22 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z10sm7827764pfr.139.2019.11.01.09.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:35:21 -0700 (PDT)
Subject: Re: [PATCH 12/24] scsi: introduce scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-13-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4033ba38-3c60-8c7e-cb84-c0ed3c9c6ffa@acm.org>
Date:   Fri, 1 Nov 2019 09:35:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-13-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> Introduce scsi_build_sense() as a wrapper around
> scsi_build_sense_buffer() to format the buffer and set
> the correct SCSI status.

Please split this patch into one patch for the SCSI core and one patch 
per SCSI LLD.

Thanks,

Bart.
