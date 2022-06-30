Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE429C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 08:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiF3I6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiF3I6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 04:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F232542A1B
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 01:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656579482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKAlI7eJU4dW+oHNvoYZzzoa2yiw44zSxyBZ0VepjwU=;
        b=dmSWkA8NKijQXMq38v9qurRpXZ5jjcMwoXA628tFx+aeeEpm5oU6G19Xn3m3RQKWkwNDm1
        wV6emEMU/7SFRfMwNm3NpvhOWC4gZaiD/PbCEP3ZeNWuO1RPsQPHf6rJoX+fTWpueOCMis
        osAHItokUYISKDDKnsX03Tx84KLGL0U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-mPhl5IY9Pwm_Vwgg4fSqew-1; Thu, 30 Jun 2022 04:57:56 -0400
X-MC-Unique: mPhl5IY9Pwm_Vwgg4fSqew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4259380664E;
        Thu, 30 Jun 2022 08:57:55 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7F62C2810D;
        Thu, 30 Jun 2022 08:57:49 +0000 (UTC)
Date:   Thu, 30 Jun 2022 16:57:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <Yr1lh5YhR20S15H8@T590>
References: <20220628175612.2157218-1-bvanassche@acm.org>
 <YruoKUbpBZvAkZ4L@T590>
 <8e464697-e179-19f7-e417-be089821a861@acm.org>
 <Yrz18+1iFb/QkiBZ@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrz18+1iFb/QkiBZ@T590>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2022 at 09:01:39AM +0800, Ming Lei wrote:
> Hi Bart,
> 
> I'd rather to understand the issue first.
> 
> On Wed, Jun 29, 2022 at 02:49:27PM -0700, Bart Van Assche wrote:
> > On 6/28/22 18:17, Ming Lei wrote:
> > > On Tue, Jun 28, 2022 at 10:56:12AM -0700, Bart Van Assche wrote:
> > > > There are two .exit_cmd_priv implementations. Both implementations use the
> > > > SCSI host pointer. Make sure that the SCSI host pointer is valid when
> > > > .exit_cmd_priv is called by moving the .exit_cmd_priv calls from
> > > > scsi_device_dev_release() to scsi_forget_host(). Moving
> 
> .exit_cmd_priv is actually called from scsi_host_dev_release() instead
> of scsi_device_dev_release(). Both scsi host pointer and host->shost_data is
> still valid when calling .exit_cmd_priv via scsi_mq_destroy_tags().
> 
> Previously I fixed[1] one similar issue, and that is caused by early module
> unloading, and anywhere host->hostt is referred, the scsi driver module
> should be prevented from being unloaded.
> 
> 
> [1] f2b85040acec scsi: core: Put LLD module refcnt after SCSI device is released

Hi Bart,

BTW, Changhui reported one very similar issue when running elevator
switch/scsi debug LUN hotplug.

From Changhui's report, the issue is basically same with what
f2b85040acec tried to address, but the try_module_get() in
scsi_device_dev_release() may fail, so the scsi_debug module
still can be unloaded.

The thing is that sdev can be released in async style, and target/host
release is triggered by scsi_device_dev_release_usercontext().

So after scsi_host_remove() returns, the shost may still be live from
driver core/sysfs viewpoint, and its release handler can be called
after the LLD module is unloaded. Then this kind of issue is triggered.

Seems there are at least two approaches for fixing the issue:

1) the one suggested in this thread:
- moving any reference to shost->hostt in host release handler into
scsi_host_remove(), and scsi_mq_destroy_tags()/scsi_proc_hostdir_rm(shost->hostt)()
should be covered at least

2) wait until all targets are released in scsi_host_remove()

I am fine with either of the two approaches.

Bart, please let me know if you are working towards the approach in 1).
If not, I have one patch which implements 2).

BTW, after either 1) or 2) is done, commit f2b85040acec can be reverted.


Thanks,
Ming

