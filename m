From: Tejun Heo <htejun@gmail.com>
Subject: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 15:40:08 +0900
Message-ID: <43E99248.7090505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.194]:4534 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030573AbWBHGkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 01:40:17 -0500
Received: by uproxy.gmail.com with SMTP id s2so172955uge
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2006 22:40:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello, James.

Now that new ordered implementation is in the mainline, we can properly 
use ordered-tag during barrier sequence.  As noted in the barrier doc, 
the problem with the current SCSI midlayer is that scsi_request_fn() is 
not atomic w.r.t. q->queuelock, so even if ordered-tag requests leave 
request queue in the correct order, they can be reordered while they are 
being issued by SCSI midlayer.

There can be two solutions to this problem.

1. Rewrite scsi_request_fn() and scsi_dispatch_cmd() such that 
q->queuelock is not released during command issue.  This implies 
grabbing shost->host_lock while holding q->queuelock.

2. Don't allow concurrent command issuing by marking SCSI device during 
command issuing (e.g. sdev->issue_in_progress)

I prefer #1 as it's more straight-forward.  To implement #1, 
scsi_request_fn() should be reorganized quite a bit, but, if you 
remember, the scsi_reqfn reimplementation patch I wrote quite a while 
ago suites this pretty well.  What do you think?

-- 
tejun
