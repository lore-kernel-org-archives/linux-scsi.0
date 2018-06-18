From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Mon, 18 Jun 2018 09:37:01 -0600
Message-ID: <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-13559-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
Content-Language: en-US
To: dgilbert@interlog.com, Al Viro <viro@ZenIV.linux.org.uk>, Jann Horn <jannh@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/15/18 2:47 PM, Douglas Gilbert wrote:
> On 2018-06-15 12:40 PM, Al Viro wrote:
>> On Fri, Jun 15, 2018 at 05:23:35PM +0200, Jann Horn wrote:
>>
>>> I've mostly copypasted ib_safe_file_access() over as
>>> scsi_safe_file_access() because I couldn't find a good common header -
>>> please tell me if you know a better way.
>>> The duplicate pr_err_once() calls are so that each of them fires once;
>>> otherwise, this would probably have to be a macro.
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>
>> WTF do you mean, in ->release()?  That makes no sense whatsoever -
>> what kind of copy_{to,from}_user() would be possible in there?
> 
> The folks responsible are no longer active in kernel development ***
> but as far as I know the async write(command), read(response) were
> added to bsg over 10 years ago as proof-of-concept and never properly
> worked in this async mode. The biggest design problem with it that I'm

It was born with that mode, but I don't think anyone ever really used it.
So it might feasible to simply yank it. That said, just doing a prune
mode at ->release() time doesn't seem like such a hard task.

> aware of is that two tasks which issue write(commands) at about the
> same time to the same device can receive one another's read(response).
> The tracking of which response belongs to which task is in part the
> reason why the sg driver's data structures are more complex than the
> bsg driver's are. Hence the code work to fix that problem in the bsg
> driver is not trivial and probably a reason why no-one has attempted it.
> 
> Once real world users (needing an async SCSI (or general storage)
> pass-through) find out about that bsg "feature", they don't use it.
> They use the sg driver or something else. So the fact that bsg has
> other glaring errors in it in async mode is no surprise to me.
> 
> When I took over the maintenance of the sg driver in 1998, it only
> had an async (i.e. write(command), read(response)) interface.
> The SG_IO ioctl was added at the suggestion of Jørg Schilling (of
> cdrecord "fame"). The sg driver implementation was essentially to
> put a write(command) and read(response) back-to-back. The bsg driver
> came along later and started with the synchronous SG_IO ioctl
> interface only. The async write(command)/read(response) functionality
> was added later to bsg. Perhaps that part of the bsg driver should be
> deprecated/withdrawn if a maintainer/rewriter cannot be found.
> [BTW the bsg sync SG_IO ioctl implementation can probably get the
> wrong response, it's just that the window is a lot narrower.]

Feature wise, I don't think it ever changed. The read/write async
mode was included from the get-go.

> 
> That said, the bsg driver has lots of other users. For example it is
> the only generic pass-through in Linux for the SAS Management Protocol
> (SMP) used to control SAS based storage enclosures. I have a user space
> package based on it (in Linux) called smp_utils which works well IMO.
> However disk enclosures won't typically have contention between users
> trying to control them and I'm not aware of any disk enclosures that
> support Persistent Reservations. So the bsg driver's "async" problems
> are not a practical issue in this case. Also I believe some high end
> storage hardware uses bsg to communicate with their hardware from their
> user space tools.
> 
> 
> Just some observations from an interested observer ...
> 
> Doug Gilbert
> 
> 
> *** Well Jens Axbø's Copyright notice is on the bsg driver, together with
>      and Peter M. Jones. Since I have been watching the bsg driver I'm
>      not aware of any substantial patches or reworks for them. As far as
>      I know FUJITA Tomonori did a ground up rewrite of it and he no longer
>      works in this area. Makes you wonder what exactly Copyright banners
>      mean on some code; 10, 15, 20 years on.

It was never re-written. I handed it over to Fujita about 11 years ago,
but there was never any rewrite.

BTW, don't ever write my name like that, the 'oe' is not a spelled out
ascii variant, it's my name. For Jörg, it's o with umlaut, not the
Danish/Norwegian variant (he's German).

-- 
Jens Axboe
