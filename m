Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC728C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Dec 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhLLDCf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Dec 2021 22:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhLLDCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Dec 2021 22:02:35 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38009C061714
        for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2021 19:02:35 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639278153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XfFwGkajSMMNjLHqX7vGYCF1nmPf3wlJ39uZHzYAAiA=;
        b=UYRDESn/AEFUZQRG6/AKuS78ligQPA5ivx9HflJPr+Ok2E6E9o/FP3l6n9tn7QVVRWeVJe
        //31fnATaHjzrby4am0noVAphO7IMEOZO82XObwDTVhO4qsa/r31x25y4Lwi+5NrO3zQ/b
        /zmFJCN+Wideba5NMmSBOtiTcjs3ws0=
To:     Bart Van Assche <bvanassche@acm.org>,
        Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com, xuyun@ramaxel.com,
        yanggan@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <b5002b52-3654-825c-f94f-f9ade708042e@acm.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanling song <yanling.song@linux.dev>
Message-ID: <fcb61728-00c3-08e5-9c5a-a545dabd3c58@linux.dev>
Date:   Sun, 12 Dec 2021 03:02:25 +0000
MIME-Version: 1.0
In-Reply-To: <b5002b52-3654-825c-f94f-f9ade708042e@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanling.song@linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 12/10/21 5:42 PM, Bart Van Assche wrote:
> On 11/25/21 11:33 PM, Yanling Song wrote:
>> +config RAMAXEL_SPRAID
>> +    tristate "Ramaxel spraid Adapter"
>> +    depends on PCI && SCSI && BLK_DEV_BSGLIB
>> +    depends on ARM64 || X86_64
> 
> Why is this driver restricted to ARM64 and X86_64 systems? What prevents
> compilation of this driver on other CPU architectures?
> 
The target market of spraid controller is ARM and X86.

In theory, spraid driver can also work on other CPU architectures but not tested yet.

>> +    help
>> +      This driver supports Ramaxel spraid driver.
> 
> The help text is too short. Please add one or two sentences about the interface
> type of this RAID controller (PCIe?) and also about the storage media supported
> by this RAID controller (SAS? SATA? any other?).
> 
More help text will be included in the next version:
This driver supports Ramaxel SPRxxx serial raid controller, which has PCIE Gen4 interface with host

and supports SAS/SATA Hdd/ssd.

>> +struct spraid_bsg_request {
>> +    u32  msgcode;
>> +    u32 control;
>> +    union {
>> +        struct spraid_passthru_common_cmd admcmd;
>> +        struct spraid_ioq_passthru_cmd    ioqcmd;
>> +    };
>> +};
> 
> Definitions like the above are required by user space software that uses the
> BSG interface and hence should be moved into a header file under include/uapi/.
> See e.g. include/uapi/scsi/scsi_bsg_ufs.h.
> 
The definitions are for our own private tool and cannot be used by others.

Does it make sense to put it in include/uapi/scsi?

> Thanks,
> 
> Bart.
