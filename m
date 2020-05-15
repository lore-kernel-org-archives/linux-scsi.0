Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E869EC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB235206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 06:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgEOGuW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 02:50:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:36500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgEOGuW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 02:50:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4BDBCAF10;
        Fri, 15 May 2020 06:50:23 +0000 (UTC)
Subject: Re: [PATCH v6 15/15] qla2xxx: Fix endianness annotations in source
 files
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-16-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <77c33a4e-c67c-1978-8b72-ceca58d4309d@suse.de>
Date:   Fri, 15 May 2020 08:50:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-16-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/20 11:35 PM, Bart Van Assche wrote:
> Fix all endianness complaints reported by sparse (C=2) without affecting
> the behavior of the code on little endian CPUs.
> 
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c   |  3 +-
>   drivers/scsi/qla2xxx/qla_bsg.c    |  4 +-
>   drivers/scsi/qla2xxx/qla_dbg.c    | 87 +++++++++++++++--------------
>   drivers/scsi/qla2xxx/qla_init.c   | 59 ++++++++++----------
>   drivers/scsi/qla2xxx/qla_iocb.c   | 71 ++++++++++++-----------
>   drivers/scsi/qla2xxx/qla_isr.c    | 93 +++++++++++++++----------------
>   drivers/scsi/qla2xxx/qla_mbx.c    | 37 ++++++------
>   drivers/scsi/qla2xxx/qla_mr.c     |  9 ++-
>   drivers/scsi/qla2xxx/qla_nvme.c   |  8 +--
>   drivers/scsi/qla2xxx/qla_nx.c     | 89 ++++++++++++++---------------
>   drivers/scsi/qla2xxx/qla_os.c     | 27 ++++-----
>   drivers/scsi/qla2xxx/qla_sup.c    | 69 ++++++++++++-----------
>   drivers/scsi/qla2xxx/qla_target.c | 86 ++++++++++++++--------------
>   drivers/scsi/qla2xxx/qla_tmpl.c   |  4 +-
>   14 files changed, 328 insertions(+), 318 deletions(-)
> 

All looks good, but:

> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index f05a4fa2b9d7..b91ec1c3a3ae 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -922,9 +922,9 @@ qla27xx_firmware_info(struct scsi_qla_host *vha,
>   	tmp->firmware_version[0] = vha->hw->fw_major_version;
>   	tmp->firmware_version[1] = vha->hw->fw_minor_version;
>   	tmp->firmware_version[2] = vha->hw->fw_subminor_version;
> -	tmp->firmware_version[3] = cpu_to_le32(
> +	tmp->firmware_version[3] = (__force u32)cpu_to_le32(
>   		vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
> -	tmp->firmware_version[4] = cpu_to_le32(
> +	tmp->firmware_version[4] = (__force u32)cpu_to_le32(
>   	  vha->hw->fw_attributes_ext[1] << 16 | vha->hw->fw_attributes_ext[0]);
>   }
>   
> 
Why do you need (__force u32) here?
It should be a 32bit array, and cpu_to_le32() trivially returns 32bits.
What's there to force?

Otherwise:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
