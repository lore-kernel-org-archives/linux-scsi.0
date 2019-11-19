Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C14C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16F632245B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAc174dE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKSVBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 16:01:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33497 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726711AbfKSVBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 16:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574197296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3k76vkbxYfBS7iYecez5mNImE7w6shD/L48z6TFORCk=;
        b=LAc174dEMe9m3VwgSyDzKbu3P7IsKpeidul6hCiuWhHmux0rRmxkEjdp5DjWM8fDaWjAsG
        +wVjKP9bD34LmK6En7f24UrAu501Ht44SH2UH1Rz5vZaxPeknBeIWJ9p0oMsTSnQmqzVXy
        IijFKP7sN1QKjw7nJklOSeHp/zosUOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-L9mtVF4AOdSQufZtODqdIg-1; Tue, 19 Nov 2019 16:01:32 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 941E2800686;
        Tue, 19 Nov 2019 21:01:28 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9345E27A;
        Tue, 19 Nov 2019 21:01:23 +0000 (UTC)
Message-ID: <16ea01eb24e349da19bcad725f95b2759973e5e3.camel@redhat.com>
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter
 for SSDs
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com, sathya.prakash@broadcom.com,
        chaitra.basappa@broadcom.com,
        suganath-prabu.subramani@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        hch@lst.de, hare@suse.de, bart.vanassche@wdc.com
Date:   Tue, 19 Nov 2019 16:01:23 -0500
In-Reply-To: <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
         <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: L9mtVF4AOdSQufZtODqdIg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-19 at 12:07 -0800, Sumanesh Samanta wrote:
> =20
> +#define MAX_PER_CPU_COUNTER_ABSOLUTE_VAL (0xFFFFFFFFFFF)
> +#define PER_CPU_COUNTER_OK_VAL (MAX_PER_CPU_COUNTER_ABSOLUTE_VAL>>16)
> +#define USE_DEVICE_BUSY(sdev)=09(!(sdev)->host->hostt->use_per_cpu_devic=
e_busy \
> +=09=09=09=09|| !blk_queue_nonrot((sdev)->request_queue))
> +
> +

I think this macro, which looks at a couple of different flags, one of
which is keyed off a property of the device, rather than the driver,
needs to be further refined.  Also, QUEUE_FLAG_NONROT can be changed by
sysfs, this might cause problems later.

-Ewan

