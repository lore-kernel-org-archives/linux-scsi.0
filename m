Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1470BEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjGLKPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjGLKPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735CE1997
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689156865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D/4n1T4Di9dqAOFGS+inlBrET7BRHhbAxPcO28uG01Q=;
        b=UmWzTEyASGjtIzhrfTfbHj+i5seW5XyKX8vCV75SBl/mgP0+oiZ2Ju4+I8buGlxKZ3wmE1
        ZSuj9zGmHKOcyCTJIoEbAg0txEZBcqKuVFaq+p7hzDAWIgHuqET/FW1vNURYqX9IoJLnl2
        nY+i+78bm3AT4YpXzxGnFaTb1yVzkJ0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-WXtvIkN-PR-OPVyOsmxiAQ-1; Wed, 12 Jul 2023 06:14:21 -0400
X-MC-Unique: WXtvIkN-PR-OPVyOsmxiAQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-635a4267cf5so64464716d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689156860; x=1691748860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/4n1T4Di9dqAOFGS+inlBrET7BRHhbAxPcO28uG01Q=;
        b=kGKCTIVZ5MG8vrrjmMc68EzyChDpR8767OEwVzMUXEvrwNeJJD4iRUgnNLNMiQYIcm
         LBJz3bZA8NUTV409iPH0FjUyrT5cE2Jbj1vhVBlRhsjKhlgcnQ6TWPBn7QPY0y7Yx33j
         aqrOZcLvqKTaNoyoGpuwSKvW22WKaBYPFT3oJiDp7UvDjxHOppREGMF5RsOsBErkf19J
         Bw1eTQlL3dSO7sYO6CwY6EkUdmtVZq5ui28PJj2QqDMaJi8tqak5P0XeVx1MAbuqTTSE
         WGKjqWnF0M4ncuiY8fzhys+0tmXzU61avXtu+wOSsmeSvZkCx6LmwfbiI8VnRR+VkBBX
         K4zQ==
X-Gm-Message-State: ABy/qLbvE8FM84GnJh3kLzvHaz6TyjQP+E5g4bUS8LveHnUb3LWaduCL
        IMpNXYdAoeGLdENOOV6+a0NFa+IpppEE84mqLDVDCPExoMU7svpqCTZQFrTyfgOpbY9MeiiZHjW
        kAycN6z+j7dhgbv0k274VqA==
X-Received: by 2002:ac8:5b0b:0:b0:403:9f48:7ce1 with SMTP id m11-20020ac85b0b000000b004039f487ce1mr17970970qtw.53.1689156860693;
        Wed, 12 Jul 2023 03:14:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHlxbb8j7LshAiGKZNfsSGwJ4zTSF2mOzrqRvKk5LzC+D2tYuiNcSmvHeC6WLXDnQaz2YIMjw==
X-Received: by 2002:ac8:5b0b:0:b0:403:9f48:7ce1 with SMTP id m11-20020ac85b0b000000b004039f487ce1mr17970952qtw.53.1689156860434;
        Wed, 12 Jul 2023 03:14:20 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-6.retail.telecomitalia.it. [82.53.134.6])
        by smtp.gmail.com with ESMTPSA id c14-20020ac81e8e000000b0040331f93ee0sm2123644qtm.77.2023.07.12.03.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:14:20 -0700 (PDT)
Date:   Wed, 12 Jul 2023 12:14:15 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-stable@nongnu.org,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
Message-ID: <bnitgwesvbjdkbrvnykltherzddi3zvms3ckd5yk3w4whdplu3@tv43e42wjl55>
References: <20230705071523.15496-1-sgarzare@redhat.com>
 <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
 <765f14c5-a938-ebd9-6383-4fe3d5c812ca@oracle.com>
 <10a3d00f-a3a2-91d1-0f94-9758cdc4b969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <10a3d00f-a3a2-91d1-0f94-9758cdc4b969@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 10:06:56AM +0200, Paolo Bonzini wrote:
>On 7/11/23 22:21, Mike Christie wrote:
>>What was the issue you are seeing?
>>
>>Was it something like you get the UA. We retry then on one of the
>>retries the sense is not setup correctly, so the scsi error handler
>>runs? That fails and the device goes offline?
>>
>>If you turn on scsi debugging you would see:
>>
>>
>>[  335.445922] sd 0:0:0:0: [sda] tag#15 Add. Sense: Reported luns data has changed
>>[  335.445922] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445925] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445929] sd 0:0:0:0: [sda] tag#17 Done: FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>>[  335.445932] sd 0:0:0:0: [sda] tag#17 CDB: Write(10) 2a 00 00 db 4f c0 00 00 20 00
>>[  335.445934] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445936] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445938] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445940] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445942] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.445945] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>[  335.451447] scsi host0: scsi_eh_0: waking up 0/2/2
>>[  335.451453] scsi host0: Total of 2 commands on 1 devices require eh work
>>[  335.451457] sd 0:0:0:0: [sda] tag#16 scsi_eh_0: requesting sense
>
>Does this log come from internal discussions within Oracle?
>
>>I don't know the qemu scsi code well, but I scanned the code for my co-worker
>>and my guess was commit 8cc5583abe6419e7faaebc9fbd109f34f4c850f2 had a race in it.
>>
>>How is locking done? when it is a bus level UA but there are multiple devices
>>on the bus?
>
>No locking should be necessary, the code is single threaded.  However, 
>what can happen is that two consecutive calls to 
>virtio_scsi_handle_cmd_req_prepare use the unit attention ReqOps, and 
>then the second virtio_scsi_handle_cmd_req_submit finds no unit 
>attention (see the loop in virtio_scsi_handle_cmd_vq).  That can 
>definitely explain the log above.

Yes, this seems to be the case!
Thank you both for the help!

Following Paolo's advice, I'm preparing a series for QEMU to solve the
problem!

Stefano

