Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6844EC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 15:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422E721D56
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 15:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfIZPWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 11:22:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36660 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfIZPWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 11:22:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so1471232plr.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2019 08:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VuGSNHjZ3+kNCMccdts/DjndSJEeD9X/p8vxZ055BRs=;
        b=C0pQ5bvOlqxoWsDYBi0QCsUgsnK5CamXecvAad+0ut4Fr1ABzPW7JPXXbOfYxnKMSB
         0QkXOQE0XCwlmyzfqVFQdKmMmtrAb1fh6olD/7NXn9KJumHuytx3hyX2OZbYfBNn0lNd
         w3ZrG6aaf/ZqDosWhuE+vJdnKuU+gfkRmiCGIrylHdqjo5q4HGTAphhsYVI7f59LKZpD
         uVJD1ADaP26ZSAeatai9atYAvoOq7Bef/VbSZOYmyaPQaoTOFwljXzZ4EWv+YMY1AtD+
         eVBXjmf6wAN/9Orr4We/7Z3r9vdCjZBEjtEpi7MoXeoE1G4SncSsY1wVzKHPp3AYDfDw
         8j6w==
X-Gm-Message-State: APjAAAXt8lCirATQEeBVigxRVxuauCEntu9S0pTIIOLiqdYCyh8CIaYc
        r7yZu60LJJTlDVdr7DZrxazaLmiun6w=
X-Google-Smtp-Source: APXvYqwVMsM8Eko9r0zclVWmaHSR+Ne5ikazCnNZq13J0LhRj+swfBIxvkMJHE8LqSd590v8dcj/dQ==
X-Received: by 2002:a17:902:74cb:: with SMTP id f11mr4537917plt.5.1569511327995;
        Thu, 26 Sep 2019 08:22:07 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w189sm3528936pfw.101.2019.09.26.08.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 08:22:06 -0700 (PDT)
Subject: Re: [PATCH] scsi: Add sysfs attributes for VPD pages 0h and 89h
To:     Ryan Attard <ryanattard@ryanattard.info>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20190925180251.49980-1-ryanattard@ryanattard.info>
 <20190925180251.49980-2-ryanattard@ryanattard.info>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b22a3d05-d1f6-8702-f7f1-d731c0d6e344@acm.org>
Date:   Thu, 26 Sep 2019 08:22:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925180251.49980-2-ryanattard@ryanattard.info>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/19 11:02 AM, Ryan Attard wrote:
>   static struct bin_attribute *scsi_sdev_bin_attrs[] = {
> +	&dev_attr_vpd_pg0,
>   	&dev_attr_vpd_pg83,
>   	&dev_attr_vpd_pg80,
> +	&dev_attr_vpd_pg89,
>   	&dev_attr_inquiry,
>   	NULL
>   };
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 571ddb49b926..5e91b0d00393 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -137,6 +137,8 @@ struct scsi_device {
>   #define SCSI_VPD_PG_LEN                255
>   	struct scsi_vpd __rcu *vpd_pg83;
>   	struct scsi_vpd __rcu *vpd_pg80;
> +	struct scsi_vpd __rcu *vpd_pg89;
> +	struct scsi_vpd __rcu *vpd_pg0;
>   	unsigned char current_tag;	/* current tag */
>   	struct scsi_target      *sdev_target;   /* used only for single_lun */

How about using numerical order consistently for the vpd related 
variables? Otherwise this patch looks fine to me.

Thanks,

Bart.

