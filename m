Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67357C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41AC52071C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YD3HQliY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDWBtG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:49:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDWBtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 21:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587606545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Yq3gVavrIWjxtPSiTvUpzdhbDuTm1Ve5hdpLPT2nCg=;
        b=YD3HQliYJkB5nSTNugy7fnxkpw9kGgm9LsHN1zZ2cJwQmKcBi6CV5ZSYUtEcgBv8FHWmRx
        IswzAvSnnxVfQZ84S3kkZnsJQk7Y/AkPk9p5r1d+2UsGcX7Of7h55jD+/EHfRoT39ACs2P
        Xa1oJeDFL3TR2RleDA9OEKlPON1hj2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-t-D1Bt7rP-CM8oFX6SkaBA-1; Wed, 22 Apr 2020 21:49:01 -0400
X-MC-Unique: t-D1Bt7rP-CM8oFX6SkaBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B2871800D6B;
        Thu, 23 Apr 2020 01:48:59 +0000 (UTC)
Received: from T590 (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 087836084B;
        Thu, 23 Apr 2020 01:48:52 +0000 (UTC)
Date:   Thu, 23 Apr 2020 09:48:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V2] scsi: put hot fields of scsi_host_template into one
 cacheline
Message-ID: <20200423014848.GA331623@T590>
References: <20200422095425.319674-1-ming.lei@redhat.com>
 <1587566490.3485.7.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587566490.3485.7.camel@HansenPartnership.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2020 at 07:41:30AM -0700, James Bottomley wrote:
> On Wed, 2020-04-22 at 17:54 +0800, Ming Lei wrote:
> > The following three fields of scsi_host_template are referenced in
> > scsi IO submission path, so put them together into one cacheline:
> > 
> > - cmd_size
> > - queuecommand
> > - commit_rqs
> 
> Are there benchmarks to show this actually makes a difference, if so,
> how much?

Originally I observed 40% IOPS boost on scsi_debug by moving the three
fields into scsi_host, but I lost that test environment now.

When I run fio on scsi_debug in another machine, IOPS gets ~10% boost
with this patch.

Thanks,
Ming

