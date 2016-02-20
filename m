From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath test scripts
Date: Sat, 20 Feb 2016 11:34:49 -0500
Message-ID: <20160220163449.GA26384@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
 <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com>
 <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com>
 <56C834F8.8050604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbcBTQev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Feb 2016 11:34:51 -0500
Content-Disposition: inline
In-Reply-To: <56C834F8.8050604@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Feb 20 2016 at  4:42am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/20/2016 07:12 AM, Mike Snitzer wrote:
> >On Fri, Feb 19 2016 at  2:42pm -0500,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>On Fri, Feb 19 2016 at  3:37am -0500,
> >>Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> >>
> >>>On 02/19/16 09:33, Nomura Junichi wrote:
> >>>>On 02/19/16 02:17, Mike Snitzer wrote:
> >>>>>What is the last kernel version that your scripts have worked on?
> >>>>
> >>>>v4.4 worked fine. I'll check with v4.5-rc4 when I get a machine.
> >>>
> >>>v4.5-rc4 works fine, too.
> >>
> >>Have you been running with blk-mq?
> >>Either by setting CONFIG_DM_MQ_DEFAULT or:
> >>echo Y > /sys/module/dm_mod/parameters/use_blk_mq
> >>
> >>I'm seeing test_02_sdev_delete fail with blk-mq enabled.
> >
> >I only see failure if I stack dm-mq ontop of old non-mq scsi devices with:
> >
> >echo N > /sys/module/scsi_mod/parameters/use_blk_mq
> >echo Y > /sys/module/dm_mod/parameters/use_blk_mq
> >
> >If I use scsi-mq for the underlying devices all works fine (been testing
> >the latest dm-4.6 branch though, I'll go back and try stock 4.5-rc4 just
> >to double check).
> >
> >But this makes me think the novelty of having dm-mq support stacking on
> >non-blk-mq devices was misplaced.  It is a senseless config.  I'll
> >probably remove support for such stacking soon (next week).
> 
> Hmm. I must admit I really, really don't like these 'once-and-for-all'
> parameter.
> 
> ATM the only SCSI driver to support SCSI-mq properly are lpfc,
> virtio, and fnic. None of the other driver have been modified, and I
> suspect the performance might be less than stellar.
> 
> So there will be configurations where one might want to run scsi-mq
> alongside non-mq HBAs.

dm-mq already disallows such a mix though.  From dm_table_set_type():

        if (use_blk_mq) {
                /* verify _all_ devices in the table are blk-mq devices */
                list_for_each_entry(dd, devices, list)
                        if (!bdev_get_queue(dd->dm_dev->bdev)->mq_ops) {
                                DMERR("table load rejected: not all devices"
                                      " are blk-mq request-stackable");
                                return -EINVAL;
                        }
                t->type = DM_TYPE_MQ_REQUEST_BASED;

        }

But I was talking about removing support for dm-mq stacked on _all_ old
.request_fn devices.

> I would really love to see to make that more granular so that these
> configurations can run efficiently.
> I know Christoph is violently against it, but I don't really see any
> solution presenting itself at the moment.

I'm with Christoph on this.  Supporting such elaborate mixing is too
fragile.  Time would be much better spent converting drivers to properly
support scsi-mq and/or fixing scsi-mq to perform better.

> Maybe a good topic for LSF ...

Unlikely.. but don't let me stop you! ;)
