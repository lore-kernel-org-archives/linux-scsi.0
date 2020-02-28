Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665D0C3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E69246A2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgB1JPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:15:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:49156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgB1JPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:15:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71C1FB24E;
        Fri, 28 Feb 2020 09:15:21 +0000 (UTC)
Subject: Re: [PATCH v7 29/38] sg: add 8 byte SCSI LUN to sg_scsi_id
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        Hannes Reinecke <hare@suse.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-30-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dc491539-46f9-ba4f-2d31-4fb0e34d5f9e@suse.de>
Date:   Fri, 28 Feb 2020 10:15:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-30-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> The existing ioctl(SG_GET_SCSI_ID) fills a object of type
> struct sg_scsi_id whose last field is int unused[2]. Add
> an anonymous union with u8 scsi_lun[8] sharing those last
> 8 bytes. This patch will place the current device's full
> LUN in the scsi_lun array using T10's preferred LUN
> format (i.e. an array of 8 bytes) when
> ioctl(SG_GET_SCSI_ID) is called.
> 
> Note that structure already contains a 'lun' field but that
> is a 32 bit integer. Users of this upgrade should choose
> the scsi_lun array field henceforth but existing code
> can remain as it is and will get the same 'lun' value with
> the version 3 or version 4 driver.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 6 ++++--
>   include/uapi/scsi/sg.h | 5 ++++-
>   2 files changed, 8 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
