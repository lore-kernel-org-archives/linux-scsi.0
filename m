Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0F7C31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13C6220679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHLQcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:32:07 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37842 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLQcH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 12:32:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5A7E6204194;
        Mon, 12 Aug 2019 18:32:03 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2CsMPOFPosj0; Mon, 12 Aug 2019 18:32:00 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 17A15204155;
        Mon, 12 Aug 2019 18:31:58 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 08/20] sg: speed sg_poll and sg_get_num_waiting
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-9-dgilbert@interlog.com>
 <20190812143101.GA16127@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <23406ca1-a7b8-1611-78c5-8bb016c218d5@interlog.com>
Date:   Mon, 12 Aug 2019 12:31:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812143101.GA16127@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:31 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:40PM +0200, Douglas Gilbert wrote:
>> Track the number of submitted and waiting (for read/receive)
>> requests on each file descriptor with two atomic integers.
>> This speeds sg_poll() and ioctl(SG_GET_NUM_WAITING) which
>> are oft used with the asynchronous (non-blocking) interfaces.
> 
> The idea of just tracking a count here seems sensible.

With the added benefit of ioctl(SG_GET_NUM_WAITING) becoming O(1).
I clocked it an 500 nanoseconds per invocation on my laptop.

> Tiny nitpick below:
> 
>> +	else if (likely(sfp->cmd_q))
>> +		p_res |= EPOLLOUT | EPOLLWRNORM;
>> +	else if (atomic_read(&sfp->submitted) == 0)
>>   		p_res |= EPOLLOUT | EPOLLWRNORM;
> 
> Why not simply:
> 
> 	 else if (sfp->cmd_q || atomic_read(&sfp->submitted)
>   		p_res |= EPOLLOUT | EPOLLWRNORM;

Loses the "likely", doesn't compile, and is logically wrong.
Brown paper bag :-)


And this is getting beyond a joke. I have had to repeatedly rebuild
dev kernels because:
    1) Torvalds forces Martin to use buggy "rc1" kernels in his
       scsi-queue branches, and
    2) in lk 5.3-rc1 there is your snafu in scsi_lib.c

Please go light on such "optimizations".

Doug Gilbert
