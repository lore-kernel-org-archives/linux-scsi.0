From: Rajat Jain <rajatja@google.com>
Subject: Implementing aio cancel for SCSI/SATA devices
Date: Wed, 15 Jul 2015 17:24:55 -0700
Message-ID: <CACK8Z6EfZw3NrHZk_HD1Qh17ZAntOaxXzRx=kpp2noNfJ6KRWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35066 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbbGPAY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2015 20:24:56 -0400
Received: by iecuq6 with SMTP id uq6so45516037iec.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2015 17:24:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Benjamin LaHaise <bcrl@kvack.org>, Theodore Tso <tytso@google.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-aio@kvack.org, Kent Overstreet <kent.overstreet@gmail.com>

Hello,

Currently I don't see any users of aio cancellation facility (except a
USB gadget driver).

I have a SATA controller and disk that both support the NCQ command
aborts, and I am thinking of ways to implement aio cancellation on
these devices in the kernel. The way I see it, at the time user
requests for a command to be cancelled, it could be be in one of the 2
places:

1. Sitting in block layer elevator queues, and not yet submitted it to
the SCSI subsystem (scsi_dispatch_cmd() not yet called). [I see some
solutions available to this https://lkml.org/lkml/2013/5/13/615 ]

2. Submitted to the SCSI subsystem / LLD, but pending in the LLD SW or
the HW  (scsi_done() not yet called). This part is what I am keen on
adding.

My line of thought (10000 ft view) currently is, that I should:

A) Do the necessary plumbing (through the block & scsi layers) such
that the kiocb_cancel() should eventually result in a call to the
eh_abort_handler() for the LLD for that particular command. This
should (atleast in my theory) let the LLD know that it needs to cancel
the command, and can do whatever it needs to do in order to cancel it.

B) Add a helper function in libata that allocates & initializes a new
"Queue Management - Abort (0x63)" ATA command, that the LLD's
eh_abort_handler() can choose to use in case it sees that the command
is already sent to the disk drive. It can then send this new
ata_queued_cmd to abort the pending command to the drive. This is of
course optional and to be used at LLD(s) discretion.

Comments? Thoughts?

I'd appreciate if you could please let me know if I'm on the right
track or totally off?

Thanks,

Rajat
