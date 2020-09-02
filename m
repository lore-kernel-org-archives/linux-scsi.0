Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817F9C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 22:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B923207D3
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 22:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBWXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 18:23:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIBWXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 18:23:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7518AC55;
        Wed,  2 Sep 2020 22:23:38 +0000 (UTC)
Date:   Thu, 3 Sep 2020 00:23:36 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Michael Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-ID: <20200903002336.083e88a4@suse.de>
In-Reply-To: <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
References: <20200813002142.13820-1-ddiss@suse.de>
        <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

On Tue, 1 Sep 2020 22:17:51 -0500, Michael Christie wrote:

> > --- a/drivers/target/target_core_xcopy.c
> > +++ b/drivers/target/target_core_xcopy.c
> > @@ -68,8 +68,14 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
> > 	if (rc != 0)
> > 		return 0;
> > 
> > -	info->found_dev = se_dev;
> > 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
> > +	if (info->found_dev) {
> > +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p and %p\n",
> > +			info->found_dev, se_dev);
> > +		target_undepend_item(&info->found_dev->dev_group.cg_item);
> > +		return -ENOTUNIQ;
> > +	}
> > +	info->found_dev = se_dev;  
> 
> Was it valid to copy to/from the same LUN? You would copy from/to different src/destinations on that LUN. Would your patch break that?

XCOPY allows for copies to occur on the same LUN or between separate
src/destinations. The intention of this patch is that regardless of the
source or destination, if the NAA WWN could refer to multiple LUNs on
the same target (via target_for_each_device()) then the XCOPY should
fail and force the initiator to fallback to initiator driver copy.

Cheers, David
