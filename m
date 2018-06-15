From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in release
Date: Fri, 15 Jun 2018 18:44:51 +0200
Message-ID: <CAG48ez2Fku77S+FM2w5n8J_utOhO0EW_RFbMib=t5Nmwc9pwfQ@mail.gmail.com>
References: <20180615152335.208202-1-jannh@google.com> <20180615164009.GD30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615164009.GD30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 6:40 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Jun 15, 2018 at 05:23:35PM +0200, Jann Horn wrote:
>
> > I've mostly copypasted ib_safe_file_access() over as
> > scsi_safe_file_access() because I couldn't find a good common header -
> > please tell me if you know a better way.
> > The duplicate pr_err_once() calls are so that each of them fires once;
> > otherwise, this would probably have to be a macro.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
>
> WTF do you mean, in ->release()?  That makes no sense whatsoever -
> what kind of copy_{to,from}_user() would be possible in there?

bsg_release -> bsg_put_device -> bsg_complete_all_commands ->
blk_complete_sgv4_hdr_rq -> bsg_scsi_complete_rq -> copy_to_user.
I don't think that was intentional.

Basically, the sense buffer is copied to a userspace address supplied
in the previous ->write() when you ->read() the reply. But when you
->release() the file without reading the reply, they have to clean it
up, and for that, they reuse the same code they use for ->read() - so
the sense buffer is written to userspace on ->release().
