Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DC7C10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBB124655
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:17:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P1K/Clw0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgCIQRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 12:17:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38363 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgCIQRO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 12:17:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id z5so145781pfn.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2020 09:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ach1ug4HnQhBRQgwelQXzdDvGo1MBpH4vwjQjnj3OV8=;
        b=P1K/Clw0j4yQjl9bANVv+1u0p8x4dC1ggm/ZPm3xPYNHOTOQ44Uv+zmjZI99zCj2mg
         6tcbOzKJxB9d7mlwqRGGmhX2jO5DVylLOKiLVbUpbLF1AbooQyNQdCzSprjC5HsGfS+s
         8uvPMIaR7HvIqL3f4pqG9pb7eyyx2kryyopsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ach1ug4HnQhBRQgwelQXzdDvGo1MBpH4vwjQjnj3OV8=;
        b=cQjAYyfHg5z/lEhHHcO6GubChNgNk6vPdKyI/HUXCVBJgkRA45itOVUU1Pe7sl0BbW
         LRMAZxOGFCZXs8+S4vRe+4WJJn83r0qZu0DTowruILNPwco5kq3lKrAC9/ExaFwkxWZI
         W8lKv1v5fo6zptiIhZNvDg7YaOMXUCHhKMVcsZBV0rzvirYKKl+/kSMXXJkwBbewDSa7
         cHVTNFN0+2jRtnik3WPFr8E9LCLMZyXZ3kwd8ibU2XhWlNURBST+92n0yhJ5uXQLsllL
         TxlaDx+x+txSInHsCnPF/HEC8AYl+VB44ml1ykM2hTSrSpJevqrvCUEiUs8Z/UROUeUL
         oKDQ==
X-Gm-Message-State: ANhLgQ3NPk7LFl6JGT3yodMRFFMacTXxDlBgLIzonC72tMedqvxHBXHR
        bqJAWuFxlmpn61lzRWKx1DS7Vg==
X-Google-Smtp-Source: ADFU+vsoPPUv1U4ocsflojRddWHb1IxRbaKL5licxEdJanMiBKUpvfzu+p0hZqzasAgtIJ+7HwJNeQ==
X-Received: by 2002:a63:f757:: with SMTP id f23mr17032725pgk.223.1583770633861;
        Mon, 09 Mar 2020 09:17:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 64sm45559100pfd.48.2020.03.09.09.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:17:13 -0700 (PDT)
Date:   Mon, 9 Mar 2020 09:17:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     john.garry@huawei.com, aacraid@microsemi.com, bvanassche@acm.org,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: aacraid: cleanup warning cast-function-type
Message-ID: <202003090917.A3B8294@keescook>
References: <9a0e6373-b4a3-0822-3b65-e3b326266832@huawei.com>
 <20200309155319.12658-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309155319.12658-1-tranmanphong@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 09, 2020 at 10:53:19PM +0700, Phong Tran wrote:
> Make the aacraid driver -Wcast-function-type clean
> Report by: https://github.com/KSPP/linux/issues/20
> 
> drivers/scsi/aacraid/aachba.c:813:23:
> warning: cast between incompatible function types from
> 'int (*)(struct scsi_cmnd *)' to 'void (*)(struct scsi_cmnd *)'
> [-Wcast-function-type]
> 
> Reviewed-by: Bart van Assche <bvanassche@acm.org>
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/scsi/aacraid/aachba.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 33dbc051bff9..ebfb42af67f5 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
>  	return 0;
>  }
>  
> +static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
> +{
> +	aac_probe_container_callback1(scsi_cmnd);
> +}
> +
>  int aac_probe_container(struct aac_dev *dev, int cid)
>  {
>  	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
> @@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>  		return -ENOMEM;
>  	}
>  	scsicmd->list.next = NULL;
> -	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
> +	scsicmd->scsi_done = aac_probe_container_scsi_done;
>  
>  	scsicmd->device = scsidev;
>  	scsidev->sdev_state = 0;
> -- 
> 2.20.1
> 

-- 
Kees Cook
