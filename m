Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AEFC433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7F561A1E
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZRM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:12:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:39002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhCZRMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 13:12:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616778742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ZVzcRgPNqukAOdCcm7h3Tg0naSD0/Jbw2asDN5SmnM=;
        b=g0MhjgYI5r5mACk+BL4KSfRdQ0pKyqnepbPAQudieIt4NGzaf3AeDhJO0pugf2WhXGHr6p
        3wLIItMU2sivl7wvVCPDivX4aGa9m7cSiIWDB/x/FflWPw+kRb4K0TRshSlYLdGcU+2GnM
        bJ+RLwg5Oeflf6YuHWqEDa9Zt8u2r2o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF578AD8D;
        Fri, 26 Mar 2021 17:12:22 +0000 (UTC)
Message-ID: <3ea650fd67ddea9a4145985e687dcff29134a37c.camel@suse.com>
Subject: Re: [dm-devel] md/dm-mpath: check whether all pgpaths have same
 uuid in multipath_ctr()
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@redhat.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     lixiaokeng <lixiaokeng@huawei.com>,
        linfeilong <linfeilong@huawei.com>, linux-scsi@vger.kernel.org,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        "wubo (T)" <wubo40@huawei.com>, agk@redhat.com
Date:   Fri, 26 Mar 2021 18:12:21 +0100
In-Reply-To: <20210325151407.GA17059@redhat.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
         <20210322081155.GE1946905@infradead.org>
         <20210322142207.GB30698@redhat.com>
         <cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
         <20210325151407.GA17059@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-03-25 at 11:14 -0400, Mike Snitzer wrote:
> On Wed, Mar 24 2021 at  9:21pm -0400,
> Zhiqiang Liu <liuzhiqiang26@huawei.com> wrote:
> 
> > 
> > 
> > On 2021/3/22 22:22, Mike Snitzer wrote:
> > > On Mon, Mar 22 2021 at  4:11am -0400,
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> > > > > From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > > 
> > > > > When we make IO stress test on multipath device, there will
> > > > > be a metadata err because of wrong path. In the test, we
> > > > > concurrent execute 'iscsi device login|logout' and
> > > > > 'multipath -r' command with IO stress on multipath device.
> > > > > In some case, systemd-udevd may have not time to process
> > > > > uevents of iscsi device logout|login, and then 'multipath -r'
> > > > > command triggers multipathd daemon calls ioctl to load table
> > > > > with incorrect old device info from systemd-udevd.
> > > > > Then, one iscsi path may be incorrectly attached to another
> > > > > multipath which has different uuid. Finally, the metadata err
> > > > > occurs when umounting filesystem to down write metadata on
> > > > > the iscsi device which is actually not owned by the multipath
> > > > > device.
> > > > > 
> > > > > So we need to check whether all pgpaths of one multipath have
> > > > > the same uuid, if not, we should throw a error.
> > > > > 
> > > > > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > > > > Signed-off-by: linfeilong <linfeilong@huawei.com>
> > > > > Signed-off-by: Wubo <wubo40@huawei.com>
> > > > > ---
> > > > >  drivers/md/dm-mpath.c   | 52
> > > > > +++++++++++++++++++++++++++++++++++++++++
> > > > >  drivers/scsi/scsi_lib.c |  1 +
> > > > >  2 files changed, 53 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > > index bced42f082b0..f0b995784b53 100644
> > > > > --- a/drivers/md/dm-mpath.c
> > > > > +++ b/drivers/md/dm-mpath.c
> > > > > @@ -24,6 +24,7 @@
> > > > >  #include <linux/workqueue.h>
> > > > >  #include <linux/delay.h>
> > > > >  #include <scsi/scsi_dh.h>
> > > > > +#include <linux/dm-ioctl.h>
> > > > >  #include <linux/atomic.h>
> > > > >  #include <linux/blk-mq.h>
> > > > > 
> > > > > @@ -1169,6 +1170,45 @@ static int parse_features(struct
> > > > > dm_arg_set *as, struct multipath *m)
> > > > >         return r;
> > > > >  }
> > > > > 
> > > > > +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> > > > > +#define MPATH_UUID_PREFIX_LEN 7
> > > > > +static int check_pg_uuid(struct priority_group *pg, char
> > > > > *md_uuid)
> > > > > +{
> > > > > +       char pgpath_uuid[DM_UUID_LEN] = {0};
> > > > > +       struct request_queue *q;
> > > > > +       struct pgpath *pgpath;
> > > > > +       struct scsi_device *sdev;
> > > > > +       ssize_t count;
> > > > > +       int r = 0;
> > > > > +
> > > > > +       list_for_each_entry(pgpath, &pg->pgpaths, list) {
> > > > > +               q = bdev_get_queue(pgpath->path.dev->bdev);
> > > > > +               sdev = scsi_device_from_queue(q);
> > > > 
> > > > Common dm-multipath code should never poke into scsi
> > > > internals.  This
> > > > is something for the device handler to check.  It probably also
> > > > won't
> > > > work for all older devices.
> > > 
> > > Definitely.
> > > 
> > > But that aside, userspace (multipathd) _should_ be able to do
> > > extra
> > > validation, _before_ pushing down a new table to the kernel,
> > > rather than
> > > forcing the kernel to do it.
> > 
> > As your said, it is better to do extra validation in userspace
> > (multipathd).
> > However, in some cases, the userspace cannot see the real-time
> > present devices
> > info as Martin (committer of multipath-tools) said.
> > In addition, the kernel can see right device info in the table at
> > any time,
> > so the uuid check in kernel can ensure one multipath is composed
> > with paths mapped to
> > the same device.
> > 
> > Considering the severity of the wrong path in multipath, I think it
> > worths more
> > checking.
> 
> As already said: this should be fixable in userspace.  Please work
> with
> multipath-tools developers to address this.

I agree this patch won't help, because the kernel doesn't (re)attach
devices to multipath maps by itself. If multipathd actively adds a
device to a map, it must check the WWID beforehand, and so it does (and
has been doing so for years).

But in general, it's hard to avoid WWID mismatches entirely in user
space. We have no problem if a device is removed an re-added. But if it
looks like a device just having been offline or unreachable for some
time and then reappear, it gets tricky. We might even miss the fact
that the device was temporarily away. multipathd can't constantly poll
devices just to detect changes - and what if the sysfs vpd attributes
stay the same because the kernel didn't even notice?

It would be great if userspace could rely on the kernel to deliver
events in such cases. I want look into monitoring SCSI UNIT ATTENTION
events, which multipathd currently doesn't. That might cover many
situations. But I've been told that in some situations really no event
arrived in user space, and I'm not sure if that was a fault of the
storage involved (no UNIT ATTENTION sent) or something else.

Another possibility would be that the kernel used sysfs_notify() for
the inquiry or vpd_pgXY attributes for SCSI (and similar attirbutes for
other device types).

Regards
Martin



