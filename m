Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91ECC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5562074D
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgEPDTQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 23:19:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33011 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgEPDTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 23:19:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id x77so1942079pfc.0;
        Fri, 15 May 2020 20:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UU737tti4EbQvKMajSwO055w1IJCKfj238CPnutQI7Q=;
        b=BolxFMwxR4Xav+W5QgAC9pbEQIZa4mWK2J0Phufs0S3tiWVDWrBu2mnNovzfIiwg0Q
         Ii/4t3c4fI/or4/312Hp9SaDwzkAX9rul6QV/SJY+ZMZbOmTvywMxt0UhBvBywMpjUh4
         LcvqfOMVFDUkmzqWQtWMTvs3dueCHysLY4bLUkYtWeYXbPFXkk+vBhO2JIsz3aHawykW
         pEPgdVKrz6q0e1oc9i5nieAgzowyle2zccV4Q9sOwnQ6l15gu8xZ+mccISN0LpioBGuD
         do6xwAz8qgCg3tLDBObAcmSaZlZJc8miOT2G6xhe/7KOb8fpJyY9jtiONK65/CqHaipe
         zjOQ==
X-Gm-Message-State: AOAM531IPyg713jVZycIa8Q8g5pPhv5B4rRr1YXYkelH0wii3rs/8Iz+
        3m7O/KkV4skP/dV4CZ/Y3Xg=
X-Google-Smtp-Source: ABdhPJy/78dbgo4QJABJnk4W5JjkLPIs6B/kePfxQCli3CYhY7n73+bBCR7goHhotIV/u99lsIlw8g==
X-Received: by 2002:a62:ed14:: with SMTP id u20mr7181610pfh.69.1589599154295;
        Fri, 15 May 2020 20:19:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id z6sm2755577pgu.85.2020.05.15.20.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 20:19:13 -0700 (PDT)
Subject: Re: [RFC PATCH 11/13] scsi: Allow device handler set their own CDB
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
 <1589538614-24048-12-git-send-email-avri.altman@wdc.com>
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
Message-ID: <80a69f59-08b6-73c2-5ee6-848149005701@acm.org>
Date:   Fri, 15 May 2020 20:19:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-12-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> Allow scsi device handler handle their own CDB and ship it down the
> stream of scsi passthrough command setup flow, without any further
> interventions.
> 
> This is useful for setting DRV-OP that implements vendor commands via
> the scsi device handlers framework.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c | 5 +++--
>  drivers/scsi/sd.c       | 9 +++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6b6dd40..4e98714 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1148,14 +1148,15 @@ static blk_status_t scsi_setup_fs_cmnd(struct scsi_device *sdev,
>  {
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>  
> +	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
> +	memset(cmd->cmnd, 0, BLK_MAX_CDB);
> +
>  	if (unlikely(sdev->handler && sdev->handler->prep_fn)) {
>  		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
>  		if (ret != BLK_STS_OK)
>  			return ret;
>  	}
>  
> -	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
> -	memset(cmd->cmnd, 0, BLK_MAX_CDB);
>  	return scsi_cmd_to_driver(cmd)->init_command(cmd);
>  }
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a793cb0..246bef8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1221,6 +1221,14 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
>  		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
>  					 protect | fua);
> +	} else if (unlikely(sdp->handler && blk_rq_is_private(rq))) {
> +		/*
> +		 * scsi device handler that implements vendor commands -
> +		 * the command was already constructed in the device handler's
> +		 * prep_fn, so no need to do anything here
> +		 */
> +		rq->cmd_flags = REQ_OP_READ;
> +		ret = BLK_STS_OK;
>  	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
>  		   sdp->use_10_for_rw || protect) {
>  		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
> @@ -1285,6 +1293,7 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
>  		return sd_setup_write_same_cmnd(cmd);
>  	case REQ_OP_FLUSH:
>  		return sd_setup_flush_cmnd(cmd);
> +	case REQ_OP_DRV_IN:
>  	case REQ_OP_READ:
>  	case REQ_OP_WRITE:
>  		return sd_setup_read_write_cmnd(cmd);

The above looks weird to me. My understanding is that
scsi_setup_fs_cmnd() is intended for operations like REQ_OP_READ,
REQ_OP_WRITE and REQ_OP_DISCARD. I don't think that it is appropriate to
pass REQ_OP_DRV_IN requests to scsi_setup_fs_cmnd() and/or
sd_init_command().

Thanks,

Bart.


