Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CE0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 14:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiGAOjs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 10:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiGAOjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 10:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C61B7735A8
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 07:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656686238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYz3ZyW6DBawKSaUG1X70gK44PDfn6YckHjMVSNLX/s=;
        b=daWYmzOR29MhG9qob3uFY9ttSqC9yIqymqUmeELKutsK97ZXRZkeYjGfX0E3j7VQsQLhLM
        1i1WizNOTmT6hwb/+7dMoZoX+jyMeCWLJ7l3CirIKxfZnOiiAW3fFhG4lAQB1h+dT56icE
        I/xkOixZQXfLHUyr8dZouMXupdT71MA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-rn3bTJ9mOHm9faBUiUTd7A-1; Fri, 01 Jul 2022 10:37:17 -0400
X-MC-Unique: rn3bTJ9mOHm9faBUiUTd7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13AC53C23865;
        Fri,  1 Jul 2022 14:37:17 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC7DB1121314;
        Fri,  1 Jul 2022 14:37:11 +0000 (UTC)
Date:   Fri, 1 Jul 2022 22:37:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <Yr8GkVCJUMMSYZZA@T590>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org>
 <Yr5tlDkrTTldwjSq@T590>
 <4753a2ce-0cab-ce19-68d2-de7b3c15828a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753a2ce-0cab-ce19-68d2-de7b3c15828a@acm.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 01, 2022 at 07:07:13AM -0700, Bart Van Assche wrote:
> On 6/30/22 20:44, Ming Lei wrote:
> > On Thu, Jun 30, 2022 at 02:37:33PM -0700, Bart Van Assche wrote:
> > > There are two .exit_cmd_priv implementations. Both implementations use
> > > resources associated with the SCSI host. Make sure that these resources are
> > 
> > Please document what the exact resources associated with this SCSI host is.
> > 
> > We need the root cause.
> > 
> > I understand it might be related with module unloading, since ib_srp may
> > be gone already, but not sure if it is the exact one in this report.
> 
> It is not necessary to unload ib_srp to trigger this scenario.
> Hot-unplugging an RDMA adapter used by the ib_srp driver is sufficient.
> Hot-unplugging triggers a call of srp_remove_one(). srp_remove_one() itself
> and also its caller free resources used by srp_exit_cmd_priv(), e.g. struct
> ib_device.

OK, looks it isn't same with Changhui's report.

> 
> > > still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
> > > calls from scsi_host_dev_release() to scsi_forget_host(). Moving
> > > blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
> > > safe because scsi_forget_host() drains all the request queues that use the
> > > host tag set. This guarantees that no requests are in flight and also that
> > > no new requests will be allocated from the host tag set.
> > > 
> > > This patch fixes the following use-after-free:
> > > 
> > > ==================================================================
> > > BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> > > Read of size 8 at addr ffff888100337000 by task multipathd/16727
> > 
> > What is the 8bytes buffer which triggers UAF? what does srp_exit_cmd_priv+0x27
> > point to?
> 
> I think that Li already answered this question.

OK, from Li's input, the UAF is on the following code:

	struct srp_device *dev = target->srp_host->srp_dev;

So looks you meant target->srp_host is freed by srp_remove_one() before calling
srp_exit_cmd_priv?

Then when is srp_remove_one() triggered? And why is it called before
scsi_remove_host()? Sorry for the stupid question since I am not familiar with srp.


Thanks,
Ming

