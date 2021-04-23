Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEFAC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 01:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB6B761459
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 01:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhDWByz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 21:54:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240153AbhDWByy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 21:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619142858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JuicL4NJ8ntJP8ZqsMGE4tBWCboCpYJmZ5Z+nKeH780=;
        b=FpNB6z+uCzot1/QYT8HbuFQTvYcSVAGquj/XqeGuDZanIZ5Mlowt2mHZi3qlz17slNf3FG
        kalzPTXzMczXy2iRauDlQl3VOzbZYfDX9TgXMBpFdGwB4fkRmBE0MbzkR4XNfCl+U8ilIB
        /MYnRC89bJdz5IVLbN8vOgORdYTy5SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-oTL6rHyBMziFn2smuNcELA-1; Thu, 22 Apr 2021 21:54:16 -0400
X-MC-Unique: oTL6rHyBMziFn2smuNcELA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3555110054F6;
        Fri, 23 Apr 2021 01:54:15 +0000 (UTC)
Received: from T590 (ovpn-13-78.pek2.redhat.com [10.72.13.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 151C15DDAD;
        Fri, 23 Apr 2021 01:54:05 +0000 (UTC)
Date:   Fri, 23 Apr 2021 09:54:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kashyap.desai@broadcom.com, dgilbert@interlog.com
Subject: Re: [PATCH] scsi: core: Cap initial sdev queue depth at
 shost.can_queue
Message-ID: <YIIouSOM77zEw3Qb@T590>
References: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
 <YH4aIECa/J/1uS5S@T590>
 <bba5f248-523d-0def-1a3e-bafeb2b7633f@huawei.com>
 <YIDTlD2Mq+U36Oqz@T590>
 <186be6c5-dbcd-d1fb-67c5-72b5a761568a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <186be6c5-dbcd-d1fb-67c5-72b5a761568a@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 22, 2021 at 05:35:42PM +0100, John Garry wrote:
> On 22/04/2021 02:38, Ming Lei wrote:
> > > I would rather not change the values which are provided from the driver. I
> > > would rather take the original values and try to use them in a sane way.
> > > 
> > > I have not seen other places where driver shost config values are modified
> > > by the core code.
> 
> Hi Ming,
> 
> > Wrt. .cmd_per_lun, I think it is safe to modify it into one correct
> > depth because almost all drivers are just producer of .cmd_per_lun. And
> > except for debug purpose, there are only three consumers of .cmd_per_lun
> > in scsi, and all are for scsi_change_queue_depth():
> > 
> > 	process_message()
> > 	scsi_alloc_sdev()
> > 	virtscsi_change_queue_depth()
> 
> sg_ioctl_common() also looks to read it, but I can't imagine we could break
> that interface with either suggested change.

Then one bad .cmd_per_lun can be passed to userspace, as your patch
doesn't cover this case.

> 
> So I still prefer not to modify shost.cmd_per_lun, but if you feel strongly
> enough then I can look to make that change.

I still suggest to make .cmd_per_lun correct since the beginning,
otherwise you may have to cover anywhere .cmd_per_lun is used.


Thanks,
Ming

