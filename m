Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C556C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 03:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD0F206FA
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 03:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MnJL+1/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgFKDHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 23:07:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56534 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726306AbgFKDHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 23:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591844852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=czsPVHHbfIrbWxVtGiOSBsLEckvry285yyDlUPyXhJo=;
        b=MnJL+1/M08/5cD46uFSAjF5yBCDBfG4v0HMBZGMSM68C4ZJRL3F7JoqYvdxrivZ3FwTvke
        lf/oeNBqT+zaD4NRJrJKQqq4MMtiEeMuXrabEb4DW+OqChzEu/Gf7h1V95r4NPPfKw10qF
        0hwaE21ZblAUKq5lmcSs1ZUN2EzXoDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-B_c9so5yMmuIkxekDeYPdA-1; Wed, 10 Jun 2020 23:07:27 -0400
X-MC-Unique: B_c9so5yMmuIkxekDeYPdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA19A835B40;
        Thu, 11 Jun 2020 03:07:24 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 811975C1B0;
        Thu, 11 Jun 2020 03:07:12 +0000 (UTC)
Date:   Thu, 11 Jun 2020 11:07:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, bvanassche@acm.org, hare@suse.com,
        hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
Message-ID: <20200611030708.GB453671@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 11, 2020 at 01:29:07AM +0800, John Garry wrote:
> Hi all,
> 
> Here is v7 of the patchset.
> 
> In this version of the series, we keep the shared sbitmap for driver tags,
> and introduce changes to fix up the tag budgeting across request queues (
> and associated debugfs changes).
> 
> Some performance figures:
> 
> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
> but it is not always an appropriate scheduler to use.
> 
> Tag depth 		4000 (default)			260**
> 
> Baseline:
> none sched:		2290K IOPS			894K
> mq-deadline sched:	2341K IOPS			2313K
> 
> Final, host_tagset=0 in LLDD*
> none sched:		2289K IOPS			703K
> mq-deadline sched:	2337K IOPS			2291K
> 
> Final:
> none sched:		2281K IOPS			1101K
> mq-deadline sched:	2322K IOPS			1278K
> 
> * this is relevant as this is the performance in supporting but not
>   enabling the feature
> ** depth=260 is relevant as some point where we are regularly waiting for
>    tags to be available. Figures were are a bit unstable here for testing.
> 
> A copy of the patches can be found here:
> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7
> 
> And to progress this series, we the the following to go in first, when ready:
> https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/

I'd suggest to add options to enable shared tags for null_blk & scsi_debug in V8, so
that it is easier to verify the changes without real hardware.

Thanks,
Ming

