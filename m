Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9988C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A535E2076C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgFHGVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:21:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:34358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHGVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 02:21:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D0740ACAE;
        Mon,  8 Jun 2020 06:21:51 +0000 (UTC)
Subject: Re: [PATCH 17/17] target: drop sess_get_index
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-18-git-send-email-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0f369872-ebd0-9df8-49a5-c7fe15d2a4b4@suse.de>
Date:   Mon, 8 Jun 2020 08:21:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-18-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> Use the LIO session id for the scsiAttIntrPortIndex. iSCSI was
> already using this value and the other drivers used hard coded
> values of 1 or 0. The SCSI-MIB specs says:
> 
> This object represents an arbitrary integer used to uniquely
> identify a particular attached remote initiator port to a
> particular SCSI target port within a particular SCSI target device
> within a particular SCSI instance.
> 
> So the lio session sid can be used.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ---------------
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  7 -------
>   drivers/target/iscsi/iscsi_target_configfs.c |  6 ------
>   drivers/target/loopback/tcm_loop.c           |  6 ------
>   drivers/target/sbp/sbp_target.c              |  6 ------
>   drivers/target/target_core_configfs.c        |  4 ----
>   drivers/target/target_core_stat.c            |  5 +----
>   drivers/target/tcm_fc/tfc_conf.c             |  1 -
>   drivers/target/tcm_fc/tfc_sess.c             |  7 -------
>   drivers/usb/gadget/function/f_tcm.c          |  6 ------
>   drivers/vhost/scsi.c                         |  6 ------
>   drivers/xen/xen-scsiback.c                   |  6 ------
>   include/target/target_core_fabric.h          |  1 -
>   14 files changed, 1 insertion(+), 81 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
