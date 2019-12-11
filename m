Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E003C2D0C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 03:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9060214D8
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 03:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLKDWC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:22:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbfLKDWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 22:22:02 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 86EDA17B335F7DBE9168;
        Wed, 11 Dec 2019 11:21:59 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 11:21:50 +0800
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Failed to disable WCE for a SATA disk
To:     "axboe@kernel.dk" <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Message-ID: <a3624979-0917-4b66-ca18-89e0e2dd3bf2@hisilicon.com>
Date:   Wed, 11 Dec 2019 11:21:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I encounter a issue related to libata and libsas. For hisi_sas driver, 
it uses libsas. When disable WCE with tool sdparm (sdparm --clear=WCE 
/dev/sda) for a SATA disk,
it fails with error info from hardware (the error info indicates that 
the length of transfer data is conflicted with the direction of data, 
the length is 0 but
the data of direction is from host to device).

I check the process: When disable WCE, it sends pasthrough IO with sg_io 
, req->__data_len is not 0, and scsi_cmd->sc_data_direction = DMA_TO_DEVICE.
But for the command (MODE_SELECT), qc->tf.protocol is set 0 (not 
ATA_PROT_DMA) in ->queuecommand() 
->ata_sas_queuecmd()->ata_scsi_translate()->ata_scsi_mod_select_xlat()->ata_mselect_caching(),
so it doesn't dma map ata sg in function ata_qc_issue(). While in 
function sas_ata_qc_issue()，it calcutes the length with the total sum of 
sg_dma_len(sg), as for the
command it doesn't dma map ata sg, so the length is 0.

Do we need to dma map ata sg for the command? Or is it really we need 
the data for the command MODE_SELECT?

Thanks,
Shawn



