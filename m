Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886DEC56201
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 06:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A9402158C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 06:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MHmEx3A0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKSGei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 01:34:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgKSGeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 01:34:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605767676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ibf0uGzRxcUkF4auB3MzFVdM7ogAHtGTXDNvmnCoM/s=;
        b=MHmEx3A0PiJJagWIyls4LcjGP+ZmjqCqgVUHqXdjhURVKwwfKkE3cvmrSQAiBioydWH43x
        24Qegod45v5mgYQDHOEU7TmGb/HD8MGazZ0+/kycOCRDExfAzf1uTnxemcEyeIvX1rldGe
        h09ma9lrCnCQqrN31kSLTbSOUO926R0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-f1zfwBIwM2CXen1vzjd1zQ-1; Thu, 19 Nov 2020 01:34:32 -0500
X-MC-Unique: f1zfwBIwM2CXen1vzjd1zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DF8164159;
        Thu, 19 Nov 2020 06:34:30 +0000 (UTC)
Received: from T590 (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E039A5C1D7;
        Thu, 19 Nov 2020 06:34:12 +0000 (UTC)
Date:   Thu, 19 Nov 2020 14:34:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     kernel test robot <lkp@intel.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, Omar Sandoval <osandov@fb.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V4 12/12] scsi: replace sdev->device_busy with sbitmap
Message-ID: <20201119063407.GB170672@T590>
References: <20201116090737.50989-13-ming.lei@redhat.com>
 <202011161944.U7XHrbsd-lkp@intel.com>
 <20201118023507.GA92339@T590>
 <36b8e652641fefca6e8f95d3bbaaf3ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36b8e652641fefca6e8f95d3bbaaf3ca@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 19, 2020 at 11:50:39AM +0530, Kashyap Desai wrote:
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > > >> drivers/scsi/megaraid/megaraid_sas_fusion.c:365:41: error: no
> member
> > named 'device_busy' in 'struct scsi_device'
> > >            sdev_busy = atomic_read(&scmd->device->device_busy);
> >
> > This new reference to sdev->device_busy is added by recent shared host
> tag
> > patch, and according to the comment, you may have planed to convert into
> > one megaraid internal counter.
> >
> >         /* TBD - if sml remove device_busy in future, driver
> >          * should track counter in internal structure.
> >          */
> >
> > So can you post one patch? And I am happy to fold it into this series.
> 
> Ming - Please find the patch for megaraid_sas driver -
> I have used helper inline function just for inter-operability with older
> kernel to support in our out of box driver.
> This way it will be easy for us to replace helper function as per kernel
> version check.
> 
> Subject: [PATCH] megaraid_sas: replace sdev_busy with local counter
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 ++
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 34 ++++++++++++++++++---
>  2 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> b/drivers/scsi/megaraid/megaraid_sas.h
> index 0f808d63580e..0c6a56b24c6e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2019,10 +2019,12 @@ union megasas_frame {
>   * struct MR_PRIV_DEVICE - sdev private hostdata
>   * @is_tm_capable: firmware managed tm_capable flag
>   * @tm_busy: TM request is in progress
> + * @sdev_priv_busy: pending command per sdev
>   */
>  struct MR_PRIV_DEVICE {
>         bool is_tm_capable;
>         bool tm_busy;
> +       atomic_t sdev_priv_busy;
>         atomic_t r1_ldio_hint;
>         u8 interface_type;
>         u8 task_abort_tmo;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index fd607287608e..e813ea0ad8b7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -220,6 +220,32 @@ megasas_clear_intr_fusion(struct megasas_instance
> *instance)
>         return 1;
>  }
> 
> +static inline void
> +megasas_sdev_busy_inc(struct scsi_cmnd *scmd)
> +{
> +       struct MR_PRIV_DEVICE *mr_device_priv_data;
> +
> +       mr_device_priv_data = scmd->device->hostdata;
> +       atomic_inc(&mr_device_priv_data->sdev_priv_busy);
> +}
> +static inline void
> +megasas_sdev_busy_dec(struct scsi_cmnd *scmd)
> +{
> +       struct MR_PRIV_DEVICE *mr_device_priv_data;
> +
> +       mr_device_priv_data = scmd->device->hostdata;
> +       atomic_dec(&mr_device_priv_data->sdev_priv_busy);
> +}
> +static inline int
> +megasas_sdev_busy_read(struct scsi_cmnd *scmd)
> +{
> +       struct MR_PRIV_DEVICE *mr_device_priv_data;
> +
> +       mr_device_priv_data = scmd->device->hostdata;
> +       return atomic_read(&mr_device_priv_data->sdev_priv_busy);
> +}
> +
> +
>  /**
>   * megasas_get_cmd_fusion -    Get a command from the free pool
>   * @instance:          Adapter soft state
> @@ -359,10 +385,7 @@ megasas_get_msix_index(struct megasas_instance
> *instance,
>  {
>         int sdev_busy;
> 
> -       /* TBD - if sml remove device_busy in future, driver
> -        * should track counter in internal structure.
> -        */
> -       sdev_busy = atomic_read(&scmd->device->device_busy);
> +       sdev_busy = megasas_sdev_busy_read(scmd);

The above is only used for MR_BALANCED_PERF_MODE, so maybe you can
skip inc/dec/read the counter for other perf mode.



Thanks, 
Ming

