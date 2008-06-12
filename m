From: Tejun Heo <htejun@gmail.com>
Subject: Re: Prevent busy looping
Date: Thu, 12 Jun 2008 12:06:49 +0900
Message-ID: <485092C9.3050309@gmail.com>
References: <20080416151305.8788.63912.stgit@denkblock.local>	<20080416163152.GK12774@kernel.dk>	<87r6d5l9pb.fsf@denkblock.local>	<20080417071335.GR12774@kernel.dk>	<87ve2gc1bn.fsf@denkblock.local>	<484F7A8D.1040809@gmail.com> <20080611080502.4aa43980@core> <484F86D4.8050907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:65485 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYFLDGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 23:06:55 -0400
Received: by ti-out-0910.google.com with SMTP id b6so911644tic.23
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 20:06:53 -0700 (PDT)
In-Reply-To: <484F86D4.8050907@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Alan Cox wrote:
>>> Elias's synthetic test case triggered infinite loop because it wasn't
>>> a proper ->qc_defer().  ->qc_defer() should never defer commands when
>>> the target is idle.
>> Target or host ? We *do* defer commands in the case of an idle channel
>> when dealing with certain simplex controllers that can only issue one
>> command per host not one per cable (and in fact in the general case we
>> can defer commands due to activity on the other drive on the cable).
> 
> The term was confusing.  I used target to mean both device
> (ATA_DEFER_LINK) and host (ATA_DEFER_PORT).  Hmmm... in simplex case,
> yeah, blocked counters need to be > 1.  We'll need to increase blocked
> counts after all.  I'll test blocked counts of 2 w/ PMP and make sure it
> doesn't incur unnecessary delays and post the patch.

Setting blocked counts to 2 makes simplex scheduling starve one of the
drives.  When a drive loses competition, it retries only after plug
delay and of course it loses most of the time.  For now, it seems we'll
have to live with busy loops (which doesn't lock up the machine) for
simplex controllers.  Ewww... :-(

-- 
tejun
