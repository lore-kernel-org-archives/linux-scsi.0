Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67172EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjGLKY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGLKYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:24:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED066AD
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689157451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16LsduwYFZpz+6uAILPKz1Rz7ytcW9Aohn733XoPS64=;
        b=hil4hFL5X8hOj0uw/kKBhNKMmSHPeofpRcBJQpsAs98EasDrdhoaLRRNoimkitY33Ma6mO
        Ldm5zGsCrxWvMIW8FjIaANBV2OBtFq2HICfTI9JyQraFCic8FtY8Y6glJCTMvZFSObpWA6
        wmWFwYAGzx1MP4CxOb0yNBVqfDoQhfw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-1ZyfEseVPYCG9uaRju4aKQ-1; Wed, 12 Jul 2023 06:24:10 -0400
X-MC-Unique: 1ZyfEseVPYCG9uaRju4aKQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7659924cf20so661481185a.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689157449; x=1691749449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16LsduwYFZpz+6uAILPKz1Rz7ytcW9Aohn733XoPS64=;
        b=BXhes1MkgGFdhO5OqKzMp7N/LFd8Xq4IRi2vjWRX0BJZRUJ/wn/7KIIFno2tRJyNGf
         3wQr3EXubCSryfMy1u4Elh3EZMmIcob1koP0m+OyJ0rDFYec8kNVyswNBD0jKwmrmi8s
         NGgz5xeep/+pF4JfcsvHqPqlEC6kz2jD8w1vqci08LUbymC66cM3aZS3CmeffaiXrm0V
         n8O5Kf61xLgozLpBYJ0x6CEvIPEQTofdPpviSAtryymflZv2yV++qhVzI06joWUc6my6
         mA5IC7wvJhaXC3/LseXiSiMGStjqh3+0BtPHM8TtwYgWFNpw+KCESGf7rPLiT5XYxTU7
         jp8Q==
X-Gm-Message-State: ABy/qLa4KQajBFyMP/gJtdW42Yr/YfpHtQrd1wGami0owIj0zKG3xT95
        5u+tEOvFXj+5CIj+3K8IJb2uT+NKZvxOQkqiO/4EWDF5SpikD084P4E/Rr9HAItdwuW/2LZc6lG
        9ZJRpWMbNyNalU5vkZDUL+A==
X-Received: by 2002:a05:620a:4548:b0:75b:23a1:8e3a with SMTP id u8-20020a05620a454800b0075b23a18e3amr22098179qkp.11.1689157449680;
        Wed, 12 Jul 2023 03:24:09 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEfqOsduTbhdiSYs6Y5PlmTPSCDqhCfSDijs7C3XZvcuWANMc6PF+7tyGF9W8eaGON9HkUJ7A==
X-Received: by 2002:a05:620a:4548:b0:75b:23a1:8e3a with SMTP id u8-20020a05620a454800b0075b23a18e3amr22098161qkp.11.1689157449453;
        Wed, 12 Jul 2023 03:24:09 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-6.retail.telecomitalia.it. [82.53.134.6])
        by smtp.gmail.com with ESMTPSA id p13-20020ae9f30d000000b007675bef6b0dsm2012163qkg.118.2023.07.12.03.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:24:08 -0700 (PDT)
Date:   Wed, 12 Jul 2023 12:24:04 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>,
        Thomas Huth <thuth@redhat.com>, qemu-stable@nongnu.org,
        Mark Kanda <mark.kanda@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
Message-ID: <jkzogg62ewin2oa7px6gakhjwny3zyeftivoiaiavbbmwcgraz@5nnhucfswyn7>
References: <20230705071523.15496-1-sgarzare@redhat.com>
 <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
 <1406de7f-106f-9b88-1ce9-f0aa1c034561@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1406de7f-106f-9b88-1ce9-f0aa1c034561@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 10:35:48AM +0200, Paolo Bonzini wrote:
>On 7/11/23 19:06, Stefano Garzarella wrote:
>>CCing `./scripts/get_maintainer.pl -f drivers/scsi/virtio_scsi.c`,
>>since I found a few things in the virtio-scsi driver...
>>
>>FYI we have seen that Linux has problems with a QEMU patch for the
>>virtio-scsi device (details at the bottom of this email in the revert
>>commit message and BZ).
>>
>>
>>This is what I found when I looked at the Linux code:
>>
>>In scsi_report_sense() in linux/drivers/scsi/scsi_error.c linux calls
>>scsi_report_lun_change() that set `sdev_target->expecting_lun_change =
>>1` when we receive a UNIT ATTENTION with REPORT LUNS CHANGED
>>(sshdr->asc == 0x3f && sshdr->ascq == 0x0e).
>>
>>When `sdev_target->expecting_lun_change = 1` is set and we call
>>scsi_check_sense(), for example to check the next UNIT ATTENTION, it
>>will return NEEDS_RETRY, that I think will cause the issues we are
>>seeing.
>>
>>`sdev_target->expecting_lun_change` is reset only in
>>scsi_decide_disposition() when `REPORT_LUNS` command returns with
>>SAM_STAT_GOOD.
>>That command is issued in scsi_report_lun_scan() called by
>>__scsi_scan_target(), called for example by scsi_scan_target(),
>>scsi_scan_host(), etc.
>>
>>So, checking QEMU, we send VIRTIO_SCSI_EVT_RESET_RESCAN during hotplug
>>and VIRTIO_SCSI_EVT_RESET_REMOVED during hotunplug. In both cases now we
>>send also the UNIT ATTENTION.
>>
>>In the virtio-scsi driver, when we receive VIRTIO_SCSI_EVT_RESET_RESCAN
>>(hotplug) we call scsi_scan_target() or scsi_add_device(). Both of them
>>will call __scsi_scan_target() at some points, sending `REPORT_LUNS`
>>command to the device. This does not happen for
>>VIRTIO_SCSI_EVT_RESET_REMOVED (hotunplug). Indeed if I remove the
>>UNIT ATTENTION from the hotunplug in QEMU, everything works well.
>>
>>So, I tried to add a scan also for VIRTIO_SCSI_EVT_RESET_REMOVED:
>
>The point of having the event queue is to avoid expensive scans of the 
>entire host, so I don't think this is the right thing to do.

I see. I'll follow your advice for QEMU changes ;-)

>
>On the Linux side, one change we might do is to remove the printk for 

Do you mean the "LUN assignments on this target have changed.
The Linux SCSI layer does not automatically remap LUN assignments."?

>adapters that do process hotplug/hotunplug, using a new flag in 
>scsi_host_template.  There are several callers of scsi_add_device() and 
>scsi_remove_device() in adapter code, so at least these should not 
>issue the printk:

I guess it makes sense since that message could be confusing in this
case. I'll try to send a patch for that.

>
>drivers/scsi/aacraid/commsup.c
>drivers/scsi/arcmsr/arcmsr_hba.c
>drivers/scsi/esas2r/esas2r_main.c
>drivers/scsi/hpsa.c
>drivers/scsi/ipr.c
>drivers/scsi/megaraid/megaraid_sas_base.c
>drivers/scsi/mvumi.c
>drivers/scsi/pmcraid.c
>drivers/scsi/smartpqi/smartpqi_init.c
>drivers/scsi/virtio_scsi.c
>drivers/scsi/vmw_pvscsi.c
>drivers/scsi/xen-scsifront.c
>

Thanks,
Stefano

