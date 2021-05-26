Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3799C4707F
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 00:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 901B46142B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 00:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhEZAgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 20:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhEZAgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 20:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621989269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2eLBrKWtD0qwraKGh25e7ijIKX8GSNTLqKSyocjsO4=;
        b=bOUZN0bw3PrR1C3JBDQy3ZS8rfaw3u/LV8QBAj7L+jO6YAl9esbtUje2OMQ2dYFwl96HaJ
        e9be5PewALgCeP26jA7ZykkZdkS9fwb58wdKysufDvN/U67u8DqGXLDINDUMwuIFjTrPht
        5U+NbsbEhCA8pdLQrCw4gKZH66j/Quw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-hs4ZYW2UN8675bUl2VFEMg-1; Tue, 25 May 2021 20:34:26 -0400
X-MC-Unique: hs4ZYW2UN8675bUl2VFEMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B170A180FD61;
        Wed, 26 May 2021 00:34:24 +0000 (UTC)
Received: from T590 (ovpn-12-85.pek2.redhat.com [10.72.12.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E04D60C04;
        Wed, 26 May 2021 00:34:16 +0000 (UTC)
Date:   Wed, 26 May 2021 08:34:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: REQ_HIPRI and SCSI mid-level
Message-ID: <YK2Xg0HBiS1cRYOV@T590>
References: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 21, 2021 at 05:56:19PM -0400, Douglas Gilbert wrote:
> The REQ_HIPRI flag on requests is associated with blk_poll() (aka iopoll)
> and assumes the user space (or some higher level) will be calling
> blk_poll() on requests marked with REQ_HIPRI and that will lead to their
> completion.
> 
> In lk 5.13-rc1 the megaraid and scsi_debug LLDs support blk_poll() [seen
> by searching for 'mq_poll'] with more to follow, I assume. I have tested
> blk_poll() on the scsi_debug driver using both fio and the new sg driver.
> It works well with one caveat: as long as there isn't an error.
> After fighting with that error processing from the ULD side (i.e. the
> new sg driver) and the LLD side I am concluding that the glue that
> holds them together, that is, the mid-level is not as REQ_HIPRI aware
> as it should be.
> 
> Yes REQ_HIPRI is there in scsi_lib.c but it is missing from scsi_error.c
> How can scsi_error.c re-issue requests _without_ taking into account
> that the original was issued with REQ_HIPRI ? Well I don't know but I'm
> pretty sure that is close to the area that I see causing problems
> (mainly lockups).
> 
> As an example the scsi_debug driver has an in-use bitmap that when a new
> request arrives the code looks for an empty slot. Due to (incorrect)
> parameter setup that may fail. If the driver returns:
>     device_qfull_result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
> then I see lock-ups if the request in question has REQ_HIPRI set.
> 
> If that is changed to:
>     device_qfull_result = (DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
> then my user space test program sees that error and aborts showing the
> TASK SET FULL SCSI status. That is much better than a lockup ...
> 
> Having played around with variants of the above for a few weeks, I'd
> like to throw this problem into the open :-)
> 
> 
> Suggestion: perhaps the eh could give up immediately on any request
> with REQ_HIPRI set (i.e. make it a higher level layer's problem).

One invariant is that the polling will be kept as running until the
associated iocb/bio is completed. So I understand it should be fine
for timeout handler /EH to ignore REQ_HIPRI. That said the associated
iocb/bio will be reaped by upper layer if EH/timeout handler makes
progress. Or can you explain the scsi-debug REQ_HIPRI lockup in a bit
detail?


Thanks,
Ming

