Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFA1C3F2D0
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C4B246A2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgB1JQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:16:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:49714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgB1JQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:16:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89F6BAC4A;
        Fri, 28 Feb 2020 09:16:20 +0000 (UTC)
Subject: Re: [PATCH v7 31/38] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-32-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <55a02453-1a6b-d873-1eb0-e3423c4539f1@suse.de>
Date:   Fri, 28 Feb 2020 10:16:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-32-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
> are meant to be (almost) drop-in replacements for the write()/read()
> async version 3 interface. They only accept the version 3 interface.
> 
> See the webpage at: http://sg.danny.cz/sg/sg_v40.html
> specifically the table in the section titled: "13 SG interface
> support changes".
> 
> If sgv3 is a struct sg_io_hdr object, suitably configured, then
>      res = write(sg_fd, &sgv3, sizeof(sgv3));
> and
>      res = ioctl(sg_fd, SG_IOSUBMIT_V3, &sgv3);
> are equivalent. Dito for read() and ioctl(SG_IORECEIVE_V3).
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 77 +++++++++++++++++++++++++++++++++++++++++-
>   include/uapi/scsi/sg.h |  6 ++++
>   2 files changed, 82 insertions(+), 1 deletion(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
