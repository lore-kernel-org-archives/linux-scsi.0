Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC0DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56DFD64D96
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCRIIa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 04:08:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:33446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhCRIIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 04:08:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 676F5AC1D;
        Thu, 18 Mar 2021 08:08:16 +0000 (UTC)
Date:   Thu, 18 Mar 2021 09:08:16 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v2 6/6] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
Message-ID: <20210318080816.a2fkja2ovlry4qxc@beryllium.lan>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318032840.7611-7-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 17, 2021 at 08:28:40PM -0700, Bart Van Assche wrote:
> @@ -2873,7 +2875,9 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
>  		}
>  
>  		/* reset firmware statistics */
> -		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		ql_log(ql_log_warn, vha, 0x70d9,
> +		       "Resetting ISP statistics failed: rval = %d\n", rval);

Is there not an 'if' missing?

	if (rval)
		ql_log(...)

