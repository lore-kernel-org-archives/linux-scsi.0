From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Tue, 03 Sep 2002 14:09:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209031909.g83J9iG07312@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA20210
	for <linux-scsi@vger.kernel.org>; Tue, 3 Sep 2002 12:09:58 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Tue, 03 Sep 2002 14:23:53 EDT." <20020903142353.A12157@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Leave abort active.  It does actually work in certain scenarios.  The
> CD  burner scenario that started this thread is an example of
> somewhere that  an abort should actually do the job. 

Unfortunately, it would destroy the REQ_BARRIER approach in the block layer.  
At best, abort probably causes a command to overtake a barrier it shouldn't, 
at worst we abort the ordered tag that is the barrier and transactional 
integrity is lost.

When error correction is needed, we have to return all the commands for that 
device to the block layer so that ordering and barrier issues can be taken 
care of in the reissue.  This makes LUN RESET (for those that support it) the 
minimum level of error correction we can apply.

James


