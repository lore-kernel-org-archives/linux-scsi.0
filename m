Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F904C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 15:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjERPBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 11:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjERPBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 11:01:01 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B141724
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 08:00:24 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-64388cf3263so1541530b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 08:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684421950; x=1687013950;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iThObQ23DfkvDvB65ajSkB8yfWsGof4At1OGgh3Gh/U=;
        b=b4hr7/tLaQMy++lLqjtjGxtMvMBdXq7gD8Zn9ttLAQ5PoxQJ7NI2okoHNNcxgy8EKe
         U0Idm4Bmefyx5pH+9V2tLL1z+jUwA2nPahQa7n0N0SBzgcFGu6O5uZzJhs/95QTLPUQm
         rrbBe7ewsN1u0pdQyXE+UGuZgz6hhnE92ZS4fHDtxDLTd2phPlRpGkCum0MEOzh6yiud
         aY9dIKyMyz45TbQ9CD/jEmqa2YLtT9ydQcJfYeu0W+QBXXQpuR4IDxnSD0QumPuuJHLm
         RutOD8SH2dSBv99Bi5ZueVZyW9fZUdLHQAMlTizPwdj/SpA8j6IEqU5RvlamObsVTNdZ
         gx4w==
X-Gm-Message-State: AC+VfDx/jQkLf48IEFJFzd0cxNATrQEHXjKydcZ2IjqnNDa2JyLN4CGk
        9RnOTLuf1nVIFNCErM/DgK8Sk/dq9uk=
X-Google-Smtp-Source: ACHHUZ7f2Xz/45qoMDszFe2r/keSjVbhzZPqyx67AF6OVebyOEaAYr+NWisjB6f1lpN2xZDKnprJ2g==
X-Received: by 2002:a05:6a00:1a55:b0:643:b263:404 with SMTP id h21-20020a056a001a5500b00643b2630404mr4241874pfv.33.1684421949748;
        Thu, 18 May 2023 07:59:09 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id p20-20020aa78614000000b0064399be15f0sm1441105pfn.183.2023.05.18.07.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 07:59:09 -0700 (PDT)
Message-ID: <0ec80565-9a49-9359-8540-5ea079ac879c@acm.org>
Date:   Thu, 18 May 2023 07:59:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 4/4] scsi: core: Delay running the queue if the host is
 blocked
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-5-bvanassche@acm.org>
 <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
 <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
 <ZGWP/3dX1sgpRj+t@ovpn-8-16.pek2.redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZGWP/3dX1sgpRj+t@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 19:39, Ming Lei wrote:
> In reality, it can be full of race, maybe we can just remove
> BLK_STS_DEV_RESOURCE.

We need a better solution than changing BLK_STS_DEV_RESOURCE into 
BLK_STS_RESOURCE. Otherwise power usage will go up in battery-powered 
devices that use block drivers that return BLK_STS_DEV_RESOURCE today.

Thanks,

Bart.
