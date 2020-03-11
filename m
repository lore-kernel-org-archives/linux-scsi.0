Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F421FC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3511720575
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:38:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pq5WI5+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgCKOir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:38:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729718AbgCKOir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 10:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583937526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/J3I+ex4SvmIY+7EAcBB18vkXoztt3EPUNGrhEijzQg=;
        b=Pq5WI5+3lK28vT68QqPNB2qY5b8imDpU3Qc5ehVlL3EKH2DOHB7M+8inXmORr2xzETON5a
        COGhIqiLF53q6FByp061XZT2xDBvRHAde0wgcyrTqWvR5c78GF4c1ALFw/4IIpEszOsRp2
        ix8ABdXO6YZKwGXaYBCCFNgm+91u30w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-c2o9MtmFNf68XwawDK1keA-1; Wed, 11 Mar 2020 10:38:42 -0400
X-MC-Unique: c2o9MtmFNf68XwawDK1keA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FAA9800D54;
        Wed, 11 Mar 2020 14:38:41 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4E1760BF1;
        Wed, 11 Mar 2020 14:38:40 +0000 (UTC)
Message-ID: <01a81b7a7e347ab1c567ad005658159af5a90050.camel@redhat.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Date:   Wed, 11 Mar 2020 10:38:40 -0400
In-Reply-To: <789f1dc7-38bf-eced-85b1-ad22e7d69757@acm.org>
References: <20200309181416.10665-1-emilne@redhat.com>
         <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
         <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
         <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
         <e13d0e51e83fd2fc5d653633a9cfb74e2b24b5a6.camel@redhat.com>
         <789f1dc7-38bf-eced-85b1-ad22e7d69757@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-03-10 at 21:01 -0700, Bart Van Assche wrote:
> 

...

> If any thread modifies any of these existing bitfields concurrently with
> scsi_prep_state_check(), one of the two modifications will be lost. That
> is because compilers implement bitfield changes as follows:
> 
> new_value = (old_value & ~(1 << ...)) | (1 << ...);
> 
> If two such assignment statements are executed concurrently, both start
> from the same 'old_value' and only one of the two changes will happen.
> I'm concerned that this patch introduces a maintenance problem in the
> long term. Has it been considered to make 'offline_already' a 32-bits
> integer variable or a boolean instead of a bitfield? I think such
> variables can be modified without discarding values written from another
> thread.
> 
> Thanks,
> 
> Bart.
> 

I understand your concern about long-term maintenance, and introducing
a pattern that could be used by other code that needs more accurate
state.  (Although, it is likely that a lock or an atomic operation might
be required in other cases).  I'll post a v2 changing this to a boolean.

-Ewan


