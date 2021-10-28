Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63462C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4274C61056
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJ1Ufq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:35:46 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51762 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhJ1Ufp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 16:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635453198;
        bh=cSZBm0trHz1EnFTZoBXBXvs8X4Y8AfvRTslBGZ+VMEU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=T7A0/ovwPsaP1m0wEvOR2VhCtiZMK9rRu+OM/OaqVp11IBHMkHXp0pd8+AtIxsPdF
         L1L4NtVxekNGT/TF3F2ryXi+WYhuW8X2lsyFShDk0BPnB2U/BfrfoKIGpcM9kfInDS
         fy30iPfEdFd/3B30/j7gN4tAWcJTYKp7s5DPkrZw=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 12FD21280CAB;
        Thu, 28 Oct 2021 16:33:18 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ETgKuIeG6ep6; Thu, 28 Oct 2021 16:33:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635453197;
        bh=cSZBm0trHz1EnFTZoBXBXvs8X4Y8AfvRTslBGZ+VMEU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=RQ2V1m0kPrFTWeAUpbc7TfIpKCj17D/qdRGUrl052MNYP8DPpk89EnjTMbHhK63Yd
         2tGuMY94LlZXWm3VQWbFOHDpV7QzD7NkN8VxX4yKfvR/SjFC6PnG54SccGtiuH/JL+
         XLQnjMsqzSIGwg5NWCjzwzzZxl9c/vTvkhoN2dHM=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 178EA1280CA9;
        Thu, 28 Oct 2021 16:33:17 -0400 (EDT)
Message-ID: <4f16a99974be6f2a0f207d5ca7327719cdf4e36e.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>
Date:   Thu, 28 Oct 2021 16:33:15 -0400
In-Reply-To: <a6af2ce7-4a03-ab0c-67cd-c58022e5ded1@acm.org>
References: <20211026071204.1709318-1-hch@lst.de>
         <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
         <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
         <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
         <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
         <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
         <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
         <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
         <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
         <20211027052724.GA8946@lst.de>
         <b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com>
         <a6af2ce7-4a03-ab0c-67cd-c58022e5ded1@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-10-28 at 13:21 -0700, Bart Van Assche wrote:
[...]
> Hi James,
> 
> The help with trying to find a solution is appreciated.
> 
> One of the software developers who is familiar with HPB explained to
> me that READ BUFFER and WRITE BUFFER commands may be received in an
> arbitrary order by UFS devices. The UFS HPB spec requires UFS devices
> to be able to stash up to 128 such pairs. I'm concerned that leaving
> out WRITE BUFFER commands only will break the HPB protocol in a
> subtle way.

Based on the publicly available information (the hotstorage paper) I
don't belive it can.  The Samsung guys also appear to confirm that the
use of WRITE BUFFER is simply an optimzation for large requests:

https://lore.kernel.org/all/20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3/

As did the excerpt from the spec you posted.  It will cause slowdowns
for reads of > 32kb, because they have to go through the native FTL
lookup now, but there shouldn't be any functional change.  Unless
there's anything else in the proprietary spec that contradicts this?

James



