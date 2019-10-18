Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96934CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 06:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6994F20820
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 06:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504409AbfJRGdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 02:33:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4681 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392981AbfJRGdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 02:33:49 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6B42A83A44724D9CD6D8;
        Fri, 18 Oct 2019 10:47:45 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 10:47:38 +0800
Subject: Re: [PATCH v4 2/2] scsi: core: fix uninit-value access of variable
 sshdr
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>
References: <1571293177-117087-1-git-send-email-zhengbin13@huawei.com>
 <1571293177-117087-3-git-send-email-zhengbin13@huawei.com>
 <yq1y2xiixms.fsf@oracle.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <e14f87ac-5302-0a5e-0e77-bdc0933e332d@huawei.com>
Date:   Fri, 18 Oct 2019 10:46:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <yq1y2xiixms.fsf@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/10/18 10:40, Martin K. Petersen wrote:
> zhengbin,
>
>> We can init sshdr in sr_get_events, but there have many callers of
>> scsi_execute, scsi_execute_req, we have to troubleshoot all callers,
>> the simpler way is init sshdr in __scsi_execute.
> There aren't that many callers. I'd prefer to make sure that everybody
> is handling DRIVER_SENSE and scsi_sense_valid() correctly. Looks like
> we're generally OK, but please verify.

OK, I have troubleshoot callers, there are similar bug(scsi_report_opcode, cache_type_store, scsi_test_unit_ready, scsi_report_lun_scan, sd_spinup_disk, read_capacity_16,

read_capacity_10, sr_get_events, alua_rtpg, alua_stpg, send_trespass_cmd, hp_sw_tur, hp_sw_start_stop, send_mode_select, sd_sync_cache, sd_start_stop_device, sr_do_ioctl).

I modify these in a patch? or every .c a patch, use a patchset?

>
> Thanks!
>

