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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F28C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CD661090
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhDOLMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 07:12:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhDOLML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 07:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618485108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bfSCf9i2INh0qWOhyFljOt+xsy4huxA9mX4Hpj5LeQ8=;
        b=NB9rx/5qXI9MLvSfMFlYjZz3BaI1rEdIaoocvriiZw3hdFS1/d5f2wNeb4hcC5Auz9wBh/
        6mGly4TX35/oZSq1E/9R9F1ixYkNrPZb/q5pbf0uqHAfcyUTHb7qDLBfetyA225w6A5fOW
        6VseXCseqpB1yphQWegsasNqyOrDViA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-WLPWDbyGN4mTHetVr-Fr7A-1; Thu, 15 Apr 2021 07:11:44 -0400
X-MC-Unique: WLPWDbyGN4mTHetVr-Fr7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F2F410054F6;
        Thu, 15 Apr 2021 11:11:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD3DE5C290;
        Thu, 15 Apr 2021 11:11:42 +0000 (UTC)
Subject: Re: [PATCH v2 08/24] mpi3mr: add support of event handling part-3
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-9-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <34be0912-25ca-796d-6c1a-031a4c7faf99@redhat.com>
Date:   Thu, 15 Apr 2021 13:11:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-9-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_SAS_BROADCAST_PRIMITIVE
> MPI3_EVENT_CABLE_MGMT
> MPI3_EVENT_ENERGY_PACK_CHANGE
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c |  3 +++
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 37 +++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index d9ac045428e8..a5c9a0f7cb8e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2745,8 +2745,11 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
>  	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
>  
>  	retval = mpi3mr_issue_event_notification(mrioc);
>  	if (retval) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 40b46eadcd32..cd30e26a2225 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1497,6 +1497,36 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
>  
>  }
>  
> +/**
> + * mpi3mr_energypackchg_evt_th - Energy pack change evt tophalf
> + * @mrioc: Adapter instance reference
> + * @event_reply: Event data
> + *
> + * Identifies the new shutdown timeout value and update.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventNotificationReply_t *event_reply)
> +{
> +	Mpi3EventDataEnergyPackChange_t *evtdata =
> +	    (Mpi3EventDataEnergyPackChange_t *)event_reply->EventData;
> +	u16 shutdown_timeout = le16_to_cpu(evtdata->ShutdownTimeout);
> +
> +	if (shutdown_timeout <= 0) {
> +		ioc_warn(mrioc,
> +		    "%s :Invalid Shutdown Timeout received = %d\n",
> +		    __func__, shutdown_timeout);
> +		return;
> +	}
> +
> +	ioc_info(mrioc,
> +	    "%s :Previous Shutdown Timeout Value = %d New Shutdown Timeout Value = %d\n",
> +	    __func__, mrioc->facts.shutdown_timeout, shutdown_timeout);
> +	mrioc->facts.shutdown_timeout = shutdown_timeout;
> +}
> +
> +
>  /**
>   * mpi3mr_os_handle_events - Firmware event handler
>   * @mrioc: Adapter instance reference
> @@ -1560,9 +1590,16 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
>  		process_evt_bh = 1;
>  		break;
>  	}
> +	case MPI3_EVENT_ENERGY_PACK_CHANGE:
> +	{
> +		mpi3mr_energypackchg_evt_th(mrioc, event_reply);
> +		break;
> +	}
>  	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
>  	case MPI3_EVENT_SAS_DISCOVERY:
> +	case MPI3_EVENT_CABLE_MGMT:
>  	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> +	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
>  	case MPI3_EVENT_PCIE_ENUMERATION:
>  		break;
>  	default:
> 
Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>


