Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ED6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 18:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbhLASfN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:35:13 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:45571 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352512AbhLASfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 13:35:04 -0500
Received: by mail-pl1-f181.google.com with SMTP id b11so18362398pld.12
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2021 10:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3BtUISZbH+R5cKB4I26o8fKtu5DrQch8Aqeuj2ve8k=;
        b=EBDUTyNCZmZ4I8BC+vahwAaUHz9jz/g1WvYD/GaEs8BL2+WeoNrxaC4Uo0YyDPNNAq
         +Kx9ia30AgGKKZk9tJSSLT7hFrzClISat1FCDFODTewaQ3KdBfE3Mj0tFL4YZ/A+uN7i
         NvvKAlCaPExN/NRbHGbSa3jc0sDH8IsAKnhp+QY8Ya4bljCtxr3cuFRjVmAYmSi7hZXR
         GehQUZmN/wqY8LeRV1TY4ZXY9goi9HtwKkc0EwM+IMgNkBws51yI3/jGDHCbAGuTKMuh
         3fNsPbBVB7F08taP537tVa/YgU8SfIs57M/GBYqBN9gVL3Xs7ZOTCVBkPCeY6jchJTAy
         vl+A==
X-Gm-Message-State: AOAM532xQaW/6wFR7mB5lzvwdZ3O5Azm4zNLc1ktIezykB3nlfQTigm6
        eLwRqtbQBpDXncBjdB4E9O0=
X-Google-Smtp-Source: ABdhPJyhFHxloxPR3DTm93JTGAgSmQrPseFeWq9AhNwt6mGkjeISyF1CYJHicj/hLa27va96wvQRmQ==
X-Received: by 2002:a17:902:ec90:b0:142:269:4691 with SMTP id x16-20020a170902ec9000b0014202694691mr9814649plg.48.1638383503571;
        Wed, 01 Dec 2021 10:31:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7344:c0bd:a55f:88b8])
        by smtp.gmail.com with ESMTPSA id kk7sm42796pjb.19.2021.12.01.10.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:31:43 -0800 (PST)
Subject: Re: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-14-bvanassche@acm.org>
 <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
 <235fe40e-5695-a7a6-7422-68fc6d33cdac@acm.org>
 <062f4ad2381d652162c010755600557cce2211dd.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <90d702d0-907b-c56d-2a5b-db0318580198@acm.org>
Date:   Wed, 1 Dec 2021 10:31:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <062f4ad2381d652162c010755600557cce2211dd.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/21 5:44 AM, Bean Huo wrote:
> How about adding a hardware-specific UFS device management queue to the
> UFS device? Compared with NVMe and eMMC CMDQ, they both have dedicated
> tags for device management commands. NVMe is queue 0, eMMC CMDQ is CMDQ
> slot 31.
> 
> I'm thinking about the benefits of using this device manage queue. If
> the benefits are significant, we can submit the Jedec proposal for the
> UFS equipment management queue.

Hi Bean,

Do you want to modify UFSHCI 4.0 or UFSHCI 3.0? As you may know UFSHCI 4.0
will support multiple queues. The proposal is called multi-circular queue
(MCQ). Since UFSHCI 4.0 has not yet been ratified the draft is only available
to JEDEC members.

For UFSHCI 3.0, how about increasing the number of tags instead of adding an
additional queue? Increasing the number of tags probably will be easier to
implement in existing UFS host controllers than adding a new queue.

Thanks,

Bart.
