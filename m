Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110FBCD4847
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 18:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjIVSOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 14:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjIVSOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 14:14:36 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F08B7;
        Fri, 22 Sep 2023 11:14:30 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c5bbb205e3so23864275ad.0;
        Fri, 22 Sep 2023 11:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695406469; x=1696011269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UcROZaOCaq0utWr9SRnQeHh2pM14ioFVRFHoRfTuFf0=;
        b=fhzW5UiezIhyXigTj+Ki5l+Zfwd08BT9dExZeSYNPEvUz6vRQKsdZ9fwINQpRKHZo6
         j7wk6wKkNaYgVNSArPaKy2K8o6XGkACP3X/dsPWvAf8DyfX9hEdW0INwKZb/xEAm1OWL
         aR5TyHVdnC/4EQyUMw3erWFNOYMIhQP4lkq8SwdDByoXRJB2rW+3aNkN5w7/U63+b4Nr
         9fZxkrUFeeYMAN2B+fGNKqdgCtbGgXo3cmBSQZXcZQV2iwEBWcIajYooLoUjUH/K9J+2
         OQ2LEHVqmHm5y8i4qb1QHSdiI7UP4Mgd8NISrL2FUWL2j4hVrX7C+rRkdFNzvrmi906k
         ahoA==
X-Gm-Message-State: AOJu0YxR59UV4iDNDGuyEhgxlT5TB87D3QkB59gGlTxaPNpCAxXnyt5G
        8MFutyarx8VM5ADdKB+GFrFm5tVoBGc=
X-Google-Smtp-Source: AGHT+IFuGOKnVYKLCdgfVtzOGvq72IyvTzZbcMlkpmpPaiEkkW6bZjh0Cj20RYjekB+vekDACrhozg==
X-Received: by 2002:a17:902:6b05:b0:1c3:a396:25ae with SMTP id o5-20020a1709026b0500b001c3a39625aemr147732plk.56.1695406469318;
        Fri, 22 Sep 2023 11:14:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:70e9:c86f:4352:fcc? ([2620:15c:211:201:70e9:c86f:4352:fcc])
        by smtp.gmail.com with ESMTPSA id ju12-20020a170903428c00b001b87d3e845bsm3805912plb.149.2023.09.22.11.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 11:14:28 -0700 (PDT)
Message-ID: <49f609ca-f862-4dce-95d8-616acbbc3e0e@acm.org>
Date:   Fri, 22 Sep 2023 11:14:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230921180758.955317-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/23 11:07, Damien Le Moal wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1d106c8ad5af..d86306d42445 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3727,7 +3727,8 @@ static int sd_remove(struct device *dev)
>   
>   	device_del(&sdkp->disk_dev);
>   	del_gendisk(sdkp->disk);
> -	sd_shutdown(dev);
> +	if (sdkp->device->sdev_state == SDEV_RUNNING)
> +		sd_shutdown(dev);
>   
>   	put_disk(sdkp->disk);
>   	return 0;

Doesn't this patch involve a behavior change? I'm concerned the above patch
will always cause the sd_shutdown() call to be skipped if scsi_remove_host()
is called, whether or not the scsi_remove_host() call is triggered by a
resume failure.

Thanks,

Bart.
