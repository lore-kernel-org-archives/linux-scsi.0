From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: [PATCH] scsi/block: increase flush/sync timeout
Date: Wed, 25 Aug 2010 02:36:35 +0200
Message-ID: <201008250236.35593.bs_lists@aakef.fastmail.fm>
References: <1280863560-4747-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46353 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab0HYAgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2010 20:36:38 -0400
In-Reply-To: <1280863560-4747-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk, Mike Christie <mchristi@redhat.com>, Bernd Schubert <bschubert@ddn.com>

On Tuesday, August 03, 2010, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> We have been seeing the flush request timeout with a wide
> range of hardware from tgt+iser to FC targets from a major vendor.
> 
> I did this patch which added a flush timeout:
> http://marc.info/?l=linux-scsi&m=127957359200466&w=2
> 
> A problem with that patch is how to determine what value
> should be set and when you need to set it. You will
> not know that you need to increase until it times out
> and fails, then to figure out what to set it to you
> need to set the timeout and try it out a couple times.
> 
> So this patch just increases the flush/sync cache timeout
> to 2 minutes. In testing, it has taken at most around 60
> seconds to complete the operation, so I thought 120 would
> be safe and not add that long of delay if the device was
> really jammed and needed the scsi eh.

Sorry for my late reply. Doesn't it depend on the device cache how long it 
takes? 120s is should be sufficient for everything I worked with, but then 
there are units out there that that have far more cache. Although I don't know 
if those honor the SYNC_CACHE command. Personally I would prefer the previous 
patch as it allows it to tune it with udev (*). So shouldn't just the previous 
patch be updated to 120s default timeout?


Thanks,
Bernd

PS: I just think it is a bit confusing to have different timeouts in differnt 
directories (/sys/block/sdX/device/timeout and 
/sys/block/sdX/queue/flush_timeout). The patch I have on my disk, which I 
never managed to test and therefore never sent to the list, added it to 
/sys/block/sdX/device.




-- 
Bernd Schubert
DataDirect Networks
