From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 05 May 2009 12:41:15 +0900
Message-ID: <49FFB55B.9060902@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <49FEDAC0.3040503@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FEDAC0.3040503@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index 7149224..3813a0e 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive,
>> int dsc)
>>          }
>>  
>>          tape->first_frame += blocks;
>> -        rq->data_len -= blocks * tape->blk_size;
>> +        rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
> 
>    Is it already guaranteed that rq->data_len == blk_rq_bytes(rq) here?

Oops, no.  I'll move it to later ide-cleanup-rq-data_len-usages patch.

Thanks.

-- 
tejun
