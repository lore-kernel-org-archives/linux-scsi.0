From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/23] sd: implement REQ_OP_WRITE_ZEROES
Date: Tue, 28 Mar 2017 15:33:54 -0400
Message-ID: <20170328193354.GB21445@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-4-hch@lst.de>
	<1490726988.2573.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490726988.2573.16.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 28 2017 at  2:50pm -0400,
Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

> On Thu, 2017-03-23 at 10:33 -0400, Christoph Hellwig wrote:
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index af632e350ab4..b6f70a09a301 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -748,7 +748,7 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
> >  	return scsi_init_io(cmd);
> >  }
> >  
> > -static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
> > +static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd, bool unmap)
> >  {
> >  	struct scsi_device *sdp = cmd->device;
> >  	struct request *rq = cmd->request;
> > @@ -765,13 +765,14 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
> >  
> >  	cmd->cmd_len = 16;
> >  	cmd->cmnd[0] = WRITE_SAME_16;
> > -	cmd->cmnd[1] = 0x8; /* UNMAP */
> > +	if (unmap)
> > +		cmd->cmnd[1] = 0x8; /* UNMAP */
> >  	put_unaligned_be64(sector, &cmd->cmnd[2]);
> >  	put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
> 
> Hello Christoph,
> 
> A quote from SBC: "An OPTIMAL UNMAP GRANULARITY field set to a non-zero value
> indicates the optimal granularity in logical blocks for unmap requests (e.g.,
> an UNMAP command or a WRITE SAME (16) command with the UNMAP bit set to one).
> An unmap request with a number of logical blocks that is not a multiple of
> this value may result in unmap operations on fewer LBAs than requested."
> 
> This means that just like the start and end of a discard must be aligned on a
> discard_granularity boundary, WRITE SAME commands with the UNMAP bit set must
> also respect that granularity. I think this means that either
> __blkdev_issue_zeroout() has to be modified such that it rejects unaligned
> REQ_OP_WRITE_ZEROES operations or that blk_bio_write_same_split() has to be
> modified such that it generates REQ_OP_WRITEs for the unaligned start and tail.

That'd get DM thinp off the hook from having to zero the unaligned start
and tail...
