Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEA2ECE58D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 18:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0B320854
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 18:30:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="duMPaPU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387797AbfJQSaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 14:30:11 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:43797 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbfJQSaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 14:30:11 -0400
Received: by mail-vs1-f67.google.com with SMTP id b1so2251056vsr.10
        for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2019 11:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=fN8trqoI71X2Nttkb04NtlI/5fVLxViifqs/z8wZWC4=;
        b=duMPaPU8wKgwAYjqXGgY7shKApkyJXWSv4310sI67+XBdJGUoKMC0WH6LH7FZ83nV6
         ViMbCUd5Q5H3wm36cYuHnky3HbJwVsvekiIbWj7H2LZSkszL9vnpM9j7TXlYZVZsNM15
         sWIkZEsAdcSOxLHCH2DQ0ky1XakupdiI2L+eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=fN8trqoI71X2Nttkb04NtlI/5fVLxViifqs/z8wZWC4=;
        b=fefBWEUKVSw72x7ZZuVTj6Kd2N64YQ1tiNXzB26l6BosFvOLuG/gqhLVOFlTHTgzwb
         WeEw3RhY/kkh9hDyhDbcNVcKv+YwLuAfmkBZ4YzHeHepxmUhfX+MgVuhH66MnbVe6JYE
         HLp9TDMmQV6jBzKB7ICAjYq5+j8XbKGgLlsF/OWZjMKS+HR5/5ps44LIQcOgVs1wMtYO
         niaulVGlF/jA7XdjKV8wHT33HQ+1dNLN5+SNlWgLaKP41q1xgkzuLm5WkbmkHfXfJ3zX
         0ta4YqZU0uoR7M/NwMAiZpSMuxK5rzkt+tSIx3ROwhn9jRbqJ5EEy1toYddzc4LhLPFN
         FHAg==
X-Gm-Message-State: APjAAAUv1fbH4kAd/89XgMbHvOKybVsnmvTJ4knHHWeXzbFvEm1FT2VU
        f5aUxHocG8sJPA/te6YWPprs7qnEE0GvKYH4+yzV1Q==
X-Google-Smtp-Source: APXvYqyPeEVkIq+aJ7RQdMoM2j78EnSppF5pCW4No+frymDh45yP5PCKTbe1p9ch6djGEHg3XHmZ6CkskLAKYbwuQCw=
X-Received: by 2002:a67:ad0c:: with SMTP id t12mr3011580vsl.82.1571337010296;
 Thu, 17 Oct 2019 11:30:10 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191009093241.21481-1-ming.lei@redhat.com> <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
In-Reply-To: <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ+aAV5wNbUGIJ6nkm2Ot6VMXRpiQIhodcgAyzU6Wil4tFUMA==
Date:   Fri, 18 Oct 2019 00:00:07 +0530
Message-ID: <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
Subject: RE: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 10/9/19 2:32 AM, Ming Lei wrote:
> > @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev,
> struct scsi_cmnd *cmd)
> >   	if (starget->can_queue > 0)
> >   		atomic_dec(&starget->target_busy);
> >
> > -	atomic_dec(&sdev->device_busy);
> > +	if (!blk_queue_nonrot(sdev->request_queue))
> > +		atomic_dec(&sdev->device_busy);
> >   }
> >
>
> Hi Ming,
>
> Does this patch impact the meaning of the queue_depth sysfs attribute (see
> also sdev_store_queue_depth()) and also the queue depth ramp up/down
> mechanism (see also scsi_handle_queue_ramp_up())? Have you considered to
> enable/disable busy tracking per LUN depending on whether or not sdev-
> >queue_depth < shost->can_queue?
>
> The megaraid and mpt3sas drivers read sdev->device_busy directly. Is the
> current version of this patch compatible with these drivers?

We need to know per scsi device outstanding in mpt3sas and megaraid_sas
driver.
Can we get supporting API from block layer (through SML)  ? something
similar to "atomic_read(&hctx->nr_active)" which can be derived from
sdev->request_queue->hctx ?
At least for those driver which is nr_hw_queue = 1, it will be useful and we
can avoid sdev->device_busy dependency.


Kashyap
>
> Thanks,
>
> Bart.
