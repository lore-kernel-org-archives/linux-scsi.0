From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 14:03:28 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <41473270.3070405@rtr.ca>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com> <41472FA0.2090108@rtr.ca> <414730D9.3000003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269685AbUINSMp@vger.kernel.org>
In-Reply-To: <414730D9.3000003@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

 >The SCSI LLD API really needs to -not- spinlock on the EH hooks,
 >and instead simply guarantee that ->queuecommand and other hooks
 >will not be called while the driver is in EH.
 >
 >ISTR James didn't disagree, so maybe a patch can be worked out...

It looks to me as if the eh code prevents further queuecommand()
calls while the LLD *_reset_handler() code is running.
I wonder if it also does so for the eh_strategy_handler() ?

Have to look at it, I guess.

 >Of course, you could always just use ->eh_strategy_handler
 >and do 100% of the error handling yourself.

Mmmm.. yes, that may be better, perhaps.

Whatever this driver does, it has to be reasonably portable
back to early 2.4.xx kernels, so it cannot depend too much
upon newly (or to-be) implemented semantics in 2.6.xx.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
