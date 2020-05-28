Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627ADC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4932D21532
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404946AbgE1QQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 12:16:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40583 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404872AbgE1QQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 12:16:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id j21so13667238pgb.7;
        Thu, 28 May 2020 09:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AiyBV0vGcERCP8qoB3YDvmHJfZC1K97O59wS9c3H20E=;
        b=ABLiMPA0aB9SPugVCCN6+iX9qDj8YVsAf115Rh/PgyjfHnJ8YFQMZ9wOi5qQGVadVv
         6RI0mhcaeQGP0vgZM5X9gVm+t7Kg7//YlENJM2tDtuGj+XzuCwuLtfCvw68NVk8EwjYG
         enh1VD9yjnTb7/EfuLA6yz5J8AKklTq0G1loiWKOM7AGSfNetcUBawVBofqdGxVi0gg4
         YeFjU0ArFCj7+4Xb5kJwT/39yjbr+i7KXtIOeK8a0jYg+pkGgu8VY6vdiOTBwZHubwc5
         7PowMhrU8aJu6PKprUA0oWv+RLeQjFLj6naq6RbY2ePwHb+4EplNsn1F04G3NHxrH8/Q
         Wc3g==
X-Gm-Message-State: AOAM530kP87+jfXaWB6A+pIL/GmDLM8EUCxiCnFFhsRDJdEE0rKSlnQ4
        YUY/8O7yf7sKXVg9si57j7giPRXDUJs=
X-Google-Smtp-Source: ABdhPJwHssJ9qRtCjFfhshenoj9JiKUIVFUD49Gb/k5xSugTgXAdeYtepavbRi8b7HcDBVhbDJxw9g==
X-Received: by 2002:a63:ef03:: with SMTP id u3mr3675843pgh.254.1590682564091;
        Thu, 28 May 2020 09:16:04 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id a85sm5013772pfd.181.2020.05.28.09.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 09:16:03 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528115616.9949-1-huobean@gmail.com>
 <20200528115616.9949-2-huobean@gmail.com>
 <85bbc91f-7b91-46fc-acff-3bcc2288c4ae@acm.org>
 <82e8faa7d6a0c5f04832519740230f9f520347cb.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <8e1bfd09-0269-ecd6-eb24-31f953573189@acm.org>
Date:   Thu, 28 May 2020 09:16:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <82e8faa7d6a0c5f04832519740230f9f520347cb.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 08:04, Bean Huo wrote:
> do you mean  like this: buff_len = hba->desc_size[id]?

How about the following untested change?

Thanks,

Bart.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..e33754c15c2c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6606,14 +6606,11 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
 	int err;
-	size_t buff_len;
 	u8 model_index;
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;

-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
-			 QUERY_DESC_MAX_SIZE + 1);
-	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	desc_buf = kmalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
 		goto out;
