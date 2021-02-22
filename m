Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C509C4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DEAE64E74
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhBVPdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:33:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231728AbhBVPcw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 10:32:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614007882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uz057YKz9OOpKcig9ktQxGS+X2J130mjzcC+9SUhwfY=;
        b=Y3corV25NYuarKNwFTAFzrh2c7fJFuIrvA7VSAKeskyQZlNEgcIZQ6VoK/l4NJB49NKnM3
        qhamHGOE69ffbL3QpawAGlS9M/B2v4QMJlszMHhWt/ZkcbOLpzN8Z02cLXNE0WblSe04Dl
        eu6HzjIZn8JIoEWm6OX3rhk768tBB3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-vytqjd6KMh6qs2LmF8Aq2A-1; Mon, 22 Feb 2021 10:31:18 -0500
X-MC-Unique: vytqjd6KMh6qs2LmF8Aq2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F45107ACE4;
        Mon, 22 Feb 2021 15:31:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 196E819CA8;
        Mon, 22 Feb 2021 15:31:14 +0000 (UTC)
Subject: Re: [PATCH 06/24] mpi3mr: add support of event handling part-1
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-7-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <1d1e8644-85a3-6696-41d6-16bb0cf405bb@redhat.com>
Date:   Mon, 22 Feb 2021 16:31:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-7-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_DEVICE_ADDED
> MPI3_EVENT_DEVICE_INFO_CHANGED
> MPI3_EVENT_DEVICE_STATUS_CHANGE
> MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
> MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_SAS_DISCOVERY
> MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR
> 
> Key support in this patch is device add/removal.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
...
> + */
> +void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3mr_fwevt *fwevt = NULL;
> +
> +	if ((list_empty(&mrioc->fwevt_list) && !mrioc->current_event) ||
> +	    !mrioc->fwevt_worker_thread || in_interrupt())
The in_interrup macro is deprecated and should not be used in new code.
Is it at all possible to call the mpi3mr_cleanup_fwevt_list from
interrupt context?

> +		return;
> +
> +	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)) ||
> +	    (fwevt = mrioc->current_event)) {
> +		/*
> +		 * Wait on the fwevt to complete. If this returns 1, then
> +		 * the event was never executed, and we need a put for the
> +		 * reference the work had on the fwevt.
> +		 *
> +		 * If it did execute, we wait for it to finish, and the put will
> +		 * happen from mpi3mr_process_fwevt()
> +		 */
> +		if (cancel_work_sync(&fwevt->work)) {
> +			/*
> +			 * Put fwevt reference count after
> +			 * dequeuing it from worker queue
> +			 */
> +			mpi3mr_fwevt_put(fwevt);
> +			/*
> +			 * Put fwevt reference count to neutralize
> +			 * kref_init increment
> +			 */
> +			mpi3mr_fwevt_put(fwevt);
> +		}
> +	}
> +}

