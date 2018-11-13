From: Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH 6/8] bsg-lib: handle bidi requests without block layer
 help
Date: Tue, 13 Nov 2018 15:35:20 +0100
Message-ID: <20181113143520.GB7222@w530-pk1mzal>
References: <20181111133211.13926-1-hch@lst.de>
 <20181111133211.13926-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181111133211.13926-7-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2018 at 02:32:09PM +0100, Christoph Hellwig wrote:
> We can just stash away the second request in struct bsg_job instead
> of using the block layer req->next_rq field, allowing for the eventual
> removal of the latter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c                   | 44 +++++++++++++++++++---
>  block/bsg.c                       | 62 ++++++-------------------------
>  drivers/scsi/scsi_transport_sas.c |  1 -
>  include/linux/bsg-lib.h           |  4 ++
>  4 files changed, 54 insertions(+), 57 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 192129856342..005e2b75d775 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -74,6 +74,9 @@ static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
>  {
>  	struct scsi_request *sreq = scsi_req(rq);
> 
> +	if (hdr->dout_xfer_len && hdr->din_xfer_len)
> +		return -EOPNOTSUPP;
> +

This seems like a non-obvious user-breakage. So apart from removing the
in-kernel stuff that uses bidirectional commands you also forbid
userspace from every using them? That seems wrong to me.

There is other SCSI Command Sets than OSD that provide bidirectional
commands, even SBC has some (i.e.  X*WRITE*, COMPARE AND WRITE).



-- 
With Best Regards, Benjamin Block      /      Linux on IBM Z Kernel Development
IBM Systems & Technology Group   /  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz       /      Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
