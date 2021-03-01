Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68DEC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77EA760234
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhCAHBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:01:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:49268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232187AbhCAHBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:01:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D0103AAC5;
        Mon,  1 Mar 2021 06:59:53 +0000 (UTC)
Subject: Re: [PATCH 11/24] mpi3mr: print ioc info for debugging
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-12-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a784e6a1-622c-dfe3-d490-fcfa01b73526@suse.de>
Date:   Mon, 1 Mar 2021 07:59:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-12-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 63 +++++++++++++++++++++++++++++++++
>   1 file changed, 63 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 10ff287e78db..aad0a2bd06b9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2540,6 +2540,68 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
>   	return retval;
>   }
>   
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
> +	ioc_info(mrioc, "Protocol=(");
> +
> +	if (mrioc->facts.protocol_flags &
> +	    MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
> +		pr_cont("Initiator");
> +		i++;
> +	}
> +
> +	if (mrioc->facts.protocol_flags &
> +	    MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET) {
> +		pr_cont("%sTarget", i ? "," : "");
> +		i++;
> +	}
> +
> +	if (mrioc->facts.protocol_flags &
> +	    MPI3_IOCFACTS_PROTOCOL_NVME) {
> +		pr_cont("%sNVMe attachment", i ? "," : "");
> +		i++;
> +	}
> +	pr_cont("), ");
> +	pr_cont("Capabilities=(");
> +
> +	if (mrioc->facts.ioc_capabilities &
> +	    MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE)
> +		pr_cont("RAID");
> +
> +	pr_cont(")\n");
> +}
>  
Yikes. Don't.

pr_cont() has the habit to be broken up into individual lines per call 
if the system has to print out lots of messages.
I would seriously advocate having just one pr_XX() call per line, and 
use conditional statements to construct the arguments.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
