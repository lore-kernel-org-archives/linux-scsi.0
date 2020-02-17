Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924FFC35254
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 10:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 580F820679
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 10:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZSnbAFre"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgBQKKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:10:12 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41008 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgBQKKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 05:10:11 -0500
Received: by mail-oi1-f195.google.com with SMTP id i1so16143160oie.8
        for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2020 02:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YsGCSyVBPYt/3r/sbYFtdX9xctg+GdUB7WTA5vRuN8=;
        b=ZSnbAFreZ9DbTHwZeUzivOorQhB9Ohztu5cmBwyG2A5fZ1tykPiXdXAw1D45vNzaP9
         9DuGGYom+qJMkLAOz9KJGUwMdepRask4j+uBvfv3ZVx1esCY6wFOacegXVfezIUgK5jv
         S46dxw53IP0glnl4mvKysoyCwNWc80YwMXSvQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YsGCSyVBPYt/3r/sbYFtdX9xctg+GdUB7WTA5vRuN8=;
        b=XFNF9e80j7DbeSmr8V9OHrzDaLXyVE6CrRyc8ErULoP8DrRjVBB8o8n4kkJKc8ejE2
         dr23yosRBIcxXEgmRF2HQel8gJgTWU5al99zdD68QCcV0tzDDMzDye3DXZ97KXzXuCk3
         vEphawjIBLklsDURfbxM1gAqft3XGNkPmd/drqd9j545vmB6YzgFli6apswhwAys3ijm
         bbe3PYWbTRt2OL3sDjGZkSe0At7vlJzzBfMqCJeiKP94YR2CZBgSdRAgL5FxcC5CdGiL
         fPEQous3JMpsiSwBPNA2R49cXGJ7nzVnvWrNNRWHebKFiDm6JnFFF8iajmsoEFIV8Mkj
         7rUA==
X-Gm-Message-State: APjAAAWVgXlm7szoEo2ae+sJO+htZHdVQnTtZwbObHxK+LReVSHyKa0N
        xwr9TwgTul1YYm7M4bZzFPqbncY4OFj4BD6bidtOvQ==
X-Google-Smtp-Source: APXvYqxPecfjOC29bfeXXI/Vrt8ZjjF3/47gJQbdzPfu2gN6TCNYWgm+GRk9yDDI+sXLOFH2c+GZLShzBjhJKeb1DAA=
X-Received: by 2002:aca:1a10:: with SMTP id a16mr9683878oia.9.1581934211131;
 Mon, 17 Feb 2020 02:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20191202153914.84722-1-hare@suse.de> <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de> <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
 <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com> <CAL2rwxpLY1xfbiW4CZ6nWF7W8_zLWS+a+W6XC6emcVm96XetNw@mail.gmail.com>
 <ab0397bf-19a0-41b1-3bd6-a08dbdd94cdb@huawei.com>
In-Reply-To: <ab0397bf-19a0-41b1-3bd6-a08dbdd94cdb@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Mon, 17 Feb 2020 15:39:45 +0530
Message-ID: <CAL2rwxooozyNvx30Qsr+15XmuYJ4VUyXBHNz3-iXVqQZabATJQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2020 at 3:37 PM John Garry <john.garry@huawei.com> wrote:
>
> On 17/01/2020 11:18, Sumit Saxena wrote:
> >>>> or doing a performance test here.
> >>> Hi Hannes,
> >>>
>
> Hi Sumit,
>
> >>> Sorry for the delay in replying, I observed a few issues with this patchset:
> >>>
> >>> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
> >>> which IO submitter CPU is affined with. Due to this IO submission and
> >>> completion CPUs are different which causes performance drop for low
> >>> latency workloads.
> >> Hi Sumit,
> >>
> >> So the new code has:
> >>
> >> megasas_build_ldio_fusion()
> >> {
> >>
> >> cmd->request_desc->SCSIIO.MSIxIndex =
> >> blk_mq_unique_tag_to_hwq(tag);
> >>
> >> }
> >>
> >> So the value here is hw queue index from blk-mq point of view, and not
> >> megaraid_sas msix index, as you alluded to.
> > Yes John, value filled in "cmd->request_desc->SCSIIO.MSIxIndex" is HW
> > queue index.
> >
> >> So we get 80 msix, 8 are reserved for low_latency_index_start (that's
> >> how it seems to me), and we report other 72 as #hw queues = 72 to SCSI
> >> midlayer.
> >>
> >> So I think that this should be:
> >>
> >> cmd->request_desc->SCSIIO.MSIxIndex =
> >> blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;
>
> Can you possibly test performance again with this local change, or would
> you rather an updated patchset be sent?
Updated patchset is not required. I will do performance run with this
change and update.

Thanks,
Sumit
>
> > Agreed, this should return correct HW queue index.
> >>
>
>
> Thanks,
> John
