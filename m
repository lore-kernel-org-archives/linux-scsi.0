Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19C7C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 12:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8260220746
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 12:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJtRQI00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgCMMD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 08:03:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726395AbgCMMD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 08:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584101035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wgzgm6JaYoAr0MU4gciCuR9N8C/x7pq06UHotJC9GRU=;
        b=YJtRQI00KYhgmXpYAxXKyJJjLSNm0lj7pxKDfDznUoxXfGU+ra/HkqjYxKqMQxACuwOIJ/
        LKQ1SG9xleNCCWpD65v94FYiFdAPWUHDYlzNJUSV33MOzSKtn/R0vE/H1lqyT4JGFq0/JK
        WYrDvkvTtupe0KQW8j1py2MW8WMU57U=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-oNuZwdMuMUqP3CxMhS92TA-1; Fri, 13 Mar 2020 08:03:54 -0400
X-MC-Unique: oNuZwdMuMUqP3CxMhS92TA-1
Received: by mail-qt1-f200.google.com with SMTP id o10so7266893qtk.22
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 05:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wgzgm6JaYoAr0MU4gciCuR9N8C/x7pq06UHotJC9GRU=;
        b=C+PYvY5LmFOJgTeGvBCjjfFMIMQkrM92s1AHq30iH7fyJkB80TbV7KtOhn3/RoSo3t
         pVfb8MlnLIFrXHuOWkKldCgtJJoA3L5B7Erx5/l52o5weU1AytUO4NhSALW35xpd9NVq
         bJVe6YA0hyWeSrxD+kDhBqEadUQ1y+6wN6cUtERU54iPFPMuiBd8jLW4vYiOesjEDSF/
         KtG0zPvcfriUHJZTXwIY11aa5vINPzg0uuJ72FhUDtyBdN/ynHBa2A1OMMaAr+otuMLE
         Xj7sL2chOne95H4rfDNs15Hn1IvhSNX36SFzmPcmsw79zxa1BeLvAJbctOsivx+jke6U
         WkbQ==
X-Gm-Message-State: ANhLgQ1xDqeiKuw7wZISA/gxn+mWKQPRbXm+jOoSoQ8WO2iDSeyMMFkB
        Fkhw4Q+GzyUEZ6v/HQqOUNDLY3D8BnGF4cwlygaLkoHNWDNincQBykWVjb0yhlOsuBBkbIJrUSA
        Yw/f53JawB6hcCHOS0aVZqw==
X-Received: by 2002:aed:39c9:: with SMTP id m67mr12270906qte.107.1584101033483;
        Fri, 13 Mar 2020 05:03:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs/DBDwC5cntaanGb9aci0ZKe1Sf1EGSdz6ouYqr9dr86FztDr+JZDt7vE51dqahU80oz+lQw==
X-Received: by 2002:aed:39c9:: with SMTP id m67mr12270854qte.107.1584101033011;
        Fri, 13 Mar 2020 05:03:53 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:2941:4bf6:8ce7:6ce9])
        by smtp.gmail.com with ESMTPSA id 65sm29594606qtf.95.2020.03.13.05.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Mar 2020 05:03:52 -0700 (PDT)
Message-ID: <eaa1e2c0669185f304bde246bfa44894e7d93b6f.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
From:   Laurence Oberman <loberman@redhat.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        emilne@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Date:   Fri, 13 Mar 2020 08:03:50 -0400
In-Reply-To: <20200313085001.3781-1-njavali@marvell.com>
References: <20200313085001.3781-1-njavali@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-03-13 at 01:50 -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> I/Os could be passed down while the device FC SCSI device is being
> deleted.
> This would result in unnecessary delay of I/O and driver messages
> (when
> extended logging is set).
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> index b520a98..7a94e11 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -864,7 +864,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>  		goto qc24_fail_command;
>  	}
>  
> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport-
> >deleted) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>  			atomic_read(&base_vha->loop_state) ==
> LOOP_DEAD) {
>  			ql_dbg(ql_dbg_io, vha, 0x3005,
> @@ -946,7 +946,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>  		goto qc24_fail_command;
>  	}
>  
> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport-
> >deleted) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>  			atomic_read(&base_vha->loop_state) ==
> LOOP_DEAD) {
>  			ql_dbg(ql_dbg_io, vha, 0x3077,

Tested-by:   Laurence Oberman <loberman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>

Built and tested in Red Hat CEE lab with fault injection.

