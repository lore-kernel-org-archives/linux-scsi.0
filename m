Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3E7C25B08
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344370AbiHITmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344603AbiHITkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47F0D1A06E
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 12:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660074044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nzfgbRqx1oA7rB0L1CmuO04Pzl/8xtUsGl9mIPWH8rg=;
        b=YXqsZ7TvQPsTPaqvvYUUMLYNR7OS/Dj3UrZ1N9p3XI2ne/mSGRqt8ledgE6gSijXlBu8if
        TdUC2maIuETTXU+9QlWXs51lUyA0C/Fp2Pv6ZCnQybKrdnN7ruj8JSz/uOQwNMLpO8Kx2B
        siWF0NPD/muqkG+sfRjDo4JtS9b45sM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-9TJloXASOMW6x2hIdCProg-1; Tue, 09 Aug 2022 15:40:42 -0400
X-MC-Unique: 9TJloXASOMW6x2hIdCProg-1
Received: by mail-ed1-f71.google.com with SMTP id z20-20020a05640235d400b0043e1e74a495so7868775edc.11
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 12:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nzfgbRqx1oA7rB0L1CmuO04Pzl/8xtUsGl9mIPWH8rg=;
        b=b4uxPPWxKCrd2+i5Jn0jRRe0xF9iusDrgEXdmFSees0zEa89YWShTR1O5n66tRkVdB
         1otfvmUjiWcSEDee/01/OTZoDCgCY+A8/SDOKr+qmxMY0Ywwk7YbhWXVYOw8SFUbHp8V
         Tj97dRPzPuiQvFisnZOn+Cl1HcFmr/aE4HzjopgQSyfOEqLoLo6c7jKyycZFjEWket/a
         qvYRlR6r0Wc2EuCzbu+LqxdhQ1h83aDlaDC/Dgu9E+r3KMdpB61BBCCwk9lHPhvaq9aF
         IUl5SMW+4NE5Qpg5QmoZ0w5AwUExj6vHSP+9mP37zSIDdpgACfCxSHJx9GJ3TgdpbnCV
         KnMQ==
X-Gm-Message-State: ACgBeo2FIXKRtZf+fa+dqkmgUSev7AMiSysMWFRK0QyN7lbDlXi6/zFL
        Dkh8lMJteP6fUIZTlX48y2bgzfaTR/u/K/fjyFNMar1TgLMaEu7mWuQkNwNFo2xc+nITVmHjYNn
        d/DqrJxLEhjvs+WIprg6C7Q==
X-Received: by 2002:a17:907:75d5:b0:730:8baf:b314 with SMTP id jl21-20020a17090775d500b007308bafb314mr17626111ejc.587.1660074041774;
        Tue, 09 Aug 2022 12:40:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4i0sPhXMDOLhsiuZ5FKwOqA5EwPNTCNZvmwuiH+w2aQ/64CF+5Ah7uhbaGJ4r5OZ6fCvdTSA==
X-Received: by 2002:a17:907:75d5:b0:730:8baf:b314 with SMTP id jl21-20020a17090775d500b007308bafb314mr17626097ejc.587.1660074041581;
        Tue, 09 Aug 2022 12:40:41 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id q35-20020a05640224a300b00440a1888e00sm4114845eda.59.2022.08.09.12.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 12:40:41 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:40:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 05/10] scsi: virtio_scsi: Drop DID_NEXUS_FAILURE use.
Message-ID: <20220809154011-mutt-send-email-mst@kernel.org>
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804034100.121125-6-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 03, 2022 at 10:40:55PM -0500, Mike Christie wrote:
> DID_NEXUS_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
> 
> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
> error and think a command was successful.
> 
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
> 
> It looks like virtio_scsi gets this when something like qemu returns
> VIRTIO_SCSI_S_NEXUS_FAILURE. It looks like qemu returns that error code
> if host OS returns DID_NEXUS_FAILURE (qemu's internal
> SCSI_HOST_RESERVATION_ERROR maps to DID_NEXUS_FAILURE). This shouldn't
> happen for linux since we don't propagate that error code to userspace.
> 
> This has us convert VIRTIO_SCSI_S_NEXUS_FAILURE to a
> SAM_STAT_RESERVATION_CONFLICT in case some other virt layer is returning
> it. In that case we will still get the reservation confict failure we
> expect.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

If everyone drops it, so should virtio

so

Acked-by: Michael S. Tsirkin <mst@redhat.com>

but pls merge with rest of the patchset.

> ---
>  drivers/scsi/virtio_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 112d8c3962b0..00cf6743db8c 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -144,7 +144,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		set_host_byte(sc, DID_BAD_TARGET);
>  		break;
>  	case VIRTIO_SCSI_S_NEXUS_FAILURE:
> -		set_host_byte(sc, DID_NEXUS_FAILURE);
> +		set_status_byte(sc, SAM_STAT_RESERVATION_CONFLICT);
>  		break;
>  	default:
>  		scmd_printk(KERN_WARNING, sc, "Unknown response %d",
> -- 
> 2.25.1

