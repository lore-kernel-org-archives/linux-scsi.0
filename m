Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F65C25B06
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344798AbiHITmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345166AbiHITlI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:41:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C29E61A06E
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 12:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660074065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d+ZfsqCeyahB2OkgQ61BdcNCID4fV3MLBarpodAaqgE=;
        b=fw3fJpjJ7pogIpQqpIZh8jM94tIQ9oYiCaIUqxn3tS0grpuXmHg7SsNkd/uL3/ZYFf5cWr
        ahUUsjKtztMoYvcHWButQYicQd5IlLR/4K+Sezs4hAIoYWzbZvkCLXbCOjKd+DBgzicdtv
        1pjYy6UivdBdHqMd0zy5iZGvJXfsvWI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-mz55U1rqMZmzpWuQvEFMQg-1; Tue, 09 Aug 2022 15:41:04 -0400
X-MC-Unique: mz55U1rqMZmzpWuQvEFMQg-1
Received: by mail-ed1-f69.google.com with SMTP id z3-20020a056402274300b0043d4da3b4b5so7760260edd.12
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 12:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=d+ZfsqCeyahB2OkgQ61BdcNCID4fV3MLBarpodAaqgE=;
        b=79OQECPHAODLDs6o9rErECqZ8f1hsgH5HU0sk0kd6l3VbrdBsM0L8O9ZyQh3TDoWxx
         lywESSF6n9ai9QIaObB0rO2zcXs8xRfCaY0/Jnq/8P3mbU7Nsrc9N+bHLpraUvxktMum
         GCulwB0SrIlWJEYDX8QwDszc2x/qnLh4rGC/LpyQCamQDWaJOL2CNNWN0Wo8BETjrFsh
         gr+7ga3n7atIWzZ3Ir8Sdt2pYy2MwcU/efcQVushB4jpHxlrgye74RAJgmjp3FXYhSsO
         VhrgG8Ohfg+O6BpecNPlN5dF8gJm88iYbFBYik2C5+cWN9ikqDwHVxvC/Sfzv4mbo6rl
         N/ig==
X-Gm-Message-State: ACgBeo0QCDV1fJDLT5OlVfRzQ5U4F/XDsNkOrX9jp6+cM2VXJrCg1gKm
        /PGDkDaYnAHUOIXBkBO+b70mW9yRDULWgfG+ZPQVxCK1t+3OCjeKDCXsQcLLnYfOMsRe44f3Jsh
        9CdVp6WFtDuG73Ytbp9ySqg==
X-Received: by 2002:a17:906:7950:b0:730:f098:86ce with SMTP id l16-20020a170906795000b00730f09886cemr14863316ejo.390.1660074063353;
        Tue, 09 Aug 2022 12:41:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Roi0BYM9UDfsBAP1eqBmSBjJ7bDEAOv27wgFqi0lvzeYq+uUKo0r7W3WbC9y60ljoCDsM3w==
X-Received: by 2002:a17:906:7950:b0:730:f098:86ce with SMTP id l16-20020a170906795000b00730f09886cemr14863299ejo.390.1660074063166;
        Tue, 09 Aug 2022 12:41:03 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id sb1-20020a170906edc100b0072f1d8e7301sm1460055ejb.66.2022.08.09.12.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 12:41:02 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:40:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 04/10] scsi: virtio_scsi: Drop DID_TARGET_FAILURE use.
Message-ID: <20220809154045-mutt-send-email-mst@kernel.org>
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-5-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804034100.121125-5-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 03, 2022 at 10:40:54PM -0500, Mike Christie wrote:
> DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
> 
> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
> error and think a command was successful.
> 
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
> 
> It looks like virtio_scsi gets this when something like qemu returns
> VIRTIO_SCSI_S_TARGET_FAILURE. It looks like qemu returns that error code
> if a host OS returns it, but this shouldn't happen for linux since we
> never propagate that error to userspace.
> 
> This has us use DID_BAD_TARGET in case some other virt layer is returning
> it. In that case we will still get a hard error like before and it conveys
> something unexpected happened.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

pls merge with rest of patchset.

> ---
>  drivers/scsi/virtio_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 578c4b6d0f7d..112d8c3962b0 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -141,7 +141,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
>  		break;
>  	case VIRTIO_SCSI_S_TARGET_FAILURE:
> -		set_host_byte(sc, DID_TARGET_FAILURE);
> +		set_host_byte(sc, DID_BAD_TARGET);
>  		break;
>  	case VIRTIO_SCSI_S_NEXUS_FAILURE:
>  		set_host_byte(sc, DID_NEXUS_FAILURE);
> -- 
> 2.25.1

