From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to
 blk_rq_bytes() on issue
Date: Fri, 15 May 2009 17:16:45 -0600
Message-ID: <20090515171645.7a92d46c.zaitcev@redhat.com>
References: <4A0D86DB.9000203@kernel.org>
	<4A0D87D2.7090806@gmail.com>
	<20090515112901.84d4dd97.zaitcev@redhat.com>
	<4A0DE954.4020102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0DE954.4020102@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>, zaitcev@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 16 May 2009 07:14:44 +0900, Tejun Heo <htejun@gmail.com> wrote:

> So, I could have written
> 
>  if (cmd->act_len >= rq->resid_len)
> 	rq->resid_len = 0;
>  else
> 	rq->resid_len -= cmd->act_len
> 
> Instead I wrote
> 
>  rq->resid_len -= min(cmd->act_len, rq->resid_len);
> 
> It's just capping the amount to be subtracted so that resid_len
> doesn't underflow.  What is so wrong or bad style about that?

Curse of the gifted, I guess. To use a subtraction instead of zero
this way looks like a pointless, even mischievous obfuscation to me.

Also, we probably want a stack_dump or a printk when actual length
exceeds the requested length, don't we? If it ever happens, we
might be overwriting some I/O buffer somewhere.

-- Pete
