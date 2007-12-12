From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 22/30] blk_end_request: changing cpqarray (take 4)
Date: Wed, 12 Dec 2007 15:25:52 +0000
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15718B39@G6W0268.americas.hpqcorp.net>
References: <20071211.175021.39666150.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:59009 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbXLLPaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 10:30:23 -0500
In-Reply-To: <20071211.175021.39666150.k-ueda@ct.jp.nec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>



> -----Original Message-----
> From: Kiyoshi Ueda [mailto:k-ueda@ct.jp.nec.com]
> Sent: Tuesday, December 11, 2007 4:50 PM
> To: jens.axboe@oracle.com
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
> linux-ide@vger.kernel.org; dm-devel@redhat.com;
> j-nomura@ce.jp.nec.com; k-ueda@ct.jp.nec.com; Miller, Mike (OS Dev)
> Subject: [PATCH 22/30] blk_end_request: changing cpqarray (take 4)
>
> This patch converts cpqarray to use blk_end_request interfaces.
> Related 'ok' arguments are converted to 'error'.
>
> cpqarray is a little bit different from "normal" drivers.
> cpqarray directly calls bio_endio() and disk_stat_add() when
> completing request.  But those can be replaced with
> __end_that_request_first().
> After the replacement, request completion procedures of those
> drivers become like the following:
>     o end_that_request_first()
>     o add_disk_randomness()
>     o end_that_request_last()
> This can be converted to __blk_end_request() by following the
> rule (b) mentioned in the patch subject "[PATCH 01/30]
> blk_end_request: add new request completion interface".
>
> Cc: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cpqarray.c |   36 +++++++-----------------------------
>  1 files changed, 7 insertions(+), 29 deletions(-)
>
> Index: 2.6.24-rc4/drivers/block/cpqarray.c
> ===================================================================
> --- 2.6.24-rc4.orig/drivers/block/cpqarray.c
> +++ 2.6.24-rc4/drivers/block/cpqarray.c
> @@ -167,7 +167,6 @@ static void start_io(ctlr_info_t *h);
>
>  static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
> static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t
> *c); -static inline void complete_buffers(struct bio *bio,
> int ok);  static inline void complete_command(cmdlist_t *cmd,
> int timeout);
>
>  static irqreturn_t do_ida_intr(int irq, void *dev_id); @@
> -980,26 +979,13 @@ static void start_io(ctlr_info_t *h)
>         }
>  }
>
> -static inline void complete_buffers(struct bio *bio, int ok) -{
> -       struct bio *xbh;
> -
> -       while (bio) {
> -               xbh = bio->bi_next;
> -               bio->bi_next = NULL;
> -
> -               bio_endio(bio, ok ? 0 : -EIO);
> -
> -               bio = xbh;
> -       }
> -}
>  /*
>   * Mark all buffers that cmd was responsible for
>   */
>  static inline void complete_command(cmdlist_t *cmd, int timeout)  {
>         struct request *rq = cmd->rq;
> -       int ok=1;
> +       int error = 0;
>         int i, ddir;
>
>         if (cmd->req.hdr.rcode & RCODE_NONFATAL && @@
> -1011,16 +997,17 @@ static inline void complete_command(cmdl
>         if (cmd->req.hdr.rcode & RCODE_FATAL) {
>                 printk(KERN_WARNING "Fatal error on ida/c%dd%d\n",
>                                 cmd->ctlr, cmd->hdr.unit);
> -               ok = 0;
> +               error = -EIO;
>         }
>         if (cmd->req.hdr.rcode & RCODE_INVREQ) {
>                                 printk(KERN_WARNING "Invalid
> request on ida/c%dd%d = (cmd=%x sect=%d cnt=%d sg=%d ret=%x)\n",
>                                 cmd->ctlr, cmd->hdr.unit,
> cmd->req.hdr.cmd,
>                                 cmd->req.hdr.blk,
> cmd->req.hdr.blk_cnt,
>                                 cmd->req.hdr.sg_cnt,
> cmd->req.hdr.rcode);
> -               ok = 0;
> +               error = -EIO;
>         }
> -       if (timeout) ok = 0;
> +       if (timeout)
> +               error = -EIO;
>         /* unmap the DMA mapping for all the scatter gather
> elements */
>         if (cmd->req.hdr.cmd == IDA_READ)
>                 ddir = PCI_DMA_FROMDEVICE; @@ -1030,18
> +1017,9 @@ static inline void complete_command(cmdl
>                  pci_unmap_page(hba[cmd->ctlr]->pci_dev,
> cmd->req.sg[i].addr,
>                                 cmd->req.sg[i].size, ddir);
>
> -       complete_buffers(rq->bio, ok);
> -
> -       if (blk_fs_request(rq)) {
> -               const int rw = rq_data_dir(rq);
> -
> -               disk_stat_add(rq->rq_disk, sectors[rw],
> rq->nr_sectors);
> -       }
> -
> -       add_disk_randomness(rq->rq_disk);
> -
>         DBGPX(printk("Done with %p\n", rq););
> -       end_that_request_last(rq, ok ? 1 : -EIO);
> +       if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> +               BUG();
>  }
>
>  /*
>
