Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977D3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C84861153
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhDOLzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 07:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOLze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 07:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618487711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apb5U7c5NOmuOWkHy+xtTykjKvRwafzTSbAc6qFqLVM=;
        b=c240Y0mZAYMgg/1SEUgQ9EsbFllhejKwXUr9v5ycBSkNfTeoOIPR/33H1iwWkPW//E1Fui
        a7EvJatr6tAD8wgxwutt3YGR141Ck51c0pgqsoJaq1TltAJ6ZPqvffRMTzhCEkTG7FCyiq
        iyK4lCac8C8YYqLnq6Oo3ieDLhI8qmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-kqKfQ2OzO0CkFFmAn6YgIg-1; Thu, 15 Apr 2021 07:55:09 -0400
X-MC-Unique: kqKfQ2OzO0CkFFmAn6YgIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE0DF107ACE4;
        Thu, 15 Apr 2021 11:55:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15A8E5C1B4;
        Thu, 15 Apr 2021 11:55:07 +0000 (UTC)
Subject: Re: [PATCH v2 11/24] mpi3mr: print ioc info for debugging
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-12-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <7e449ff0-a66b-18a3-ba05-88e273a62a8f@redhat.com>
Date:   Thu, 15 Apr 2021 13:55:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-12-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 80 +++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index d47031d05322..c3882fef2d2a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2550,6 +2550,85 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
>  	return retval;
>  }
>  
> +/* Protocol type to name mapper structure*/
> +static const struct {
> +	u8 protocol;
> +	char *name;
> +} mpi3mr_protocols[] = {
> +	{ MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR, "Initiator" },
> +	{ MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET, "Target" },
> +	{ MPI3_IOCFACTS_PROTOCOL_NVME, "NVMe attachment" },
> +};
> +
> +/* Capability to name mapper structure*/
> +static const struct {
> +	u32 capability;
> +	char *name;
> +} mpi3mr_capabilities[] = {
> +	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
> +};
> +
> +/**
> + * mpi3mr_print_ioc_info - Display controller information
> + * @mrioc: Adapter instance reference
> + *
> + * Display controller personalit, capability, supported
> + * protocols etc.
> + *
> + * Return: Nothing
> + */
> +static void
> +mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
> +{
> +	int i = 0;
> +	char personality[16];
> +	char protocol[50] = {0};
> +	char capabilities[100] = {0};
> +	bool is_string_nonempty = false;
> +	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
> +
> +	switch (mrioc->facts.personality) {
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA:
> +		strcpy(personality, "Enhanced HBA");
> +		break;
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR:
> +		strcpy(personality, "RAID");
> +		break;
> +	default:
> +		strcpy(personality, "Unknown");
> +		break;
> +	}
> +
> +	ioc_info(mrioc, "Running in %s Personality", personality);
> +
> +	ioc_info(mrioc, "FW Version(%d.%d.%d.%d.%d.%d)\n",
> +	fwver->gen_major, fwver->gen_minor, fwver->ph_major,
> +	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
> +
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_protocols[i].protocol) {
> +			if (is_string_nonempty)
> +				strcat(protocol, ",");
> +			strcat(protocol, mpi3mr_protocols[i].name);
> +			is_string_nonempty = true;
> +		}
> +	}
> +
> +	is_string_nonempty = false;
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_capabilities[i].capability) {
> +			if (is_string_nonempty)
> +				strcat(capabilities, ",");
> +			strcat(capabilities, mpi3mr_capabilities[i].name);
> +			is_string_nonempty = true;
> +		}
> +	}
> +
> +	ioc_info(mrioc, "Protocol=(%s), Capabilities=(%s)\n",
> +	    protocol, capabilities);
> +}
>  
>  /**
>   * mpi3mr_cleanup_resources - Free PCI resources
> @@ -2808,6 +2887,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
>  		}
>  
>  	}
> +	mpi3mr_print_ioc_info(mrioc);
>  
>  	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
>  	if (retval) {
> 

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

