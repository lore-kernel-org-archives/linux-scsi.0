From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Separate zone requests from medium access requests
Date: Tue, 28 Feb 2017 22:21:47 -0500
Message-ID: <yq1shmxsmus.fsf@oracle.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
        <20170228160259.GA22755@lst.de> <yq160jtu2s0.fsf@oracle.com>
        <6f1c8be1-9366-b32e-621e-8b05f22a1753@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:49536 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdCAEyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 23:54:14 -0500
In-Reply-To: <6f1c8be1-9366-b32e-621e-8b05f22a1753@wdc.com> (Damien Le Moal's
        message of "Wed, 1 Mar 2017 12:02:14 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien,

Damien> The problem remains that the mpt3sas driver needs fixing. As you
Damien> suggest, we can do that in sd, or directly in mpt3sas.  I tried
Damien> to do a clean fix in sd, but always end up consuming a lot of
Damien> aspirin because of all the potential corner cases to deal
Damien> with.

What? You expected this to be easy? :)

FWIW, I'm perfectly happy with the desire to shuffle the ZBC-specifics
over to sd_zbc.c.

Damien> The file sd.h has the inline function
Damien> scsi_medium_access_command() defined. We could move that to
Damien> include/scsi/scsi.h (or scsi_proto.h) and use it in place of
Damien> blk_rq_accesses_medium() in the mpt3sas driver to not force
Damien> unaligned resid corrections for zone commands. Would that be
Damien> acceptable ?

I'd still rather keep it in sd. If you don't have sufficient supplies of
aspirin for the sd_completed_bytes() approach then I'm OK with a simple
tweak to sd_done(). We need something we can reasonably Cc: to stable
for 4.10.

You are welcome to key off of scsi_medium_access_command() if you like
but I don't think it's necessary. Just having a default for the req_op
switch should suffice.

I believe that was your original sd approach. If you post it again I'll
have another look.

And then I'll put the bigger completion rework back on my todo list.

-- 
Martin K. Petersen	Oracle Linux Engineering
