From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 4/4] 2.4 SCSI error handling fixes
Date: Mon, 23 Sep 2002 11:54:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209231554.g8NFsRA02460@localhost.localdomain>
References: <rmk@arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pogo.mtv1.steeleye.com (host194.steeleye.com [66.206.164.34])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id g8NGt7A21564
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 09:55:07 -0700
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA08367
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 08:54:37 -0700
In-Reply-To: Message from Russell King <rmk@arm.linux.org.uk>
   of "Thu, 12 Sep 2002 19:18:24 BST." <20020912191824.D4739@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

rmk@arm.linux.org.uk said:
> *** NOTE *** This needs a better solution.  Setting the FUA bit
> bypasses the drives cache altogether.  You should read the message at
> the URL above *before* commenting for a detailed explaination of the
> problem, and why I've had to make this change. 

I read the message.  I think your drive is out of spec in its behaviour.

Patches 1-3 look fine. Patch 4 would kill our performance on huge cache RAID 
arrays (guess what most benchmarks are done on).

I think the correct (but much more invasive) fix for this is to return all 
MEDIUM errors immediately to the upper level driver (sd or sr) and let them do 
error recovery (i.e. determine whether retry should be done).  Once the upper 
level drivers do the retry, you can reliably add the FUA bit to the command 
for the retry.  Thus we'd only use FUA in the retry case and normal caching 
performance shouldn't be impacted.

Do you want to try doing it this way?

James


