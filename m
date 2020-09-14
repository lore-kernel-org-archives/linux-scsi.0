Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F7FC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 13:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76381208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 13:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EuATfV30"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgINNpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 09:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgINN2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 09:28:34 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A609BC06174A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 06:28:26 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id z1so4012343ooj.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 06:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z/nsXJEmv3bjxBMPqniSWwu3bLXK58gqV1v3b66wVa4=;
        b=EuATfV30/zA+G0vXptfb5bmcyyNEawvUFZlXBXDK72UGq7/kzhzeVhHGH2Q5CM4i6O
         ERQ6VL5d0R77LY/jgf4CUijp42i9jE1JldZEezJ8jAF8wA/hCoadtYmrHeo0CPfLIckG
         m68tLOafYKebLIMHBcCd+n6tS28p5IyC3DCL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z/nsXJEmv3bjxBMPqniSWwu3bLXK58gqV1v3b66wVa4=;
        b=D8/s83Tab2mQbnOoDA+sXITtpD2SzG3rD9O6O1OE6fmSBJSbGc5G9Sfx15l/lKs+dD
         5FmQlnuQOBUg+6HKzyhQlzqUocCEPasnZ79IC30jvjta3peKLt8MpzpJzzpdKIIFjmZ2
         lqjrVg8dt8hSCfsLrnNn7Nlwb/Grk/+1/0KFUnwSi4rXnH4d7CDkUcp9BBErBAo0Uqn/
         nbHbazs8VkpS4ZBRc7nKttKuKDR8RHQz2Qvlvq/FB/w/gG0owSBMgAk5KfvJfm1xRQ70
         ak83gqRlO49xYOwfhl29YPGcFz7+CHJVFC+eQ7v5QZNX4oLkTqTI75bpJDtBc8Jq5gc2
         uuVQ==
X-Gm-Message-State: AOAM530a3mHFLykVNmGyPNxyLQ9WL5dV1TgYufwJ5ZwJXVKmqGwOG/RR
        vOFCswLt41Tp692rCwV32e8NRIpwRAe0EXbv3fNNHQ==
X-Google-Smtp-Source: ABdhPJyyX9bsr6mnog8xW7Nq99oHpqIVJERU1/ROrmYSpo2DQpXLQBzsP71Rn/ralrReSmkhBP0qLs0FV80q/5x8VDs=
X-Received: by 2002:a4a:978a:: with SMTP id w10mr10293848ooi.69.1600090101255;
 Mon, 14 Sep 2020 06:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200911180057.14633-1-thenzl@redhat.com>
In-Reply-To: <20200911180057.14633-1-thenzl@redhat.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 14 Sep 2020 18:58:10 +0530
Message-ID: <CAK=zhgov_HrtqHpYaWzMkQXUFTfTWoEVmfBV2+YrsWw3o4u9Xw@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: a small correction in _base_process_reply_queue
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 11, 2020 at 11:31 PM Tomas Henzl <thenzl@redhat.com> wrote:
>
> There is no need to compute module a simple comparision
> is good enough.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: sreekanth reddy <sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index a67749c8f4ab..ea51fd04e3f1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1627,7 +1627,7 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
>                  * So that FW can find enough entries to post the Reply
>                  * Descriptors in the reply descriptor post queue.
>                  */
> -               if (!base_mod64(completed_cmds, ioc->thresh_hold)) {
> +               if (completed_cmds >= ioc->thresh_hold) {
>                         if (ioc->combined_reply_queue) {
>                                 writel(reply_q->reply_post_host_index |
>                                                 ((msix_index  & 7) <<
> --
> 2.25.4
>
