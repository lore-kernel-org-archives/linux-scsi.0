Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A51C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 10:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C86A2173E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 10:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389902AbfHHKXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 06:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389756AbfHHKXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Aug 2019 06:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EDDEC08EC1A;
        Thu,  8 Aug 2019 10:23:20 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-144.ams2.redhat.com [10.36.116.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DD8D1001955;
        Thu,  8 Aug 2019 10:23:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 582B316E08; Thu,  8 Aug 2019 12:23:19 +0200 (CEST)
Date:   Thu, 8 Aug 2019 12:23:19 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>, tzimmermann@suse.de,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/8] scsi: core: fix the dma_max_mapping_size call
Message-ID: <20190808102319.d4wdcp3sfcjqdk44@sirius.home.kraxel.org>
References: <20190808093702.29512-1-kraxel@redhat.com>
 <20190808093702.29512-2-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20190808093702.29512-2-kraxel@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 08 Aug 2019 10:23:20 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808102319.R00zR54L39tLlBDfz0i5XJrTM4ucYodt5n6-iuglwWY@z>

On Thu, Aug 08, 2019 at 11:36:55AM +0200, Gerd Hoffmann wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> We should only call dma_max_mapping_size for devices that have a DMA mask
> set, otherwise we can run into a NULL pointer dereference that will crash
> the system.
> 
> Also we need to do right shift to get the sectors from the size in bytes,
> not a left shift.

Oops, that wasn't meant to be re-sent, sorry.

drm-misc-next maintainers: any chance for a backmerge to pick up this fix,
so I don't have to carry it in my branches?

thanks,
  Gerd

