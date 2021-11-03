Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D31C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CD561101
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhKCQvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:51:03 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36747 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhKCQu6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:50:58 -0400
Received: by mail-pj1-f42.google.com with SMTP id o10-20020a17090a3d4a00b001a6555878a8so1839364pjf.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 09:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=58z90GBN71bZrAOZZZtLGHSRxZtsV45kTdExpzodJeQ=;
        b=MpYyqRWfVcjaraEsYfzX/FlcCNhCvp9GkDFHnf0z3hjXKJb4IP6zCCrKEECuAciYjw
         mECxArgngnmWXSP4aaEMqnkNKgP3PJCTk325MRiWfMacgclLI+Sx53n3Mznvl9OCu6Pn
         QkoEb/zDa4ogm5tSXCdKQ7IFe/+vbfb8E5c4mwHvTXLbKkFafnITPqALOpML3Mts38Xw
         39jw/P/bz8vECmm9ENrtACJA6V8E7HplW41wlJqf1PhALMVBiGEVczQ9UsH7wI2qs4pK
         pbTLl3YkHZdlD+8vYO9IfDniq3agxUyWnlXKbaMiI3NUwyHVeCdfN1eEGurE4/fQl+eT
         Ydvg==
X-Gm-Message-State: AOAM530G4cUS+Rojcy4aAR0jy5wDvyPou2nQJQK7v3+r+DogWGdCZE37
        V5Hic3Xmy+ir6eZn6zZUL/g=
X-Google-Smtp-Source: ABdhPJz3bVUry8yut6AE6N0piQiXEkGBcmHENqQc0/pe88MkqQoEZ2P351p3qqwNd/4u+6F2cd32Zg==
X-Received: by 2002:a17:90a:ad47:: with SMTP id w7mr15063340pjv.16.1635958101576;
        Wed, 03 Nov 2021 09:48:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id co4sm5817098pjb.2.2021.11.03.09.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 09:48:21 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Christoph Hellwig <hch@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
 <19b8e555-d12f-9bf5-91c6-d3c5f849e72c@intel.com>
 <YYK59D+M5w4FSoo0@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ac927e92-f69f-a21a-5b3f-7672853fd2d6@acm.org>
Date:   Wed, 3 Nov 2021 09:48:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YYK59D+M5w4FSoo0@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 9:33 AM, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 10:37:30AM +0200, Adrian Hunter wrote:
>> The UFS driver does not issue device commands to the block layer.
>> blk_get_request() is used only to get a free slot.
> 
> That is indeed the case for the code touched here, but not in general:
> 
> ch@brick:~/work/linux$ git-grep blk_execute_rq drivers/scsi/ufs/
> drivers/scsi/ufs/ufshcd.c:      blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
> drivers/scsi/ufs/ufshpb.c:      blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
> drivers/scsi/ufs/ufshpb.c:      blk_execute_rq_nowait(NULL, req, 1, ufshpb_map_req_compl_fn);

Hi Christoph,

The blk_execute_rq_nowait() call in drivers/scsi/ufs/ufshcd.c will disappear
from Linus' master branch once Linus merges the v5.16 scsi core pull request.
See also the following patch authored by myself: "[PATCH 2/2] scsi: ufs: Stop
clearing unit attentions"
(https://lore.kernel.org/linux-scsi/20211001182015.1347587-3-jaegeuk@kernel.org/).

Thanks,

Bart.


