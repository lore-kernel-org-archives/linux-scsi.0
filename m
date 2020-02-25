Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917DDC35E01
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6337C20CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="nxL1iM21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgBYTeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:34:44 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:45564 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728051AbgBYTeo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 14:34:44 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9802241209;
        Tue, 25 Feb 2020 19:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received;
         s=mta-01; t=1582659280; x=1584473681; bh=xt1uuFLSiofYv8ysp+TgqL
        KBkNBwreQltJEUTRm37m0=; b=nxL1iM21hj+smw5OBkCt/Za8H1Ug+Hkv3aOxY2
        zm7BMyjoIqjfBqAFOWKPiqV6IOf66EXS6h7Cz+5Yi7Mv7gXSZMwfuKGcEn2Gg/iu
        8TJJhojazh5VZ7UK9vNHCRXaIxR8gTx1VRgqmHR9D9cKvwFQCA43PVQ9sU8Ez76F
        iXBP0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G8KouRJOHsPr; Tue, 25 Feb 2020 22:34:40 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BD96341254;
        Tue, 25 Feb 2020 22:34:39 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-01.corp.yadro.com
 (172.17.10.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 25
 Feb 2020 22:34:39 +0300
Date:   Tue, 25 Feb 2020 22:34:39 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 5/5] qla2xxx: Fix the endianness annotations for the
 port attribute max_frame_size member
Message-ID: <20200225193439.xookulf54arbakxq@SPB-NB-133.local>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200220043441.20504-6-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-01.corp.yadro.com (172.17.10.101)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 08:34:41PM -0800, Bart Van Assche wrote:
> Make sure that sparse doesn't complain about the statements that load or
> store the port attribute max_frame_size member. The port attribute data
> structures represent FC protocol data and hence use big endian format.
> This patch only changes the meaning of two ql_dbg() statements.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  4 ++--
>  drivers/scsi/qla2xxx/qla_gs.c  | 14 ++++++--------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 

Hi Bart,

As I said in reply to previous version, IMO, all four-byte binary fields
and bitmasks in RPA request should be made __be32 rather than only one.
Probably that may go into a patch series where each field in the
structure is fixed patch-by-patch or one patch that fixes all fields at
once.

According to Table 402 – Port Attribute Values in FC-GS-7 and RPA
request attributes in the structure above, that includes:
        Supported Speed
        Current Port Speed
        Maximum Frame Size
        Port Type
        Supported Classes of Service
        Port State
        Number of Discovered Ports
        Port Identifier

But the patch itself looks good,
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Regards,
Roman

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index cec0b5082927..c5c3a532f299 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2741,7 +2741,7 @@ struct ct_fdmiv2_port_attr {
>  		uint8_t fc4_types[32];
>  		uint32_t sup_speed;
>  		uint32_t cur_speed;
> -		uint32_t max_frame_size;
> +		__be32	max_frame_size;
>  		uint8_t os_dev_name[32];
>  		uint8_t host_name[256];
>  		uint8_t node_name[WWN_SIZE];
> @@ -2772,7 +2772,7 @@ struct ct_fdmi_port_attr {
>  		uint8_t fc4_types[32];
>  		uint32_t sup_speed;
>  		uint32_t cur_speed;
> -		uint32_t max_frame_size;
> +		__be32	max_frame_size;
>  		uint8_t os_dev_name[32];
>  		uint8_t host_name[256];
>  	} a;
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index aaa4a5bbf2ff..594b366db0ef 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1848,14 +1848,13 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
>  	eiter = entries + size;
>  	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
>  	eiter->len = cpu_to_be16(4 + 4);
> -	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
> +	eiter->a.max_frame_size = cpu_to_be32(IS_FWI2_CAPABLE(ha) ?
>  	    le16_to_cpu(icb24->frame_payload_size) :
> -	    le16_to_cpu(ha->init_cb->frame_payload_size);
> -	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
> +	    le16_to_cpu(ha->init_cb->frame_payload_size));
>  	size += 4 + 4;
>  
>  	ql_dbg(ql_dbg_disc, vha, 0x203c,
> -	    "Max_Frame_Size=%x.\n", eiter->a.max_frame_size);
> +	       "Max_Frame_Size=%x.\n", be32_to_cpu(eiter->a.max_frame_size));
>  
>  	/* OS device name. */
>  	eiter = entries + size;
> @@ -2419,14 +2418,13 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
>  	eiter = entries + size;
>  	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
>  	eiter->len = cpu_to_be16(4 + 4);
> -	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
> +	eiter->a.max_frame_size = cpu_to_be32(IS_FWI2_CAPABLE(ha) ?
>  	    le16_to_cpu(icb24->frame_payload_size) :
> -	    le16_to_cpu(ha->init_cb->frame_payload_size);
> -	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
> +	    le16_to_cpu(ha->init_cb->frame_payload_size));
>  	size += 4 + 4;
>  
>  	ql_dbg(ql_dbg_disc, vha, 0x20bc,
> -	    "Max_Frame_Size = %x.\n", eiter->a.max_frame_size);
> +	       "Max_Frame_Size = %x.\n", be32_to_cpu(eiter->a.max_frame_size));
>  
>  	/* OS device name. */
>  	eiter = entries + size;
