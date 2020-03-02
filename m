Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01CFC3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 16:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B42182064A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 16:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCBQuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 11:50:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:42688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgCBQuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 11:50:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D34AB26A;
        Mon,  2 Mar 2020 16:50:42 +0000 (UTC)
Date:   Mon, 2 Mar 2020 17:50:41 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/4] qla2xxx: Fix endianness annotations in header files
Message-ID: <20200302165041.fzwxzd3aojz6vylh@beryllium.lan>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302033023.27718-3-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Mar 01, 2020 at 07:30:21PM -0800, Bart Van Assche wrote:
> Annotate members of FC protocol and firmware dump data structures as big
> endian. Annotate members of RISC control structures as little endian.
> Annotate mailbox registers as little endian. Annotate the mb[] arrays as
> CPU-endian because communication of the mb[] values with the hardware
> happens through the readw() and writew() functions. readw() converts from
> __le16 to u16 and writew() converts from u16 to __le16.
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.h    | 442 +++++++++---------
>  drivers/scsi/qla2xxx/qla_def.h    | 646 +++++++++++++-------------
>  drivers/scsi/qla2xxx/qla_fw.h     | 738 +++++++++++++++---------------
>  drivers/scsi/qla2xxx/qla_inline.h |   2 +-
>  drivers/scsi/qla2xxx/qla_mr.h     |   8 +-
>  drivers/scsi/qla2xxx/qla_nvme.h   |  46 +-
>  drivers/scsi/qla2xxx/qla_nx.h     |  36 +-
>  drivers/scsi/qla2xxx/qla_target.h | 208 ++++-----
>  8 files changed, 1063 insertions(+), 1063 deletions(-)

I've tried to make sure the new variable type has correct length. I
suspect our tooling will complain if the endian doesn't fit. Looks
good.

Just one nitpick: Sometimes there is an additianol space added between
the type and the variable name, e.g.

> -	uint16_t nport_handle;
> -	uint16_t reserved_1;
> +	__le16	nport_handle;
> +	__le16	reserved_1;

and as result the ovarall aligment in the context is not consistent
anymore. Not how much we care about this.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel
