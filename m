Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3F6C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 17:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E43619C0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 17:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCWRMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 13:12:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhCWRLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 13:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616519511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKHlmcAcFrOM8c13z+gPq/cfF8DQ2S4kR6iZLDzuW8w=;
        b=BzlWdVnZsaDD2BtCJ2ruOfVTGl9PVH0R9gqK5ASQgc/1pRGQ/5rKddAObq0zndwTTd/cSH
        dJuP02Hr5bANdD0s1dPQU7yJ3nRRuUcFZ4mZ1rnWW/iqjQL5RoqEWU8FnM+CxI1AsDJbvD
        cg45Ezxa3oiTcNsbIzCJyyPa6wrwuUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-sR3Ur4hPO2qR45qt9qq_hw-1; Tue, 23 Mar 2021 13:11:47 -0400
X-MC-Unique: sR3Ur4hPO2qR45qt9qq_hw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A67B05F9E1;
        Tue, 23 Mar 2021 17:11:45 +0000 (UTC)
Received: from ovpn-112-207.phx2.redhat.com (ovpn-112-207.phx2.redhat.com [10.3.112.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EB045C232;
        Tue, 23 Mar 2021 17:11:30 +0000 (UTC)
Message-ID: <5612cd9e298488ea9277f8d99ce0fd35240bdc53.camel@redhat.com>
Subject: Re: md/dm-mpath: check whether all pgpaths have same uuid in
 multipath_ctr()
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     lixiaokeng <lixiaokeng@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     agk@redhat.com, dm-devel@redhat.com,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linfeilong <linfeilong@huawei.com>,
        "wubo (T)" <wubo40@huawei.com>
Date:   Tue, 23 Mar 2021 13:11:30 -0400
In-Reply-To: <a46013db-8143-7b41-95a8-182439b385f2@huawei.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
         <20210322081155.GE1946905@infradead.org>
         <20210322142207.GB30698@redhat.com>
         <a46013db-8143-7b41-95a8-182439b385f2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-23 at 15:47 +0800, lixiaokeng wrote:
> 
> On 2021/3/22 22:22, Mike Snitzer wrote:
> > On Mon, Mar 22 2021 at  4:11am -0400,
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> > > > From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > 
> > > > When we make IO stress test on multipath device, there will
> > > > be a metadata err because of wrong path. In the test, we
> > > > concurrent execute 'iscsi device login|logout' and
> > > > 'multipath -r' command with IO stress on multipath device.
> > > > In some case, systemd-udevd may have not time to process
> > > > uevents of iscsi device logout|login, and then 'multipath -r'
> > > > command triggers multipathd daemon calls ioctl to load table
> > > > with incorrect old device info from systemd-udevd.
> > > > Then, one iscsi path may be incorrectly attached to another
> > > > multipath which has different uuid. Finally, the metadata err
> > > > occurs when umounting filesystem to down write metadata on
> > > > the iscsi device which is actually not owned by the multipath
> > > > device.
> > > > 
> > > > So we need to check whether all pgpaths of one multipath have
> > > > the same uuid, if not, we should throw a error.
> > > > 
> > > > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > > > Signed-off-by: linfeilong <linfeilong@huawei.com>
> > > > Signed-off-by: Wubo <wubo40@huawei.com>
> > > > ---
> > > >  drivers/md/dm-mpath.c   | 52
> > > > +++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/scsi/scsi_lib.c |  1 +
> > > >  2 files changed, 53 insertions(+)
> > > > 
> > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > index bced42f082b0..f0b995784b53 100644
> > > > --- a/drivers/md/dm-mpath.c
> > > > +++ b/drivers/md/dm-mpath.c
> > > > @@ -24,6 +24,7 @@
> > > >  #include <linux/workqueue.h>
> > > >  #include <linux/delay.h>
> > > >  #include <scsi/scsi_dh.h>
> > > > +#include <linux/dm-ioctl.h>
> > > >  #include <linux/atomic.h>
> > > >  #include <linux/blk-mq.h>
> > > > 
> > > > @@ -1169,6 +1170,45 @@ static int parse_features(struct
> > > > dm_arg_set *as, struct multipath *m)
> > > >  	return r;
> > > >  }
> > > > 
> > > > +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> > > > +#define MPATH_UUID_PREFIX_LEN 7
> > > > +static int check_pg_uuid(struct priority_group *pg, char
> > > > *md_uuid)
> > > > +{
> > > > +	char pgpath_uuid[DM_UUID_LEN] = {0};
> > > > +	struct request_queue *q;
> > > > +	struct pgpath *pgpath;
> > > > +	struct scsi_device *sdev;
> > > > +	ssize_t count;
> > > > +	int r = 0;
> > > > +
> > > > +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
> > > > +		q = bdev_get_queue(pgpath->path.dev->bdev);
> > > > +		sdev = scsi_device_from_queue(q);
> > > 
> > > Common dm-multipath code should never poke into scsi
> > > internals.  This
> > > is something for the device handler to check.  It probably also
> > > won't
> > > work for all older devices.
> > 
> > Definitely.
> > 
> > But that aside, userspace (multipathd) _should_ be able to do extra
> > validation, _before_ pushing down a new table to the kernel, rather
> > than
> > forcing the kernel to do it.
> > 
> 
> Martin (committer of multipath-tools) said that:
> "Don't get me wrong, I don't argue against tough testing. But we
> should
> be aware that there are always time intervals during which
> multipathd's
> picture of the present devices is different from what the kernel
> sees."
> 
> It is difficult to solve this in multipathd.
> 
> Regards,
> Lixiaokeng
> 

I think the patch is no good.  There are plenty of devices that don't
support VPD page 83h:

int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
{
        u8 cur_id_type = 0xff;
        u8 cur_id_size = 0;
        unsigned char *d, *cur_id_str;
        unsigned char __rcu *vpd_pg83;
        int id_size = -EINVAL;

        rcu_read_lock();
        vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
        if (!vpd_pg83) {
                rcu_read_unlock();
                return -ENXIO;
        }

and the DM layer should not be looking at the properties of the
underlying devices in this way anyway.  It should be pushed down
to the table.

-Ewan



