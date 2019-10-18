Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C498DCA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 16:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DB7920663
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 16:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JqjIkhRx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405960AbfJRQgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 12:36:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42730 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405934AbfJRQgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 12:36:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so4208367pff.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 09:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Bye135gwA1svZblRSZCCqjJ0pb5KXJ36Pgiefcf2DQY=;
        b=JqjIkhRx2SvqMM1489kPjibumhUQKoZNWSY3TZ/nKULBQFgG5OQSKI2BCTJJ7D5Uih
         wPwEy/nlsOwbvqwLjuUTvjy+u7C74Nh/PmLWkqrTif8X2y2SorrUynVHI92/JZ8WXGFE
         JumSiErFubDM+PEttZ9RQmguyAda29gp1fPX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Bye135gwA1svZblRSZCCqjJ0pb5KXJ36Pgiefcf2DQY=;
        b=Mr6uapKvZUvMGNpugTfLwDzidsbkvx7fTZwjd9E8t7SotraX9LmmR4AwMSGXZ0V0n2
         v2DLjUdP58XfHRUG0w1nKV9rPCfdM2Ef59WViD+26+8GyKKMxvndmrYtHuAU8f2EBfVT
         0XTcWoi0pPOehZIUDy28eqw7150H5g7IvhHhtnfhF8N/PEl7BMs/1iugrdVCMEcSk8cy
         4kFOpXw2pzCFts8mIBxFWeYsmH6qb0rDzY8sJq4OdQlhSsvnh6HGhB02ypXLhUvDkcvU
         o22cN3fLs/6025FeoShu8zHzSWPDmt3EZC3evgXnfDWiEyjPbjHOuei4C1a09J3bHqAP
         h/Uw==
X-Gm-Message-State: APjAAAVEbcIczwlCas138CiaYCRMVBuM7J7/1576iHmY94tGNqWqd6fY
        CdCcTBBSOBWzDPLT25qukDFiyA==
X-Google-Smtp-Source: APXvYqzD/qt6MHkD1pK6flLL5LHVVOJ2Ajha+rl3DPyHpe600uM4wBypQgjk0Zslwx2Zxy0J0/N8tw==
X-Received: by 2002:aa7:9842:: with SMTP id n2mr7883881pfq.258.1571416570119;
        Fri, 18 Oct 2019 09:36:10 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e127sm7457161pfe.37.2019.10.18.09.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:36:07 -0700 (PDT)
Subject: Re: [PATCH] lpfc: remove left-over BUILD_NVME defines
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Martin George <martin.george@netapp.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>,
        stable <stable@vger.kernel.org>
References: <20191017150019.75769-1-hare@suse.de> <yq1eezake0f.fsf@oracle.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <0e739a86-a462-9d44-9ef9-24a4488c0d87@broadcom.com>
Date:   Fri, 18 Oct 2019 09:36:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <yq1eezake0f.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/2019 7:01 PM, Martin K. Petersen wrote:
> Hannes,
>
>> The BUILD_NVME define never got defined anywhere, causing NVMe
>> commands to be treated as SCSI commands when freeing the buffers.
>> This was causing a stuck discovery and a horrible crash in
>> lpfc_set_rrq_active() later on.
> Applied to 5.4/scsi-fixes, thanks!
>

The offending patches that introduced the define are:

 From 12.2.0.0:
scsi: lpfc: Move SCSI and NVME Stats to hardware queue structures
commit    4c47efc140fa926f00aa59c248458d95bd7b5eab
 From 12.4.0.0:
scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair
commit    c00f62e6c5468ed0673c583f1ff284274e817410

The 12.2 patch just misses some stats - no big deal.
But the 12.4 patch introduces a logic error, and is in the head of the 
stable tree.

I assume that 5.4/scsi-fixes will get merged into 5.4 pre-release, and 
that the stable tree will rebase to pick it up ?

-- james


