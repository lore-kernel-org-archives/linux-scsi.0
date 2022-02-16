Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2151C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 20:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiBPUJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:09:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiBPUJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 15:09:40 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DEB243121
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 12:09:26 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id w1so2836223plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 12:09:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d9Am0i4lsljR8VQWQecUgncK/rGfnGpbo3Q4fEmift4=;
        b=rQOz6dCQKhLOY98Ahz7pm0QDUoQRtO0ZmQTzHhMf3o81qpMVAQg68DVtg2j/oscy3g
         qS9M9JgaI2TClMWnToL/psutT/Pf+OyUmP6rxX16OYaNwuN19r4A4PoTSpTAV7noR3Pz
         x7wu7JEB31Ja4FpvbJbU6ZH4fIFuFm5Swv/ZACsETgl0QkR4BhVZjKv0XLG3yQkxCcIW
         3Lrj38Wd9gz2EKH+ibSwWZxM6O7Tsqb7PbH0nRVfBXePPwRju0Xql+MGYK+xtHcfkloX
         96vifq3GZgLW0qRcr4eW3q7poCa1ey/i8QlGB7aCsEmxGFQlyLyeKFxS122TvXyslpJf
         aVKQ==
X-Gm-Message-State: AOAM5328OCUkv7jNMjLJuw0A25zv1WHCpYe1iDS3FTRfd6KmxtmRbKLA
        g8vfiVGWDvp0zzisaHhMjV8=
X-Google-Smtp-Source: ABdhPJxHSg3NGUfFoWn8U2GHSai7z2MrpuvE9yWp8BxYJEN5ipnw80asvmL9VdvgsaoUvkq6/MM+7Q==
X-Received: by 2002:a17:902:bd06:b0:14f:500:cb50 with SMTP id p6-20020a170902bd0600b0014f0500cb50mr521649pls.36.1645042165499;
        Wed, 16 Feb 2022 12:09:25 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id r7sm6047083pgv.15.2022.02.16.12.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 12:09:24 -0800 (PST)
Message-ID: <72f04fb1-e86e-5a71-8509-fe18e0a1bd9b@acm.org>
Date:   Wed, 16 Feb 2022 12:09:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 28/48] scsi: libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-29-bvanassche@acm.org>
 <2b079541-4333-535f-3f20-abb3feca85da@suse.de>
 <09dae05e-3e53-cd31-1538-9a715ca16774@acm.org>
 <21707ef4-58f7-4036-3792-bdb842f1f8d4@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <21707ef4-58f7-4036-3792-bdb842f1f8d4@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/22 23:02, Hannes Reinecke wrote:
> Although you can kill the 'status' field for bnx2fc; it's only ever set 
> and never read.

I will remove the status field from the bnx2fc and qedf drivers.

Thanks,

Bart.
