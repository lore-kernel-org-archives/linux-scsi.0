From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to
 blk_rq_bytes() on issue
Date: Fri, 15 May 2009 11:29:01 -0600
Message-ID: <20090515112901.84d4dd97.zaitcev@redhat.com>
References: <4A0D86DB.9000203@kernel.org>
	<4A0D87D2.7090806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0D87D2.7090806@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>, zaitcev@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 16 May 2009 00:18:42 +0900, Tejun Heo <htejun@gmail.com> wrote:

> In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
> rq->resid_len, the default value of residue count was changed from
> full count to zero. []

So it's not a residue anymore, right? You should've renamed it to
rq->count or something, then. Now we have this:

> +++ block/drivers/block/ub.c
> @@ -781,8 +781,7 @@ static void ub_rw_cmd_done(struct ub_dev
>  
>  	if (cmd->error == 0) {
>  		if (blk_pc_request(rq)) {
> -			if (cmd->act_len < blk_rq_bytes(rq))
> -				rq->resid_len = blk_rq_bytes(rq) - cmd->act_len;
> +			rq->resid_len -= min(cmd->act_len, rq->resid_len);
>  			scsi_status = 0;

You are subtracting resid_len from itself. Just how in the world
can this be correct?

Even it if is, in fact, correct, it's such an eggregious violation
of good style, that your good programmer's card is going to lose
a big coupon and have a hole punched in it.

This is not in Linus' tree yet, but I'm going to take a hard look
at this once it shows up.

-- Pete
