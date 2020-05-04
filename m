Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950F0C47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 18:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 731632087E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 18:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMssfDr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgEDSAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 14:00:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731030AbgEDSAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 14:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588615236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ekvQ0W9+R32qHNFUdIvIRrUfmozi/8YjzI602DYnNY=;
        b=fMssfDr/mtB7h6mvx3MDZ5nLgRJi4SAQODKSwnyHZigsXgDh1QAoiw0NXRdXjYR821UJFE
        vHsihl1gHBQwPmf3hMY2ywYD9ZnnBtYdB3w5DdE2WKIoaWRhWK++D8s+Yc9AxUQoo04TjB
        sqsyV6Ve3zCjjjKOEzRgsZT87ariCoo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-yCyZRAtbPyiVILsb5m4vdA-1; Mon, 04 May 2020 14:00:34 -0400
X-MC-Unique: yCyZRAtbPyiVILsb5m4vdA-1
Received: by mail-qk1-f200.google.com with SMTP id i10so59715qkm.23
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2020 11:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ekvQ0W9+R32qHNFUdIvIRrUfmozi/8YjzI602DYnNY=;
        b=C0lkDS8CGN567JHEhhAlZ2xJNLw9QqzV8TCKKdJxff+tkegUXe94lYsUtRbP6DjYNb
         tZuZID1AQa9Q78hTht36n2QTRSrg+cl7mjeuJSQGZ7OooqsprQ41NIMHP36CfrZ6Xu4l
         ql5d26zu5qwwARGaIQLG+KulaqlyGLso//WxGhfVycX3aS546uMzt1CzxtIsztGZ6qF8
         rfcHuV/b4hW3DYnXC3ZyfVHaiaPUdAY+htMbBIwo3NDo2E37iGpIhOrweED92lICfDsx
         7kqDQXgaZydInvTKH9iTAeONRoPkyqlLQaR4OB4hGfmsAjNqAv+Ag7se3YDTmp5bSg+H
         OoZg==
X-Gm-Message-State: AGi0PuZ9mSmu3qwgKJV59HWJIx0ZejKgcqpaDsNfTaZpKPiPvzAGx31f
        Nj9VJkIVIX9ztTgXY81h5RWYeL65mk870maQJIyr9njy9PPnq/JDq+9GxII80PH6TLoKgQYGo6M
        mAIsAoJqEzInJG8bD0lniZQ==
X-Received: by 2002:a37:7ac2:: with SMTP id v185mr420388qkc.386.1588615234063;
        Mon, 04 May 2020 11:00:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypKnPZqN9nanSFOcjxGdXzeO8UeX54jnQMDIyTHF0H8gUXHreTJ/6vLH9+V/+wddz6hIGwk4aA==
X-Received: by 2002:a37:7ac2:: with SMTP id v185mr420356qkc.386.1588615233715;
        Mon, 04 May 2020 11:00:33 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id d4sm11755419qtc.48.2020.05.04.11.00.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 11:00:33 -0700 (PDT)
Message-ID: <f42a7ef6701574ebe4805a494650c56a10a9bdae.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx: Do not log message when reading port
 speed via sysfs
From:   Laurence Oberman <loberman@redhat.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com,
        himanshu.madhani@oracle.com
Date:   Mon, 04 May 2020 14:00:32 -0400
In-Reply-To: <20200504175416.15417-1-emilne@redhat.com>
References: <20200504175416.15417-1-emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-05-04 at 13:54 -0400, Ewan D. Milne wrote:
> Calling ql_log() inside qla2x00_port_speed_show() is causing messages
> to be output to the console for no particularly good reason.  The
> sysfs
> read routine should just return the information to userspace.  The
> only
> reason to log a message is when the port speed actually changes, and
> this already occurs elsewhere.
> 
> Cc: <stable@vger.kernel.org> # v5.1+
> Fixes: 4910b524ac9 ("scsi: qla2xxx: Add support for setting port
> speed")
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 3325596..2c9e5ac 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1850,9 +1850,6 @@ qla2x00_port_speed_show(struct device *dev,
> struct device_attribute *attr,
>  		return -EINVAL;
>  	}
>  
> -	ql_log(ql_log_info, vha, 0x70d6,
> -	    "port speed:%d\n", ha->link_data_rate);
> -
>  	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha-
> >link_data_rate]);
>  }
>  

Looks good for me, and fixes an issue we dealt with last week. 
In other words confusing log noise for customers.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

