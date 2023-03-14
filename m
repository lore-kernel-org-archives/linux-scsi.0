Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A827DC05027
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCNRPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCNRPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:15:43 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1A8BDE5;
        Tue, 14 Mar 2023 10:15:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D95EE68B05; Tue, 14 Mar 2023 18:15:38 +0100 (CET)
Date:   Tue, 14 Mar 2023 18:15:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v4 07/18] nvme: Fix reservation status related structs
Message-ID: <20230314171538.GG6780@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com> <20230224174502.321490-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224174502.321490-8-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2023 at 11:44:51AM -0600, Mike Christie wrote:
> +	__u8	resv10[14];
> +	union {
> +		struct {
> +			__u8	rsvd24[40];
> +			struct nvme_registered_ctrl_ext regctl_eds[0];
> +		};
> +		struct nvme_registered_ctrl regctl_ds[0];
> +	};

... actually - I think both these zero sized arrays should
be the modern [] notation.
