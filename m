Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FF7F4E1
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2024 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707725294; cv=none; b=uVXdkk7/glji2yMnNRZNheDmG5pr+4CJULaL8U1eltRLUQmBlMNA46gokqLy+wIuxndYJ2smWUWxtHz6F8enEqQnDlGJrGOU2kYsbGvyMBzues5rJghdeyuX7IoLY7WGj0TC/tClVEeNQIQXRO1h8tPY7YWG2RQzPhXqB3Ic/Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707725294; c=relaxed/simple;
	bh=OxCIciPqR2CGxmJVs+ARy66BdHyf2bhD9db1C9DMqy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D5p65C3bou8ZmJa+33zudoM4xwbtPo7C+HaUbpKbFJWICjpN8dCLki8gt2wu+pH27w/l+8T5MnL+YBnW6gZJVJieJT/CLuUpiGErTKQiMWMuSKlKOUn7oDNKPOQnzDcYsUJhqMdg8Gz6/qUwlyI5uBo/I22LV2e/tLv1lwPWrzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZvfoGVcX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZvfoGVcX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707725291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWCguNETcrfTBiAY5f9wJsa/D0Q5D3XV8r2NEo/B7go=;
	b=ZvfoGVcXjcTUzVu2uThb4Ab2K4RalDnWbqPLZ6d/efVP9O6B99aIJZzZZ3zgHneaPZQOxY
	0w3gB81NFDgOZ6teKKldvxOkWLkkRO9bBNMKQ59hf3Fj2uEP347TzUB03iEK4rrOJp412X
	dckqu0nwjiSNnG7cs47BdHHIN46aMuk=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-MKwUUA1FPJGbgWSRS8cLiQ-1; Mon, 12 Feb 2024 03:08:10 -0500
X-MC-Unique: MKwUUA1FPJGbgWSRS8cLiQ-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7cec904a1c8so1617979241.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2024 00:08:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707725289; x=1708330089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWCguNETcrfTBiAY5f9wJsa/D0Q5D3XV8r2NEo/B7go=;
        b=ALuN98FLVIM/YhjbER7DfW0bTUXVofD4Gr6+B+f+XhG4JYOVvZx8AUxoaHZYewgo0c
         b74KBSFoNCeTc4jNoQG2vNJQDGY6w7m9v+ayRwIq3RCk1AqGq/iqnu5s4UwsoLxWe+63
         P0NuiG0jRrKJfZax/U86yRxc4UPwb7hO3HDtC1FbVvZaUpa5gC8t3O5/Ws6kueStKx/w
         rtZhp/s1zmpF1YU066z7wEdYyZ6i5CMd/vi6dEIwoq7bFzPh1c1aoXDqgA7UcrMwE7NG
         Tg9uzK89kbN+p14Xc+9KyTB6M9fAHPXbo84uiN65nYdI2yT9pCe67R7LKMFMvBl9DEYk
         vZdg==
X-Forwarded-Encrypted: i=1; AJvYcCUU7qLBYMFZc4Gb7Fg2HnuEquGgZtGsmUtM2ll/zyDRoDQ2T5sI4Y6ngWlfrVrUSpGgun6pzGYmuobMtScWQu6nxK7NK6Lgy+dHrg==
X-Gm-Message-State: AOJu0YxvCKdWNoPqmo266X+FHtUjrc9H+CWnD7/8HsiVEDMirX0TiYvb
	NHFMfdKh/8ZFgzrfeA0GYA6FNgZ/2hcuWZi/So5QjV6V4cqebeMQ1JsqrS6OYzg+35k5kv9yR99
	lCxootKlmqd+6IDjlvSz5aV9r2zt+gZJjEaC8Ny2O6jCg+yarfJPidJnnRbHAxtkCe7upHOcW2+
	fIMOGu309bkhFm/wsr3DNfEMOfLK8IhRwN0g==
