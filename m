From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Fri, 5 Dec 2014 21:05:01 +0800
Message-ID: <CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaLENFI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 08:05:08 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1XwsZE-0000zS-1l
	for linux-scsi@vger.kernel.org; Fri, 05 Dec 2014 13:05:04 +0000
Received: by mail-oi0-f51.google.com with SMTP id e131so405008oig.10
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 05:05:01 -0800 (PST)
In-Reply-To: <yq1r3wefe6o.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>

On Fri, Dec 5, 2014 at 8:56 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:
>
> Ming,
>
> Ming> QEMU SCSI device claims to support UNMAP, WRITE SAME and WRITE
> Ming> SAME 16 in LBP VPD page, but only provides "Maximum unmap LBA
> Ming> count" in block limits VPD page, and "Maximum write same length"
> Ming> isn't set.
>
> That really sounds like a problem that should be fixed in QEMU SCSI.

It can be fixed, but there are lots of old QEMU in production.

>
> Ming> The default max_discard_sectors(SD_MAX_WS16_BLOCKS) can't work at
> Ming> all since it is much bigger than the actual Maximum unmap LBA
> Ming> count.
>
> There is absolutely no correlation between max write same blocks and max
> unmap blocks. They are two entirely different commands. If QEMU SCSI

Do you have any better idea for the problem?

> advertises support for WRITE SAME(16) and does not report a cap in the
> block limits VPD then we must expect that it supports the maximum number
> of blocks that can be expressed by the command.

Unfortunately it doesn't support that, see below log:

[   50.112885] sd 0:0:1:0: [sda] FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   50.113859] sd 0:0:1:0: [sda] Sense Key : Illegal Request [current]
[   50.113859] sd 0:0:1:0: [sda] Add. Sense: Invalid field in cdb
[   50.113859] sd 0:0:1:0: [sda] CDB:
[   50.113859] Write same(16): 93 08 00 00 00 00 00 00 80 00 00 40 00 00 00 00
[   50.113859] blk_update_request: critical target error, dev sda, sector
32768


Thanks,
Ming Lei
