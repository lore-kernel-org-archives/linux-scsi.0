From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 12:42:40 -0700
Message-ID: <54665B30.4070708@kernel.dk>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org> <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51400 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161586AbaKNTmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 14:42:44 -0500
Received: by mail-pa0-f47.google.com with SMTP id kx10so18145137pab.20
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2014 11:42:44 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

On 11/14/2014 12:35 PM, Meelis Roos wrote:
>> Paul, what's the best way to figure out these CPU stalls?
>>
>> The second oops is in blk_mq_map_queue() which is a trivial
>> two level cpu lookup.  I wonder if there's something odd about
>> cpu numbers on these big old sparc systems?
> 
> CPU numbers are sparse - they are determined by hardware slot number and 
> some models only fill every other mainboard slot, and first slots can be 
> free. I have first board offline and currently have CPUs numbered 
> 10,11,14,15 online.
>  
> Here is debug with Jens's patch:

> [  133.971050] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 516 cycles)
> [  133.975491] CPU 14: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
> [  133.979943] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
> [  133.980146] Brought up 4 CPUs

So this looks like this might be the issue. On a scsi-mq disabled boot,
you have 4 CPUs, but how are they numbered?

We might need Christophs debug patch on top this to fully know...

-- 
Jens Axboe

