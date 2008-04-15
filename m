From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Tue, 15 Apr 2008 19:05:50 +0900
Message-ID: <20080415190550P.fujita.tomonori@lab.ntt.co.jp>
References: <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080414144154.GB10288@osc.edu>
	<48045D30.5070406@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:36292 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbYDOKJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 06:09:54 -0400
In-Reply-To: <48045D30.5070406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-ide@vger.kernel.org

On Tue, 15 Apr 2008 10:45:52 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Mon, Apr 14 2008 at 17:41 +0300, Pete Wyckoff <pw@osc.edu> wrote:
> > fujita.tomonori@lab.ntt.co.jp wrote on Mon, 14 Apr 2008 19:50 +0900:
> >> This patch changes rq->cmd from the static array to a pointer to
> >> support large commands.
> >>
> >> We rarely handle large commands. So for optimization, a struct request
> >> still has a static array for a command. rq_init sets rq->cmd pointer
> >> to the static array.
> >>
> >> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> Cc: Jens Axboe <jens.axboe@oracle.com>
> > [..]
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index b3a58ad..5710ae4 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -215,8 +215,9 @@ struct request {
> >>  	/*
> >>  	 * when request is used as a packet command carrier
> >>  	 */
> >> -	unsigned int cmd_len;
> >> -	unsigned char cmd[BLK_MAX_CDB];
> >> +	unsigned short cmd_len;
> >> +	unsigned char __cmd[BLK_MAX_CDB];
> >> +	unsigned char *cmd;
> >>  
> >>  	unsigned int data_len;
> >>  	unsigned int extra_len;	/* length of alignment and padding */
> >> @@ -812,6 +813,13 @@ static inline void put_dev_sector(Sector p)
> >>  	page_cache_release(p.v);
> >>  }
> >>  
> >> +static inline void rq_set_cmd(struct request *rq, unsigned char *cmd,
> >> +			      unsigned short cmd_len)
> >> +{
> >> +	rq->cmd = cmd;
> >> +	rq->cmd_len = cmd_len;
> >> +}
> > 
> > Here's one way this will be used, in a patched bsg that understands
> > large commands.  Complication is the need to copy and hold onto the
> > big command across the duration of the request.
> > 
> > Submit time is fairly clean:
> > 
> > 	/* buf, len from user request */
> > 	rq = blk_get_request(..);
> > 	rq->cmd_len = len;
> > 	if (len > BLK_MAX_CDB) {
> > 		rq->cmd = kmalloc(len);
> > 		if (rq->cmd == NULL)
> > 			goto out;
> > 	}
> > 	copy_from_user(rq->cmd, buf, len);
> > 
> > Completion time needs to know when to free rq->cmd:
> > 
> > 	if (rq->cmd_len > BLK_MAX_CDB)
> > 		kfree(rq->cmd);
> > 	blk_put_request(rq);
> > 
> > Could use (rq->cmd != rq->__cmd) instead, but nothing had better
> > ever touch rq->cmd_len.
> > 
> 
> Don't do any of that please. The 16 bytes buffer at request is eventually
> going away. Just always allocate and call rq_set_cmd(). This way we are
> free to change in the future, and users code need not change.

Hmm, it's clean for bsg, but we nearly always allocates 16 bytes
dynamically. That's wasteful. Probably, we would loose some
performance as we did for sense buffer.


> And better then kmalloc the space for the command, is if you have
> a structure that governs your request, just allocate a 
> SCSI_MAX_VARLEN_CDB_SIZE (260) bytes array at your structure and always
> use that.

I don't put 260 bytes into bsg_command structure. I don't see why bsg
needs to be tuned up for OSD or for SCSI commands.
