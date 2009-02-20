From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Date: Thu, 19 Feb 2009 16:54:29 -0800 (PST)
Message-ID: <852441.94339.qm@web110616.mail.gq1.yahoo.com>
References: <56979.43325.qm@web110612.mail.gq1.yahoo.com> <1235080134.12500.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web110616.mail.gq1.yahoo.com ([67.195.13.207]:40712 "HELO
	web110616.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754039AbZBTAyb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 19:54:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>

> 
> Your specific behaviour change seems to be a bug in the way the rewrite
> is handling ABORTED_COMMAND.  Could you try the patch below (with or
> without the block patch, it shouldn't matter) and see if it gets you
> back to 2.6.28 behaviour?

Yup that patch makes things timeout quickly just like 2.6.28. The whole 
"it didn't used to cache failures" piece in the previous email seems to
have been a fabrication inside my own head - I checked and 2.6.28 caches
the failure until the cache is dropped too.

It might be worth turning your original patch into some sort of warning
stack trace trigger so that people understand it's just there for 
unwedging and isn't expected behaviour (it is useful for breaking out of
near lockups though).

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>



      
