Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089C4C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 15:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22C961A2D
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 15:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhCYPOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 11:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhCYPOS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 11:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616685257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C00CdzusvAGi2U6TMJ7rYAJxzxg6IJ+1BL3U6X7eoPk=;
        b=ITKdyausEufwoNx/fUL1pA4+BjBDpsbWUvTsAISBw8Nxm8uNx7FemynCpfTVmT0wW/13p7
        qpQHpsQQHKCLzATLzKqAbu/POWZJroaCWvT9uHUKGEArlqA31EU7IHop7kKjixavrgWaQP
        Wecos3i7rm+wbCEsHQm/+ruVARWWNrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-PUiCKOryMKqns6LEMcbHYA-1; Thu, 25 Mar 2021 11:14:13 -0400
X-MC-Unique: PUiCKOryMKqns6LEMcbHYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80A451009E29;
        Thu, 25 Mar 2021 15:14:11 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EA0D5C3DF;
        Thu, 25 Mar 2021 15:14:08 +0000 (UTC)
Date:   Thu, 25 Mar 2021 11:14:07 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     Christoph Hellwig <hch@infradead.org>, agk@redhat.com,
        dm-devel@redhat.com, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "wubo (T)" <wubo40@huawei.com>
Subject: Re: md/dm-mpath: check whether all pgpaths have same uuid in
 multipath_ctr()
Message-ID: <20210325151407.GA17059@redhat.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
 <20210322081155.GE1946905@infradead.org>
 <20210322142207.GB30698@redhat.com>
 <cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24 2021 at  9:21pm -0400,
Zhiqiang Liu <liuzhiqiang26@huawei.com> wrote:

> 
> 
> On 2021/3/22 22:22, Mike Snitzer wrote:
> > On Mon, Mar 22 2021 at  4:11am -0400,
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> >> On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> >>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> >>>
> >>> When we make IO stress test on multipath device, there will
> >>> be a metadata err because of wrong path. In the test, we
> >>> concurrent execute 'iscsi device login|logout' and
> >>> 'multipath -r' command with IO stress on multipath device.
> >>> In some case, systemd-udevd may have not time to process
> >>> uevents of iscsi device logout|login, and then 'multipath -r'
> >>> command triggers multipathd daemon calls ioctl to load table
> >>> with incorrect old device info from systemd-udevd.
> >>> Then, one iscsi path may be incorrectly attached to another
> >>> multipath which has different uuid. Finally, the metadata err
> >>> occurs when umounting filesystem to down write metadata on
> >>> the iscsi device which is actually not owned by the multipath
> >>> device.
> >>>
> >>> So we need to check whether all pgpaths of one multipath have
> >>> the same uuid, if not, we should throw a error.
> >>>
> >>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> >>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> >>> Signed-off-by: linfeilong <linfeilong@huawei.com>
> >>> Signed-off-by: Wubo <wubo40@huawei.com>
> >>> ---
> >>>  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
> >>>  drivers/scsi/scsi_lib.c |  1 +
> >>>  2 files changed, 53 insertions(+)
> >>>
> >>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> >>> index bced42f082b0..f0b995784b53 100644
> >>> --- a/drivers/md/dm-mpath.c
> >>> +++ b/drivers/md/dm-mpath.c
> >>> @@ -24,6 +24,7 @@
> >>>  #include <linux/workqueue.h>
> >>>  #include <linux/delay.h>
> >>>  #include <scsi/scsi_dh.h>
> >>> +#include <linux/dm-ioctl.h>
> >>>  #include <linux/atomic.h>
> >>>  #include <linux/blk-mq.h>
> >>>
> >>> @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> >>>  	return r;
> >>>  }
> >>>
> >>> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> >>> +#define MPATH_UUID_PREFIX_LEN 7
> >>> +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
> >>> +{
> >>> +	char pgpath_uuid[DM_UUID_LEN] = {0};
> >>> +	struct request_queue *q;
> >>> +	struct pgpath *pgpath;
> >>> +	struct scsi_device *sdev;
> >>> +	ssize_t count;
> >>> +	int r = 0;
> >>> +
> >>> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
> >>> +		q = bdev_get_queue(pgpath->path.dev->bdev);
> >>> +		sdev = scsi_device_from_queue(q);
> >>
> >> Common dm-multipath code should never poke into scsi internals.  This
> >> is something for the device handler to check.  It probably also won't
> >> work for all older devices.
> > 
> > Definitely.
> > 
> > But that aside, userspace (multipathd) _should_ be able to do extra
> > validation, _before_ pushing down a new table to the kernel, rather than
> > forcing the kernel to do it.
> 
> As your said, it is better to do extra validation in userspace (multipathd).
> However, in some cases, the userspace cannot see the real-time present devices
> info as Martin (committer of multipath-tools) said.
> In addition, the kernel can see right device info in the table at any time,
> so the uuid check in kernel can ensure one multipath is composed with paths mapped to
> the same device.
> 
> Considering the severity of the wrong path in multipath, I think it worths more
> checking.

As already said: this should be fixable in userspace.  Please work with
multipath-tools developers to address this.

Mike

