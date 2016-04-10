From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Sun, 10 Apr 2016 22:02:06 +0300
Message-ID: <570AA32E.8070709@grimberg.me>
References: <57079616.4000202@suse.de> <20160408174006.GI2781@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36657 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908AbcDJTCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2016 15:02:15 -0400
In-Reply-To: <20160408174006.GI2781@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Hannes Reinecke <hare@suse.de>
Cc: lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

Hey Willy,

>   - Interrupt steering needs to be controlled by block-mq instead of
>     the driver.  It's pointless to have each driver implement its own
>     policies on interrupt steering, irqbalanced remains a source of
>     end-user frustration, and block-mq can change the queue<->cpu mapping
>     without the driver's knowledge.

I honestly don't think that block-mq is the right place to
*assign* interrupt steering. Not all HW devices are dedicated
to storage, take RDMA for example, a RNIC is shared by block
storage, networking and even user-space workloads so obviously
block-mq can't understand how a user wants to steer interrupts.

I think that block-mq needs to ask the device driver:
"what is the optimal queue index for cpu X?" and use it
while *someone* will be responsible for optimum interrupt
steering (can be the driver itself or user-space).

 From some discussions I had with HCH I think he intends to
use the cpu reverse-mapping API to try and do what's described
above (if I'm not mistaken).
