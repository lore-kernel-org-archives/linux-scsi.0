Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD86C3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC712067C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgB1JCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:02:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:41506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgB1JCb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:02:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D512AF2B;
        Fri, 28 Feb 2020 09:02:29 +0000 (UTC)
Subject: Re: [PATCH v7 25/38] sg: replace rq array with lists
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-26-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7e909e64-7aff-fb22-d7ae-fe62cea311f3@suse.de>
Date:   Fri, 28 Feb 2020 10:02:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-26-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> Remove the fixed size array of 16 request elements per file
> descriptor and replace with the xarray added in the previous
> patch. All sg_request objects are now kept, available for
> re-use, until their owning file descriptor is closed. The
> sg_request deletions are in sg_remove_sfp_usercontext().
> Each active sg_request object has an associated block
> request and a scsi_request object but they have different
> lifetimes. The block request and the scsi_request object
> are released much earlier; their lifetime is the same as it
> was in the v3 sg driver. The lifetime of the bio is also the
> same (but is stretched in a later patch).
> 
> Collect various flags into bit maps: one for requests
> (SG_FRQ_*) and the other for file descriptors (SG_FFD_*).
> They join a per sg_device bit map (SG_FDEV_*) added in an
> earlier patch.
> 
> Prior to a new sg_request object being (re-)built, information
> that will be placed in it uses a new struct sg_comm_wr_t
> object.
> 
> Since the above changes touch almost every function and low
> level structures, this patch is big.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 1568 +++++++++++++++++++++++++++++----------------
>   1 file changed, 1008 insertions(+), 560 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
