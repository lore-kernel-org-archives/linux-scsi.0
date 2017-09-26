From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Limit WRITE SAME / WRITE SAME(16) w/UNMAP length for certain devices
Date: Mon, 25 Sep 2017 21:46:09 -0400
Message-ID: <yq1wp4mcjvi.fsf@oracle.com>
References: <1505837661-2280-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50617 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934961AbdIZBqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 21:46:15 -0400
In-Reply-To: <1505837661-2280-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Tue, 19 Sep 2017 12:14:21 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org


Ewan,

> Some devices do not support a WRITE SAME / WRITE SAME(16) with the
> UNMAP bit set up to the length specified in the MAXIMUM WRITE SAME
> LENGTH field in the block limits VPD page (or, the field is zero,
> indicating there is no limit).  Limit the length by the MAXIMUM UNMAP
> LBA COUNT value.  Otherwise the command might be rejected.

>From SBC4:

  "A MAXIMUM UNMAP LBA COUNT field set to a non-zero value indicates the
  maximum number of LBAs that may be unmapped by an UNMAP command"

Note that it explicitly states "UNMAP command" and not "unmap
operation".

  "A MAXIMUM WRITE SAME LENGTH field set to a non-zero value indicates
  the maximum number of contiguous logical blocks that the device server
  allows to be unmapped or written in a single WRITE SAME command."

It says "unmapped or written" and "WRITE SAME command".

The spec is crystal clear. The device needs to be fixed. We can
blacklist older firmware revs.

-- 
Martin K. Petersen	Oracle Linux Engineering
