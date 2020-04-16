Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9445BC2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC61208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636221AbgDPMqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:46:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:55674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636192AbgDPMpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 08:45:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 09B42ABAD;
        Thu, 16 Apr 2020 12:45:06 +0000 (UTC)
Date:   Thu, 16 Apr 2020 14:45:05 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        maier@linux.ibm.com, bvanassche@acm.org, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 25/31] elx: efct: Hardware IO submission routines
Message-ID: <20200416124505.cqqkotnsjhlpkhp3@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-26-jsmart2021@gmail.com>
 <1af2f44d-ede4-bdd8-5812-9d4526a1f9b5@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1af2f44d-ede4-bdd8-5812-9d4526a1f9b5@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 16, 2020 at 10:10:18AM +0200, Hannes Reinecke wrote:
> > +	switch (type) {
> > +	case EFCT_HW_ELS_REQ:
> > +		if (!send ||
> > +		    sli_els_request64_wqe(&hw->sli, io->wqe.wqebuf,
> > +					  hw->sli.wqe_size, io->sgl,
> > +					*((u8 *)send->virt),
> > +					len, receive->size,
> > +					iparam->els.timeout,
> > +					io->indicator, io->reqtag,
> > +					SLI4_CQ_DEFAULT, rnode->indicator,
> > +					rnode->sport->indicator,
> > +					rnode->attached, rnode->fc_id,
> > +					rnode->sport->fc_id)) {
> > +			efc_log_err(hw->os, "REQ WQE error\n");
> > +			rc = EFCT_HW_RTN_ERROR;
> > +		}
> > +		break;
> 
> I did mention several times that I'm not a big fan of overly long argument
> lists.
> Can't you pass in 'io' and 'rnode' directly and cut down on the number of
> arguments?

Yes, please!
