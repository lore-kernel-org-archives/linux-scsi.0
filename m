Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D85DC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C6D02073E
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgEPDGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 23:06:33 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51739 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgEPDGc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 23:06:32 -0400
Received: by mail-pj1-f67.google.com with SMTP id mq3so1764968pjb.1;
        Fri, 15 May 2020 20:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T2GyJli/LtpjNMryaclGRF8nKqCQNV/l/DH3OGmd/9c=;
        b=M+FeyZMM6vVp00doQX97+0OwJO+20jTuZcbX0w2EaXGSWsfql/7T+pFUCqjVCdDq6l
         qYtFMAQ93dAdiweMOGOM9u8gqp893OmGx/XVz9e1FG6sq3J+dVBYMh7CHL+n+S57/tGz
         H3cHmXDDYf33HGNVOIHaGi5mCaxEz1MsdfO3J2TrsmHfxIVswYeiq3vgYJZXvWKivqLR
         o6/NqcTCRDG3Z5IzKeP2hc9gjT/ogl+xn0FPxTfmMVMVAhBNTv6VrLrXZ97leHKaHDXg
         GR7iHRLO1nKhlrxgE2JiZRYNTLcRYilzdLUaI8Z0KjAGYzCaogDnRwsYFukHx5dTHUkr
         ySTw==
X-Gm-Message-State: AOAM533d6SYs9Hgxttv01cL4e4m4nBJ2OsBHf2YQ7oHMNd7bTEUyr7k2
        YB/HwLrbJz+1vjyp9gWIwPE=
X-Google-Smtp-Source: ABdhPJx+vns/ssIkJi4jyZILzl09L0c7z3Gfq+MJqyh+rsrNcXyD1wZtZWFUhveEu/tBDZ8XYMo7SA==
X-Received: by 2002:a17:902:9044:: with SMTP id w4mr6607162plz.83.1589598391314;
        Fri, 15 May 2020 20:06:31 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id z7sm2968082pff.47.2020.05.15.20.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 20:06:30 -0700 (PDT)
Subject: Re: [RFC PATCH 09/13] scsi: ufshpb: Add response API
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-10-git-send-email-avri.altman@wdc.com>
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
Message-ID: <9619597b-3a3e-e67c-5afa-cebf03cc678b@acm.org>
Date:   Fri, 15 May 2020 20:06:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-10-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> +#define RSP_DATA_SEG_LEN (sizeof(struct ufshpb_sense_data))

The name of this macro is almost as long as the expression it replaces.
It may make the code easier to read by dropping this macro and using the
sizeof() expression directly.

> +	struct tasklet_struct rsp_tasklet;

Why a tasklet instead of e.g. a work_struct? Tasklets can cause nasty
problems, e.g. CPU lockup complaints if too much work is done in tasklet
context.

> +static void ufshpb_dh_notify(struct ufshpb_lun *hpb,
> +			     struct ufshpb_sense_data *sense)
> +{
> +	struct ufs_hba *hba = shost_priv(hpb->sdev->host);
> +
> +	spin_lock(hba->host->host_lock);
> +
> +	if (scsi_device_get(hpb->sdev)) {
> +		spin_unlock(hba->host->host_lock);
> +		return;
> +	}
> +
> +	scsi_dh_set_params(hpb->sdev->request_queue, (const char *)sense);
> +
> +	scsi_device_put(hpb->sdev);
> +
> +	spin_unlock(hba->host->host_lock);
> +}

To me this looks like slight abuse of the scsi_dh_set_params() function.
The documentation of that function mentions clearly that the second
argument is an ASCII string and not e.g. sense data.

Has this driver been tested on a system with lockdep enabled? I don't
think that it is acceptable to use spin_lock() in tasklet context.

> +static void ufshpb_tasklet_fn(unsigned long priv)
> +{
> +	struct ufshpb_lun *hpb = (struct ufshpb_lun *)priv;
> +	struct ufshpb_rsp_element *rsp_elem = NULL;
> +	unsigned long flags;
> +
> +	while (1) {
> +		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +		rsp_elem = ufshpb_get_rsp_elem(hpb, &hpb->lh_rsp);
> +		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +
> +		if (!rsp_elem)
> +			return;
> +
> +		ufshpb_dh_notify(hpb, &rsp_elem->sense_data);
> +
> +		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +		list_add_tail(&rsp_elem->list, &hpb->lh_rsp_free);
> +		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +	}
> +}

Please schedule work instead of using tasklet context.

Thanks,

Bart.
