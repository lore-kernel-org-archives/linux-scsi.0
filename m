From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: 14 Sep 2004 14:25:35 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1095186343.2008.29.camel@mulgrave>
References: <41471163.10709@rtr.ca>  <414723B0.1090600@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269694AbUINSiG@vger.kernel.org>
In-Reply-To: <414723B0.1090600@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2004-09-14 at 13:00, Jeff Garzik wrote:
> 9) use of do_sleep paradigm is dubious:  you should instead try to keep 
> your locked code regions as small as possible.  in general, this code 
> has far too many unlock-doit-lock sections.
> 
> Experience has shown that too much unlock-doit-lock leads to bugs and 
> increases the pain when analyzing your locking.
> 
> In particular, releasing the lock and sleeping would be very wrong in 
> the ->queuecommand and error handling paths (alas...  I would love to 
> sleep in the fine-grained eh hooks)

Actually, its only wrong in queuecommand because that can be called in
softirq context.

Sleeping in the eh paths is fine (as long as you drop the locks that the
EH thread has uselessly taken for you).  Indeed it's often required
since the return is supposed to tell the eh thread whether the action
was successful or not.

James
