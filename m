Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D01BC3F68F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 14:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6100821744
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 14:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IurBPeGy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBDO15 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 09:27:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727230AbgBDO14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 09:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580826475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZzQBeeuGCY6hbKyjec6BogL9TDm69xs9csxAW6D8cg=;
        b=IurBPeGypqfcsiLr1qxOq191xKDq5g9f6rtybDi4rWfusEoPVRUVd8umdr/eIny2U817j2
        lvTEIlT96tsuCMAEGguvpBOwekAG8vAFHQWh32/pt5y1HUuihU8W/ZddDgUCsxE80B0WTa
        zaMAG8oTbXaYu5asz/LfndbwrXYEDNw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-LX0GxDsJNzuMD-Hfr4co5Q-1; Tue, 04 Feb 2020 09:27:51 -0500
X-MC-Unique: LX0GxDsJNzuMD-Hfr4co5Q-1
Received: by mail-qk1-f199.google.com with SMTP id f22so11912633qka.10
        for <linux-scsi@vger.kernel.org>; Tue, 04 Feb 2020 06:27:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZzQBeeuGCY6hbKyjec6BogL9TDm69xs9csxAW6D8cg=;
        b=Zi9D78Lcx2laHyKdlXBGfE3X9/MxwRyh2YfR0Chk6elAJlHNF0Ym+ix2Sd7Fj9IEWc
         fM969U5YQsha+arR4txKhVUrg90u6ol0pHlIgsQcj8EvUf9V+HkLEi71JScasylO/5Yt
         nCSR+py/9alqBKL+2WrIvHBtKFGxRJtMi75yETfTXvnW0tTYYv0xEy+BpNDGEc0o9+Q/
         7zP46Y4zE0C5ysVXP+yqGSshFQwU2u+7DhsoFRfr1fYrUcd76o6+E5a0jTsKk0cKk92j
         dQ6EOw6wOkmsNpuIZH0ixs0s/57n4mVjc5Dyxfxe7OXek0NMZuGmcHJSYWkrdWaQfB8W
         eyTQ==
X-Gm-Message-State: APjAAAUeoErUrZ/agB8GwbginfUILasku66aQoSJLGSl80KzqkFyaums
        4c8fk6jmjiNmUIpCpEw5uhGPRNdQAQXMcTn751CAOH6mNvqN/P6OvERWXK90deL6+353t+P1Myg
        od+o0IpHBA5Os8GVMAPGCcg==
X-Received: by 2002:a0c:fe0d:: with SMTP id x13mr28044768qvr.88.1580826471119;
        Tue, 04 Feb 2020 06:27:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqySblk6HEtGNKV5kd53hTFF7azJVcEZOMSiJUvx2X16soG0TCg97Bf1Ir9fltZmR/tynGD21g==
X-Received: by 2002:a0c:fe0d:: with SMTP id x13mr28044744qvr.88.1580826470772;
        Tue, 04 Feb 2020 06:27:50 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id z185sm5717726qkb.116.2020.02.04.06.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Feb 2020 06:27:49 -0800 (PST)
Message-ID: <1c8375b53508e12eff0e0cfd091253d297f85592.camel@redhat.com>
Subject: Re: [PATCH] scsi: return correct status in
 scsi_host_eh_past_deadline()
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 04 Feb 2020 09:27:47 -0500
In-Reply-To: <20200204102316.39000-1-hare@suse.de>
References: <20200204102316.39000-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-02-04 at 11:23 +0100, Hannes Reinecke wrote:
> If the user changed the 'eh_deadline' setting to 'off' while
> evaluating
> the time_before() call we will return 'true', which is inconsistent
> with the first conditional, where we return 'false' if 'eh_deadline'
> is set to 'off'.
> 
> Reported-by: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ae2fa170f6ad..ae29a9b4af56 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -113,7 +113,7 @@ static int scsi_host_eh_past_deadline(struct
> Scsi_Host *shost)
>  	    shost->eh_deadline > -1)
>  		return 0;
>  
> -	return 1;
> +	return shost->eh_deadline == -1 ? 0 : 1;
>  }
>  
>  /**

Makes sense, looks right to me.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

