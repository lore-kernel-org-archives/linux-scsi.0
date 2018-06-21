From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Thu, 21 Jun 2018 08:07:23 -0600
Message-ID: <36a641db-fb1d-6c4c-7f1b-172f2b1cde32@kernel.dk>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621123431.GA558@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dgilbert@interlog.com, Al Viro <viro@ZenIV.linux.org.uk>, Jann Horn <jannh@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/21/18 6:34 AM, Christoph Hellwig wrote:
> On Mon, Jun 18, 2018 at 09:37:01AM -0600, Jens Axboe wrote:
>> It was born with that mode, but I don't think anyone ever really used it.
>> So it might feasible to simply yank it. That said, just doing a prune
>> mode at ->release() time doesn't seem like such a hard task.
> 
> Let's try to kill it.  It is a significant amount of code, which does
> fishy things and is probably entirely unused:

I'd be fine with that, if we knew that nobody uses it. But that's
really hard to figure out. I did see Jann's source code scan, which
even if non-exhaustive, still shows at least one user of it.

How about we just make the write interface sync? Then any copy can
happen while the we block the task, and the read side is just
copying the header info back, or dumping it if the task didn't
read it before it went away.

That will still be functional, just not queueable. But that's not
a huge concern, it won't break any applications. And with pure
sync issue, most of the code goes away anyway and becomes similar
to the sync ioctl.

-- 
Jens Axboe
