Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087B5C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68F8613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhDOKf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhDOKfz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 06:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618482932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHBCW5YcJ5tcw/4Tfg8AMNz24UDpSX/WpBMuM5oWSv8=;
        b=cnhyzbTp9joPo76NKbnbhmeUvqfRgm7gt02U83J7nDfrTo/jbBr+hjjNkt8FD3ib4Heuw2
        BWL2096SIzvmCZj0PxVb7l4TUFU4JtXj0P6+6Bv0TrS+7Tf1Eq93uq00gF10j820/2N9Cn
        iO0pL2+E3psJ4DRHDdr4Zq3aTGflRcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-jP5sBDAwNn-7XOAzWwwh_w-1; Thu, 15 Apr 2021 06:35:30 -0400
X-MC-Unique: jP5sBDAwNn-7XOAzWwwh_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406C86D581;
        Thu, 15 Apr 2021 10:35:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B7C75D9DC;
        Thu, 15 Apr 2021 10:35:28 +0000 (UTC)
Subject: Re: [PATCH v2 03/24] mpi3mr: create operational request and reply
 queue pair
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-4-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <e47ff8f2-4741-9ed0-93e4-7a14a6300450@redhat.com>
Date:   Thu, 15 Apr 2021 12:35:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-4-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Create operational request and reply queue pair.
> 
> The MPI3 transport interface consists of an Administrative Request Queue,
> an Administrative Reply Queue, and Operational Messaging Queues.
> The Operational Messaging Queues are the primary communication mechanism
> between the host and the I/O Controller (IOC).
> Request messages, allocated in host memory, identify I/O operations to be
> performed by the IOC. These operations are queued on an Operational
> Request Queue by the host driver.
> Reply descriptors track I/O operations as they complete.
> The IOC queues these completions in an Operational Reply Queue.
> 
> To fulfil large contiguous memory requirement, driver creates multiple
> segments and provide the list of segments. Each segment size should be 4K
> which is h/w requirement. An element array is contiguous or segmented.
> A contiguous element array is located in contiguous physical memory.
> A contiguous element array must be aligned on an element size boundary.
> An element's physical address within the array may be directly calculated
> from the base address, the Producer/Consumer index, and the element size.
> 
> Expected phased identifier bit is used to find out valid entry on reply queue.
> Driver set <ephase> bit and IOC invert the value of this bit on each pass.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

