Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D564C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 15:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498252222B
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 15:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXiAR/9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKBPZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 10:25:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbgKBPZS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 10:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604330716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZxy5nwoelG0xp4hpZrpbGdGAtoA6kInwBAKt8RDAhY=;
        b=NXiAR/9anHYITKWWTw6FFuixtPG95kewE7oIUDIJYqHlmRGecLFFuWLg8ayZE7u8XMdOHC
        +wW9ML0lJRke0ZPWKIoEm6qgerZX1oI58ep9Ha1oik3RCmwvrhnV7T4PKtJDj5fdpPPR/b
        Mr+VUpXZG+okizZ8t3eu3VhR5tb7xLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-b1KmrXT7MkGgZhluMdUqYA-1; Mon, 02 Nov 2020 10:25:12 -0500
X-MC-Unique: b1KmrXT7MkGgZhluMdUqYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C56A110B9CB0;
        Mon,  2 Nov 2020 15:25:09 +0000 (UTC)
Received: from ovpn-112-12.rdu2.redhat.com (ovpn-112-12.rdu2.redhat.com [10.10.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6836EF50;
        Mon,  2 Nov 2020 15:25:02 +0000 (UTC)
Message-ID: <2272fa13f5a5cad5deecb3210061e7353260cc6d.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   Qian Cai <cai@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, ming.lei@redhat.com, bvanassche@acm.org,
        dgilbert@interlog.com, paolo.valente@linaro.org, hare@suse.de,
        hch@lst.de
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Date:   Mon, 02 Nov 2020 10:24:59 -0500
In-Reply-To: <1824064113e9adfdf4d086709cccee00@mail.gmail.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
         <1597850436-116171-18-git-send-email-john.garry@huawei.com>
         <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
         <1824064113e9adfdf4d086709cccee00@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-02 at 20:01 +0530, Kashyap Desai wrote:
> > On Wed, 2020-08-19 at 23:20 +0800, John Garry wrote:
> > > From: Kashyap Desai <kashyap.desai@broadcom.com>
> > > 
> > > Fusion adapters can steer completions to individual queues, and we now
> > > have support for shared host-wide tags.
> > > So we can enable multiqueue support for fusion adapters.
> > > 
> > > Once driver enable shared host-wide tags, cpu hotplug feature is also
> > > supported as it was enabled using below patchsets - commit
> > > bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are
> > > offline")
> > > 
> > > Currently driver has provision to disable host-wide tags using
> > > "host_tagset_enable" module parameter.
> > > 
> > > Once we do not have any major performance regression using host-wide
> > > tags, we will drop the hand-crafted interrupt affinity settings.
> > > 
> > > Performance is also meeting the expecatation - (used both none and
> > > mq-deadline scheduler)
> > > 24 Drive SSD on Aero with/without this patch can get 3.1M IOPs
> > > 3 VDs consist of 8 SAS SSD on Aero with/without this patch can get
> > > 3.1M IOPs.
> > > 
> > > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > > Signed-off-by: John Garry <john.garry@huawei.com>
> > 
> > Reverting this commit fixed an issue that Dell Power Edge R6415 server
> > with
> > megaraid_sas is unable to boot.
> 
> I will take a look at this. BTW, can you try keeping same PATCH but use
> module parameter "host_tagset_enable =0"

Yes, that also works.

