Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3346448B93
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772924; cv=pass; b=LXZUrMEohWlCwn49NuU08Kj1r84uBbA4eKy0oK2E1LwxbXBFf24p9abpjpRpHr5jp54mw8DuzntXuJObcQmUlIsMFRl4SzN6lnlzHpWd4oep0LUyY02gb2iD6/G74LR+iB8imMBlLUcslukmA+IiTq0WPGrvzcNdv6mMd0y+ExY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772924; c=relaxed/simple;
	bh=jdC3YU8dHQs+R1DdVna6vLRwPjsbGknBcowKTw7Do2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tqe6ZkFh5jS/BW65+LCwooGV9Tzmu2JvLr+Lv0bVh1qMRMm2cir/+GM21yVSlH78e1XwtH4esjdCRsJfeQJPh6ioWmcds9yMEuKh7LLH7NhgekYqU8uloY50Brmky7QMXzKA0bp2ERiv4OU557ipSwc4chWsv20Wld8Cay+PgZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0i9whWa; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0i9whWa"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-85b293528a9so37528067b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2026 02:22:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788772921; cv=none;
        d=google.com; s=arc-20260327;
        b=fL+mFuBJMS+WyUmUxA2Q1aw4mMjFxbQlku2FRis62pFjkcQ4ZjthCcNSYYguotJkHS
         Mg/lteVVpto/G0BvspD3DrQThyJsMCy5yg+o3nykjyKtOhsFq0cD7uKrvDJJzYtnCFug
         renIPBfuAhKPQczHkr2+u5SyTi+LDGxWmEDFojI/SVtEM7rBCwXP66rmST2h94ZvZAgA
         WF1FhHIAJvrZnC+tOrcYxErrw2Zl2XqMJ3rJCBc74Fb4LKQ75G2ebMYn+btRtQ0NAj+Z
         dWlHUbGXTv8FwQbP6Weum9h4Js+m/5b0NSevG+o46Lmk+MUOb1OfFTkygRZyCTOW95Pc
         OLRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J0t5MHJvx2iLkVwFpdNQYQKKsnnTlLCT8TZwcuf3lTs=;
        fh=p3tKHgIIHZvzqXXnM+veZK6hDm5BE9X5KIJ3TfLNBT8=;
        b=GtSDdM0pzSG9zP53jimmBwq3hGqIldrIKpPGt/jtbPK6nq8GEG8OefLd1j68Z6E80/
         XV7QWdD+VucsqLadMhvZMet42n3HFdva+NLPeanZ5LNmfGrK0xyZAaPlh3IV3h04cHqY
         7zCfGkiatRE+FtFsxQFRBb6skkWI0jThKoMZU6D0kgVtXC8hEh617z8nN0FsvNgZygoW
         wO5J5H7yQr4oR5yldvWqI1EVqQNanDcstdN+FxZt4gZFHejSvY3/mdZMm4GEEj/4o49v
         tUFojr1SVUN7btlK+8+pwdh6tOnDIxcYi9jUElqPFApnlKpAMqk39CKaNTs0DSDAkeDI
         14cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788772921; x=1789377721; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J0t5MHJvx2iLkVwFpdNQYQKKsnnTlLCT8TZwcuf3lTs=;
        b=c0i9whWazaJQ3HCZjS/S03gbBX0v/e/P3Zu3HsA1Co31h88O5avmljerX+lSDzu967
         9qSTP0/nVn3L/ExlmtFnZ0ysCvpNGRXr+vQdpmGboMUgdyFB4dRZXMieg2uZcar4owzL
         DBaZ4QUsKKShnmKpgmBxnZ3F9r1JXHsuYpKqIt248fzmrbtZO39+BPe3hZLewgMbdsF6
         qhFEwcYoX0pu1dC4gW8PLaEfM1+IcCeby+ErY/1CN3J+5yCXs/I/EyWQR76XZXYxZugO
         ZZ2/dTKXEULwOTWyzAQNRf1EWVdRY/HfqLOa8O/SrHS24ClRPFdyPo1Gm5HsSbCrm4vv
         6Wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788772921; x=1789377721;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=J0t5MHJvx2iLkVwFpdNQYQKKsnnTlLCT8TZwcuf3lTs=;
        b=MSDq9h8DzOxEQEYpZwqxwnIPW7y0JYqc8/qoMD+IP1hGIuss9EM+g6TQWGtSdQIeA4
         6viHD6nF/JCkGRk9iHpJuBf03g66eNux4E5Cc2HqrFp1RsZcWQ2KIJNEUA577P99VZm9
         uORUnoSuC0lMVtNkskxRlvCY2PDEtDbKIlBtPPnKO50rHQ4Rk+T68YXflpWJ6C14ausL
         AUWpYpVKIer9S/McFbeeAXuGRvxD5dTjM485HVNw5xyNqgLhjkB8KhRpahGS0tQsTngm
         iW/vrik2odBZ5HrfJXTCrcB4DoUEawaI/a2EiprZkZbMzjXGjAD5p1TF85Uzj+fqJw3W
         cl8w==
X-Forwarded-Encrypted: i=1; AKwUvBxPSTy6hLwI2GpK6ftE1ffB6/PuSFn1CSfnsXwvdiMR5NzNK5QO4oQwWcr77NT5PptuJdXxuurvRVlO@vger.kernel.org
X-Gm-Message-State: AFuF++mQp1S5Zk9wBEHurIVVPEKVZngbU0gG21pqQcESPwWHp3XnhnTq
	dyMeWuRVMn4WTDgr11ZxCbmQF69ClX0VVhAeP1KrcdHlxUiD1CxrT1XDpPYnbOVK/ySpboqNdc7
	Fs6hffN9JoKOaOqqGy9JbZmCeRH/SY3b4stML
