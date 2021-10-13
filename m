Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BD3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA7326052B
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhJMQwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:52:18 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:42791 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhJMQwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 12:52:17 -0400
Received: by mail-pj1-f50.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso2749931pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 09:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=te+evGk5OwqKiytc8HitDHcI75KqBq/yfszzE0PLAgU=;
        b=1pyyaxaeN7lw9U28z/IspCKpiJ9ML4p4MvXr4UrNjiuNYFYNVc/SZE8H4sTyOMiAv8
         Szagj+7b+X4GMujM+K3laqBZGnHqzmqrWl7lbBRf8KaUY9RcNH+TFbH9bkGY0OlPGC9E
         +ra7WergZ/54je/JswjuvlXmJGeeByojIuHDTI5FrBmAHG+pvGV1XosdA8Exe9BJdiMH
         eGcC0t8LkIUyMNYpiHggniUjQ+0P8mxJbUohMT3mRjGrA2hCtssSEwfyKF4DbRO+S/z0
         JaNBSK3I0msFdlZ/ciTJrcyL15EIBo7ingPdE/AgKU80fCkcRhmzZAnng0urc8QDk/3U
         u90g==
X-Gm-Message-State: AOAM531r5H2P7+Be1WB4E8DqEjX8Cyp3te4zLnEtMi/93MkOLS0mjylD
        FuOH6HOaSEYkZQC0KHhSvsA=
X-Google-Smtp-Source: ABdhPJzzqbUaaQcyRMQyLjzlsFPoCANbo54jS7AnEYXVlWwMur+LImL/8V5Tz1sZGSRCCNBRCMem+g==
X-Received: by 2002:a17:90a:a41:: with SMTP id o59mr14820794pjo.243.1634143814138;
        Wed, 13 Oct 2021 09:50:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae3:1dc1:f2a3:9c06])
        by smtp.gmail.com with ESMTPSA id z2sm55062pfe.210.2021.10.13.09.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 09:50:13 -0700 (PDT)
Subject: Re: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-6-bvanassche@acm.org> <YWaIcpHbK4e6ELih@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3c42ab83-3344-418c-5523-1640dd29f018@acm.org>
Date:   Wed, 13 Oct 2021 09:50:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWaIcpHbK4e6ELih@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 12:19 AM, Greg Kroah-Hartman wrote:
>>   static const struct attribute_group *ufshcd_driver_groups[] = {
>>   	&ufs_sysfs_unit_descriptor_group,
>>   	&ufs_sysfs_lun_attributes_group,
>> @@ -8183,6 +8219,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>>   	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>>   	.max_host_blocked	= 1,
>>   	.track_queue_depth	= 1,
>> +	.shost_attrs		= ufshcd_shost_attrs,
> 
> Why can't this get added to the sdev_groups list?

The UFS error handler resets the host controller. There is one SCSI host 
per UFS host controller. Hence the choice to associate the sysfs 
attribute with the SCSI host.

There is one SCSI sdev per SCSI LUN. Although I'm not sure this can 
happen for UFS, it is possible that zero SCSI devices (sdevs) are 
associated with a SCSI host.

Bart.
