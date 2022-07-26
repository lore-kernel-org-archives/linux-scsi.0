Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2960C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 06:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiGZGs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 02:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbiGZGsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 02:48:55 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07C6220FD;
        Mon, 25 Jul 2022 23:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658818133; x=1690354133;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o0AGuCbDQgQfq9ai86IVzKSjcgci0SSS5ogiey3b7dI=;
  b=revI4MUwjTvU27oldLQ/mcFULWowGtkAXHma+SW+te5M12hbfA7KrUN6
   ouHJd+1lIapARchiE5NAz7IZQEYaiATxQtGAOdU+sKfuaOhAZDXVe68j9
   VFAWVbAQQkwGq+Exp+QXwycAnM0irm9Douq1wbo0CS4om18puUtwgLQVT
   A=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 25 Jul 2022 23:48:53 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 23:48:53 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 23:48:52 -0700
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Jul
 2022 23:48:48 -0700
Message-ID: <fda2811d-8cad-d3e7-3587-3b4448d7dc08@quicinc.com>
Date:   Tue, 26 Jul 2022 14:48:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/2] scsi: ufs: Add Multi-Circular Queue support
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1658214120-22772-1-git-send-email-quic_cang@quicinc.com>
 <1658214120-22772-2-git-send-email-quic_cang@quicinc.com>
 <DM6PR04MB65750EE12401C4F69B352E5CFC909@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1de1372e-1c69-611b-0999-c162da8013ac@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <1de1372e-1c69-611b-0999-c162da8013ac@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 7/23/2022 1:58 AM, Bart Van Assche wrote:
> On 7/22/22 00:31, Avri Altman wrote:
>>> +#define UFSHCD_MCQ_IO_QUEUE_OFFSET 1
>> Maybe add a comment above: "queue 0 is reserved for query commands" 
>> or something
>> That is if the query commands don't use the  legacy doorbell
>
> Is it essential to reserve a queue for device management commands? 
> Wouldn't it be better to have one additional queue for submitting I/O 
> commands rather than reserving a queue for device management commands?


Since this is just RFC change, we are trying to make the whole thing 
work with minimal efforts.

So we found that having a reserved queue (with only one active command) 
for device management

requires much less changes in ufshcd.c, because current device 
management commands anyways come

one by one (we have a mutex lock dev_cmd.lock held in 
exec_dev_command()) and it is easy to handle/assign

the task tag for device management command by just reading sq_tp_slot. 
If you think this needs to be improved,

can you please elaborate your idea? Thanks.


Regards,

Can Guo.

>
> Thanks,
>
> Bart.
>
