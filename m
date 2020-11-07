Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB64C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 00:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF9B20867
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 00:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RRNWQKzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgKGADR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 19:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbgKGADD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 19:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604707382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpRhWfhivDzpjB1y5eblNoCkv5k+SDQ8FP+BeZhkygE=;
        b=RRNWQKzQVyfDYqaem4JvIWrsjU6D3AuJvyEAqZTnXeoO5KEIl98wnie9qWswC25JQUbNJo
        P+52fynW1+ItCFQR2YqiIKpDqdQKfru+Dw9mPYbAaLddrCwXyWnvVJaZoxgBQj78/IPHu6
        bOm1BlQaIuR/Gw48hb3Gy+blqjLMWDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-eIWtGEMYNj-K_UIVshZGug-1; Fri, 06 Nov 2020 19:02:58 -0500
X-MC-Unique: eIWtGEMYNj-K_UIVshZGug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD3751006704;
        Sat,  7 Nov 2020 00:02:57 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C9937664C;
        Sat,  7 Nov 2020 00:02:57 +0000 (UTC)
Message-ID: <71160d6ae57867312c60ac5a14ef6df2ece21d84.camel@redhat.com>
Subject: Re: [PATCH 0/4] scsi: remove devices in ALUA transitioning status
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Fri, 06 Nov 2020 19:02:56 -0500
In-Reply-To: <20200930080256.90964-1-hare@suse.de>
References: <20200930080256.90964-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-09-30 at 10:02 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> during testing we found that there is an issue with dev_loss_tmo and
> devices in ALUA transitioning state.
> What happens is that I/O gets requeued via BLK_STS_RESOURCE for these
> devices, so when dev_loss_tmo triggers the SCSI core cannot flush the
> request list as I/O is simply requeued.
> 
> So when the driver is trying to re-establish the device it'll wait
> for
> that last reference to drop in order to re-attach the device, but as
> I/O
> is still outstanding on the (old) device it'll wait for ever.
> 
> Fix this by returning 'BLK_STS_AGAIN' from scsi_dh_alua when the
> device
> is in ALUA transitioning, and also set the 'transitioning' state when
> scsi_dh_alua is receiving a sense code, and not only after
> scsi_dh_alua
> successfully received the response to a REPORT TARGET PORT GROUPS
> command.
> 
> Hannes Reinecke (4):
>   block: return status code in blk_mq_end_request()
>   scsi_dh_alua: return BLK_STS_AGAIN for ALUA transitioning state
>   scsi_dh_alua: set 'transitioning' state on unit attention
>   scsi: return BLK_STS_AGAIN for ALUA transitioning
> 
>  block/blk-mq.c                             |  2 +-
>  drivers/scsi/device_handler/scsi_dh_alua.c | 10 +++++++++-
>  drivers/scsi/scsi_lib.c                    |  8 ++++++++
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 

We had a report of I/O hangs during storage controller resets
and analysis of the kernel state showed the sdev in ALUA transitioning.

The patch set fixes the ALUA transitioning issue, it looks good.
There was a reproducible test case.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

-Ewan


