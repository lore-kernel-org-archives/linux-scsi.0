Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0887FC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 02:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiITCBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 22:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiITCBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 22:01:11 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1D952836
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 19:01:03 -0700 (PDT)
X-UUID: be2c60a37d7f42d3a5b3e44e117587d5-20220920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:CC:To:Subject:MIME-Version:Date:Message-ID; bh=RupT8e3l6c7V6ux+6h3Z+mdWvwvDjI3AX/lrgrv6+Wk=;
        b=SYmOfzkr2IG8wnMtzPbNrKk8jTW1K87z+Kg34sES6RO/61qKN7vFLDeiJBUNj6V2E6/fuuVFyUPIi95eXnOvSYcFwjt47LGyB+oE1rcQeAOaYUYW4He3GcK9/1WjJBVjoFd/xsGvFKLBHOi8P9fZgPDp6KPOEkDRYKnTGUTei/c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:81e29f63-ece4-46b9-bbb5-9316c0c7f6d4,IP:0,U
        RL:0,TC:0,Content:0,EDM:-32768,RT:-32768,SF:-32768,FILE:0,BULK:-32768,RULE
        :Release_Ham,ACTION:release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:eaa63453-ffcd-4a71-8075-f280d669ab90,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:nil,IP:nil,
        URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: be2c60a37d7f42d3a5b3e44e117587d5-20220920
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1703952319; Tue, 20 Sep 2022 10:00:50 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 20 Sep 2022 10:00:49 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Sep 2022 10:00:48 +0800
Message-ID: <aec67382-d9d4-052a-50c4-574cf5c4a501@mediatek.com>
Date:   Tue, 20 Sep 2022 10:00:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1] ufs: core: bypass get rpm when err handling with
 pm_op_in_progress
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220915115858.7642-1-peter.wang@mediatek.com>
 <4fadab02-5ab7-03d5-e849-55eaa26113cf@acm.org>
 <647e3423-94dc-f2c6-0fad-7896e709f291@mediatek.com>
 <4acf4f39-f6f8-6b65-2bc6-a4c5225d9a04@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
In-Reply-To: <4acf4f39-f6f8-6b65-2bc6-a4c5225d9a04@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 9/20/22 00:25, Bart Van Assche wrote:
> On 9/19/22 07:47, Peter Wang wrote:
>> If the scsi error happened and need do ufshcd_eh_host_reset_handler, 
>> the rpm state should in RPM_ACTIVE.
>> Because scsi need wakeup suspended LUN, and send command to LUN then 
>> get error, right?
>
> The following sequence may activate the SCSI error handler while the 
> RPM state is RPM_RESUMING:
> * The RPM state is RPM_SUSPENDED.
> * The RPM state is changed into RPM_RESUMING and ufshcd_wl_resume() is 
> called.
> * ufshcd_set_dev_pwr_mode() calls scsi_execute() and the START STOP 
> UNIT command times out.
> * Because of this timeout the SCSI error handler is activated.

This case will not get rpm, because pm_op_in_progress is true.

So it won't hang with ufshcd_rpm_get_sync.


Thanks

Peter


