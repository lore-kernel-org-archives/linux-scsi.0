From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [BSG]: Add support for struct
	sg_io_v4->d[out,in]_iovec_count
Date: Sun, 13 Jun 2010 23:42:33 -0700
Message-ID: <1276497753.32681.37.camel@haakon2.linux-iscsi.org>
References: <1276495889-1714-1-git-send-email-nab@linux-iscsi.org>
	 <20100614152138W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100614152138W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, kvm-devel <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-06-14 at 15:22 +0900, FUJITA Tomonori wrote:
> On Sun, 13 Jun 2010 23:11:29 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings Jens and co,
> > 
> > This patch adds the missing support to block/bsg.c:bsg_map_hdr() to accept
> > struct sg_io_v4->d[out,in]_iovec_count and process struct sg_io_v4->d[out,in]_xferp memory
> > containing userspace iovecs for kernel level BSG.  It adds a new wrapper bsg_rq_map_user_iov()
> > that will call copy_from_user() and blk_rq_map_user_iov() following the original SG_IO logic in
> > drivers/scsi/sg.c:sg_start_req().
> > 
> > So far this has been tested on a x86_64 v2.6.34 KVM Host with TCM_Loop Virtual SAS Port/LUNs
> > into a x86_64 v2.6.26 KVM Guest with Megasas 8707EM2 HBA Emulation + my new scsi-bsg backstore code.
> > 
> > Please consider this for v2.6.36 as it will be required in order for QEMU-KVM MegaSAS and VirtIO HBA
> > emulation using QEMU scatterlist memory and BSG backstores.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  block/bsg.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 47 insertions(+), 8 deletions(-)
> 
> This have been rejected several times.
> 

I guess that would explain why the iovec_count structure members are
part of struct sg_io_v4 and block/bsg.c:bsg_map_hdr() silently accepts
and overwrites them..  :(

> This doesn't work on 32bit user/64bit kernel.

Hmmm, being able to use QEMU-KVM HBA emulation with userspace
scatterlist memory for the various HBA emulation with a matched
user/kernel is still useful though, yes..?  Being able to handle TMR
emulation from QEMU-KVM HBA emulation would also be useful I think.

Having QEMU-KVM fall back to SG_IO for the 32bit/64bit kernel would be
accpetable for me if we can still make BSG + iovecs work for the typical
case.

> 
> The compat code doesn't work for the read/write interface (does for
> the ioctl interface though). So we can't support this feature cleanly.

So I am curious to see if there will be a performance improvement
between QEMU-KVM + scsi-bsg w/ AIO IOVECs compared to the legacy SG_IO
ioctl().  Anyways, I will post my QEMU-KVM scsi-bsg patches and run some
benchmarks this week with this patch on 5500 series Nehalem so see aside
from the userspace TMR case how useful having a BSG backstore for
QEMU-KVM may be.

Best,

--nab
