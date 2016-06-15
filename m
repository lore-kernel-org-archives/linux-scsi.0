From: Jens Axboe <axboe@kernel.dk>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Wed, 15 Jun 2016 12:03:40 +0200
Message-ID: <576127FC.9020608@kernel.dk>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de> <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
 <5760F6BC.60109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38305 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbcFOKDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2016 06:03:44 -0400
Received: by mail-wm0-f47.google.com with SMTP id m124so28199329wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 03:03:43 -0700 (PDT)
In-Reply-To: <5760F6BC.60109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On 06/15/2016 08:33 AM, Hannes Reinecke wrote:
> And as I've mentioned before: what is the purpose of this check?
>
> 'max_sectors' and 'max_hw_sectors' are checked during request assembly,
> and those limits are not changed even after calling
> blk_recalc_rq_segments(). And if we go over any device-imposed
> restrictions we'll be getting an I/O error from the driver anyway.
> So why have it at all?

You don't know that to be the case. The driver asked for certain limits, 
the core MUST obey them. The driver should not need to check for these 
limits, outside of in a BUG_ON() like manner.

> Especially as the system boots happily with this check removed...

That's the case for you, but you can't assume this to be the case in 
general.

There's a _lot_ of hand waving in this thread, Hannes. How do we 
reproduce this? We need to get this fixed for real, not just delete some 
check that triggers for you and that it just happens to work without. 
That's not how you fix problems.

-- 
Jens Axboe

