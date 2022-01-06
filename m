Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6559C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiAFDDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 22:03:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229645AbiAFDDu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 22:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641438230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXW7Pt5ebfBtwSKfWYulqfouNPZnXMJp16ZbSOe8IEM=;
        b=Wagj0WUI8BW5p+FiUeHY/LB1G3fJu4FNjVETlrJ9ne6PKtANeXM7cmRPufiPHqjAGHpX7I
        P+DEd3VNJ1Ab5Kn5HFIefonxnLJmzmUBOGPDzaqWzzr4cj18qXFVjlprZQY+rMTgRr/iM2
        N9m0oA9WPaAMXWNCIvNhNaG+8L3WzuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-KqGML13iNCGjGVMydVkVsw-1; Wed, 05 Jan 2022 22:03:45 -0500
X-MC-Unique: KqGML13iNCGjGVMydVkVsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79F51189DF42;
        Thu,  6 Jan 2022 03:03:43 +0000 (UTC)
Received: from T590 (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A76FB1037F4B;
        Thu,  6 Jan 2022 03:03:33 +0000 (UTC)
Date:   Thu, 6 Jan 2022 11:03:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <YdZcABq/pxMMh3X0@T590>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 05, 2022 at 06:00:41PM +0000, Martin Wilck wrote:
> Hello Ming, Sreekanth,
> 
> I'm observing a problem where mpt3sas fails to allocate the budget_map
> for any SCSI device, because attempted allocation is larger than the
> maximum possible. The issue is caused by the logic used in 020b0f0a3192
> ("scsi: core: Replace sdev->device_busy with sbitmap") 
> to calculate the bitmap size. This is observed with 5.16-rc8.
> 
> The controller at hand has properties can_queue=29865 and
> cmd_per_lun=7. The way these parameters are used in scsi_alloc_sdev()->

That two parameter looks bad, can_queue is too big, however cmd_per_lun
is so small.

> sbitmap_init_node(), this results in an sbitmap with 29865 maps, where
> only a single bit is used per map. On x86_64, this results in an
> attempt to allocate 29865 * 192 =  5734080 bytes for the sbitmap, which
> is larger than  PAGE_SIZE * (1 << (MAX_ORDER - 1)), and fails.

Bart has posted one patch for fixing the issue:

https://lore.kernel.org/linux-scsi/20211203231950.193369-2-bvanassche@acm.org/

but it isn't merged yet.

Martin, can we merge the above patch for fixing this issue?


Thanks,
Ming

