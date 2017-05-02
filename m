From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 25/27] block: remove the discard_zeroes_data
	flag
Date: Mon, 01 May 2017 23:43:45 -0700
Message-ID: <1493707425.23202.77.camel@haakon3.risingtidesystems.com>
References: <20170405172125.22600-1-hch@lst.de>
	<20170405172125.22600-26-hch@lst.de>
	<1493671519.2665.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1493671519.2665.15.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
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
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-05-01 at 20:45 +0000, Bart Van Assche wrote:
> On Wed, 2017-04-05 at 19:21 +0200, Christoph Hellwig wrote:
> > Now that we use the proper REQ_OP_WRITE_ZEROES operation everywhere we can
> > kill this hack.
> > 
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
> > [ ... ]
> > diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> > index c754ae33bf7b..d2f089cfa9ae 100644
> > --- a/drivers/target/target_core_device.c
> > +++ b/drivers/target/target_core_device.c
> > @@ -851,7 +851,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
> >  	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
> >  	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
> >  								block_size;
> > -	attrib->unmap_zeroes_data = q->limits.discard_zeroes_data;
> > +	attrib->unmap_zeroes_data = 0;
> >  	return true;
> >  }
> >  EXPORT_SYMBOL(target_configure_unmap_from_queue);
> 
> Hello Christoph,
> 
> Sorry that I hadn't noticed this before but I think that this patch
> introduces a significant performance regressions for LIO users. Before
> this patch the LBPRZ flag was reported correctly to initiator systems
> through the thin provisioning VPD. With this patch applied that flag
> will always be reported as zero, forcing initiators to submit WRITE
> commands with zeroed data buffers instead of submitting the SCSI UNMAP
> command to block devices for which discard_zeroes_data was set. From
> target_core_spc.c:
> 
> /* Thin Provisioning VPD */
> static sense_reason_t spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
> {
> 	[ ... ]
> 	/*
> 	 * The unmap_zeroes_data set means that the underlying device supports
> 	 * REQ_DISCARD and has the discard_zeroes_data bit set. This satisfies
> 	 * the SBC requirements for LBPRZ, meaning that a subsequent read
> 	 * will return zeroes after an UNMAP or WRITE SAME (16) to an LBA
> 	 * See sbc4r36 6.6.4.
> 	 */
> 	if (((dev->dev_attrib.emulate_tpu != 0) ||
> 	     (dev->dev_attrib.emulate_tpws != 0)) &&
> 	     (dev->dev_attrib.unmap_zeroes_data != 0))
> 		buf[5] |= 0x04;
> 	[ ... ]
> }
> 

According to sd_config_discard(), it's SD_LBP_WS16, SD_LBP_WS10 and
SD_LBP_ZERO that where ever setting unmap_zeros_data = 1 to begin with.
For UNMAP, q->limits.discard_zeroes_data was never set.

That said, it's pretty much implied that supporting DISCARD means
subsequent READs return zeros, so target_configure_unmap_from_queue()
should be setting attrib->unmap_zeroes_data = 1, or just dropping it
all-together.

Post -rc1, I'll push a patch to do the latter.
