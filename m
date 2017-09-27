From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: Limit WRITE SAME / WRITE SAME(16) w/UNMAP length
 for certain devices
Date: Wed, 27 Sep 2017 12:27:57 -0400
Message-ID: <1506529677.4100.452.camel@localhost.localdomain>
References: <1505837661-2280-1-git-send-email-emilne@redhat.com>
         <yq1wp4mcjvi.fsf@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752201AbdI0Q17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 12:27:59 -0400
In-Reply-To: <yq1wp4mcjvi.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Frederick.Knight@netapp.com

On Mon, 2017-09-25 at 21:46 -0400, Martin K. Petersen wrote:
> Ewan,
> 
> > Some devices do not support a WRITE SAME / WRITE SAME(16) with the
> > UNMAP bit set up to the length specified in the MAXIMUM WRITE SAME
> > LENGTH field in the block limits VPD page (or, the field is zero,
> > indicating there is no limit).  Limit the length by the MAXIMUM UNMAP
> > LBA COUNT value.  Otherwise the command might be rejected.
> 
> From SBC4:
> 
>   "A MAXIMUM UNMAP LBA COUNT field set to a non-zero value indicates the
>   maximum number of LBAs that may be unmapped by an UNMAP command"
> 
> Note that it explicitly states "UNMAP command" and not "unmap
> operation".
> 
>   "A MAXIMUM WRITE SAME LENGTH field set to a non-zero value indicates
>   the maximum number of contiguous logical blocks that the device server
>   allows to be unmapped or written in a single WRITE SAME command."
> 
> It says "unmapped or written" and "WRITE SAME command".
> 
> The spec is crystal clear. The device needs to be fixed. We can
> blacklist older firmware revs.
> 

Yes, I know that is what SBC-4 says, and I agree that the devices
are not conforming.  Unfortunately, I've come across 3 different
arrays now from 3 different manufacturers that exhibit this behavior.

cc: Fred Knight for his opinion on this (NetApp was not one of the
arrays that I've run into, though).

-Ewan
