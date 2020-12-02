Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808C0C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2737C20679
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgLBKAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:00:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388247AbgLBKAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 05:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606903149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z8AQZAgl1UdsrqF/icNEETV75RA2NfX+ehHLJ3NCqqw=;
        b=Kq1r/uonnBSAH1jbjHcbExoxR/xzT6kcikXuBbGStrieklNcW663SwHtu0CbVW+ITr31LW
        5tR4+aebYPshiDLXcRF6vc81cfHHEXCs/JPU+xnF+OLGFFR1MeTbPg0lyHzMB6L+R31AdO
        JDx4EGOEpymUFiZ1GG9WMwWcmQkWbBA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-rZXBYnZSPXexmq6MtnsnNQ-1; Wed, 02 Dec 2020 04:59:07 -0500
X-MC-Unique: rZXBYnZSPXexmq6MtnsnNQ-1
Received: by mail-wm1-f71.google.com with SMTP id o203so2654778wmo.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 01:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z8AQZAgl1UdsrqF/icNEETV75RA2NfX+ehHLJ3NCqqw=;
        b=LI32zBcBe7TK31+eL4uTmeaabp2pVl1W+GrrgO5O7VAfZXdPwS6z94OrFo2UeOHKuk
         PdFAVnARowtTZHUcmV2IuimdE0OHIq8xroOqWI2YlAUcxKIKxjsDTpBbRmHbt1G7uvej
         Fgicsi9g+AiESc7IFPgphBmBeyq7qjvgsj8TqG23TlQ8Ga7YTY6/ABPOfzL8fxeXd1fs
         +o1hqmoKclcjIuL4M6g8ooxFFdiEnn7jnrud2K41Z9BDcVBXHRrCBvk+pgvtqQKSdKej
         ViaFuVvnoSICuYdDJ+10DlL7Y4S5K8KhABhO2UKEPk37UQNUxqqnSqHRgOpJCRJ3Uop9
         na8g==
X-Gm-Message-State: AOAM530NwYvswGHRi6QMs+lHAVayw/e6pWAsITyDX2izzlczpiVDXHF+
        RacmOHHCU2CNWKTWGYApO10gZ8aEwtLZVQA3ZRl1S/t3i1qgIajvsIZtIQN6Wftq1E71iS537gO
        MMTvJu/56kvNJXclAB2y4JQ==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr2177307wmg.145.1606903146601;
        Wed, 02 Dec 2020 01:59:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlyOpsA5OFT6XaiG7rTTB0hoZWxmFeJV5oLJmK4wvaw9/zUbY1bAYBODC22GlGVObe124jzQ==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr2177290wmg.145.1606903146488;
        Wed, 02 Dec 2020 01:59:06 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id z11sm1418191wmc.39.2020.12.02.01.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:59:05 -0800 (PST)
Date:   Wed, 2 Dec 2020 04:59:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] qemu vhost scsi: add VHOST_SET_VRING_ENABLE support
Message-ID: <20201202045807-mutt-send-email-mst@kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 12, 2020 at 05:19:00PM -0600, Mike Christie wrote:
> diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
> index 7523218..98dd919 100644
> --- a/linux-headers/linux/vhost.h
> +++ b/linux-headers/linux/vhost.h
> @@ -70,6 +70,7 @@
>  #define VHOST_VRING_BIG_ENDIAN 1
>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)

OK so first we need the kernel patches, then update the header, then
we can apply the qemu patch.

>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */
> -- 
> 1.8.3.1

