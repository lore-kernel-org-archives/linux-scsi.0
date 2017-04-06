From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: problem with discard granularity in sd
Date: Thu, 06 Apr 2017 13:34:28 -0400
Message-ID: <yq1mvbtphi3.fsf@oracle.com>
References: <CA+Xd3XHp381w87Fr5_HGU5gBpWMSRSwD+pRacGkHu7Rp7CYUfg@mail.gmail.com>
        <yq1d1crvhjv.fsf@oracle.com>
        <CA+Xd3XGwXZRat_zF=3vraT81jm7WgU1RSjdNeNDBfioYD9-B9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932977AbdDFRee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 13:34:34 -0400
In-Reply-To: <CA+Xd3XGwXZRat_zF=3vraT81jm7WgU1RSjdNeNDBfioYD9-B9Q@mail.gmail.com>
        (David Buckley's message of "Wed, 5 Apr 2017 09:14:45 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Buckley <dbuckley@oreilly.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

David Buckley <dbuckley@oreilly.com> writes:

David,

> As I mentioned previously, I'm fairly certain that the issue I'm
> seeing is due to the fact that while NetApp LUNs are presented as 512B
> logical/4K physical disks for compatibility, they actually don't
> support requests smaller than 4K (which makes sense as NetApp LUNs are
> actually just files allocated on the 4K-block WAFL filesystem).

That may be. But they should still deallocate all the whole 4K blocks
described by an UNMAP request. Even if head and tail are not aligned.

> Let me know if there's any additional information I can provide. This
> has resulted in a 2-3x increase in raw disk requirements for some
> workloads (unfortunately on SSD too), and I'd love to find a solution
> that doesn't require rolling back to a 3.10 kernel.

I just posted some patches yesterday that will address this (using WRITE
SAME w/ UNMAP for block zeroing and allowing discards to be sent using
the UNMAP command, honoring the granularity and alignment suggested by
the device). That's 4.13 material, though.

The enterprise distros have many customers using NetApp filers. I'm a
bit puzzled why this is the first we hear of this...

-- 
Martin K. Petersen	Oracle Linux Engineering
