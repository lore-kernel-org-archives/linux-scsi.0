Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B2DC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Dec 2021 03:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhLLDEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Dec 2021 22:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhLLDEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Dec 2021 22:04:40 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3339DC061714
        for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2021 19:04:40 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639278278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5H7k/QmCgUxKiMha6p6YAo9eO6jw/64j4RKkUvLMNA=;
        b=euuJR6y1B6L3tGBRARcOS8HYHAhZng1uzc8LBYx+OwrIu70p8A1IKAV7EFi7ylSHdf+4Px
        Dj8Dv0Vr4mdA5t9mqWydhZlihnECo61Lv/5BJFfHOOfdvsxzw5D/FHsoCUQUInrEy5v2hD
        GP+0J91A14k/dh29qSvIZpSk+By2+rE=
To:     Bart Van Assche <bvanassche@acm.org>,
        Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com, xuyun@ramaxel.com,
        yanggan@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <6207ff07-b64b-a147-ed49-f194c81bb9ac@acm.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanling song <yanling.song@linux.dev>
Message-ID: <9f492efa-4e8c-f135-d922-1e02fbc602ed@linux.dev>
Date:   Sun, 12 Dec 2021 03:04:34 +0000
MIME-Version: 1.0
In-Reply-To: <6207ff07-b64b-a147-ed49-f194c81bb9ac@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanling.song@linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 12/10/21 9:40 PM, Bart Van Assche wrote:
> On 11/25/21 11:33 PM, Yanling Song wrote:
>> +/* bsg dispatch user command */
>> +static int spraid_bsg_host_dispatch(struct bsg_job *job)
>> +{
>> +    struct Scsi_Host *shost = dev_to_shost(job->dev);
>> +    struct spraid_dev *hdev = shost_priv(shost);
>> +    struct request *rq = blk_mq_rq_from_pdu(job);
>> +    struct spraid_bsg_request *bsg_req = (struct spraid_bsg_request *)(job->request);
> 
> Since job->request has type 'void *', no cast is necessary when assigning job->request to
> bsg_req. Hence please leave out the cast.
> 
Ok. The cast will be removed in the next verison.

> Thanks,
> 
> Bart.
