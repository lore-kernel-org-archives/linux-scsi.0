From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
Date: Sat, 16 May 2009 09:14:23 +0900
Message-ID: <4A0E055F.9000308@gmail.com>
References: <4A0D86DB.9000203@kernel.org>	<4A0D87D2.7090806@gmail.com>	<20090515112901.84d4dd97.zaitcev@redhat.com>	<4A0DE954.4020102@gmail.com> <20090515171645.7a92d46c.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090515171645.7a92d46c.zaitcev@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Pete Zaitcev wrote:
>> So, I could have written
>>
>>  if (cmd->act_len >= rq->resid_len)
>> 	rq->resid_len = 0;
>>  else
>> 	rq->resid_len -= cmd->act_len
>>
>> Instead I wrote
>>
>>  rq->resid_len -= min(cmd->act_len, rq->resid_len);
>>
>> It's just capping the amount to be subtracted so that resid_len
>> doesn't underflow.  What is so wrong or bad style about that?
> 
> Curse of the gifted, I guess. To use a subtraction instead of zero
> this way looks like a pointless, even mischievous obfuscation to me.

Ummm... I don't know.  I prefer min/max over if/else when capping
values.  To me, it makes the intention clearer but you're the
maintainer and don't like the style, so I'll update the patch so that
it has the if/else clause.  :-)

> Also, we probably want a stack_dump or a printk when actual length
> exceeds the requested length, don't we? If it ever happens, we
> might be overwriting some I/O buffer somewhere.

It depends on particular implementation.  Transport overflow doesn't
necessarily become actual buffer overflow depending on hardware and
driver implementation.  If you think the user needs to be warned about
transport overflow, please go ahead and add a warning there.

Thanks.

-- 
tejun