X-Gm-Gg: AYBFou0iijKh06b7c729pdJJmgiFcyTzZObT2TsgI+oP9fqV5WL2rBxz+wgbm4QdpK2
	jTdTPPxfRxjr1cLImUvx6M3V+uLUvqQT1TZwK+WkK8Mq6CyeWqQYHjfHzoZJViyBxpqr4wx9wPQ
	3GNKC3x+fcPPzv3j7gzNjYyziD2LKLBnsl6TX8y4RumFI2514mx6QOICnnlyKScI/Yq1vGqRGGL
	4uNyqhOh1NjNUhPasZlwstnX6uksps2OluP6mZC3rVsRR6SdQe3g4nlAzLmnGfyLYXc8Ks8s1Xi
	nN3C8Uhhf+gJwGI1xwtFVnAs2GBvgBLwcGsqp0endYST1WLBIISqZBI84XxSGd8w4OtntH9/FhJ
	K
X-Received: by 2002:a05:690c:a84:b0:7f0:38f7:6ca6 with SMTP id
 00721157ae682-86e6d7905ccmr100098477b3.5.1788772921510; Mon, 07 Sep 2026
 02:22:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907063531.23981-1-hemanth.selam@gmail.com>
In-Reply-To: <20260907063531.23981-1-hemanth.selam@gmail.com>
From: Frediano Ziglio <frediano.ziglio@gmail.com>
Date: Mon, 7 Sep 2026 10:21:50 +0100
X-Gm-Features: AcwNN1UZe9OK-phDYGL6Rp7bdzbs1SB4QayVK-l7Y6JKSNPJ-dx1Aq5zzRqdwzM
Message-ID: <CAHt6W4erMMhNoqD+OjG+BmpWvZEcWLjoszFok_guwM2gANR14Q@mail.gmail.com>
Subject: Re: [PATCH] xen: fix typos in comments
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 07:36, Hemanth Selam <hemanth.selam@gmail.com> wrote:
>
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/scsi/xen-scsifront.c     | 2 +-
>  drivers/xen/mcelog.c             | 2 +-
>  include/xen/interface/platform.h | 4 ++--
>  include/xen/interface/xen.h      | 2 +-
>  include/xen/xenbus.h             | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 989bcaee42ca..f86a47056ea8 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -1076,7 +1076,7 @@ static void scsifront_do_lun_hotplug(struct vscsifrnt_info *info, int op)
>
>                 /*
>                  * Front device state path, used in sdev_configure called
> -                * on successfull scsi_add_device, and in sdev_destroy called
> +                * on successful scsi_add_device, and in sdev_destroy called
>                  * on remove of a device.
>                  */
>                 snprintf(info->dev_state_path, sizeof(info->dev_state_path),
> diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
> index 32ab419bb503..f19cc7a67f36 100644
> --- a/drivers/xen/mcelog.c
> +++ b/drivers/xen/mcelog.c
> @@ -1,6 +1,6 @@
>  /******************************************************************************
>   * mcelog.c
> - * Driver for receiving and transferring machine check error infomation
> + * Driver for receiving and transferring machine check error information
>   *
>   * Copyright (c) 2012 Intel Corporation
>   * Author: Liu, Jinsong <jinsong.liu@intel.com>
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 79a443c65ea9..462e36392a9f 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -421,10 +421,10 @@ struct xenpf_pcpuinfo {
>         /* IN */
>         uint32_t xen_cpuid;
>         /* OUT */
> -       /* The maxium cpu_id that is present */
> +       /* The maximum cpu_id that is present */
>         uint32_t max_present;
>  #define XEN_PCPU_FLAGS_ONLINE   1
> -       /* Correponding xen_cpuid is not present*/
> +       /* Corresponding xen_cpuid is not present*/
>  #define XEN_PCPU_FLAGS_INVALID  2
>         uint32_t flags;
>         uint32_t apic_id;
> diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> index 40c9793e9880..f9acb21875cf 100644
> --- a/include/xen/interface/xen.h
> +++ b/include/xen/interface/xen.h
> @@ -94,7 +94,7 @@
>  #define VIRQ_XENOPROF   7  /* V. XenOprofile interrupt: new sample available */
>  #define VIRQ_CON_RING   8  /* G. (DOM0) Bytes received on console            */
>  #define VIRQ_PCPU_STATE 9  /* G. (DOM0) PCPU state changed                   */
> -#define VIRQ_MEM_EVENT  10 /* G. (DOM0) A memory event has occured           */
> +#define VIRQ_MEM_EVENT  10 /* G. (DOM0) A memory event has occurred           */
>  #define VIRQ_XC_RESERVED 11 /* G. Reserved for XenClient                     */
>  #define VIRQ_ENOMEM     12 /* G. (DOM0) Low on heap memory       */
>  #define VIRQ_XENPMU     13  /* PMC interrupt                                 */
> diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
> index 8ca15743af7f..6424c5cf8ef5 100644
> --- a/include/xen/xenbus.h
> +++ b/include/xen/xenbus.h
> @@ -63,7 +63,7 @@ struct xenbus_watch
>         unsigned int nr_pending;
>
>         /*
> -        * Called just before enqueing new event while a spinlock is held.
> +        * Called just before enqueuing new event while a spinlock is held.
>          * The event will be discarded if this callback returns false.
>          */
>         bool (*will_handle)(struct xenbus_watch *,

Reviewed-by: Frediano Ziglio <freddy77@gmail.com>

Frediano
