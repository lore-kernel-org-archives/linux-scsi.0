Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C022C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 13:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC68C2222B
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 13:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgJONmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 09:42:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:46732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgJONmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Oct 2020 09:42:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4219B1DD;
        Thu, 15 Oct 2020 13:42:21 +0000 (UTC)
Subject: Re: [PATCH v11 27/44] sg: add sg v4 interface support
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20201015020643.432908-1-dgilbert@interlog.com>
 <20201015020643.432908-28-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <95271b89-aa2c-c06b-f75e-731f18c9ea5b@suse.de>
Date:   Thu, 15 Oct 2020 15:42:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201015020643.432908-28-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/20 4:06 AM, Douglas Gilbert wrote:
> Add support for the sg v4 interface based on struct sg_io_v4 found
> in include/uapi/linux/bsg.h and only previously supported by the
> bsg driver. Add ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
> async (non-blocking) usage of the sg v4 interface. Do not accept
> the v3 interface with these ioctls. Do not accept the v4
> interface with this driver's existing write() and read()
> system calls.
> 
> For sync (blocking) usage expand the existing ioctl(SG_IO)
> to additionally accept the sg v4 interface object.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 442 +++++++++++++++++++++++++++++++++--------
>   include/uapi/scsi/sg.h |  37 +++-
>   2 files changed, 397 insertions(+), 82 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
