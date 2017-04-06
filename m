From: David Buckley <dbuckley@oreilly.com>
Subject: (unknown)
Date: Thu, 6 Apr 2017 12:09:16 -0700
Message-ID: <CA+Xd3XH1zUY9Cr+q4HfixrWvZACZrQvjJW2sq5qCz9d2UhcABQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36675 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdDFTJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 15:09:59 -0400
Received: by mail-lf0-f43.google.com with SMTP id x137so31631561lff.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2017 12:09:58 -0700 (PDT)
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin,

I'm rather surprised nobody else has previously reported this as well,
especially as NetApp hadn't received any reports.  The only probably
explanation I could think of is that EL 7 is still based on a 3.10
kernel so is too old to be affected, and that is likely to be what
most NetApp customers are running.



I've been trying to test some additional kernels to try and narrow the
versions affected, and the change in discard_granularity does not
correspond with discard failing (as you suggested).

With kernel 3.13,  discard works as expected with
discard_granularity=4096 and discard_max_bytes=4194304.

With kernel 3.19, discard stops working completely, with
discard_granularity=4096 and discard_max_bytes=8388608.

Do you think the change in discard_max_bytes could be relevant?  If
that comes from the VPD data it seems odd it would change.

I am wondering if part of the issue is that in my use case, UNMAP and
WRITE SAME zeros result in very different results.  With thin
provisioned LUNs, UNMAP requests result in the blocks being freed and
thus shrinks the real size of the LUN allocation.  If WRITE SAME
requests are used to zero the blocks, they remain allocated as part of
the LUN and thus the real size of the LUN grows to match the allocated
size (effectively thick-provisioning the LUN).  This matches what I am
seeing on kernels with discard not working; running 'fstrim
/lun/mount' results in the LUN growing to its max size.

Thank you again for your help with this!

-David

On Thu, Apr 6, 2017 at 10:34 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> David Buckley <dbuckley@oreilly.com> writes:
>
> David,
>
>> As I mentioned previously, I'm fairly certain that the issue I'm
>> seeing is due to the fact that while NetApp LUNs are presented as 512B
>> logical/4K physical disks for compatibility, they actually don't
>> support requests smaller than 4K (which makes sense as NetApp LUNs are
>> actually just files allocated on the 4K-block WAFL filesystem).
>
> That may be. But they should still deallocate all the whole 4K blocks
> described by an UNMAP request. Even if head and tail are not aligned.
>
>> Let me know if there's any additional information I can provide. This
>> has resulted in a 2-3x increase in raw disk requirements for some
>> workloads (unfortunately on SSD too), and I'd love to find a solution
>> that doesn't require rolling back to a 3.10 kernel.
>
> I just posted some patches yesterday that will address this (using WRITE
> SAME w/ UNMAP for block zeroing and allowing discards to be sent using
> the UNMAP command, honoring the granularity and alignment suggested by
> the device). That's 4.13 material, though.
>
> The enterprise distros have many customers using NetApp filers. I'm a
> bit puzzled why this is the first we hear of this...
>
> --
> Martin K. Petersen      Oracle Linux Engineering
