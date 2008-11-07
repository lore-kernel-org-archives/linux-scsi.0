From: Bernd Schubert <bs@q-leap.de>
Subject: [regression 2.6.28-rcX] error handler broken
Date: Fri, 7 Nov 2008 18:25:45 +0100
Message-ID: <200811071825.46310.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:35798 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYKGRZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 12:25:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>

Hello,

while testing mpt fusion patches, I noticed the error handler in 2.6.28-rcX 
doesn't work any more.

>From scsi_eh_scmd_add() the function scsi_eh_wakeup() is called, which will 
activate the error handler only if shost->host_busy == shost->host_failed. 
However, in the end for 90% of my testcases 

shost->host_failed= shost->host_busy+1

Due locking of shost->host_lock in scsi_eh_scmd_add(), which also locks 
shost->host_failed++, scsi_eh_wakeup() will still activate the error handler. 
But in scsi_error_handler() another check against 
shost->host_failed != shost->host_busy is done and mostly when it reaches this 
point shost->host_failed is already shost->host_busy+1, so 
scsi_error_handler() won't do anything at all. Since all commands have been 
queued for the error handler, access to this specific device is locked up for 
ever.

I tried to bisect the problem and it points to this commit: 

242f9dcb8ba6f68fcd217a119a7648a4f69290e9 is first bad commit
commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Sun Sep 14 05:55:09 2008 -0700

    block: unify request timeout handling


I'm not absolutely sure, though, since the error handler only mostly fails. I  
verified each 'good' bisection two times, but from statistical point of view 
this is actually not sufficient.
Also, On the one hand this commit doesn't seem to directly change the logic of 
host_failed or host_busy, but on the other hand, it is related to timeouts, 
which is what is actually activating the error handler for my test cases.


Suggestions?

-- 
Bernd Schubert
Q-Leap Networks GmbH
