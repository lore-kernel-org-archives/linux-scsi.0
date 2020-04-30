Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B56AC47247
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2C12082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnCOPUN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgD3PQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:16:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726355AbgD3PQI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 11:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588259767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JhfFIDViz/O6KZzcf+b8rblD3qco4a5Ws6+3byz+Uo4=;
        b=UnCOPUN/aqrjnxyiWtIqjArOHfb96fLWDb6MiO9kBXBIy1yh1BVs28BlpYvFy2VWDfc3wS
        YhCoCGIar9L1p/A9IzhVve4G/qtzRsYMTbux+W6noon4ls6J/YcxXWKY0moPT0t3WgXis0
        1kjXVzlUg3u62T6o48W0Njyk7OUE2C8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-CM2xGhjDNiSig41MX6yNxw-1; Thu, 30 Apr 2020 11:16:02 -0400
X-MC-Unique: CM2xGhjDNiSig41MX6yNxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ACD219200C4;
        Thu, 30 Apr 2020 15:16:01 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 197522855D;
        Thu, 30 Apr 2020 15:15:51 +0000 (UTC)
Date:   Thu, 30 Apr 2020 23:15:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
Message-ID: <20200430151546.GB1005453@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-5-hare@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:27PM +0200, Hannes Reinecke wrote:
> When issuing a LUN reset we should be using a reserved command
> to avoid overwriting the original command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/csiostor/csio_init.c |  1 +
>  drivers/scsi/csiostor/csio_scsi.c | 48 +++++++++++++++++++++++----------------
>  2 files changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> index 8dea7d53788a..5e1b0a24caf6 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -622,6 +622,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
>  	ln->dev_num = (shost->host_no << 16);
>  
>  	shost->can_queue = CSIO_MAX_QUEUE;
> +	shost->nr_reserved_cmds = 1;

->can_queue isn't increased by 1 given CSIO_MAX_QUEUE isn't changed, so
setting shost->nr_reserved_cmds as 1 will cause io queue depth reduced by 1,
that is supposed to not happen.

Any conversion not increasing ->can_queue should have this same issue, please
check other conversions.



thanks,
Ming

