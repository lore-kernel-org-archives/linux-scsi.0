Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FC5C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 23:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1852173E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567119978;
	bh=2DIq5j2X+QpOMWqhkHBK01w0HUI6PPxaH+sxt3qGcWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dXPDsJQ5NRLz5131PKHIIY6S1+FQM1yGTjjdqCOLlixLvfTsgnWPSHrB55HrKg2b1
	 S5CnoYQUd8IV7Lj9wB/UacXOuP97XyB14rjy+GGxuIdvsT9oChpEZG4DT1yJCFYtYq
	 WxOPabhxtxLUkXh3T3BVFHWXoWoDvVTa/hw3UnmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfH2XGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 19:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2XGO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 19:06:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16AB52166E;
        Thu, 29 Aug 2019 23:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567119973;
        bh=2DIq5j2X+QpOMWqhkHBK01w0HUI6PPxaH+sxt3qGcWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2cuYDBDMucFe8qdtZix2rddEIdxZw7/FHFvox1hljQ0HZ3Ccu84Be+GBM/aAV7zP
         IOg0Nnxp9u5sVvu+eoLvxTXAioLQ8iwQCyBYOrhtiBPs0XSHQwlPeRWE6nYBuA5E6J
         ojLmEC2KEMGrHULrn7ic7VfHjrp+tC0vRwH1L7S0=
Date:   Thu, 29 Aug 2019 19:06:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, jsarha@ti.com, tomi.valkeinen@ti.com,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 2/3] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE
 define value
Message-ID: <20190829230612.GQ5281@sasha-vm>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
 <20190829200001.17092-3-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829200001.17092-3-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 29, 2019 at 02:00:00PM -0600, Mathieu Poirier wrote:
>From: Pedro Sousa <sousa@synopsys.com>
>
>commit ebcb8f8508c5edf428f52525cec74d28edea7bcb upstream
>
>Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
>according to MIPI Alliance MPHY specification.
>
>Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
>Signed-off-by: Pedro Sousa <sousa@synopsys.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

I've queued this for 4.14-4.19, thanks!

--
Thanks,
Sasha
