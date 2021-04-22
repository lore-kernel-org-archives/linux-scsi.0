Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307E5C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 01:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B09613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 01:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhDVBjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 21:39:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhDVBjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 21:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619055521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bEXcWA7CNS2of+lIN30Rut/7LwiTIzDb1MLofL6cq6w=;
        b=cHNxLia2HDZgTMCzKwA9Xcn2KK71ssXAht5tXHg03u8gBCtL4eYeZmPVkGhI9P6XHOTd04
        j3LJ0/DtktdBNQj3ZBY6ly/gz9hMwhzAUtnjtGtLIZVT01AYZLVmmCGd0+lE/eH6K8pPgN
        jjOYh51srUc/aNQivrFDi3Z/GrPMDAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-T20pXHdsNfimRRw2vN1tDQ-1; Wed, 21 Apr 2021 21:38:39 -0400
X-MC-Unique: T20pXHdsNfimRRw2vN1tDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B43987A826;
        Thu, 22 Apr 2021 01:38:38 +0000 (UTC)
Received: from T590 (ovpn-12-89.pek2.redhat.com [10.72.12.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E7CB62693;
        Thu, 22 Apr 2021 01:38:29 +0000 (UTC)
Date:   Thu, 22 Apr 2021 09:38:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kashyap.desai@broadcom.com, dgilbert@interlog.com
Subject: Re: [PATCH] scsi: core: Cap initial sdev queue depth at
 shost.can_queue
Message-ID: <YIDTlD2Mq+U36Oqz@T590>
References: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
 <YH4aIECa/J/1uS5S@T590>
 <bba5f248-523d-0def-1a3e-bafeb2b7633f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bba5f248-523d-0def-1a3e-bafeb2b7633f@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2021 at 09:14:12AM +0100, John Garry wrote:
> On 20/04/2021 01:02, Ming Lei wrote:
> > On Tue, Apr 20, 2021 at 12:06:24AM +0800, John Garry wrote:
> > > Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> > > exceed shost.can_queue.
> > > 
> > > However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
> > > initial sdev queue depth greater than can_queue.
> > > 
> > > Stop this happened by capping initial sdev queue depth at can_queue.
> > > 
> > > Signed-off-by: John Garry <john.garry@huawei.com>
> > > ---
> > > Topic originally discussed at:
> > > https://lore.kernel.org/linux-scsi/85dec8eb-8eab-c7d6-b0fb-5622747c5499@interlog.com/T/#m5663d0cac657d843b93d0c9a2374f98fc04384b9
> > > 
> > > Last idea there was to error/warn in scsi_add_host() for cmd_per_lun >
> > 
> 
> Hi Ming,
> 
> > No, that isn't my suggestion.
> 
> Right, it was what I mentioned.
> 
> > 
> > > can_queue. However, such a shost driver could still configure the sdev
> > > queue depth to be sound value at .slave_configure callback, so now thinking
> > > the orig patch better.
> > 
> > As I mentioned last time, why can't we fix ->cmd_per_lun in
> > scsi_add_host() using .can_queue?
> > 
> 
> I would rather not change the values which are provided from the driver. I
> would rather take the original values and try to use them in a sane way.
> 
> I have not seen other places where driver shost config values are modified
> by the core code.

Wrt. .cmd_per_lun, I think it is safe to modify it into one correct
depth because almost all drivers are just producer of .cmd_per_lun. And
except for debug purpose, there are only three consumers of .cmd_per_lun
in scsi, and all are for scsi_change_queue_depth():

	process_message()
	scsi_alloc_sdev()
	virtscsi_change_queue_depth()


Thanks,
Ming

