Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D10C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 19:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A6AE613E1
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 19:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhDTTkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 15:40:12 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:33697 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhDTTkL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 15:40:11 -0400
Received: by mail-wr1-f48.google.com with SMTP id g9so22884259wrx.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 12:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+fRjganmD0Za5jtkx9OW3xS0KFUJi864IsL/gBz6Qs=;
        b=pl9IDR6y915/j6pt+mANnySlhjhPWvDSJ+npEIbLFkX9SKCh5sSmxGRx+rijobZVBg
         7EpIyqWd0Aw+Tjr8+Rqw9rKDvC59M/VXxskqka6S7CApoxSNNpw3LuVNmd0ni8prKx6w
         sLWwaxYiUtK+Op+txoQY3nChPUHZ3scNj5xY5dxDL4p7jbh5rPjMpBLPeLeG+UpfmOgP
         LCwD/2ow59UlvL8U0Z4skbUlSmOLOMF43F/4Xm823b6MxqtBLIsNvYEby0JYgcVW/P+x
         NsJkPPi4/AbqzxNa6vb777APbMkRMaGodoRatEqHqmTk9I0VayZiLlbgjjQsFGX9hOxv
         I8Kw==
X-Gm-Message-State: AOAM531lHsR4SOfq4UXerQZuZR4Oq+xqg/2zDRRKAhe7/3X3v0wh2/2t
        Iz9k3ouiJfz51oktHJ6kTzk=
X-Google-Smtp-Source: ABdhPJzvId3kfMsPCwMVreqfCA81lgfLtjMk1zkZ2fdJ/KTV6942QWp6/+8upxU1xv+QWT4M/P0WYA==
X-Received: by 2002:a5d:47cc:: with SMTP id o12mr22350255wrc.227.1618947577827;
        Tue, 20 Apr 2021 12:39:37 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id c18sm28447922wrn.92.2021.04.20.12.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:39:37 -0700 (PDT)
Date:   Tue, 20 Apr 2021 19:39:35 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 095/117] storvsc: Convert to the scsi_status union
Message-ID: <20210420193935.abhufyr77nlbfsca@liuwe-devbox-debian-v2>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420021402.27678-5-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 07:13:40PM -0700, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

If this is ever needed:

Acked-by: Wei Liu <wei.liu@kernel.org>
