Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC67C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E3E761139
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhDOMWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOMWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618489338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QoAD7fSGLRxaRkdTztO9eeG0xAGTI4HrEhjyHOnl3dI=;
        b=T8UkIQmn+NHiLKsNalIuPQ2Olwd29z6sWK9xu28aNYTITucYjYEpRF3teJSMOFnka1nscP
        e+NKX+FhmXOwMAEG0cjn0eWrOXdVIxSFmmv2xyk1UqFRxmHY51b/L7fDL8mDBinLL1kZ92
        TINOmEuzyH2mUaFvHLVXla1GMROhYco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-mwtJIMmYOlaHdhdSs6Hypw-1; Thu, 15 Apr 2021 08:22:12 -0400
X-MC-Unique: mwtJIMmYOlaHdhdSs6Hypw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 369B28189C6;
        Thu, 15 Apr 2021 12:22:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80AA86064B;
        Thu, 15 Apr 2021 12:22:10 +0000 (UTC)
Subject: Re: [PATCH v2 17/24] mpi3mr: add support of threaded isr
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-18-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <2dba2262-2a2c-b545-a2ae-e64f2416c080@redhat.com>
Date:   Thu, 15 Apr 2021 14:22:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-18-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Register driver for threaded interrupt.
> 
> By default, driver will attempt io completion from interrupt context
> (primary handler). Since driver tracks per reply queue outstanding ios,
> it will schedule threaded ISR if there are any outstanding IOs expected
> on that particular reply queue. Threaded ISR (secondary handler) will loop
> for IO completion as long as there are outstanding IOs
> (speculative method using same per reply queue outstanding counter)
> or it has completed some X amount of commands (something like budget).
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

