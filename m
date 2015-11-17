From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] Separate target visibility from reaped state
 information
Date: Mon, 16 Nov 2015 22:22:23 -0800
Message-ID: <1447741343.5417.7.camel@HansenPartnership.com>
References: <564A7261.7040403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43932 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbbKQGWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 01:22:31 -0500
In-Reply-To: <564A7261.7040403@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2015-11-16 at 16:18 -0800, Bart Van Assche wrote:
> Instead of representing the states "visible in sysfs" and
> "has been removed from the target list" by a single state
> variable, use two variables to represent this information.
> 
> This patch avoids that SCSI device removal can trigger a
> soft lockup.
> 
> See also:
> * "scsi: restart list search after unlock in scsi_remove_target"
>   (commit 40998193560d).
> * "scsi_remove_target: fix softlockup regression on hot remove"
>   (commit bc3f02a795d3).

OK, could you justify this, please ... like with traces and things.

The theory on which

commit 40998193560dab6c3ce8d25f4fa58a23e252ef38
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Oct 19 16:35:46 2015 +0200

    scsi: restart list search after unlock in scsi_remove_target

Was based is that the race you're claiming to be fixing no longer exists
because it was fixed by

commit f2495e228fce9f9cec84367547813cbb0d6db15a
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Tue Jan 21 07:01:41 2014 -0800

    [SCSI] dual scan thread bug fix

If that isn't the case, we can fix it, but I'd like to see the evidence.

Thanks,

James


