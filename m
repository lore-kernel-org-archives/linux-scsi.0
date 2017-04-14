From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: problem with discard granularity in sd
Date: Thu, 13 Apr 2017 22:44:56 -0400
Message-ID: <yq1efwvwvvb.fsf@oracle.com>
References: <CA+Xd3XG1AN-ZTjn3SfZffrY=4vezSS8RrE88jG0QEsuyHC5k8A@mail.gmail.com>
        <yq14lxuv187.fsf@oracle.com>
        <CA+Xd3XFoRY+SgowfzP69X1ZCSAPGTmec=qMxStoX=trths8kDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdDNCpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 22:45:03 -0400
In-Reply-To: <CA+Xd3XFoRY+SgowfzP69X1ZCSAPGTmec=qMxStoX=trths8kDg@mail.gmail.com>
        (David Buckley's message of "Wed, 12 Apr 2017 16:58:22 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Buckley <dbuckley@oreilly.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

David Buckley <dbuckley@oreilly.com> writes:

David,

> The underlying issue seems to be that (per VPD page) the maximum
> supported unmap request is 8192 * 512 = 4194304 bytes, while the
> maximum write same request is 0x4000 * 512 = 8388608 bytes.  It
> appears both of these values are correct, and in the case where a WS
> UNMAP request larger than 8192 blocks is received the UNMAP is ignored
> and the result is effectively a WS ZERO request.

That's broken on the filer, then.

> If I'm correct in my understanding, then it seems like the root cause
> of the failures is that the current code assumes a disk will always
> support WS UNMAP requests up to max_ws_blocks and does not account for
> a case where max_unmap_blocks is smaller than max_ws_blocks.

SBC says:

    "A MAXIMUM UNMAP LBA COUNT field set to a non-zero value indicates
    the maximum number of LBAs that may be unmapped by an UNMAP
    command."

    "A MAXIMUM WRITE SAME LENGTH field set to a non-zero value indicates
    the maximum number of contiguous logical blocks that the device
    server allows to be unmapped or written in a single WRITE SAME
    command."

I'm confident that our behavior is correct and that the problem is on
the storage side.

The good news is that the new discard code would alleviate your problem
in that (based on what the filer reported in your setup) we'd use UNMAP
to deallocate and WRITE SAME to zero.

-- 
Martin K. Petersen	Oracle Linux Engineering
