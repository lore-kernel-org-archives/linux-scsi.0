Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F1C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F63A65001
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhCPIhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:37:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:57836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235209AbhCPIgy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 04:36:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F35BAC1F;
        Tue, 16 Mar 2021 08:36:53 +0000 (UTC)
Date:   Tue, 16 Mar 2021 09:36:53 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 4/7] qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n'
 before using it
Message-ID: <20210316083653.e7gxi6qn4juctfdl@beryllium.lan>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316035655.2835-5-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 15, 2021 at 08:56:52PM -0700, Bart Van Assche wrote:
> This patch suppresses the following sparse warning:

[...]

> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 0677295957bc..5683126e0cbc 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1095,7 +1095,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
>  	int i ;
>  	struct crb_addr_pair *buf;
>  	unsigned long off;
> -	unsigned offset, n;
> +	unsigned offset, n = 0;
>  	struct qla_hw_data *ha = vha->hw;
>  
>  	struct crb_addr_pair {

I think sparse is not able to see that n is initialized
before it is used.

	/* Read the signature value from the flash.
	 * Offset 0: Contain signature (0xcafecafe)
	 * Offset 4: Offset and number of addr/value pairs
	 * that present in CRB initialize sequence
	 */
	n = 0;
	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
	    qla82xx_rom_fast_read(ha, 4, &n) != 0) {
		ql_log(ql_log_fatal, vha, 0x006e,
		    "Error Reading crb_init area: n: %08x.\n", n);
		return -1;
	}

I suppose this n = 0 should be dropped if n is initialized at the
beginning of the function.
