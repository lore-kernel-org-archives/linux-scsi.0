Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911FCC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 715C9613D5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhEYIiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 04:38:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:51324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232213AbhEYIiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 04:38:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621931800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNeaL6bordaQR6K/RtEmdG9iMJHGmVJ7ceVMANwC5qs=;
        b=strQxeJNC87oktrtrjM1qa69sbx6n4CyEE6IsBXAYgOPn0Yew5hpa+0qq4wQoWhhfLm0D3
        IJ4wJY4DrCdRr/mW9PYGLxF1qBREzKZAlhWTUNZgdW/NT/Fq50qpeG5Ji+Yf4XqdcHt8mF
        R5BhiZ/X73gyxLdt9fqs21oDgSyKzwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621931800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNeaL6bordaQR6K/RtEmdG9iMJHGmVJ7ceVMANwC5qs=;
        b=37is/Gn7NcNAtdFIbjhrUrpQLmIrVuokUnG7kLptFn7IPIkjjdc83mS4Uzq4XIKlbqdCFD
        yH2P0h3DwX5ZejAg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 244D0AE92;
        Tue, 25 May 2021 08:36:40 +0000 (UTC)
Subject: Re: [PATCH v19 44/45] sg: add blk_poll support
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20210524010147.94845-1-dgilbert@interlog.com>
 <20210524010147.94845-45-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b8cf3717-489e-7f55-8e5d-9b4493e2da40@suse.de>
Date:   Tue, 25 May 2021 10:36:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210524010147.94845-45-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 3:01 AM, Douglas Gilbert wrote:
> The support is added via the new SGV4_FLAG_HIPRI command flag which
> causes REQ_HIPRI to be set on the request. Before waiting on an
> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
> and if so blk_poll() is called instead of the wait. In situations
> where only the file descriptor is known (e.g. sg_poll() and
> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
> the file descriptor that have SGV4_FLAG_HIPRI set, have blk_poll()
> called on them.
> 
> It is important to know blk_execute_rq_nowait() has finished before
> sending blk_poll() on that request. The SG_RS_INFLIGHT state is set
> just before blk_execute_rq_nowait() is called so a new bit setting
> SG_FRQ_ISSUED has been added that is set just after that calls
> returns.
> 
> Note that the implementation of blk_poll() calls mq_poll() in the
> LLD associated with the request. Then for any request found to be
> ready, blk_poll() invokes the scsi_done() callback. When blk_poll()
> returns > 0 , sg_rq_end_io() may have been called on the given
> request. If so the given request will be in await_rcv state.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 111 ++++++++++++++++++++++++++++++++++++++---
>   include/uapi/scsi/sg.h |   1 +
>   2 files changed, 106 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
