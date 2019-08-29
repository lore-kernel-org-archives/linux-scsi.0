Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BDAC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 23:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7851C2173E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567119695;
	bh=W9b8uz0feEaW6eZCGVA4xllacD7howC1goKBJQjIsP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CVKRbSufVVH8RJzVT5OfRYcrP96GVItbSgS0k/EKr7hwEpK16fObV59Bh5cpnoNxs
	 8TJtmzVG4fArGDLuw5+x+bLVZcsrnKjCUxDSiqzDTVu1Xu+8wzHec4578O/xh5W29o
	 cmqzPYB57Zlow8L8CT8w7K3lfFl5/2eBOGQ2TAJY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfH2XBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 19:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2XBa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 19:01:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2D220828;
        Thu, 29 Aug 2019 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567119689;
        bh=W9b8uz0feEaW6eZCGVA4xllacD7howC1goKBJQjIsP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSJ6EehHO0cOzJSIr27S1Lja+mZUxP500FnEZtxxAgXtdPYX6f/m17eD5+lda6brA
         YPZdc70TZBBcV2AmJtoXO5/c/Ds6ILtQM+spB9LQXswf+yQTXxIL3t7auVDhf7WLdA
         tSelT+jtK3910rMvMUNQ02HQ6j9R79g+fxFCiYJY=
Date:   Thu, 29 Aug 2019 19:01:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, jsarha@ti.com, tomi.valkeinen@ti.com,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 1/3] drm/bridge: tfp410: fix memleak in
 get_modes()
Message-ID: <20190829230128.GP5281@sasha-vm>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
 <20190829200001.17092-2-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829200001.17092-2-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 29, 2019 at 01:59:59PM -0600, Mathieu Poirier wrote:
>From: Tomi Valkeinen <tomi.valkeinen@ti.com>
>
>commit c08f99c39083ab55a9c93b3e93cef48711294dad upstream
>
>We don't free the edid blob allocated by the call to drm_get_edid(),
>causing a memleak. Fix this by calling kfree(edid) at the end of the
>get_modes().
>
>Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20190610135739.6077-1-tomi.valkeinen@ti.com
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

I've queued this one for 4.14-5.2, thanks!

--
Thanks,
Sasha
