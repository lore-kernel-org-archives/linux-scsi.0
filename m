Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42422EE3F08
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbjIKUv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244018AbjIKSou (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 14:44:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04DCA1A7
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694457827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oY/hnKnKQkkkqqs8PJhDmZDkMY/l26wl8twGotlorB8=;
        b=TyviLBYzYpCx2ta6FyqL6TK1VtYdeddjz8uLm+Cg0Y0Z26Iz1XedaImxedOuN3gzch7l1M
        uCAUju2GakLu139G5u6PerQcvf5q1rxsZDcTNi3ayIzk9oLVBhuZUd3qWZQAoHYaEdexHp
        Y3cabbbsj0kS1yPGpAzhvKDByQqw/cU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-s8wIyX3FOiqOahJ59loLGQ-1; Mon, 11 Sep 2023 14:43:46 -0400
X-MC-Unique: s8wIyX3FOiqOahJ59loLGQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31ad607d383so2962544f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 11:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694457824; x=1695062624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY/hnKnKQkkkqqs8PJhDmZDkMY/l26wl8twGotlorB8=;
        b=FujegEOi6QdRVL1uiOvEkV3PwAw33Jf8/ssfQjXXjajisLLCV9Vyu/2b6YF7uroPyu
         +8ML8zSdSJlWcWdsm6AnCE7/8Xg/xGlRxjdMi0T1xzoeZC6i6ZjC7m9K6v0xjzREdae2
         vDeYLgi1Ccvtel8YRiCN2FaOx51ZqZ/VC62nme2iYPmRyp8aRZoameq8rwY0x8C2bPqN
         77tQ4J6fdQfO2XymoK0jfHHNDnn5A7qRWaQ494BlvyuiNHDSA21+O8Ft6L8k25HbbnvT
         i4gH0/VfaPbXYixQ+pqjxAzHtHga6TafSM+POKXOJvXAN+itNJG/sZJo5T3RBqLmUVKX
         k+zA==
X-Gm-Message-State: AOJu0YxdyaT8DRVS88vAWTtbhvxWm5be2zBIGRjhJTr8ehGj3AVnFv+r
        zNDNEaE2NYRDXVQCfE4e9uJa2SrOQf6N/mOUvo0dCSiZjpcYJMZxWRtYUuBR38Mam/zijb0Xm1P
        vBzUEAJohpFf52Pzen5fCHgPzzbwDFUKJyLoPZg3yU59bNA==
X-Received: by 2002:a5d:6184:0:b0:314:32b6:af3 with SMTP id j4-20020a5d6184000000b0031432b60af3mr8079783wru.5.1694457824814;
        Mon, 11 Sep 2023 11:43:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1sI7WWQuRTI7I36NYR3ANmME5+7aHNibYfLmER5GJX6IFF2nxZ5HbL4sVgj2FF2hyzSNMVSjoiIe/GREH44A=
X-Received: by 2002:a5d:6184:0:b0:314:32b6:af3 with SMTP id
 j4-20020a5d6184000000b0031432b60af3mr8079772wru.5.1694457824465; Mon, 11 Sep
 2023 11:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230908211852.37576-1-justintee8345@gmail.com>
In-Reply-To: <20230908211852.37576-1-justintee8345@gmail.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 11 Sep 2023 14:43:32 -0400
Message-ID: <CAGtn9rnW15RmeH+827SeQearwDL9d-zrtrvpB0QXYOnKbNNxQg@mail.gmail.com>
Subject: Re: [PATCH 1/1] lpfc: Early return after marking final NLP_DROPPED
 flag in dev_loss_tmo
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a very reproducible test case that hit the problem this fixes.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Fri, Sep 8, 2023 at 5:08=E2=80=AFPM Justin Tee <justintee8345@gmail.com>=
 wrote:
>
> When a dev_loss_tmo event occurs, an ndlp lock is taken before checking
> nlp_flag for NLP_DROPPED.  There is an attempt to restore the ndlp lock
> when exiting the if statement, but the nlp_put kref could be the final
> decrement causing a use-after-free memory access on a released ndlp objec=
t.
>
> Instead of trying to reacquire the ndlp lock after checking nlp_flag, jus=
t
> return after calling nlp_put.
>
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index 51afb60859eb..674dd07aae72 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -203,7 +203,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>                         ndlp->nlp_flag |=3D NLP_DROPPED;
>                         spin_unlock_irqrestore(&ndlp->lock, iflags);
>                         lpfc_nlp_put(ndlp);
> -                       spin_lock_irqsave(&ndlp->lock, iflags);
> +                       return;
>                 }
>
>                 spin_unlock_irqrestore(&ndlp->lock, iflags);
> --
> 2.38.0
>

