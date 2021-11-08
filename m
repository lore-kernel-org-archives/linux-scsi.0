Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553F3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B806120A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhKHQot (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 11:44:49 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34198 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236528AbhKHQos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 11:44:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636389723;
        bh=lpuLhbP5D8y7Rh++3/m1gJ/kmzDRQihOj3d0Ea3+naw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=vGp3HXQPGECmrit0ElRfIxrq4UE5s9ccP2I5N4d1tx20bGxFJQirlcN25WzOorCX1
         c+hY1TzUrSDiD8rZK9oHTJNaB7MtpRngWZi0Yw52XwCWC8j5HeoFLrPIFwRqofowOL
         y6ommqbMLoQDxDhuGatF3WLs1OICVeJc/gIxOxHc=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8F42112804CC;
        Mon,  8 Nov 2021 11:42:03 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id u_heyEEjYIWy; Mon,  8 Nov 2021 11:42:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636389723;
        bh=lpuLhbP5D8y7Rh++3/m1gJ/kmzDRQihOj3d0Ea3+naw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=vGp3HXQPGECmrit0ElRfIxrq4UE5s9ccP2I5N4d1tx20bGxFJQirlcN25WzOorCX1
         c+hY1TzUrSDiD8rZK9oHTJNaB7MtpRngWZi0Yw52XwCWC8j5HeoFLrPIFwRqofowOL
         y6ommqbMLoQDxDhuGatF3WLs1OICVeJc/gIxOxHc=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C56881280492;
        Mon,  8 Nov 2021 11:42:02 -0500 (EST)
Message-ID: <08f0e186093b0d5067347a1376228010cb4cc7f4.camel@HansenPartnership.com>
Subject: Re: [PATCH 3/4] scsi: make sure that request queue queiesce and
 unquiesce balanced
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 08 Nov 2021 11:42:01 -0500
In-Reply-To: <20211103034305.3691555-4-ming.lei@redhat.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
         <20211103034305.3691555-4-ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-11-03 at 11:43 +0800, Ming Lei wrote:
[...]
> +void scsi_start_queue(struct scsi_device *sdev)
> +{
> +	if (cmpxchg(&sdev->queue_stopped, 1, 0))
> +		blk_mq_unquiesce_queue(sdev->request_queue);
> +}
> +
> +static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
> +{
> +	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
> +		if (nowait)
> +			blk_mq_quiesce_queue_nowait(sdev-
> >request_queue);
> +		else
> +			blk_mq_quiesce_queue(sdev->request_queue);
> +	} else {
> +		if (!nowait)
> +			blk_mq_wait_quiesce_done(sdev->request_queue);
> +	}
> +}

This looks counter intuitive.  I assume it's done so that if we call
scsi_stop_queue when the queue has already been stopped, it waits until
the queue is actually quiesced before returning so the behaviour is the
same in the !nowait case?  Some sort of comment explaining that would
be useful.

James



