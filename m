From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: Clear out elevator private data
Date: Tue, 17 Apr 2018 15:45:38 -0600
Message-ID: <7d192394-568c-53e0-4359-723769c3ed7d@kernel.dk>
References: <20180417214218.GA44753@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417214218.GA44753@beast>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, linux-kernel@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/18 3:42 PM, Kees Cook wrote:
> Some elevators may not correctly check rq->rq_flags & RQF_ELVPRIV, and
> may attempt to read rq->elv fields. When requests got reused, this
> caused BFQ to think it already had a bfqq (rq->elv.priv[1]) allocated.
> This could lead to odd behaviors like having the sense buffer address
> slowly start incrementing. This eventually tripped HARDENED_USERCOPY
> and KASAN.
> 
> This patch wipes all of rq->elv instead of just rq->elv.icq. While
> it shouldn't technically be needed, this ends up being a robustness
> improvement that should lead to at least finding bugs in elevators faster.

Comments from the other email still apply, we should not need to do this
full memset() for every request. From a quick look, BFQ needs to straighten
out its usage of prepare request and interactions with insert_request.

> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Fixes: bd166ef183c26 ("blk-mq-sched: add framework for MQ capable IO schedulers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> In theory, BFQ needs to also check the RQF_ELVPRIV flag, but I'll leave that
> to Paolo to figure out. Also, my Fixes line is kind of a best-guess. This
> is where icq was originally wiped, so it seemed as good a commit as any.

Yeah, that's probably a bit too broad for fixes :-)

-- 
Jens Axboe
