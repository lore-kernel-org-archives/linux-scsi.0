From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in release
Date: Fri, 15 Jun 2018 19:02:44 +0200
Message-ID: <CAG48ez1G84FsGOSp_R89Fn8W1q4fNj1REiEVvfiQZO-cE18Z9Q@mail.gmail.com>
References: <20180615152335.208202-1-jannh@google.com> <20180615164930.GE30522@ZenIV.linux.org.uk>
 <CAG48ez0x+d78yUc3FxHcQOtJRCF1j3Af+iR=UojnDrqqYzzTcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0x+d78yUc3FxHcQOtJRCF1j3Af+iR=UojnDrqqYzzTcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 6:58 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Jun 15, 2018 at 6:49 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Fri, Jun 15, 2018 at 05:23:35PM +0200, Jann Horn wrote:
> > > As Al Viro noted in commit 128394eff343 ("sg_write()/bsg_write() is not fit
> > > to be called under KERNEL_DS"), sg and bsg improperly access userspace
> > > memory outside the provided buffer, permitting kernel memory corruption via
> > > splice().
> > > But they don't just do it on ->write(), also on ->read() and (in the case
> > > of bsg) even on ->release().
> > >
> > > As a band-aid, make sure that the ->read() and ->write() handlers can not
> > > be called in weird contexts (kernel context or credentials different from
> > > file opener), like for ib_safe_file_access().
> > > Also, completely prevent user memory accesses from ->release().
> >
> > Band-aid it is, and a bloody awful one, at that.  What the hell is going on
> > in bsg_put_device() and can it _ever_ hit that call chain?  I.e.
> >         bsg_release()
> >                 bsg_put_device()
> >                         blk_complete_sgv4_hdr_rq()
> >                                 ->complete_rq()
> >                                         copy_to_user()
> > If it can, the whole thing is FUBAR by design - ->release() may bloody well
> > be called in a context that has no userspace at all.
> >
> > This is completely insane; what's going on there?
>
> Perhaps I should have split my patch into two parts; it consists of
> two somewhat related changes.
>
> The first change is that ->read() and ->write() violate the normal
> contract and, as a band-aid, should not be called in uaccess_kernel()
> context or with changed creds.
>
> The second change is an actual fix: AFAICS ->release() accidentally
> accessed userspace, which I've fixed using the added "cleaning_up"
> parameter.

FWIW, the demo code I'm using to test this in a QEMU VM:

$ cat test.c
#define _GNU_SOURCE
#include <fcntl.h>
#include <unistd.h>
#include <linux/bsg.h>
#include <string.h>
#include <err.h>
#include <stdio.h>

int main(void) {
  int fd = open("/dev/bsg/0:0:0:0", O_RDWR);
  if (fd == -1)
    err(1, "foo");
  __u8 buf1[255];
  __u8 request[10] = {
    [0] = 0x5a, // MODE_SENSE_10
    [2] = 0x41,
    [8] = 0x10
  };
  __u8 sense[32];
  memset(sense, 'A', sizeof(sense));
  memset(buf1, 'A', sizeof(buf1));
  struct sg_io_v4 req = {
    .guard = 'Q',
    .protocol = BSG_PROTOCOL_SCSI,
    .subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD,
    .request_len = sizeof(request),
    .request = (__u64)request,
    .max_response_len = sizeof(sense),
    .response = (__u64)sense,
    .din_xfer_len = sizeof(buf1),
    .din_xferp = (__u64)buf1,
    .timeout = 1000
  };
  if (write(fd, &req, sizeof(req)) != sizeof(req))
    err(1, "write");
  printf("sense[0] after write: 0x%02hhx\n", sense[0]);

  /*
  struct sg_io_v4 resp;
  if (splice(fd, NULL, pipe_fds[1], NULL, sizeof(struct sg_io_v4), 0)
!= sizeof(struct sg_io_v4))
    err(1, "splice");
    */

  sleep(1);
  printf("sense[0] after sleep: 0x%02hhx\n", sense[0]);
  close(fd);
  printf("sense[0] after close: 0x%02hhx\n", sense[0]);
}
$ gcc -o test test.c -Wall && sudo ./test
sense[0] after write: 0x41
sense[0] after sleep: 0x41
sense[0] after close: 0xf0
$ uname -a
Linux debian 4.17.0+ #10 SMP Fri Jun 15 14:48:42 CEST 2018 x86_64 GNU/Linux
