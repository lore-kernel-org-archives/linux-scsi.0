From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 22:25:43 +0800
Message-ID: <CACVXFVMdUVfXNoC0FDhmaQtxehCBgG3xnTx-PJ3BmoQaT1LsoQ@mail.gmail.com>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
	<1415552224-31145-3-git-send-email-ming.lei@canonical.com>
	<54609667.8030702@redhat.com>
	<20141110133930.GA3115@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKJOZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 09:25:46 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1Xnpua-0007Lk-FC
	for linux-scsi@vger.kernel.org; Mon, 10 Nov 2014 14:25:44 +0000
Received: by mail-oi0-f46.google.com with SMTP id g201so5411813oib.19
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 06:25:43 -0800 (PST)
In-Reply-To: <20141110133930.GA3115@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Mon, Nov 10, 2014 at 9:39 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Nov 10, 2014 at 11:41:43AM +0100, Paolo Bonzini wrote:
>> FWIW, instead of force_blk_mq, it would be fine for me to make
>> virtio-scsi use a single queue if not using blk-mq.
>
> I agree with that.

For virtio-scsi, we can do that because only single vq is running at
the same time for previous multi-vq support.

> I'd rather move all of SCSI over after a fairly short
> period instead of special cases like this, mostly out of fear of a horrible
> transition we had to the new EH model 10 years ago.

It depends on how long the transition period is, and other drivers
with multi hwq support might be in the same situation with virtio-scsi. If
the period is a bit long, it would be painful for these drivers to support
both blk-mq and non-mq.

Also with force_blk_mq on virtio-scsi, people can test scsi-mq with
default setting, then it should be helpful to collect more test reports, :-)

But I don't have strong desire for force_blk_mq if you think it isn't good.

Thanks,
Ming Lei
