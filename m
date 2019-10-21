Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF45CA9EA0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 01:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7110B2064A
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 01:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfJUBuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Oct 2019 21:50:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbfJUBuU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 20 Oct 2019 21:50:20 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8FE927B08909C3ACA811;
        Mon, 21 Oct 2019 09:50:17 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 09:50:07 +0800
Subject: Re: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable
 sshdr
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
CC:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yanaijie@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
 <f9c663fe-6359-fc7b-e9f5-cf173f6fafbe@suse.de> <yq1lftii2yi.fsf@oracle.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <b09013a1-648e-7cfc-9751-fc955161aba4@huawei.com>
Date:   Mon, 21 Oct 2019 09:49:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <yq1lftii2yi.fsf@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/10/18 21:43, Martin K. Petersen wrote:
> Hannes,
>
>> The one thing which I patently don't like is the ambivalence between
>> DRIVER_SENSE and scsi_sense_valid().  What shall we do if only _one_
>> of them is set?  IE what would be the correct way of action if
>> DRIVER_SENSE is not set, but we have a valid sense code?  Or the other
>> way around?
> I agree, it's a mess.
>
> (Sorry, zhengbin, you opened a can of worms. This is some of our oldest
> and most arcane code in SCSI)
>
>> But more important, from a quick glance not all drivers set the
>> DRIVER_SENSE bit; so for things like hpsa or smartpqi the sense code is
>> never evaluated after this patchset.
> And yet we appear to have several code paths where sense evaluation is
> contingent on DRIVER_SENSE. So no matter what, behavior might
> change if we enforce consistent semantics. *sigh*

So what should we do to prevent unit-value access of sshdr?

1. still init sshdr in __scsi_execute?

@@ -255,6 +255,13 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;

+	/*
+	 * Zero-initialize sshdr for those callers that check the *sshdr
+	 * contents even if no sense data is available.
+	 */
+	if (sshdr)
+		memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
+
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);

2. init sshdr in callers of scsi_execute, instead of check the result of scsi_execute and check
whether sshdr is valid? for example:
@@ -506,6 +506,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
        put_unaligned_be32(len, &cmd[6]);
        memset(buffer, 0, len);

+       memset(&sshdr, 0 ,sizeof(sshdr));
        result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
                                  &sshdr, 30 * HZ, 3, NULL)

Besides, should sd_pr_command init sshdr?? cause sd_pr_command  have checked the result of scsi_execute 
and check whether sshdr is valid.


3. get rid of DRIVER_* completely? even this, we should init sshdr first. 


sshdr is just 8 bytes, init it does not affect performance

My advice is 2.

>
>> I _really_ would prefer to ditch the 'DRIVER_SENSE' bit, and rely on
>> scsi_sense_valid() only.
> I would really like to get rid of DRIVER_* completely. Except for
> DRIVER_SENSE, few are actually in use:
>
> DRIVER_OK: 	0
> DRIVER_BUSY:	0
> DRIVER_SOFT:	0
> DRIVER_MEDIA:	0
> DRIVER_ERROR:	6
> DRIVER_INVALID:	4
> DRIVER_TIMEOUT:	1
> DRIVER_SENSE:	58
>
> Johannes: Whatever happened to your efforts at cleaning all this up? Do
> you have a patch series or a working tree we could use as starting
> point?
>

