Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1640C3526C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 10:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE2323BDE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 10:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgLSKgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 05:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgLSKgB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Dec 2020 05:36:01 -0500
Date:   Sat, 19 Dec 2020 11:36:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608374120;
        bh=Avl70r/8VtpPOV5EvV5bOYpuJ7voLpyxA8PcyZcJzGU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=S9/o0I9080BCkI6Npb4SHVxYFW1s+7lhvCsVuGORINNmm6GC01noqodsfKaoI6eqR
         3PETyvxbVR9dTMGYD09Q/WqQBzznfJWhSoIvQ3D25yYfvzrNv2KdcVZFvRxxDi6JN7
         KHTP/sj1ZD2aVG77kRpBeHs6JP+V/IHCTnJgA9ss=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X93XuJ4lsQbBgnU+@kroah.com>
References: <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
 <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p7>
 <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Dec 19, 2020 at 06:18:47PM +0900, Daejun Park wrote:
> +static int ufshpb_get_state(struct ufshpb_lu *hpb)
> +{
> +	return atomic_read(&hpb->hpb_state);
> +}
> +
> +static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
> +{
> +	atomic_set(&hpb->hpb_state, state);
> +}

You have a lock for the state, and yet the state is an atomic variable
and you do not use the lock here at all.  You don't use the lock at all
infact...

So either the lock needs to be dropped, or you need to use the lock and
make the state a normal variable please.

> +static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct scsi_device *sdev;
> +	bool init_success;
> +
> +	init_success = !ufshpb_check_hpb_reset_query(hba);
> +
> +	shost_for_each_device(sdev, hba->host) {
> +		hpb = sdev->hostdata;
> +		if (!hpb)
> +			continue;
> +
> +		if (init_success) {
> +			dev_info(hba->dev, "set state to present\n");

Why be noisy?  Why does userspace need to see this all the time,
shouldn't only errors be printing something?

thanks,

greg k-h
