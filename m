From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Fix more error handling in SCSI_IOCTL_SEND_COMMAND
Date: Mon, 10 Nov 2014 15:43:48 -0700
Message-ID: <54613FA4.8040802@kernel.dk>
References: <54613EC2.8010304@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54613EC2.8010304@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2014-11-10 15:40, Tony Battersby wrote:
> Fix an error path in SCSI_IOCTL_SEND_COMMAND that calls
> blk_put_request(rq) on an invalid IS_ERR(rq) pointer.
>
> Fixes: a492f075450f ("block,scsi: fixup blk_get_request dead queue scenarios")
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Thanks, good catch. Might be an idea to have blk_put_request() do 
warn-and-return check on error pointers being passed in, just in case.

-- 
Jens Axboe
