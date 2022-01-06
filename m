Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C82C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 15:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbiAFPtk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 10:49:40 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4357 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiAFPtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 10:49:40 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JV9gc3BhMz67bFG;
        Thu,  6 Jan 2022 23:46:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 16:49:37 +0100
Received: from [10.47.27.56] (10.47.27.56) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 6 Jan
 2022 15:49:36 +0000
Subject: Re: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
To:     <Ajish.Koshy@microchip.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
Date:   Thu, 6 Jan 2022 15:49:22 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.27.56]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/12/2021 13:26, Ajish.Koshy@microchip.com wrote:
> Regarding maxcpus=1 issue, will check and try to reproduce the
> same on x86 server.
> 
> And for ARM issues, need to check internally as it was never
> tested for the same.

I have found another issue. There is a potential use-after-free in 
pm8001_task_exec():

static int pm8001_task_exec()
{
	...
	case SAS_PROTOCOL_SSP:
	atomic_inc(&pm8001_dev->running_req);
	if (is_tmf)
		rc = pm8001_task_prep_ssp_tm(...);
	else
		rc = pm8001_task_prep_ssp(pm8001_ha, ccb);
	break;
	...

	if (rc) {
		pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
		atomic_dec(&pm8001_dev->running_req);
		goto err_out_tag;
	}
	/* TODO: select normal or high priority */
	spin_lock(&t->task_state_lock); ****
	t->task_state_flags |= SAS_TASK_AT_INITIATOR;
	spin_unlock(&t->task_state_lock);
	...
}


Once the task is dispatched to HW at ****, it is completed async, i.e. 
it may be completed and freed at any point, even before the dispatch 
function returns. So it is illegal to touch the task at this point and 
the task state must be updated before final dispatch to the HW. If you 
enable KASAN you will prob see it yell like I saw.

Thanks,
john
