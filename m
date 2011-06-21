From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3 RESEND] dma-mapping: add new API for
	max_segment_number
Date: Wed, 22 Jun 2011 02:44:47 +0900
Message-ID: <20110622023929W.fujita.tomonori@lab.ntt.co.jp>
References: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
	<1308227453-2034-1-git-send-email-shawn.guo@linaro.org>
	<20110617124035.GA19693@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20110617124035.GA19693@parisc-linux.org>
Sender: linux-mmc-owner@vger.kernel.org
To: matthew@wil.cx
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, vinod.koul@intel.com, gregkh@suse.de, fujita.tomonori@lab.ntt.co.jp, dan.j.williams@intel.com, cjb@laptop.org, per.forlin@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 Jun 2011 06:40:35 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jun 16, 2011 at 08:30:53PM +0800, Shawn Guo wrote:
> > Here is the user story that tells the need of the new api.  The
> > mxs-mmc is the mmc host controller for Freescale MXS architecture.
> > There are a pair of  mmc host specific parameters max_seg_size and
> > max_segs that mxs-mmc host driver needs to tell mmc core, so that
> > mmc core can know how big each data segment could be and how many
> > segments could be handled one time in a scatter list by host driver.
> > 
> > The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
> > mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
> > no idea of what max_seg_size and max_segs should be, because they are
> > all mxs-dma capability parameters, and mxs-mmc needs to query them
> > from mxs-dma.
> 
> This approach would make sense if mxs-mmc were generic, but it's tied to
> mxs-dma, so it can just as well call mxs-dma to find out how many segments
> it supports.

SCSI HBA drivers stores the max number of sg entries in
host->sg_tablesize (and scsi-ml tells the block layer about the
limit)? So if we have the generic API to handle the value, scsi HBA
drivers (and scsi-ml) could use it too?
