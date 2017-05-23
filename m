From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller
 generated GPF in sg_read path
Date: Tue, 23 May 2017 08:39:56 -0600
Message-ID: <5417a4c9-fb9f-af9e-fa4a-fffb113a0f30@kernel.dk>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
 <20170522175905.GA17738@vader.DHCP.thefacebook.com>
 <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
 <f278026c-42f6-9022-f72a-84439141f5d7@kernel.dk>
 <491d4221-8d89-8284-0971-d6f0e47b6463@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36132 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966793AbdEWOj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 10:39:59 -0400
Received: by mail-it0-f48.google.com with SMTP id o5so20588680ith.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2017 07:39:58 -0700 (PDT)
In-Reply-To: <491d4221-8d89-8284-0971-d6f0e47b6463@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 05/23/2017 08:25 AM, Johannes Thumshirn wrote:
> On 05/23/2017 04:15 PM, Jens Axboe wrote:
>> Add some code to the framework that allows you to get the corresponding
>> SG device for a SCSI block device? Make that part of the prepare, skip
>> the test if the block device isn't a SCSI dev.
> 
> Well the code is already there (in patch 2/3).
> 
> I'll pack it into the prepare stage.

I tried to look up that commit:

 48ae8484e9fc ("scsi: sg: don't return bogus Sg_requests")

but that isn't in Linus' tree. Even searched for just the title, still
didn't find anything.

I'm assuming this is a bug in the sg.c driver, in which case the 2/3
prep and real test case looks fine. For generic device testing, we
should just use SG_IO and not bother with sg.c at all. The world would
be a better place if we could just get rid of sg.c...

-- 
Jens Axboe
