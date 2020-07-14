Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B766BC433EC
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920FB21582
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JRGHHhE9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgGNIHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:07:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23270 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725793AbgGNIHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 04:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594714019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2WkUS2baLZHo/qw2l6XXN08NWlFRGUaRro8FxAfMIo=;
        b=JRGHHhE9Nhcx2kCRE+VvsBPsqKYr6XSH6Dzf2k4TwgMCA+5LP2ojtUlEIUabc1o+jt0B1M
        zlV65RCiiXzauilXnJclzcOhw811gh9Vq7vxuaudvfNGKqpw1uJFzFYGIW2EUaEdUAp5wS
        XD2y6y9+opqqa3Ws/VYMDauykAt/jS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-ve21ehAVP72vb1IRekK_zA-1; Tue, 14 Jul 2020 04:06:55 -0400
X-MC-Unique: ve21ehAVP72vb1IRekK_zA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88193800400;
        Tue, 14 Jul 2020 08:06:52 +0000 (UTC)
Received: from T590 (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F92372E59;
        Tue, 14 Jul 2020 08:06:39 +0000 (UTC)
Date:   Tue, 14 Jul 2020 16:06:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>, don.brace@microsemi.com,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Message-ID: <20200714080631.GA600766@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 08:52:36AM +0100, John Garry wrote:
> On 14/07/2020 08:41, Hannes Reinecke wrote:
> > On 7/14/20 9:37 AM, John Garry wrote:
> > > On 10/06/2020 18:29, John Garry wrote:
> > > > From: Hannes Reinecke <hare@suse.de>
> > > > 
> > > > The smart array HBAs can steer interrupt completion, so this
> > > > patch switches the implementation to use multiqueue and enables
> > > > 'host_tagset' as the HBA has a shared host-wide tagset.
> > > > 
> > > 
> > > Hi Don,
> > > 
> > > I am preparing the next iteration of this series, and we're getting
> > > close to dropping the RFC tags. The series has grown a bit, and I am not
> > > sure what to do with hpsa support.
> > > 
> > > The latest versions of this series have not been tested for hpsa, AFAIK.
> > > Can you let me know if you can test and review this patch? Or someone
> > > else let me know it's tested (Hannes?)
> > > I'll give it a go.
> > 
> > Which git repository should I base the tests on?
> 
> v7 is here:
> 
> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7
> 
> So that should be good to test with for now.
> 
> And I was going to ask this same question about smartpqi, so can you please
> let me know about this one?

smartpqi is real MQ HBA, do you need any change wrt. shared tags?


Thanks,
Ming

