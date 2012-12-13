From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 12:40:27 +0100
Message-ID: <50C9BEAB.6010702@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C6ED1A.7040404@acm.org> <20121211224626.GB20898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:60266 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LMLka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 06:40:30 -0500
In-Reply-To: <20121211224626.GB20898@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/11/12 23:46, scameron@beardog.cce.hp.com wrote:
> I would be curious to see what kind of results you would get with scsi_debug
> with fake_rw=1.  I am sort of suspecting that trying to put an "upper limit"
> on scsi LLD IOPS performance by seeing what scsi_debug will do with fake_rw=1
> is not really valid (or, maybe I'm doing it wrong) as I know of one case in
> which a real HW scsi driver beats scsi_debug fake_rw=1 at IOPS on the very
> same system, which seems like it shouldn't be possible.  Kind of mysterious.

The test

# disable-frequency-scaling
# modprobe scsi_debug delay=0 fake_rw=1
# echo 2 > /sys/block/sdc/queue/rq_affinity
# echo noop > /sys/block/sdc/queue/scheduler
# echo 0 > /sys/block/sdc/queue/add_random

results in about 800K IOPS for random reads on the same setup (with a 
request size of 4 KB; CPU: quad core i5-2400).

Repeating the same test with fake_rw=0 results in about 651K IOPS.

Bart.
