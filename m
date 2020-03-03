Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C22DC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 09:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 135B720863
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 09:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgCCJYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:24:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:39000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCCJYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Mar 2020 04:24:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8A86BB195;
        Tue,  3 Mar 2020 09:24:06 +0000 (UTC)
Date:   Tue, 3 Mar 2020 10:24:05 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
Message-ID: <20200303092405.uzrzfekvmd7ceajs@beryllium.lan>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-4-bvanassche@acm.org>
 <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
 <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 02, 2020 at 10:36:05PM -0800, Bart Van Assche wrote:
> On 2020-03-02 10:40, Daniel Wagner wrote:
> > On Sun, Mar 01, 2020 at 07:30:22PM -0800, Bart Van Assche wrote:
> >> Fix all endianness complaints reported by sparse (C=2).
> > 
> > [...]
> > 
> >>  int
> >> -qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
> >> -    uint32_t ram_dwords, void **nxt)
> >> +qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
> >> +		 uint32_t ram_dwords, void **nxt)
> >>  {
> >>  	int rval = QLA_FUNCTION_FAILED;
> >>  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
> >>  	dma_addr_t dump_dma = ha->gid_list_dma;
> >> -	uint32_t *chunk = (void *)ha->gid_list;
> >> +	uint32_t *chunk = (uint32_t *)ha->gid_list;
> >>  	uint32_t dwords = qla2x00_gid_list_size(ha) / 4;
> >>  	uint32_t stat;
> >>  	ulong i, j, timer = 6000000;
> >> @@ -252,9 +252,9 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
> >>  			return rval;
> >>  		}
> >>  		for (j = 0; j < dwords; j++) {
> >> -			ram[i + j] =
> >> -			    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
> >> -			    chunk[j] : swab32(chunk[j]);
> >> +			ram[i + j] = (__force __be32)
> >> +				((IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
> >> +				 chunk[j] : swab32(chunk[j]));
> > 
> > Isn't this assuming the host runs in little endian mode? Because later down...
> 
> My goal was not to change the behavior of the code on x86. Bugs on big
> endian systems can be fixed later on (my guess is that this driver does
> not work reliably on big endian), and searching through the code for
> __force casts probably provides some good starting points.

Got it. I was just a bit confused that you are going through the pain
to fix many endianess problems and than leave these ones out. But you
are right, we should fix them later and trying to avoid introducing
regressions in this big patch.

Thans,
Daniel
