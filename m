Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E4AC2B9F7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 01:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4CF861415
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 01:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhEYBfp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 21:35:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:29702 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhEYBfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 21:35:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621906455; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=SXw/U+AQC0nvjNPVGNJlJ4LRDlKV1Sc2Sljl57kUfes=; b=uRUBctJdP6igEQyTxcQ4431DYjM2x9Qv8L5Fq+/U3w43Ehc0MrC7WMqreEVXcPI+FzmEaqld
 TcC+u0c/0BCdNsDaT3YLKlh4j8VZV6QumlmzdOCzrh6Y7fQ0IWb2LKehPExo2Q3aBLX+qmIK
 KBkzHAB0iFN32bM0Wn2IbUWd78s=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60ac54102bff04e53bf8f4b5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 May 2021 01:34:08
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2A221C43151; Tue, 25 May 2021 01:34:07 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0DEFBC433F1;
        Tue, 25 May 2021 01:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0DEFBC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d4ff8e1a-f368-6720-798a-a2a31a4d41fb@codeaurora.org>
Date:   Mon, 24 May 2021 18:34:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/2021 1:10 PM, Bart Van Assche wrote:
> On 5/24/21 1:36 AM, Can Guo wrote:
>> Current UFS IRQ handler is completely wrapped by host lock, and because
>> ufshcd_send_command() is also protected by host lock, when IRQ handler
>> fires, not only the CPU running the IRQ handler cannot send new requests,
>> the rest CPUs can neither. Move the host lock wrapping the IRQ handler into
>> specific branches, i.e., ufshcd_uic_cmd_compl(), ufshcd_check_errors(),
>> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to further
>> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host lock is
>> no longer required to call __ufshcd_transfer_req_compl(). As per test, the
>> optimization can bring considerable gain to random read/write performance.
> 

> An additional question is whether it is necessary for v3.0 UFS devices
> to serialize the submission path against the completion path? Multiple
> high-performance SCSI LLDs support hardware with separate submission and
> completion queues and hence do not need any serialization between the
> submission and the completion path. I'm asking this because it is likely
> that sooner or later multiqueue support will be added in the UFS
> specification. Benefiting from multiqueue support will require to rework
> locking in the UFS driver anyway.
> 
Hi Bart,
No it's not necessary to serialize both the paths. I think this series 
attempts to remove this serialization to a certain degree, which is 
what's giving the performance improvement.

Even if multiqueue support would be available in the future, I think 
this change is apt now for the current available specification.

> Thanks,
> 
> Bart.
> 


Thanks,
-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
