Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C0BC43462
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 13:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C836261077
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 13:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbhDSN4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240772AbhDSNz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Apr 2021 09:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxdqbfoBJXaYxfD6rImyDUvIjZiF5Q3ecjdpEO3HnrU=;
        b=ZCHwSLBVX90Q/e/qV9ttAFNtuYxFwbdNJVZhvxLbQYTItas5K5T5xOXJQhU1avUdU4RVl1
        Vo94a5AnCpCMhwgr64VB7mCNWn00RlPzzxVjYi1vFtVH6O0xv4NFfWh4emctUvdzeE6R1X
        ztRC4UAyjUAy2XdnBHrLyotupxr+JVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-OjBtjruXOaaknhPs7HO74A-1; Mon, 19 Apr 2021 09:55:26 -0400
X-MC-Unique: OjBtjruXOaaknhPs7HO74A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C60D687A83C;
        Mon, 19 Apr 2021 13:55:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FB8E5D9CA;
        Mon, 19 Apr 2021 13:55:18 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 13JDtH4F018187;
        Mon, 19 Apr 2021 09:55:17 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 13JDtHQu018179;
        Mon, 19 Apr 2021 09:55:17 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 19 Apr 2021 09:55:17 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
cc:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/3] Fix dm-crypt zoned block device
 support
In-Reply-To: <BL0PR04MB65147D94E7E30C3E1063A282E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
Message-ID: <alpine.LRH.2.02.2104190951070.17565@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com> <alpine.LRH.2.02.2104190840310.9677@file01.intranet.prod.int.rdu2.redhat.com> <BL0PR04MB65147D94E7E30C3E1063A282E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Mon, 19 Apr 2021, Damien Le Moal wrote:

> > I would say that it is incompatible with all dm targets - even the linear 
> > target is changing the sector number and so it may redirect the write 
> > outside of the range specified in dm-table and cause corruption.
> 
> DM remapping of BIO sectors is zone compatible because target entries must be
> zone aligned. In the case of zone append, the BIO sector always point to the
> start sector of the target zone. DM sector remapping will remap that to another
> zone start as all zones are the same size. No issue here. We extensively use
> dm-linear for various test environment to reduce the size of the device tested
> (to speed up tests). I am confident there are no problems there.
> 
> > Instead of complicating device mapper with imperfect support, I would just 
> > disable REQ_OP_ZONE_APPEND on device mapper at all.
> 
> That was my initial approach, but for dm-crypt only since other targets that
> support zoned devices are fine. However, this breaks zoned block device
> requirement that zone append be supported so that users are presented with a
> uniform interface for different devices. So while simple to do, disabling zone
> append is far from ideal.

So, we could enable it for the linear target and disable for all other 
targets?

I talked with Milan about it and he doesn't want to add more bloat to the 
crypt target. I agree with him.

Mikulas

