From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bsg: remove read/write support
Date: Thu, 12 Jul 2018 08:04:29 -0600
Message-ID: <7882dce2-4dca-3af6-7aea-7acd9997f3e9@kernel.dk>
References: <20180712080959.21180-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712080959.21180-1-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: torvalds@linux-foundation.org, tonyb@cybernetics.com, jannh@google.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/12/18 2:09 AM, Christoph Hellwig wrote:
> The code poses a security risk due to user memory access in ->release
> and had an API that can't be used reliably.  As far as we know it was
> never used for real, but if that turns out wrong we'll have to revert
> this commit and come up with a band aid.
> 
> Jann Horn did look software archives for users of this interface,
> and the only users found were example code in sg3_utils, and optional
> support in an optional module of the tgt user space iscsi target,
> which looks like a proof of concept extension of the /dev/sg
> read/write support.
> 
> Tony Battersby chimes in that the code is basically unsafe to use in
> general:
> 
>   The read/write interface on /dev/bsg is impossible to use safely
>   because the list of completed commands is per-device (bd->done_list)
>   rather than per-fd like it is with /dev/sg.  So if program A and
>   program B are both using the write/read interface on the same bsg
>   device, then their command responses will get mixed up, and program
>   A will read() some command results from program B and vice versa.
>   So no, I don't use read/write on /dev/bsg.  From a security standpoint,
>   it should definitely be fixed or removed.

Applied for 4.19.

-- 
Jens Axboe
