Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7A7C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 13:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2618F22210
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 13:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbhATNFk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 08:05:40 -0500
Received: from verein.lst.de ([213.95.11.211]:55685 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389858AbhATMht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 07:37:49 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 086E667357; Wed, 20 Jan 2021 13:36:50 +0100 (CET)
Date:   Wed, 20 Jan 2021 13:36:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v2 1/2] block: introduce zone_write_granularity limit
Message-ID: <20210120123649.GA3870@lst.de>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com> <20210119131723.1637853-2-damien.lemoal@wdc.com> <20210120101018.GB25746@lst.de> <BL0PR04MB65144D0B02939681617B61A8E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB65144D0B02939681617B61A8E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 20, 2021 at 11:00:29AM +0000, Damien Le Moal wrote:
> Hmm. I wanted to keep this limit to 0 for regular devices. If we default to 512,
> regular devices will see that value. They can ignore it of course, but having it
> as 0 makes it clear that it should be ignored.

Hmm.  Maybe we should keep the 0 default and only set it in sd.c.  Then the
query helper can default to the logical block size instead.  That'll just d
o the right thing without changes to most drivers.
