Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4644AC2BB1D
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 01:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1832D20771
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 01:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgDRBBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 21:01:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33574 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbgDRBBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 21:01:12 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03I10t0J015868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 21:00:56 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4C6E442013D; Fri, 17 Apr 2020 21:00:55 -0400 (EDT)
Date:   Fri, 17 Apr 2020 21:00:55 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "hch@infradead.org" <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v7 00/11] Introduce Zone Append for writing to zoned
 block devices
Message-ID: <20200418010055.GO5187@mit.edu>
References: <20200417121536.5393-1-johannes.thumshirn@wdc.com>
 <20200417160326.GK5187@mit.edu>
 <SN4PR0401MB3598F054B867C929827E23F49BD90@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598F054B867C929827E23F49BD90@SN4PR0401MB3598.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 17, 2020 at 05:48:20PM +0000, Johannes Thumshirn wrote:
> For "userspace's responsibility", I'd re-phrase this as "a consumer's 
> responsibility", as we don't have an interface which aims at user-space 
> yet. The only consumer this series implements is zonefs, although we did 
> have an AIO implementation for early testing and io_uring shouldn't be 
> too hard to implement.

Ah, I had assumed that userspace interface exposed would be opening
the block device with the O_APPEND flag.  (Which raises interesting
questions if the block device is also opened without O_APPEND and some
other thread was writing to the same zone, in which case the order in
which requests are processed would control whether the I/O would
fail.)

					- Ted

