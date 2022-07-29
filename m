Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CE6C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 01:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiG2BcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 21:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG2BcN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 21:32:13 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469A5E33A
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 18:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1659058332; x=1690594332;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kq9PDiPPwny32UbzTzcdaVnsfTL7bxgZ6itxvnxFbN8=;
  b=TDuJmWOkRsiyQClAH2jMa2VMLstlDiJO5jQEIkEWWC+U9QDQU/MXH2Zq
   P2JipGSzGt/RziDt9rBip57jVRk3PJ/rpRu1j/bRMCrjbFzR6h9CE05Hr
   pGNxZMRMjoCI8jc2XS7ohF0i8A4ZXqIXEtR4cgUzxFRhrk+dl2/i6Xife
   s=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 28 Jul 2022 18:32:12 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 18:32:11 -0700
Received: from [10.110.38.152] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 28 Jul
 2022 18:32:10 -0700
Message-ID: <f6c9076e-186b-3dc7-3723-ad7a9262b7d9@quicinc.com>
Date:   Thu, 28 Jul 2022 18:32:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 0/2] UFS Multi-Circular Queue (MCQ)
To:     Bean Huo <huobean@gmail.com>, Can Guo <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>,
        <quic_nguyenb@quicinc.com>, <quic_ziqichen@quicinc.com>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>
References: <1658214120-22772-1-git-send-email-quic_cang@quicinc.com>
 <3b1a57c89058e3c09a746bc55c21fbb15434717b.camel@gmail.com>
From:   "Asutosh Das (asd)" <quic_asutoshd@quicinc.com>
In-Reply-To: <3b1a57c89058e3c09a746bc55c21fbb15434717b.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bean,

On 7/28/2022 3:23 PM, Bean Huo wrote:
> On Tue, 2022-07-19 at 00:01 -0700, Can Guo wrote:
>> UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to
>> improve storage performance.
>> This patch series is a RFC implementation of this.
>>
> 
> Hi Can/Asutosh,
> 
> we could remove RFC, add more detail about MCQ configuration and its
> implementation. Review will takes longer since we don't have a platform
> to verify it, and now only reply you to verify.
> 
> 
Thank you for the review.

Sure, the whole idea of sending a RFC was to get a validation on the 
design that we plan to pursue. I think several valid points / comments 
were raised and we're coding those up now; hence, it's taking some time.
We plan to keep the next version as RFC too, unless we feel we've sorted 
out the initial design considerations.

> Kind regards,
> Bean
> 
>> This is the initial driver implementation and it has been verified by
>> booting on an emulation
>> platform. During testing, all low power modes were disabled and it
>> was in HS-G1 mode.
>>
>> Please take a look and let us know your thoughts.
>>
>> Asutosh Das (1):
>>    scsi: ufs: Add Multi-Circular Queue support
>>
>> Can Guo (1):
>>    scsi: ufs-qcom: Implement three CMQ related vops
>>
>>   drivers/ufs/core/Makefile   |   2 +-
>>   drivers/ufs/core/ufs-mcq.c  | 555
>> ++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/ufs/core/ufshcd.c   | 362 ++++++++++++++++++++---------
>>   drivers/ufs/host/ufs-qcom.c | 116 +++++++++
>>   drivers/ufs/host/ufs-qcom.h |   2 +
>>   include/ufs/ufs.h           |   1 +
>>   include/ufs/ufshcd.h        | 231 +++++++++++++++++-
>>   include/ufs/ufshci.h        |  89 +++++++
>>   8 files changed, 1251 insertions(+), 107 deletions(-)
>>   create mode 100644 drivers/ufs/core/ufs-mcq.c
>>
> 

-asd
