From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 05 Mar 2008 03:35:55 +0900
Message-ID: <47CD968B.1070302@gmail.com>
References: <20080304093536.GH6704@kernel.dk>	<1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com> <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com> <47CD9457.3090203@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CD9457.3090203@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <tomof@acm.org>, efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
>> -	good_bytes = scsi_bufflen(cmd);
>> +	good_bytes = scsi_bufflen(cmd) + cmd->request->data_len;
> 
> Are you sure? is it not:
> +	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len

You're right.  Sorry about the confusion.

>>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
>>  		drv = scsi_cmd_to_driver(cmd);
>>  		if (drv->done)
>>
>>
> 
> I hate this patch. I wish you could maybe take the extra_len into 
> account inside blk_end_request. The padding should be transparent
> to all concerned but the requesting LLD and the internals of the
> block layer. If block layer added padding it should take that into
> account on completion. My $0.2.

Yeah, I hate it too.  As I've been saying all along, I think it just
should be rq->data_len.

-- 
tejun
