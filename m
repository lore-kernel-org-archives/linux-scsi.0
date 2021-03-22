Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88150C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3757761973
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVINf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhCVIN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:13:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F43C061574;
        Mon, 22 Mar 2021 01:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZNtQiL6tIyqch+BmC79W/NJ6n9Wo/6qrrvbdpMthN14=; b=Z3czrzgs7g5m4PHydjpPMdqmv9
        XAPLDRUQpzn10rX3V6rakbFpXs2+E53sFwZrExGGHF7yVLyUzCWK55lH+zkFkkfJpEkGLDHnh0HHp
        1cLEcYc9ASJpHqon3wKbDQpm5U5S8AFs9UxC+MEq0XBMlhnP7vPY3YFCLBfaaAXyP3DHTsST9dFgh
        9ce39twENQO+bQlzOg1krJL6200dlTDX1N1kYrw2TTxDB5FXnc1tSFCyd/jGYNJ4z9d58Lqj32KU2
        LdosiNGSNlpu6SdPPlLT+4NyGvS1HcYi69HuA5WMpoH8LB1I68VV0a7Ewbj70iGWweya26MoPR2vW
        gmhHNx/A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOFfH-008Btj-KA; Mon, 22 Mar 2021 08:12:09 +0000
Date:   Mon, 22 Mar 2021 08:11:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "wubo (T)" <wubo40@huawei.com>
Subject: Re: [PATCH] md/dm-mpath: check whether all pgpaths have same uuid in
 multipath_ctr()
Message-ID: <20210322081155.GE1946905@infradead.org>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> When we make IO stress test on multipath device, there will
> be a metadata err because of wrong path. In the test, we
> concurrent execute 'iscsi device login|logout' and
> 'multipath -r' command with IO stress on multipath device.
> In some case, systemd-udevd may have not time to process
> uevents of iscsi device logout|login, and then 'multipath -r'
> command triggers multipathd daemon calls ioctl to load table
> with incorrect old device info from systemd-udevd.
> Then, one iscsi path may be incorrectly attached to another
> multipath which has different uuid. Finally, the metadata err
> occurs when umounting filesystem to down write metadata on
> the iscsi device which is actually not owned by the multipath
> device.
> 
> So we need to check whether all pgpaths of one multipath have
> the same uuid, if not, we should throw a error.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: linfeilong <linfeilong@huawei.com>
> Signed-off-by: Wubo <wubo40@huawei.com>
> ---
>  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c |  1 +
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index bced42f082b0..f0b995784b53 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -24,6 +24,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/delay.h>
>  #include <scsi/scsi_dh.h>
> +#include <linux/dm-ioctl.h>
>  #include <linux/atomic.h>
>  #include <linux/blk-mq.h>
> 
> @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>  	return r;
>  }
> 
> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
> +#define MPATH_UUID_PREFIX_LEN 7
> +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
> +{
> +	char pgpath_uuid[DM_UUID_LEN] = {0};
> +	struct request_queue *q;
> +	struct pgpath *pgpath;
> +	struct scsi_device *sdev;
> +	ssize_t count;
> +	int r = 0;
> +
> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
> +		q = bdev_get_queue(pgpath->path.dev->bdev);
> +		sdev = scsi_device_from_queue(q);

Common dm-multipath code should never poke into scsi internals.  This
is something for the device handler to check.  It probably also won't
work for all older devices.
