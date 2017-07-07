From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Fri, 7 Jul 2017 09:57:15 +0200
Message-ID: <20170707075715.GD3854@linux-x5ow.site>
References: <20170705134934.1703-1-jthumshirn@suse.de>
 <54abb58b-3fe6-8e64-91aa-182fbef93467@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54abb58b-3fe6-8e64-91aa-182fbef93467@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 06, 2017 at 02:47:22PM -0400, Douglas Gilbert wrote:
> Can you check your patch with one of the utilities from sg3_utils
> such as sg_inq which will use SG_DXFER_FROM_DEV with the newer
> interface?

Correct, this patch broke sg_inq. I'll send a corrected v2.

> BTW I'm not sure why dxferp is set to NULL for SG_DXFER_FROM_DEV
> transfers; perhaps some magic done by the block layer. Maybe a
> comment in the code (e.g. on line 654) would help.

This is due to:

commit fad7f01e61bf737fe8a3740d803f000db57ecac6
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Sep 2 16:20:20 2008 +0900

    sg: set dxferp to NULL for READ with the older SG interface
    
    With the older SG interface, we don't know a user-space address to
    trasfer data when executing a SCSI command. So we can't pass a
    user-space address to blk_rq_map_user.
    
    This patch fixes sg to pass a NULL user-space address to
    blk_rq_map_user so that it just sets up a request and bios with page
    frames propely without data transfer.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

> 
> Also sg_is_valid_dxfer() is only called once and is more complex
> than it looks; so perhaps it could be inlined back in
> sg_common_write().

The compiler will inline it anyways (at least the one I checked with) and
inlining it into sg_common_write() won't make the code more readable IMHO. But
ultimately it's your driver so if you insist I'll do.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
