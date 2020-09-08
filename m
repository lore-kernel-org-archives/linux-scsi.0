Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64F3C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 14:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84235229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 14:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fo+A47xP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgIHOyw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 10:54:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729114AbgIHOYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 10:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599575059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIq/H7MU4yjMR3Dxb1c5M85cjyHgWOfijzmJ6gh8S4M=;
        b=fo+A47xPhiW96JZbwqFxp/Yo4Q4qOQH9ya8gox+KLB8eW0c61QRitn+kP4UAOZxNE+NICz
        jHUwj+FCNAyrZPxYer+VPiVb+Fglw7tCKGDD310ze/PnjINQ2FTo5jZkFYo34az9Zc7hm9
        v3raxZJwkk0El2F3RpIJWU2ik6WLP20=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-TMYZs0eANJKxOHhgLQbokg-1; Tue, 08 Sep 2020 10:21:59 -0400
X-MC-Unique: TMYZs0eANJKxOHhgLQbokg-1
Received: by mail-ej1-f69.google.com with SMTP id d8so4749588ejt.14
        for <linux-scsi@vger.kernel.org>; Tue, 08 Sep 2020 07:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIq/H7MU4yjMR3Dxb1c5M85cjyHgWOfijzmJ6gh8S4M=;
        b=pnsls6eej7x0dDTjpcUKggOAnQlWKs+OIuYmAO2ysi7xfQMtD3NdzVk4Tkrr5OotA+
         0iL4oJTgilacFNKsYBazT/QwnGEWPOG9Wxjk3yFqfVHznxosJcpsqrQe/D61mj1GEFd6
         WdQ1ulkCRJruaMeQSkL3HX1x/vSm61rRiX5aXtIGRtvIRMsOWpEW47mNKG/tJGywni8N
         TJfH/U8/zLLvmh1Vu/qX35zisYud/J2/s+BLRRz9bQpMLoC0WYDjYyTRYn32Ls0I2a+e
         vrv6yqheCgzeFLJlF5BW1REDAEewKFApTILFiXYZphAiy84n+GCZ8q2ZO/xLU04ckSQz
         jOIA==
X-Gm-Message-State: AOAM531X9c+826NzaFnmq9scQFfBk5lu8fSFu+t4KET5/9UVJnBxNHRt
        OZhE+U1HFft+k7YtXwDA6pRiavwO8mxzgXhLe/gTB3hyINCuEHHDWwdURphYVICMZ9Uuq2mkPV3
        n7X7xndWfcrNIIrJIh36rAw==
X-Received: by 2002:a17:906:facb:: with SMTP id lu11mr27438267ejb.249.1599574918086;
        Tue, 08 Sep 2020 07:21:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcrrxhjakvShyUktbSgcQRcpXgRjHqw8S3hbu9iZfrSPWQtWOzrRv0FR0qtNZ9apnBfLejsA==
X-Received: by 2002:a17:906:facb:: with SMTP id lu11mr27438244ejb.249.1599574917844;
        Tue, 08 Sep 2020 07:21:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5f70:b94c:ca5f:28f2? ([2001:b07:6468:f312:5f70:b94c:ca5f:28f2])
        by smtp.gmail.com with ESMTPSA id i15sm10063285edf.82.2020.09.08.07.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:21:57 -0700 (PDT)
Subject: Re: [PATCH] Rescan the entire target on transport reset when LUN is 0
To:     Matej Genci <matej.genci@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Felipe Franciosi <felipe@nutanix.com>
References: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <200ad446-1242-9555-96b6-4fa94ee27ec7@redhat.com>
Date:   Tue, 8 Sep 2020 16:22:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/08/20 14:21, Matej Genci wrote:
> VirtIO 1.0 spec says
>     The removed and rescan events ... when sent for LUN 0, they MAY
>     apply to the entire target so the driver can ask the initiator
>     to rescan the target to detect this.
> 
> This change introduces the behaviour described above by scanning the
> entire scsi target when LUN is set to 0. This is both a functional and a
> performance fix. It aligns the driver with the spec and allows control
> planes to hotplug targets with large numbers of LUNs without having to
> request a RESCAN for each one of them.
> 
> Signed-off-by: Matej Genci <matej@nutanix.com>
> Suggested-by: Felipe Franciosi <felipe@nutanix.com>
> ---
>  drivers/scsi/virtio_scsi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index bfec84aacd90..a4b9bc7b4b4a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -284,7 +284,12 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
>  
>  	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
>  	case VIRTIO_SCSI_EVT_RESET_RESCAN:
> -		scsi_add_device(shost, 0, target, lun);
> +		if (lun == 0) {
> +			scsi_scan_target(&shost->shost_gendev, 0, target,
> +					 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
> +		} else {
> +			scsi_add_device(shost, 0, target, lun);
> +		}
>  		break;
>  	case VIRTIO_SCSI_EVT_RESET_REMOVED:
>  		sdev = scsi_device_lookup(shost, 0, target, lun);
> 


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

