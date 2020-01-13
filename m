Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52618C33CA8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A43D2084D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgAMKLm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 05:11:42 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2260 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgAMKLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 05:11:42 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 523AA4E041E01063F6F0;
        Mon, 13 Jan 2020 10:11:41 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 10:11:40 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 13 Jan
 2020 10:11:40 +0000
Subject: Re: Failed to disable WCE for a SATA disk
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>,
        Jason Yan <yanaijie@huawei.com>
References: <a3624979-0917-4b66-ca18-89e0e2dd3bf2@hisilicon.com>
 <d6e8987b-e44e-661e-7338-321583e9fb75@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <55db2e1d-5a3c-55e1-1513-25506ebf3d8f@huawei.com>
Date:   Mon, 13 Jan 2020 10:11:39 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <d6e8987b-e44e-661e-7338-321583e9fb75@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2020 03:30, chenxiang (M) wrote:

+ Jason

> Hi,
> 
> 在 2019/12/11 11:21, chenxiang (M) 写道:
>> Hi,
>>
>> I encounter a issue related to libata and libsas. For hisi_sas driver, 
>> it uses libsas. When disable WCE with tool sdparm (sdparm --clear=WCE 
>> /dev/sda) for a SATA disk,
>> it fails with error info from hardware (the error info indicates that 
>> the length of transfer data is conflicted with the direction of data, 
>> the length is 0 but
>> the data of direction is from host to device).
>>
>> I check the process: When disable WCE, it sends pasthrough IO with 
>> sg_io , req->__data_len is not 0, and scsi_cmd->sc_data_direction = 
>> DMA_TO_DEVICE.
>> But for the command (MODE_SELECT), qc->tf.protocol is set 0 (not 
>> ATA_PROT_DMA) in ->queuecommand() 
>> ->ata_sas_queuecmd()->ata_scsi_translate()->ata_scsi_mod_select_xlat()->ata_mselect_caching(), 
>>
>> so it doesn't dma map ata sg in function ata_qc_issue(). While in 
>> function sas_ata_qc_issue()，it calcutes the length with the total sum 
>> of sg_dma_len(sg), as for the
>> command it doesn't dma map ata sg, so the length is 0.
>>
>> Do we need to dma map ata sg for the command? Or is it really we need 
>> the data for the command MODE_SELECT?
> 
> Does anyone have idea about it ?
> 
>>
>> Thanks,
>> Shawn
>>
>>
>>
>>
>> .
>>
> 
> 
> .

