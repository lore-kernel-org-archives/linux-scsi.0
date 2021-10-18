Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DF4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1214861283
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhJRLM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:12:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37762 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRLM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 07:12:26 -0400
Date:   Mon, 18 Oct 2021 13:10:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634555414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=deXCoMgr7+8KQRCM1PBmbBScsjhCSW4Jg7dpZpOle4M=;
        b=1PgQoqjfkRgaMeZjAUTxsYK2GIAI9oj2xkGLWcm59Uw/CvEmoTCais4AoHCn3dL4i3jtRm
        zUEchT12iA7twTp3aQyDpr/vHPsW3XFU/xjpoPtT758IH+zdQAbQoUonA8DV5Sl9LfySdi
        o7ZGF4hztJyJKWm0AxR9yRnoAboCKr//qjC07vIZtA9egQwe5vyxYjI74WwveRXdebwI4/
        eb8jjh6XulWTKfPrPlA/61QWWzbfLzdQ3ziP6wwhsGLVViM6tRnTyvpvL39vNyC1xOWQP/
        1JYyiVTdeMq1Y3dlZtg/rhVZwet2bw97KrioUDRlMQ27Y7y7HCi6q43KjX8xPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634555414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=deXCoMgr7+8KQRCM1PBmbBScsjhCSW4Jg7dpZpOle4M=;
        b=3Ku3QgWi5OX0VpCr0hpaAHPp+GzVrpcP/lFf/+umF3pRBgUa0W1AA8ZlbhgBE/3/sDH9ZZ
        oSdfmDS3slX2SFBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Message-ID: <20211018111012.ktlshq3uez4v2hmr@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
 <a6354cfb-753a-8376-b96c-f35fda9b9b8a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a6354cfb-753a-8376-b96c-f35fda9b9b8a@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-16 14:21:37 [-0700], Bart Van Assche wrote:
> On 10/15/21 08:14, Sebastian Andrzej Siewior wrote:
> > +static inline void scsi_done(struct scsi_cmnd *scmd)
> > +{
> > +	scmd->scsi_done(scmd);
> > +}
> 
> How about leaving out this function definition and open-coding it into its
> callers?

Let me reevaluate the situation with your series. I saw that you
provided a scsi_done() function.

> Thank you,
> 
> Bart.

Sebastian
