Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F73C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C869664D9D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhBIQdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBIQde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 11:33:34 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5168DC06174A;
        Tue,  9 Feb 2021 08:32:55 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jj19so32707295ejc.4;
        Tue, 09 Feb 2021 08:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tMjEDIWXTbcxoRxHObO5ex+BXqhk3u0dsgyA0jezguc=;
        b=LaTcjo99kjQOO0KT71ans7Q9LYnDxALXwbwP3AtYPRph9BpteFOMnDXF3SlSm3UZo1
         8ID9zf1LLi+yn297lv5HM+dv3VPuZf3S3fL83CZfbSxbZ6SDhaGf3dYYOytkSuc4OCaW
         7cJRUOokajqTpn4UhSrwGcRMOHMVdn3ILuV6CCDvnezs7SaL185I7Hpg63gBeKvUEf4V
         lto1t/J/10E3UHlF8BMB0EI//J6B6qyov1wEjnh3SUwh7kFsXVQ8Hq9zHJ6Ucjwa6jBg
         ZqSO6bmIXDKxk4DXpyQuwa++h3FfcMwTTaF8ly3YF22dXumrtyTdxQifXJ84Ib/ZmRsM
         8cKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tMjEDIWXTbcxoRxHObO5ex+BXqhk3u0dsgyA0jezguc=;
        b=Gr6kFlwtInjyIx2otj759bmglgM/DO6mdB15bq/MJ095z76bJVIwyxHWH8QwSyy+Ag
         Wb/9mY/3aK8lZ/lWXfGhrKDCFRe5JOGY7vckVMxZnwjmGuey09JI0cdtX2KvoodFyG8H
         Z2tLUqr+vpPSzs4dElCYhdL2A1jNTxMtWVEzgh22sjJVcdWo9QTPiDleXh5rwuHVRAVC
         6svJqbF53ShDeAr2iYmto4vtzAZAJqth8D3GhLgufwtEHjNocg+CE3YXk3eFg0TlwurJ
         k6IyIsyONFwr13ZjLTgCyIKVG0Kzf6XDwkeWMa+ceuUFlaohd0W6wCY7rsl2p+18eec2
         mbYw==
X-Gm-Message-State: AOAM531JepYHTbYEp8nWFAR9kgJd4rQvuiFptZDsZo+pKIfpKH4n5NKX
        vZ4eC/EJtLoCU0mD655ru6dU6Liod/E=
X-Google-Smtp-Source: ABdhPJzU0qfrNAmxLwfGfKHhRcoJXPkZDWZ37bpVQtVI/4qaszAEubldy1QqK+JOXVlR3x8FqAAW5g==
X-Received: by 2002:a17:906:b4a:: with SMTP id v10mr18653052ejg.382.1612888374017;
        Tue, 09 Feb 2021 08:32:54 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id c18sm11772500edu.20.2021.02.09.08.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 08:32:53 -0800 (PST)
Subject: Re: [PATCH 10/13] target_core_user: add backend plug/unplug callouts
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-11-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <c316642b-0b9b-49b5-0d1f-db1d1fea9e99@gmail.com>
Date:   Tue, 9 Feb 2021 17:32:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209123845.4856-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 13:38, Mike Christie wrote:
> This patch adds plug/unplug callouts for tcmu, so we can avoid the
> number of times we switch to userspace. Using this driver with tcm
> loop is a common config, and dependng on the nr_hw_queues
> (nr_hw_queues=1 performs much better) and fio jobs (lower num jobs
> around 4) this patch can increase IOPs by only around 5-10% because
> we hit other issues like the big per tcmu device mutex.> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_user.c | 27 +++++++++++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index a5991df23581..a030ca6f0f4c 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -111,6 +111,7 @@ struct tcmu_dev {
>   	struct kref kref;
>   
>   	struct se_device se_dev;
> +	struct se_dev_plug se_plug;
>   
>   	char *name;
>   	struct se_hba *hba;
> @@ -119,6 +120,7 @@ struct tcmu_dev {
>   #define TCMU_DEV_BIT_BROKEN 1
>   #define TCMU_DEV_BIT_BLOCKED 2
>   #define TCMU_DEV_BIT_TMR_NOTIFY 3
> +#define TCM_DEV_BIT_PLUGGED 4
>   	unsigned long flags;
>   
>   	struct uio_info uio_info;
> @@ -959,6 +961,25 @@ static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
>   	return cmd_head;
>   }
>   
> +static void tcmu_unplug_device(struct se_dev_plug *se_plug)
> +{
> +	struct se_device *se_dev = se_plug->se_dev;
> +	struct tcmu_dev *udev = TCMU_DEV(se_dev);
> +
> +	uio_event_notify(&udev->uio_info);

Don't we have a race here?

Let's assume that
 - just here the thread is interrupted
 - userspace starts,empties the ring and sleeps again
 - another cpu queues a new CDB in the ring
In that - of course very rare condition - userspace will not wake up for the freshly queued CDB.

I think, first clearing the bit, then doing the uio_event_notify would work (without need to take the big tcmu mutex).

> +	clear_bit(TCM_DEV_BIT_PLUGGED, &udev->flags);
> +}
> +
> +static struct se_dev_plug *tcmu_plug_device(struct se_device *se_dev)
> +{
> +	struct tcmu_dev *udev = TCMU_DEV(se_dev);
> +
> +	if (!test_and_set_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
> +		return &udev->se_plug;
> +
> +	return NULL;
> +}
> +
>   /**
>    * queue_cmd_ring - queue cmd to ring or internally
>    * @tcmu_cmd: cmd to queue
> @@ -1086,8 +1107,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   
>   	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
>   
> -	/* TODO: only if FLUSH and FUA? */
> -	uio_event_notify(&udev->uio_info);
> +	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
> +		uio_event_notify(&udev->uio_info);
>   
>   	return 0;
>   
> @@ -2840,6 +2861,8 @@ static struct target_backend_ops tcmu_ops = {
>   	.configure_device	= tcmu_configure_device,
>   	.destroy_device		= tcmu_destroy_device,
>   	.free_device		= tcmu_free_device,
> +	.unplug_device		= tcmu_unplug_device,
> +	.plug_device		= tcmu_plug_device,
>   	.parse_cdb		= tcmu_parse_cdb,
>   	.tmr_notify		= tcmu_tmr_notify,
>   	.set_configfs_dev_params = tcmu_set_configfs_dev_params,
> 
