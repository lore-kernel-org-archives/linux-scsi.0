Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C93C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B1D20738
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389687AbhAKRmd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389680AbhAKRmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 12:42:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B38DC061786;
        Mon, 11 Jan 2021 09:41:53 -0800 (PST)
Date:   Mon, 11 Jan 2021 18:41:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610386911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uWPJyWhxBkn7WrSnfGWqJytS85ymmy6t5LVcfMF3glc=;
        b=GEexjkx1cgOMorH+r73WM+87NegiHQDeINmzsxiuL1IEr020p59k6UJAnBSJuzzWReBlWs
        UoTqExtkVZa3kPh0euerX9JM5Bd57OlToqSUWzGZqldUp9SXqnjLFYof2k8AscIj7mQixJ
        LWCSCM4CA2SXLcpLuBbGw9L5XuVcq4FVa0fFcrNEzzYsmA/GRSsdsSz3Wy4z3UW+k3daL9
        8z7NZX/viEb6k248ZaQq26w44tRKIVvG/NzlSIkAmTom4EfVmsfYNe4qe9yJ48+etclXet
        Qy237kIulhjLUxZee2KzNnYj7xn9pnLbV/ZC+6AKohvh22PFG3q7N3T66c2o0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610386911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uWPJyWhxBkn7WrSnfGWqJytS85ymmy6t5LVcfMF3glc=;
        b=TK8sCZH+/Sw/a2uqL4+f709IfSQqmGGa2e9adzsf5oHkeixcEzGar3wRTsC/kjb5ycRopv
        Eq8sY8SdkzeUWUDA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        artur.paszkiewicz@intel.com, jinpu.wang@cloud.ionos.com,
        corbet@lwn.net, yanaijie@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-linux-scu@intel.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas and users: Remove notifier indirection
Message-ID: <X/yN3uNT77yy8Usi@lx-t490>
References: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 01:28:32AM +0800, John Garry wrote:
...
> index a920eced92ec..6a51abdc59ae 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -230,7 +230,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
>  	}
>
>  	sas_ha = mvi->sas;
> -	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
> +	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
>

Minor point: "sas_ha" is now not used anywhere; it should be removed.
