Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1234C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B002076C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgFHGTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:19:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:33810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHGTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 02:19:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 105D2B291;
        Mon,  8 Jun 2020 06:19:53 +0000 (UTC)
Subject: Re: [PATCH 14/17] target: add free_session callout
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-15-git-send-email-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <61f5abdb-9733-aa7c-b712-bba709745b19@suse.de>
Date:   Mon, 8 Jun 2020 08:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-15-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> The next patches hook the iscsi target into the syfs API and has it
> export some basic info about the session.
> 
> To allow fabric drivers to export info in sysfs, they need to be able
> to free resources when all userspace refs have dropped. This patch
> adds a new session callback free_session which the fabric drivers can
> use to free their internal resources that are accessed via sysfs.
> 
> This also moves the setting of the fabric_sess_ptr to
> transport_alloc_session so drivers like iscsi that use that function
> can know that if that function returns success then they can always
> free the resources pointed at fabric_sess_ptr in the free_session
> callback.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target.c          |  7 +----
>   drivers/target/iscsi/iscsi_target_configfs.c |  9 ++++++
>   drivers/target/iscsi/iscsi_target_login.c    |  8 ++---
>   drivers/target/target_core_transport.c       | 47 +++++++++++++++++-----------
>   include/target/target_core_base.h            |  1 +
>   include/target/target_core_fabric.h          | 12 +++++--
>   6 files changed, 51 insertions(+), 33 deletions(-)
> One wonders why this isn't refcounted, but otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
