Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE34EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 14:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjGLO21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 10:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjGLO2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 10:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A482C272E
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 07:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689172013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RxadBZ/e9+iHxmAJkMx44y3xAiAtBYZJ7/ie6q6tPng=;
        b=W3r/nmvD0H+4muI1dhNo/vIGgkPsHfAD05/Rrw91173eOfvvpUAgTyc2Idc6wWqZ1xlicE
        I8CKD5u1oiVkmEGJ41ZM7r/kLd1cYcVUj8u54HC1unVUWb2sAv2McJwB/eaHIB3CFqQiRQ
        wXN+WPjm3zLSHqaBWGZRkrgQEy+QcMs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435--aSSKoKnN7GQPS9k6E9JWQ-1; Wed, 12 Jul 2023 10:26:52 -0400
X-MC-Unique: -aSSKoKnN7GQPS9k6E9JWQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fb7ea6652bso6450801e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 07:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689172010; x=1691764010;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxadBZ/e9+iHxmAJkMx44y3xAiAtBYZJ7/ie6q6tPng=;
        b=AQ4kmi7vOdCIiC5E564Pxo6KBjiyUYeSqvtw2AxBjl+W3JelpCtf40RV2DyioB4SkL
         zx6jFfsK/kBUT3l4so9XcqhclJwmduuHXUadr/pb2bnPWwtL/NxPoYWCW2UzI2enGB7O
         ykIk1cAPDgu4Yfy/cyi4LOv2VbtRbl+76wfKYpXYRZo2mjkt/akisbXCWF5RsHOgh8BO
         ijNrlcAdTTLT0n+wKkbR8ecL24M6CJ938BH/f4Vn3BxAgAcpJHNuUTtOKTRaqRKxE1Gc
         Jpm2IprGm+fAvHYFzLENjCWxnHLhYMuoI8Khzw7AgQb4Lkkp0CmglfvzsqBLBOSjLNPS
         uCNA==
X-Gm-Message-State: ABy/qLbqrrb09D4oaxxHKdfHo737IeHrceiFIEXmFZRL7GikJoTBD5O/
        IIH2qcQtv/ky3Dt+3GQ9eyAxklwKO0F2RpjH+xzyN+DO9//ZwEbQBGuwKZYdgxWNbaO7+K6QZks
        5E+pJfTOBex0lDrJAes5GbA==
X-Received: by 2002:a05:6512:1289:b0:4fb:745e:dd01 with SMTP id u9-20020a056512128900b004fb745edd01mr19236023lfs.45.1689172010758;
        Wed, 12 Jul 2023 07:26:50 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFkNsKPYxzyCKFBFzT2Ba1WmnPb2DW9qQiaMClrU8mrzLR7F2hdclCVyqYRAUgqznT8iViyTw==
X-Received: by 2002:a05:6512:1289:b0:4fb:745e:dd01 with SMTP id u9-20020a056512128900b004fb745edd01mr19235999lfs.45.1689172010429;
        Wed, 12 Jul 2023 07:26:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id v6-20020aa7cd46000000b0051e3385a395sm2904335edw.3.2023.07.12.07.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 07:26:49 -0700 (PDT)
Message-ID: <07672031-3e89-a221-b580-40fed4bce394@redhat.com>
Date:   Wed, 12 Jul 2023 16:26:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-stable@nongnu.org,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230705071523.15496-1-sgarzare@redhat.com>
 <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
 <CAJSP0QX5bf1Gp6mnQ0620FS61n=cY6n_ca7O-cAcH7pYCV2frw@mail.gmail.com>
 <v6xzholcgdem3c2jkkuhqtmhzo4wflvkh53nohcgtjpgkh5y2e@bb7vliper2f3>
 <ZK6tRDwxgbyYfv2v@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZK6tRDwxgbyYfv2v@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/23 15:40, Christoph Hellwig wrote:
>> The problem is that the SCSI stack does not send this command, so we
>> should do it in the driver. In fact we do it for
>> VIRTIO_SCSI_EVT_RESET_RESCAN (hotplug), but not for
>> VIRTIO_SCSI_EVT_RESET_REMOVED (hotunplug).
>
> No, you should absolutely no do it in the driver.  The fact that
> virtio-scsi even tries to do some of its own LUN scanning is
> problematic and should have never happened.

I agree that it should not do it for hot-unplug.  However, for hot-plug 
the spec says that a hotplug event for LUN 0 represents the addition of 
an entire target, so why is it incorrect to start a REPORT LUNS scan if 
the host doesn't tell you the exact LUN(s) that have been added?

There is a similar case in mpi3mr/mpi3mr_os.c, though it's only scanning 
for newly added devices after a controller reset.

Paolo

