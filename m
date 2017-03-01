From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 0/3] Separate zone requests from medium access requests
Date: Wed, 1 Mar 2017 18:06:19 +0900
Message-ID: <35d0e9b5-c6d0-05f0-7d04-5b6d0f6476a5@wdc.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
 <20170228160259.GA22755@lst.de> <yq160jtu2s0.fsf@oracle.com>
 <6f1c8be1-9366-b32e-621e-8b05f22a1753@wdc.com> <yq1shmxsmus.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46522 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdCAJIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 04:08:02 -0500
In-Reply-To: <yq1shmxsmus.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

Martin,

On 3/1/17 12:21, Martin K. Petersen wrote:
>>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:
> 
> Damien,
> 
> Damien> The problem remains that the mpt3sas driver needs fixing. As you
> Damien> suggest, we can do that in sd, or directly in mpt3sas.  I tried
> Damien> to do a clean fix in sd, but always end up consuming a lot of
> Damien> aspirin because of all the potential corner cases to deal
> Damien> with.
> 
> What? You expected this to be easy? :)
> 
> FWIW, I'm perfectly happy with the desire to shuffle the ZBC-specifics
> over to sd_zbc.c.
> 
> Damien> The file sd.h has the inline function
> Damien> scsi_medium_access_command() defined. We could move that to
> Damien> include/scsi/scsi.h (or scsi_proto.h) and use it in place of
> Damien> blk_rq_accesses_medium() in the mpt3sas driver to not force
> Damien> unaligned resid corrections for zone commands. Would that be
> Damien> acceptable ?
> 
> I'd still rather keep it in sd. If you don't have sufficient supplies of
> aspirin for the sd_completed_bytes() approach then I'm OK with a simple
> tweak to sd_done(). We need something we can reasonably Cc: to stable
> for 4.10.
> 
> You are welcome to key off of scsi_medium_access_command() if you like
> but I don't think it's necessary. Just having a default for the req_op
> switch should suffice.
> 
> I believe that was your original sd approach. If you post it again I'll
> have another look.

Just posted that. Please review.

> 
> And then I'll put the bigger completion rework back on my todo list.

Still working on that, with the hope of being able to cleanup sd_done()
more nicely and hopefully integrate the resid fix in sd_completed_bytes().

Regarding this, I have a question:

In sd_done(), the sshdr.sense_key switch-case is entered after passing
this "if" statement:

        if (driver_byte(result) != DRIVER_SENSE &&
            (!sense_valid || sense_deferred))
                goto out;

That is, the sshdr.sense_key switch-case is entered if

	driver_byte(result) == DRIVER_SENSE ||
        (sense_valid && !sense_deferred))

is true.

My question is: Why the "driver_byte(result) == DRIVER_SENSE" ?
wouldn't just checking for (sense_valid && !sense_deferred)) enough ?
After all, sshdr is initialized with scsi_command_normalize_sense() for
any non-0 value of result.

So we may be uselessly looking at sshdr with sense_valid being false for
those cases where driver_byte(result) == DRIVER_SENSE. But I am not sure
if such case is actually possible (bogus HW ?). If is is not, we should
check that more carefully, shouldn't we ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
