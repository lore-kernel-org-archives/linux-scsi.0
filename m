Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3EBC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 17:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiHAR7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiHAR7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 13:59:05 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A5CEB
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1659376726; x=1690912726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SiWC72t5X6/y2SG3bHl14Tn6Tl6IUgel79YS7kEoldo=;
  b=N6uEG2z5wyI79eY3nKre7qDU1vNzWX98qg/45Z/7DcxtngJRHbH4JO7n
   e0ccKCjZ88XkWcsM1Igkss34sTvlVzlxAOurA+do5aCguUF7uTWE+93X6
   D9SqkIWXGb9BtqnGR/UIECdwSKuyBY9Z2WChs3FwKlgR9+HSAXjGLdPnj
   0=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 01 Aug 2022 10:58:46 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 10:58:46 -0700
Received: from [10.46.161.58] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 1 Aug 2022
 10:58:45 -0700
Message-ID: <d492e8ab-5378-7e94-f457-936ff5411a28@quicinc.com>
Date:   Mon, 1 Aug 2022 10:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
To:     Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>
CC:     Peter Wang <peter.wang@mediatek.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
 <ca760b93-e6e9-abea-f2b2-dbb0c592690b@mediatek.com>
 <dadc85ee-1252-38e8-a34f-3d1935f16b29@acm.org>
From:   "Asutosh Das (asd)" <quic_asutoshd@quicinc.com>
In-Reply-To: <dadc85ee-1252-38e8-a34f-3d1935f16b29@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On 8/1/2022 9:43 AM, Bart Van Assche wrote:
> On 8/1/22 07:30, Peter Wang wrote:
>> Or, do you think we can direct remove ufshcd_wb_toggle in clock 
>> scaling and only let sysfs to control wb behavior?
> 
> I think it's worth asking the people who introduced this feature whether 
> it can be removed.
> 
> Hi Asutosh,
> 
> Commit 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support") 
> introduced the following code in ufshcd_devfreq_scale():
> 
> +       /* Enable Write Booster if we have scaled up else disable it */
> +       up_write(&hba->clk_scaling_lock);
> +       ufshcd_wb_ctrl(hba, scale_up);
> +       down_write(&hba->clk_scaling_lock);
> 
> Would you mind if the code for enabling/disabling the WriteBooster is 
> removed again from ufshcd_devfreq_scale() and that a new mechanism is 
> introduced for controlling the WriteBooster mechanism?
> 
Qualcomm would need the load based toggling of WB during scaling.
What would the new mechanism be for controlling WB mechanism?

> Thanks,
> 
> Bart.

