Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49CAC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 06:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjGYGvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 02:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjGYGvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 02:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BE919B0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 23:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D3A0602FB
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 06:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415F7C433C7;
        Tue, 25 Jul 2023 06:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690267888;
        bh=+m7YXOVIot5s7CjzxpTdEi34jLeO4Cc0uuq+cW09kws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nba8pT2QLva/a8MjXijWCxKooayHgjcjZtsFu2dNsP8WeFF+OtWBKMKj1XytGqgun
         +E0GoFk1x10LXwsC64AfUNMlpUFMQTO+GMis3EYG81E59Jgb/uMrEV8ktfhfvmXKqN
         6LXGeQ12DVtjLCG/SnNfqM8MTE9MJTNM8bV+JqdmMX/xHd9SnqF6LYZsQrARwA4ga+
         Y9RtigxmLOWb2VApt5fBIuW7JN6j+yONoctiMYDmUxHKMer01KnlRPRv4l5gBoFQ64
         ilCgYKTAGHg7B47jBTz9Df/VLPm4Qmf4pFByoNrX9J5gAEtS0yJmbqdDpMIddciGlu
         eGsUkp0XAnS9w==
Date:   Tue, 25 Jul 2023 09:51:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Damien Le Moal <dlemoal@kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH v2 2/2] RDMA/srp: Fix residual handling
Message-ID: <20230725065124.GN11388@unreal>
References: <20230724200843.3376570-1-bvanassche@acm.org>
 <20230724200843.3376570-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724200843.3376570-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 24, 2023 at 01:08:30PM -0700, Bart Van Assche wrote:
> Although the code for residual handling in the SRP initiator follows the
> SCSI documentation, that documentation has never been correct. Because
> scsi_finish_command() starts from the data buffer length and subtracts
> the residual, scsi_set_resid() must not be called if a residual overflow
> occurs. Hence remove the scsi_set_resid() calls from the SRP initiator
> if a residual overflow occurrs.
> 
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Fixes: 9237f04e12cc ("scsi: core: Fix scsi_get/set_resid() interface")
> Fixes: e714531a349f ("IB/srp: Fix residual handling")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 4 ----
>  1 file changed, 4 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>
