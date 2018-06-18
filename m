From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Mon, 18 Jun 2018 10:23:45 -0600
Message-ID: <229a6637-3f9e-e8ed-d94a-cafbbd47f140@kernel.dk>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180618161657.GP30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618161657.GP30522@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dgilbert@interlog.com, Jann Horn <jannh@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/18/18 10:16 AM, Al Viro wrote:
> On Mon, Jun 18, 2018 at 09:37:01AM -0600, Jens Axboe wrote:
> 
>>> The folks responsible are no longer active in kernel development ***
>>> but as far as I know the async write(command), read(response) were
>>> added to bsg over 10 years ago as proof-of-concept and never properly
>>> worked in this async mode. The biggest design problem with it that I'm
>>
>> It was born with that mode, but I don't think anyone ever really used it.
>> So it might feasible to simply yank it. That said, just doing a prune
>> mode at ->release() time doesn't seem like such a hard task.
> 
> "prune mode" being...?

Basically what Jann posted, not doing any copy-back of data. Need to
verify if the bio unmapping is handled correctly, as some of those
will also copy when the end_io handling is invoked.

-- 
Jens Axboe
