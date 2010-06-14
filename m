From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [BSG]: Add support for struct
 sg_io_v4->d[out,in]_iovec_count
Date: Mon, 14 Jun 2010 15:22:49 +0900
Message-ID: <20100614152138W.fujita.tomonori@lab.ntt.co.jp>
References: <1276495889-1714-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53145 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab0FNGXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2010 02:23:23 -0400
In-Reply-To: <1276495889-1714-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com, James.Bottomley@suse.de, hch@lst.de, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hare@suse.de

On Sun, 13 Jun 2010 23:11:29 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings Jens and co,
> 
> This patch adds the missing support to block/bsg.c:bsg_map_hdr() to accept
> struct sg_io_v4->d[out,in]_iovec_count and process struct sg_io_v4->d[out,in]_xferp memory
> containing userspace iovecs for kernel level BSG.  It adds a new wrapper bsg_rq_map_user_iov()
> that will call copy_from_user() and blk_rq_map_user_iov() following the original SG_IO logic in
> drivers/scsi/sg.c:sg_start_req().
> 
> So far this has been tested on a x86_64 v2.6.34 KVM Host with TCM_Loop Virtual SAS Port/LUNs
> into a x86_64 v2.6.26 KVM Guest with Megasas 8707EM2 HBA Emulation + my new scsi-bsg backstore code.
> 
> Please consider this for v2.6.36 as it will be required in order for QEMU-KVM MegaSAS and VirtIO HBA
> emulation using QEMU scatterlist memory and BSG backstores.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  block/bsg.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 47 insertions(+), 8 deletions(-)

This have been rejected several times.

This doesn't work on 32bit user/64bit kernel.

The compat code doesn't work for the read/write interface (does for
the ioctl interface though). So we can't support this feature cleanly.
