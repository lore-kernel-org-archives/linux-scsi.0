Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F31C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 17:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiESRGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 13:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242350AbiESRF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 13:05:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDBD6245BB
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 10:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652979955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VejTqPbbw2sBzaVF5LFnYav5QK+tQClpv6Uf7G8FlBI=;
        b=UQeCC0q9M+ydhxuAi9UQvmjH58eXkYc6ka/1oErllo5RCXYKDTx57Hvqq5LpJw8NzL0GBN
        e/chTqgwAQ8on9JCQT17KLa5BOh8+HTdAzUL/EhMpihUgNzE6C4phvIwX3qVZhg0ZuOXYG
        qNMTegKpKtIZ3WlXO5spQ37baUdokVo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-HFcDIjjTO7ahTwN_LACWHQ-1; Thu, 19 May 2022 13:05:53 -0400
X-MC-Unique: HFcDIjjTO7ahTwN_LACWHQ-1
Received: by mail-lj1-f197.google.com with SMTP id f10-20020a2e9e8a000000b00250925fec6aso1287069ljk.20
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 10:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VejTqPbbw2sBzaVF5LFnYav5QK+tQClpv6Uf7G8FlBI=;
        b=e/km/yyCtoCfHiC9CdXlrBGXhDWukIbFi36IW5pjkEzarU2nc5RXbJueI1StV06oT8
         PlBUZbqlLelY30wejXqVBRgOuSQWyHlz+jPr1vdBoBl8Dcjiw1/F+zCyAoGEDMqEq/Gf
         n8vogH4iw41oxjC4ShUAdeZaguBJF4GqyC/0UFXpl+0Ym+PfelGmZy6W+go5em4ur5K4
         j5cwiczphFNhn1cpUHEL5omN4IOkbscuL+garh6i9pOOUsH83az9rXA+lFUH+Hp7d+nY
         4krQxiH9Yz7EnTaqKOb9PWbShw3BLZkWC3xd97NQLwILIYVKOd0KVhZWv4WQ5tVhAigZ
         WjYA==
X-Gm-Message-State: AOAM532OywaRmWWysvtwAigZnUpcPgBTQBx72EdUBg+Y+k1YnXDoPTPH
        EYoPWTyY25kz0HzdFT7LFzr6S6wQ8dNM76v9chjqH5wjdMsMabHWoGnhgmKwbe1HsVV6tonpSX2
        r/psRQcSwN/5QZimD6FbEng6eRL3muQWCsf7l2g==
X-Received: by 2002:a05:6512:ba6:b0:477:cc66:229a with SMTP id b38-20020a0565120ba600b00477cc66229amr1412035lfv.455.1652979952189;
        Thu, 19 May 2022 10:05:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPeGiNy/MoFNUhrwdJkLH1f0iICtk5Wghk79Yh6KvvHfssiNHgRS2UPS8wCthGCxMyYULeOcjqrpMPNvsB8YY=
X-Received: by 2002:a05:6512:ba6:b0:477:cc66:229a with SMTP id
 b38-20020a0565120ba600b00477cc66229amr1412024lfv.455.1652979952000; Thu, 19
 May 2022 10:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220512111236.109851-1-hare@suse.de> <20220512111236.109851-6-hare@suse.de>
In-Reply-To: <20220512111236.109851-6-hare@suse.de>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 19 May 2022 13:05:40 -0400
Message-ID: <CAGtn9rkeUY0RwHSjEX3wuXvos-FUveqN9M1FeX-_1tRzLmS0Vw@mail.gmail.com>
Subject: Re: [PATCH 05/20] mptfc: open-code mptfc_block_error_handler() for
 bus reset
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This change removes the debug log messages that mptfc_block_error_handler()
would have generated, and also doesn't do the same thing, at all, for each rport
due to the differences in the logic between fc_block_rport() and
fc_remote_port_chkready()
and waiting for ioc->active == 0.

Perhaps this is desirable and intentional, if so, could you explain
this in the commit message?

-Ewan

On Thu, May 12, 2022 at 7:13 AM Hannes Reinecke <hare@suse.de> wrote:
>
> When calling bus_reset we have potentially several ports to be
> reset, so this patch open-codes the existing mptfc_block_error_handler()
> to wait for all ports attached to this bus.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  drivers/message/fusion/mptfc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index ea8fc32dacfa..4a621380a4eb 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -262,12 +262,23 @@ static int
>  mptfc_bus_reset(struct scsi_cmnd *SCpnt)
>  {
>         struct Scsi_Host *shost = SCpnt->device->host;
> -       struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
>         MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
> +       int channel = SCpnt->device->channel;
> +       struct mptfc_rport_info *ri;
>         int rtn;
>
> -       rtn = mptfc_block_error_handler(rport);
> -       if (rtn == SUCCESS) {
> +       list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
> +               if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
> +                       VirtTarget *vtarget = ri->starget->hostdata;
> +
> +                       if (!vtarget || vtarget->channel != channel)
> +                               continue;
> +                       rtn = fc_block_rport(ri->rport);
> +                       if (rtn != 0)
> +                               break;
> +               }
> +       }
> +       if (rtn == 0) {
>                 dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
>                         "%s.%d: %d:%llu, executing recovery.\n", __func__,
>                         hd->ioc->name, shost->host_no,
> --
> 2.29.2
>

