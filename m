Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F08C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 15:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiFBPNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiFBPNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 11:13:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768EEA471
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C6aEX7w2uDjTyvMi+Bfx1mcxy/tfbvj5vifEVtTNfjI=; b=tC4XhBwLwGDcKZ1o5axFhdBlnj
        v3EDR9cZbIBL5YxwlRwNbSmOJPzMAmn4vPV7k3n21RS9Np22ZuyHiRxjQjT5iekaAzXY/m+dmV5Tu
        Jnf6PP/xnYA5G74QDywRB3z3NtxpMwsaxWiI9rMTrRf8P/zj1UyxUIBax382oHc/6bW2m3RIDMNoC
        QjTaz75d7N53uQY6AHdLg2ANAxpi9tSanzccFNnQX3zZlX76NOJwqIsdQnhJSVMBg05nuPTwVIR2b
        vDTfzPFNqrAN9MsJrJc+4I1wz2oG6HXR2lttPWzbJL/yIJG6wQ6fN6SjftkQor7ReFC2U3JdT5reB
        4BV/fNjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwmVO-003fGx-LM; Thu, 02 Jun 2022 15:12:58 +0000
Date:   Thu, 2 Jun 2022 08:12:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_lib: allow the ALUA transitioning state time to
 complete
Message-ID: <YpjTek7u+7+zFXzM@infradead.org>
References: <CAHZQxyKMcCaquQ9n8pJ9tNb3HRZ2e14iXXojYS3C4=dB6NpUKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHZQxyKMcCaquQ9n8pJ9tNb3HRZ2e14iXXojYS3C4=dB6NpUKQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 02, 2022 at 08:10:28AM -0700, Brian Bunker wrote:
>  static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
> -                                     struct request_queue *q)
> +                                     struct request_queue *q,
> unsigned long msecs)
>  {
>         /* A new command will be prepared and issued. */
> -       scsi_mq_requeue_cmd(cmd);
> +       scsi_mq_requeue_cmd(cmd, msecs);

q is unused.  But I think it is better if we just kill this pointless
wrapper anyway.

> +       case ACTION_DELAYED_REPREP:
> +               scsi_io_completion_reprep(cmd, q, ALUA_TRANSITION_REPREP_DELAY);

This is using spaces where it should use tabs.

