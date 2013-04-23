From: Ric Wheeler <rwheeler@redhat.com>
Subject: T10 WCE interpretation in Linux & device level access
Date: Tue, 23 Apr 2013 15:41:28 -0400
Message-ID: <5176E3E8.3000809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3DWTlf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Apr 2013 15:41:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>


For many years, we have used WCE as an indication that a device has a volatile 
write cache (not just a write cache) and used this as a trigger to send down 
SYNCHRONIZE_CACHE commands as needed.

Some arrays with non-volatile cache seem to have WCE set and simply ignore the 
command.

Some arrays with non-volatile cache seem to not set WCE.

Others arrays with non-volatile cache - our problem arrays - set WCE and do 
something horrible and slow when sent the SYNCHRONIZE_CACHE commands.

Note that for file systems, you can override this behavior by mounting with our 
barriers disabled (mount -o nobarrier .....). There is currently no way do 
disable this for anything using the device directly, not through the file system.

Some applications run against block devices - not through a file system - and 
want not to slow to a crawl when they have an array in my problem set.

Giving them a hook to ignore WCE seems to be a hack, but one that would resolve 
issues with users who won't want to wait months (years?) for us to convince the 
array vendors.

Is this a hook worth doing?

Have we hashed this out in the T10 committee?

Regards,

Ric

