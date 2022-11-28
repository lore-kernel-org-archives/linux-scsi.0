Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803ADC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 03:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiK1D6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Nov 2022 22:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiK1D6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Nov 2022 22:58:41 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C412D3D
        for <linux-scsi@vger.kernel.org>; Sun, 27 Nov 2022 19:58:40 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLBWn2TMWzHwCH;
        Mon, 28 Nov 2022 11:57:57 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 11:58:37 +0800
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 11:58:36 +0800
Message-ID: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
Date:   Mon, 28 Nov 2022 11:58:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   Wenchao Hao <haowenchao@huawei.com>
Subject: [QUESTION]: Why did we clear the lowest bit of SCSI command's status
 in scsi_status_is_good
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James Bottomley" <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linfeilong@huawei.com>,
        <yanaijie@huawei.com>, <xuhujie@huawei.com>, <lijinlin3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggpeml100007.china.huawei.com (7.185.36.28) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

static inline bool scsi_status_is_good(int status)                                                                                                                                                             
{
        if (status < 0)
                return false;

        if (host_byte(status) == DID_NO_CONNECT)
                return false;

        /*  
         * FIXME: bit0 is listed as reserved in SCSI-2, but is
         * significant in SCSI-3.  For now, we follow the SCSI-2
         * behaviour and ignore reserved bits.
         */
        status &= 0xfe;
        return ((status == SAM_STAT_GOOD) ||
                (status == SAM_STAT_CONDITION_MET) ||
                /* Next two "intermediate" statuses are obsolete in SAM-4 */
                (status == SAM_STAT_INTERMEDIATE) ||
                (status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
                /* FIXME: this is obsolete in SAM-3 */
                (status == SAM_STAT_COMMAND_TERMINATED));
}
We have function defined in include/scsi/scsi.h as above, which is used to check
if the status in result is good.

But the function cleared the lowest bit of SCSI command's status, which would
translate an undefined status to good in some condition, for example the status
is 0x1.

This code seems introduced in this patch:
https://lore.kernel.org/all/1052403312.2097.35.camel@mulgrave/

Is anyone who knows why did we clear the lowest bit? 

We found some firmware or drivers would return status which did not defined in
SAM. Now SCSI middle level do not have an uniform behavior for these undefined
status. I want to change the logic to return error for all status which did not
defined in SAM or define a method in host template to let drivers to judge
what to do in this condition.
