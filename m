Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D322DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 17:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244898AbhK3RlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:41:08 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:37743 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhK3RlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 12:41:07 -0500
Received: by mail-pf1-f176.google.com with SMTP id 8so21347145pfo.4
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 09:37:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfTHhauoRg+InOcWwYkykJkWTiJ0S3QGnrhKv0OCwzI=;
        b=Uswdl849uZ4pm1kg6FNY5fFPk5EJUdiDA8VphDxI28I49NcKGxflfp3GYg87R1DRVv
         7C6FqQ1lJ6qB7p2wYqU0FGRpAlszW4MxbF/i5vTrT3Jj/wdEvlGrgJNJfu36lwTdakLr
         2P001VaJ1X2FEyUyy+gqCFUOfIoL6mSmVvS8V/bG4HJsCcp1mwTOLb5c6U2hPjiKZTQ2
         hiHc66swDVIt8cJK0kKRDP/WOeeDR3F2qCEq4e04j/5Sz81I1rCrfo/Y5VoK5ctcUlTi
         IFsIfZyp0Nokrudjimrj5QUt5HLVH0JTEphoRqOSlnNn1b7xwY9X0pAVm3OewOQmJcuY
         IdXg==
X-Gm-Message-State: AOAM533KRGp/+aKkPRhc0BOPkmLPMYsfPcwZOBrdzyF6GQOwnkwlrqmy
        pwpwaiIFmornnPYKBV9k2HY=
X-Google-Smtp-Source: ABdhPJz5JXW9zxCK0piEqH7mFpmNrp20ppYoKqh2e8zDaY97XY91ZB1GjQmZ4ZW1oVjKFZLxhoRBdw==
X-Received: by 2002:a05:6a00:1ad0:b0:49f:d04e:78da with SMTP id f16-20020a056a001ad000b0049fd04e78damr257212pfv.77.1638293867645;
        Tue, 30 Nov 2021 09:37:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id w142sm21293458pfc.115.2021.11.30.09.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:37:47 -0800 (PST)
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
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
 <20211119195743.2817-20-bvanassche@acm.org>
 <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca60e62b-d310-1f97-d61e-d0ba8bdd420b@acm.org>
Date:   Tue, 30 Nov 2021 09:37:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 12:43 AM, Bean Huo wrote:
> On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
>> +	return IRQ_HANDLED;
>>   }
>>   
> 
> ufshcd_transfer_req_compl() will never return IRQ_NONE,
> but ufshcd_intr() needs this return to check the fake interrupt.

I don't think that it is possible to implement polling and detect
spurious interrupts without affecting performance negatively. Hence
the choice to never return IRQ_NONE. Is spurious interrupt detection
that important or is this only required for debugging host controllers?
I consider helping with hardware debugging as out of scope for the UFS
driver.

>> @@ -9437,6 +9481,7 @@ int ufshcd_alloc_host(struct device *dev,
>> struct ufs_hba **hba_handle)
>>   		err = -ENOMEM;
>>   		goto out_error;
>>   	}
>> +	host->nr_maps = 3;
> 
> I don't understand why not directly uses HCTX_MAX_TYPES, 3 is already
> maximum.

If new map types would be introduced in the future, we still need 3 maps.
Hence the choice for '3' instead of HCTX_MAX_TYPES.

Thanks,

Bart.
