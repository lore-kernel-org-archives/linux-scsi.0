From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 18:02:03 -0400
Message-ID: <20130924220203.GA18700@redhat.com>
References: <20130919161043.GA27081@redhat.com>
 <20130920212142.GA17898@redhat.com>
 <alpine.LRH.2.02.1309241415380.31619@file01.intranet.prod.int.rdu2.redhat.com>
 <yq14n9aar0q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3IXWCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 18:02:07 -0400
Content-Disposition: inline
In-Reply-To: <yq14n9aar0q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24 2013 at  4:44pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> The other headache is what happens if a stacking driver gets -EIO or
> -EREMOTEIO on a WRITE SAME request. That's what Mike was trying to fix
> with his patch. Maybe it would make sense for us to use -EINVAL or
> something similar to single out the ILLEGAL REQUEST case. While
> -EREMOTEIO specifically calls out for "no retry" it might be helpful to
> indicate that we're dealing with an unsupported command. That way DM or
> MD can reconfigure themselves accordingly.

What I've committed as a v3.12 fix works, see:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-linus&id=f84cb8a46a771f36a04a02c61ea635c968ed5f6a

"Workaround the SCSI layer's problematic WRITE SAME heuristics by
disabling WRITE SAME in the DM multipath device's queue_limits if an
underlying device disabled it."

So I'm trapping requests with REQ_WRITE_SAME whose underlying queue's
queue_limits have disabled WRITE SAME.  And as the before and after
detailed in the patch header shows, it works.

I'm open to tweaking this later but will be leaving well enough alone
for v3.12 by keeping this fix.
