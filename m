From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Thu, 20 Jan 2005 10:54:47 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EA1B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28883 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262174AbVATPy5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 10:54:57 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

> No, sorry for have been unclear.  I want a pointer to the remote port
> structure in the fc_target transport data.  Every driver needs the
> linkage of these two, and instead of everyone having it in their
> private data we'd better move it to the fc_transport data structure.

Ok. It's already there. What this boils down do is exactly your last
statement (and our driver doesn't do it - we'll fix it).

Note: there's a flipside here... with the remote port stuff, we had
removed almost all the reasons for a fc driver to reference a scsi_target.
The only place we really had to was in the case the older fc_transport/xxx
sysfs attributes (which all but one exist only for compatibility).

We could move this into the remote port structure (already set up for this)
which will always exist for a scsi_target. Even so, I think extending the
scsi target and fixing the calling sequence is the correct thing to do.

>  What about dropping the 
> counters temporarily
> for submission and submit a patch later that adds them (and 
> their sysfs
> exposure) back at the midlayer?  In fact the actual 
> accounting is better
> done at the midlayer-level anyway.

OK.

-- james s
