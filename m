From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Tue, 18 Jul 2017 09:37:47 +0200
Message-ID: <20170718073747.GD4875@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ufafudubmkd.fsf@epithumia.math.uh.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 17, 2017 at 07:44:50PM -0500, Jason L Tibbitts III wrote:
> and confirmed that clean unpatched 4.12 shows the problem, while
> reverting just that patch fixes the issue.  Unfortunately I don't know
> enough to actually fix this, but I can easily test patches.

This is fixed with:
commit 68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47
Author: Johannes Thumshirn <jthumshirn@suse.de>
Date:   Fri Jul 7 10:56:38 2017 +0200

    scsi: sg: fix SG_DXFER_FROM_DEV transfers
    
    SG_DXFER_FROM_DEV transfers do not necessarily have a dxferp as we set
    it to NULL for the old sg_io read/write interface, but must have a
    length bigger than 0. This fixes a regression introduced by commit
    28676d869bbb ("scsi: sg: check for valid direction before starting the
    request")
    
    Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
    Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
    Reported-by: Chris Clayton <chris2553@googlemail.com>
    Tested-by: Chris Clayton <chris2553@googlemail.com>
    Cc: Douglas Gilbert <dgilbert@interlog.com>
    Reviewed-by: Hannes Reinecke <hare@suse.com>
    Tested-by: Chris Clayton <chris2553@googlemail.com>
    Acked-by: Douglas Gilbert <dgilbert@interlog.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
