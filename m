Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068DCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 09:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiC2JIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiC2JIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 05:08:16 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781C0242200;
        Tue, 29 Mar 2022 02:06:33 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KSNtY40TWzfZVc;
        Tue, 29 Mar 2022 17:04:53 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 29 Mar 2022 17:06:31 +0800
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 29 Mar 2022 17:06:31 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
Subject: [REQUEST DISCUSS]: speed up SCSI error handle for host with massive
 devices
To:     <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>
CC:     Wu Bo <wubo40@huawei.com>, Feilong Lin <linfeilong@huawei.com>,
        <zhangjian013@huawei.com>
Message-ID: <71e09bb4-ff0a-23fe-38b4-fe6425670efa@huawei.com>
Date:   Tue, 29 Mar 2022 17:06:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI timeout would call scsi_eh_scmd_add() on some conditions, host 
would be set
to SHOST_RECOVERY state. Once host enter SHOST_RECOVERY, IOs submitted 
to all
devices in this host would not succeed until the scsi_error_handler() 
finished.
The scsi_error_handler() might takes long time to be done, it's 
unbearable when
host has massive devices.

I want to ask is anyone applying another error handler flow to address this
phenomenon?

I think we can move some operations(like scsi get sense, scsi send startunit
and scsi device reset) out of scsi_unjam_host(), to perform these operations
without setting host to SHOST_RECOVERY? It would reduce the time of 
block the
whole host.

Waiting for your discussion.
