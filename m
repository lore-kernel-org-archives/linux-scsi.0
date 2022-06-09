Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC4EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 12:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbiFIMH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245106AbiFIMHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 08:07:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD42B264DC8
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:07:54 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJjVy75gTz67Psy;
        Thu,  9 Jun 2022 20:06:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 14:07:52 +0200
Received: from [10.47.88.201] (10.47.88.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 9 Jun
 2022 13:07:51 +0100
Message-ID: <d8739294-b561-ec24-f148-dda4ceb4e9a0@huawei.com>
Date:   Thu, 9 Jun 2022 13:07:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 2/3] scsi: libsas: introduce struct smp_rg_resp
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-3-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220609022456.409087-3-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.88.201]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/06/2022 03:24, Damien Le Moal wrote:
> When compiling with gcc 12, several warnings are thrown by gcc when
> compiling drivers/scsi/libsas/sas_expander.c, e.g.:
> 
> In function ‘sas_get_ex_change_count’,
>      inlined from ‘sas_find_bcast_dev’ at
>      drivers/scsi/libsas/sas_expander.c:1816:8:
> drivers/scsi/libsas/sas_expander.c:1781:20: warning: array subscript
> ‘struct smp_resp[0]’ is partly outside array bounds of ‘unsigned
> char[32]’ [-Warray-bounds]
>   1781 |         if (rg_resp->result != SMP_RESP_FUNC_ACC) {
>        |             ~~~~~~~^~~~~~~~
> 
> This is due to the use of the struct smp_resp to aggregate all possible
> response types using a union but allocating a response buffer with a
> size exactly equal to the size of the response type needed. This leads
> to access to fields of struct smp_resp from an allocated memory area
> that is smaller than the size of struct smp_resp.
> 
> Fix this by defining struct smp_rg_resp for sas report general
> responses.
> 
> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>
