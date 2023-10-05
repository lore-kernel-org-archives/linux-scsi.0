Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0EDE92702
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 13:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjJENz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 09:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243972AbjJENud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 09:50:33 -0400
X-Greylist: delayed 533 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Oct 2023 02:34:49 PDT
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [IPv6:2001:41d0:203:375::be])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8C2A5FE
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 02:34:48 -0700 (PDT)
Message-ID: <c0665377-d2be-e4b6-3d25-727ef303d26e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696497937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8/XbE8gP0R5n5VOgy0224cCsYOet41U373eOZr5Idw8=;
        b=PRoEAk6RYEcN6+72/6ZuSklLwRz/qUwiSpgtJxplv8LhZFN//iHB1hi6qRoGlxpNdfsT3+
        X/2YlXgOJrk9oX3a6nqMpLBJLkO/NQ0kf00CSKxr1FfIZ6xBEK/vm575ZKlRfGRiFp1jhp
        U6wyvUBCjXNDSY+mDNhp7v+2OIXWUUc=
Date:   Thu, 5 Oct 2023 17:25:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, matsuda-daisuke@fujitsu.com,
        shinichiro.kawasaki@wdc.com, linux-scsi@vger.kernel.org,
        Zhu Yanjun <yanjun.zhu@intel.com>
References: <20230922163231.2237811-1-yanjun.zhu@intel.com>
 <169572143704.2702191.3921040309512111011.b4-ty@kernel.org>
 <20230926140656.GM1642130@unreal>
 <d3c05064-a88b-4719-a390-6bf9ae01fba5@acm.org>
 <b7b365e3-dd11-bc66-dace-05478766bf41@gmail.com>
 <2d5e02d7-cf84-4170-b1a3-a65316ac84ee@acm.org>
 <2fcef3c8-808e-8e6a-b23d-9f1b3f98c1f9@linux.dev>
 <552f2342-e800-43bc-b859-d73297ce940f@acm.org>
 <20231004183824.GQ13795@ziepe.ca>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20231004183824.GQ13795@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

在 2023/10/5 2:38, Jason Gunthorpe 写道:
> On Wed, Oct 04, 2023 at 10:43:20AM -0700, Bart Van Assche wrote:
> 
>> Thank you for having reported this. I'm OK with integrating the
>> above change in my patch. However, code changes must be
>> motivated. Do you perhaps have an explanation of why WQ_HIGHPRI
>> makes the issue disappear that you observed?
> 
> I think it is clear there are locking bugs in all this, so it is not
> surprising that changing the scheduling behavior can make locking bugs
> hide
> 
> Jason

With the flag WQ_HIGHPRI, an ordered workqueue with high priority is 
allocated. With this workqueue, to now, the test has run for several 
days. And the problem did not appear. So to my test environment, this 
problem seems fixed with the above commit.

I doubt, without the flag WQ_HIGHPRI, the workqueue is allocated with 
normal priority. The work item in this workqueue is more likely 
preempted than high priority work queue.

Best Regards,
Zhu Yanjun
