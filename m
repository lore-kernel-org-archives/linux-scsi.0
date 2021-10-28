Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68393C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 01:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D46561108
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 01:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhJ1BfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 21:35:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229703AbhJ1BfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 21:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635384755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hy1o0j7MHVCAnxeIpqfWn/9BPWoP+Y8R9kI8u6KXXXs=;
        b=BWPBMHTVoXTU3DJn5MBWS/sdifzNfAqv3EeVsVTM6VuqKvjeo3XhDjHmPOeirJC2zyajyI
        Nay25RRuvG/U2jq4HzZ7a+Kx1JSmbC/Fs656W02QlZYfVTV5dQl5gFrZPLWT7mwCQR9AWD
        /BGCpV/udHzngJTZfvwrmoh6gvylKnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-lvsgKSgwNbCjzoZXK8eEPg-1; Wed, 27 Oct 2021 21:32:32 -0400
X-MC-Unique: lvsgKSgwNbCjzoZXK8eEPg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D69178030B7;
        Thu, 28 Oct 2021 01:32:30 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A49F460BE5;
        Thu, 28 Oct 2021 01:32:21 +0000 (UTC)
Date:   Thu, 28 Oct 2021 09:32:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXn9oENzCzzeGENV@T590>
References: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
 <bbab4d8f-67c0-83bb-a979-cb9f9ac28af5@kernel.dk>
 <yq1r1c6zd4f.fsf@ca-mkp.ca.oracle.com>
 <b0149856-4582-a3c0-a206-9b0fbf13854e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0149856-4582-a3c0-a206-9b0fbf13854e@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 10:01:42AM -0700, Bart Van Assche wrote:
> On 10/27/21 9:16 AM, Martin K. Petersen wrote:
> > Given that HPB developed over time, I am not sure how simple a revert
> > would be. And we only have a couple of days left before release. I
> > really want the smallest patch possible that either removes or disables
> > the 2.0 support.
> 
> How about one of the untested patches below?
> 
> The patch below disables support for HPB 2.0 by ignoring the HPB version reported
> by the UFS controller:
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 66b19500844e..5f9f7139480a 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -2872,8 +2872,8 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
>  		return;
>  	}
> 
> -	if (version == HPB_SUPPORT_LEGACY_VERSION)
> -		hpb_dev_info->is_legacy = true;
> +	/* Do not use HPB 2.0 because of the blk_insert_cloned_request() call. */
> +	hpb_dev_info->is_legacy = true;

I guess you may change ufshpb_is_required_wb() to return false simply
with comment.

> 
>  	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
> 
> 
> The second patch changes the blk_insert_cloned_request() call into a
> blk_execute_rq_nowait() call. That should work fine since this function
> bypasses the I/O scheduler for passthrough requests:

Either ->is_legacy is set as true or ufshpb_is_required_wb() returns
false, blk_insert_cloned_request() won't be called. But here
blk_execute_rq_nowait() should be used since it is one driver private IO.

That also shows the private command of pre_req is run concurrently with the
original FS IO, and two tags are consumed for doing one IO. It could be done
one by one, but I guess it is a bit slower, just saw Daejun replied this point.


thanks,
Ming

