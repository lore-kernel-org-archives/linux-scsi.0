Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8470CCDB474
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 01:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjJMBIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 21:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjJMBIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 21:08:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854E283;
        Thu, 12 Oct 2023 18:08:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD487C433C7;
        Fri, 13 Oct 2023 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697159312;
        bh=ML6uoRicNOmJrp5I03RV7bvjPAwz4gLYwFH/1sU6d/k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SLPqV+9dS+4ZYDfKHxXKnSMDdJ3x7CM3OUYMRRcbxBAZ8NcQcctB56VSfTO7qAFRy
         9BKXGi+XHNoq8njqCA6YCfkjdSJn+XO97GxeF8OQzUIm5PqoyoTiLKfZmtVFLJy5M/
         093uWig4kJAFijlFhg73S5qy6XCNVaLoNYT+ql4uPMe+yVKnduaRLTWJhhrNktJ88K
         FM9E9nq7sNiOhMkzM4augt1Sk/7RyWMOXberY9rF4I/GWUcZJK6LnxZLBUt892AZ9I
         AVvlawNibk8Wke9Ca51WrhCcsdr9QSMaWkje8SWL1cV4+IK92QF5l1bXbNkqaea3GB
         +ymx2sZxc7hFQ==
Message-ID: <2fa9ea51-c343-4cc2-b755-a5de024bb32f@kernel.org>
Date:   Fri, 13 Oct 2023 10:08:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <20231005194129.1882245-4-bvanassche@acm.org>
 <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
 <46c17c1b-29be-41a3-b799-79163851f972@acm.org>
 <b0b015bf-0a27-4e89-950a-597b9fed20fb@acm.org>
 <447f3095-66cb-417b-b48c-90005d37b5d3@kernel.org>
 <4fee2c56-7631-45d2-b709-2dadea057f52@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <4fee2c56-7631-45d2-b709-2dadea057f52@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/23 03:00, Bart Van Assche wrote:
> On 10/11/23 18:02, Damien Le Moal wrote:
>> Some have stated interest in CDL in NVMe-oF context, which could
>> imply that combining CDL and lifetime may be something useful to do
>> in that space...
> 
> We are having this discussion because bi_ioprio is sixteen bits wide and
> because we don't want to make struct bio larger. How about expanding the
> bi_ioprio field from 16 to 32 bits and to use separate bits for CDL
> information and data lifetimes?

I guess we could do that as well. User side aio_reqprio field of struct aiocb,
which is used by io_uring and libaio, is an int, so 32-bits also. Changing
bi_ioprio to match that should not cause regressions or break user space I
think. Kernel uapi ioprio.h will need some massaging though.

> This patch does not make struct bio bigger because it changes a three
> byte hole with a one byte hole:

Yeah, but if the kernel is compiled with struct randomization, that does not
really apply, doesn't it ?

Reading Niklas's reply to Kanchan, I was reminded that using ioprio hint for
the lifetime may have one drawback: that information will be propagated to the
device only for direct IOs, no ? For buffered IOs, the information will be
lost. The other potential disadvantage of the ioprio interface is that we
cannot define ioprio+hint per file (or per inode really), unlike the old
write_hint that you initially reintroduced. Are these points blockers for the
user API you were thinking of ? How do you envision the user specifying
lifetime ? Per file ? Or are you thinking of not relying on the user to specify
that but rather the FS (e.g. f2fs) deciding on its own ? If it is the latter, I
think ioprio+hint is fine (it is simple). But if it is the former, the ioprio
API may not be the best suited for the job at hand.

-- 
Damien Le Moal
Western Digital Research