X-Received: by 2002:a05:6102:2828:b0:46e:ba1f:a754 with SMTP id ba8-20020a056102282800b0046eba1fa754mr657343vsb.12.1707725289542;
        Mon, 12 Feb 2024 00:08:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXucn9iVS5eHX0jo5XJu2W7Duyw6MqNBJ/IF9kFHf21qeDdQhXhkbgYn78g5Nebb1aAapGztgSv3G3jtGCqmU=
X-Received: by 2002:a05:6102:2828:b0:46e:ba1f:a754 with SMTP id
 ba8-20020a056102282800b0046eba1fa754mr657339vsb.12.1707725289280; Mon, 12 Feb
 2024 00:08:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209215247.5213-1-michael.christie@oracle.com>
In-Reply-To: <20240209215247.5213-1-michael.christie@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Mon, 12 Feb 2024 09:07:57 +0100
Message-ID: <CAFL455mRRFUEiSKXsHkRUMVu4vRz4cFOJBzDCs1DU6=rZ5SjUw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: target: Fix unmap setup during configuration
To: Mike Christie <michael.christie@oracle.com>
Cc: d.bogdanov@yadro.com, me@xecycle.info, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

p=C3=A1 9. 2. 2024 v 22:52 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> This issue was found and also debugged by Carl Lei <me@xecycle.info>.
>
> If the device is not enabled, iblock/file will have not setup their
> se_device to bdev/file mappings. If a user tries to config the unmap
> settings at this time, we will then crash trying to access a NULL
> pointer where the bdev/file should be.
>
> This patch adds a check to make sure the device is configured before
> we try to call the configure_unmap callout.
>
> Fixes: 34bd1dcacf0d ("scsi: target: Detect UNMAP support post configurati=
on")
> Reported-by: Carl Lei <me@xecycle.info>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>
> v2: Fix missing configure_unmap handling so failure is returned.
>
>  drivers/target/target_core_configfs.c | 48 ++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index a5f58988130a..c1fbcdd16182 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -759,6 +759,29 @@ static ssize_t emulate_tas_store(struct config_item =
*item,
>         return count;
>  }
>
> +static int target_try_configure_unmap(struct se_device *dev,
> +                                     const char *config_opt)
> +{
> +       if (!dev->transport->configure_unmap) {
> +               pr_err("Generic Block Discard not supported\n");
> +               return -ENOSYS;
> +       }
> +
> +       if (!target_dev_configured(dev)) {
> +               pr_err("Generic Block Discard setup for %s requires devic=
e to be configured\n",
> +                      config_opt);
> +               return -ENODEV;
> +       }
> +
> +       if (!dev->transport->configure_unmap(dev)) {
> +               pr_err("Generic Block Discard setup for %s failed\n",
> +                      config_opt);
> +               return -ENOSYS;
> +       }
> +
> +       return 0;
> +}
> +
>  static ssize_t emulate_tpu_store(struct config_item *item,
>                 const char *page, size_t count)
>  {
> @@ -776,11 +799,9 @@ static ssize_t emulate_tpu_store(struct config_item =
*item,
>          * Discard supported is detected iblock_create_virtdevice().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("Generic Block Discard not supported\n");
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "emulate_tpu");
> +               if (ret)
> +                       return ret;
>         }
>
>         da->emulate_tpu =3D flag;
> @@ -806,11 +827,9 @@ static ssize_t emulate_tpws_store(struct config_item=
 *item,
>          * Discard supported is detected iblock_create_virtdevice().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("Generic Block Discard not supported\n");
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "emulate_tpws");
> +               if (ret)
> +                       return ret;
>         }
>
>         da->emulate_tpws =3D flag;
> @@ -1022,12 +1041,9 @@ static ssize_t unmap_zeroes_data_store(struct conf=
ig_item *item,
>          * Discard supported is detected iblock_configure_device().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("dev[%p]: Thin Provisioning LBPRZ will not=
 be set because max_unmap_block_desc_count is zero\n",
> -                              da->da_dev);
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "unmap_zeroes_dat=
a");
> +               if (ret)
> +                       return ret;
>         }
>         da->unmap_zeroes_data =3D flag;
>         pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
> --
> 2.34.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

