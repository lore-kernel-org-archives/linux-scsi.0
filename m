Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B41C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2431B6145A
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhENLrH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 07:47:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:36522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhENLrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 07:47:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 12E46AF75;
        Fri, 14 May 2021 11:45:55 +0000 (UTC)
Subject: Re: [PATCH v5 11/24] mpi3mr: print ioc info for debugging
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-12-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <67d01612-58ca-f0a5-2245-76440d7344c9@suse.de>
Date:   Fri, 14 May 2021 13:45:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210513083608.2243297-12-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 10:35 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 95 +++++++++++++++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c |  1 +
>  2 files changed, 96 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 3d834615c77b..023b9f6f374b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2534,6 +2534,99 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
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
> +	int i = 0, bytes_wrote = 0;
> +	char personality[16];
> +	char protocol[50] = {0};
> +	char capabilities[100] = {0};
> +	bool is_string_nonempty = false;
> +	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
> +
> +	switch (mrioc->facts.personality) {
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA:
> +		strncpy(personality, "Enhanced HBA", sizeof(personality));
> +		break;
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR:
> +		strncpy(personality, "RAID", sizeof(personality));
> +		break;
> +	default:
> +		strncpy(personality, "Unknown", sizeof(personality));
> +		break;
> +	}
> +
> +	ioc_info(mrioc, "Running in %s Personality", personality);
> +
> +	ioc_info(mrioc, "FW version(%d.%d.%d.%d.%d.%d)\n",
> +	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
> +	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
> +
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_protocols[i].protocol) {
> +			if (is_string_nonempty &&
> +			    (bytes_wrote < sizeof(protocol)))
> +				bytes_wrote += snprintf(protocol + bytes_wrote,
> +				    (sizeof(protocol) - bytes_wrote), ",");
> +
> +			if (bytes_wrote < sizeof(protocol))
> +				bytes_wrote += snprintf(protocol + bytes_wrote,
> +				    (sizeof(protocol) - bytes_wrote), "%s",
> +				    mpi3mr_protocols[i].name);
> +			is_string_nonempty = true;
> +		}
> +	}
> +
> +	bytes_wrote = 0;
> +	is_string_nonempty = false;
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_capabilities[i].capability) {
> +			if (is_string_nonempty &&
> +			    (bytes_wrote < sizeof(capabilities)))
> +				bytes_wrote += snprintf(capabilities + bytes_wrote,
> +				    (sizeof(capabilities) - bytes_wrote), ",");
> +
> +			if (bytes_wrote < sizeof(capabilities))
> +				bytes_wrote += snprintf(capabilities + bytes_wrote,
> +				    (sizeof(capabilities) - bytes_wrote), "%s",
> +				    mpi3mr_capabilities[i].name);
> +			is_string_nonempty = true;
> +		}
> +	}
> +
> +	ioc_info(mrioc, "Protocol=(%s), Capabilities=(%s)\n",
> +	    protocol, capabilities);
> +}
> +
>  /**
>   * mpi3mr_cleanup_resources - Free PCI resources
>   * @mrioc: Adapter instance reference
> @@ -2792,6 +2885,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
>  		}
>  	}
>  
> +	mpi3mr_print_ioc_info(mrioc);
> +
>  	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
>  	if (retval) {
>  		ioc_err(mrioc,
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 5f66926935aa..d7b6f9417aa8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -337,6 +337,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
>   * mpi3mr_flush_scmd - Flush individual SCSI command
>   * @rq: Block request
>   * @data: Adapter instance reference
> + * @reserved: N/A. Currently not used
>   *
>   * Return the SCSI command to the upper layers if it is in LLD
>   * scope.
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
