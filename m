From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Date: Thu, 19 Feb 2009 13:11:03 -0800 (PST)
Message-ID: <56979.43325.qm@web110612.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web110612.mail.gq1.yahoo.com ([67.195.13.203]:46291 "HELO
	web110612.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756094AbZBSVLF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 16:11:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> Can you try this patch ... it was something I meant to get into 2.6.29
> but forgot about.  The key problem that you seem to be hitting is that
> the requeue evades the timeout check.  Moving the timeout check to block
> should fix that.

Even by itself this patch works although the behaviour is now different
to that of 2.6.28.  Whereas in 2.6.28 it would timeout very quickly
(after about 1 or 2 seconds) it now times out after 30 seconds
(initially I hadn't realised that it would be so much longer). The
other difference is that the failure becomes cached - trying to reread
the same area using dd instantly fails from now on without any more disk
IO/kernel error messages until echo 1 > /proc/sys/vm/drop_caches is
issued. Before it would always go straight to the disk for the unread
section and the kernel spew would be repeated before the failure.

I guess if this is new intended behaviour then all is well - it's just
different and slower/faster :)

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>



      
