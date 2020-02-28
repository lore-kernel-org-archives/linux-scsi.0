Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51219C3F2D0
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1FE24695
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgB1JVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:21:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:51748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgB1JVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:21:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3E3CAC92;
        Fri, 28 Feb 2020 09:21:38 +0000 (UTC)
Subject: Re: [PATCH v7 38/38] sg: bump version to 4.0.08
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-39-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4ca88b56-79c5-4c6e-32d2-da035712f2af@suse.de>
Date:   Fri, 28 Feb 2020 10:21:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-39-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:59 PM, Douglas Gilbert wrote:
> Now that the sg version 4 interface is supported:
>    - with ioctl(SG_IO) for synchronous/blocking use
>    - with ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
>      async/non-blocking use
> Plus new ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3)
> potentially replace write() and read() for the sg
> version 3 interface. Bump major driver version number
> from 3 to 4.
> 
> The main new feature is the removal of the fixed 16 element
> array of requests per file descriptor. It is replaced by
> a xarray (eXtensible array) in their parent which is a
> sg_fd object (i.e. a file descriptor). The sg_request
> objects are not freed until the owning file descriptor is
> closed; instead these objects are re-used when multiple
> commands are sent to the same file descriptor.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 8 ++++----
>   include/uapi/scsi/sg.h | 4 ++--
>   2 files changed, 6 insertions(+), 6 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
