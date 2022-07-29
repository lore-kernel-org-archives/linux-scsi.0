Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B89C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 12:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiG2Myt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 08:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiG2Myr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 08:54:47 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4693474C0;
        Fri, 29 Jul 2022 05:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1659099286; x=1690635286;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IbJcIAs3IrCl2okNNfKOrVozJ75aHk62lJOemMRvYRI=;
  b=owwRR+fwwUb0aqKimKQ8QiFQCa1/Do4/VIqDjDuNqzvKp1LomqFRTUak
   cHESgRuY7ax3d6i7wESb8HNJ60X8qpkv9rPgg1ttJQjE7Ik7U7KYzfLiK
   xVUfiMoOCc5U0LfR5udDjsXqC6HD8W4PX9oH53r8VZdJPE6Cu4oI0P74E
   Y=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 29 Jul 2022 05:54:46 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 05:54:46 -0700
Received: from [10.242.58.28] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 29 Jul
 2022 05:54:44 -0700
Message-ID: <f1cf652a-4a36-fe60-5a98-14b9d97c9a41@quicinc.com>
Date:   Fri, 29 Jul 2022 18:24:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH V3] scsi: ufs: Get boot device storage type from command
 line
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <1659034814-3473-1-git-send-email-quic_cchinnad@quicinc.com>
 <77330f3a-5f73-e10f-7e85-f3df304aa4d7@acm.org>
From:   "Chetan Chinnadagudihundi Ravindranath (Consultant) (QUIC)" 
        <quic_cchinnad@quicinc.com>
In-Reply-To: <77330f3a-5f73-e10f-7e85-f3df304aa4d7@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Thanks for your response!. For making ufs-cmdline code integrate in 
vmlinux we might need to remove the depends on for SCSI_UFSHCD(m)

/drivers/ufs/Kconfig
  menuconfig SCSI_UFSHCD

-       depends on SCSI && SCSI_DMA

does this looks good? Instead of this Please suggest any efficient way 
of making ufs-cmdline part of vmlinux.

Thanks,

Chetan

On 7/29/2022 2:01 AM, Bart Van Assche wrote:
> On 7/28/22 12:00, Chetan C R wrote:
>> v2->v3
>> - Made ufs-cmdline to build as core driver obj-y
>
> This is not sufficient to integrate the ufs-cmdline code in vmlinux so 
> this patch has the same problem as the previous two versions.
>
> Bart.
