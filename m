From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Fri, 13 Nov 2015 10:51:14 -0600
Message-ID: <56461502.70306@cs.wisc.edu>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
 <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu>
 <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50560 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbbKMQvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2015 11:51:31 -0500
In-Reply-To: <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, mchristi@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, Shlomo Pongratz <shlomopongratz@gmail.com>

On 11/13/2015 09:06 AM, Or Gerlitz wrote:
>> The patch has caused multiple regressions, did not even compile when
>> > sent to me, and was poorly reviewed and I have not heard from you guys
>> > in a week. Given the issues the patch has had and the current time, I do
>> > not feel comfortable with it anymore. I want to re-review it and fix it
>> > up when there is more time.
> Mike (Hi),
> 
> It's a complex patch that touches all the iscsi transports, and yes,
> when it was send to you the 1st time, there was build error on one of
> the offload transports (bad! but happens) and yes, as you pointed, one
> static checker fix + one bug fix for it went upstream after this has
> been merged, happens too.

A patch should not cause this many issues.

> What makes you say it was poorly reviewed?

I just did not do a good job at looking at the patch. I should have
caught all of these issues.

- The bnx2i cleanup_task bug should have been obvious, especially for me
because I had commented about the back lock and the abort path.

- This oops, was so basic. Incorrect locking around a linked list being
accessed from 2 threads is really one of those 1st year kernel
programmer things.

- The iscsi_xmit_task static checker locking was really simple too.

- There was the issue offlist I emailed you guys about where I started
to try and fix/review it yesterday, and I found another race in the
abort and completion path that can result in a null pointer reference.

- I have not had time to fully review it again, but I think the the
reset/recovery code looks shady too.

> 
> And now after few years in upstream a possibly real bug was found
> (happens), why rush and revert? lets see if we can fix.

Send patches.
