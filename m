Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D35736E473
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768836275; cv=pass; b=Kk2TBOHyxNg5zFHSTWe27SZ6z8kkWADPYWbIqXD1z89oicAJeHsXm8an3ibheDV5r4aA2wil47lSe8AEL/gzQF+De42UEPMYrJBNmagPv8DY6FMQwfoXAVygGmjeQG56ri/gHSqeeRhpsgj9RaBdZgP4yh+ZymdUDcXPZRCiNXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768836275; c=relaxed/simple;
	bh=W0KA/Mgm4ZQZI1bhGAcIfTYz86AK1tGbcALq949oTAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5jJBNp03focomVqEjtj3otV0ya3e9ACGp/s9zgkO01NOJHkTQBNtfBscl/h0O5dZl4A1TDdP7H4Fcx7dzi830dZewBIabK/NJ6v+O6TksKxqHnycbBvT0vyHNr0KpA8qI+JV/6mxeOQZD5iVu9CjT6W0Q8OYFW/gqWZu7AEClY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iO8omINv; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iO8omINv"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64b7a91f9daso480358a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 07:24:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768836272; cv=none;
        d=google.com; s=arc-20240605;
        b=NiDR6Y+WoSx6Bn3D8/QG2DrV/usL+LVjNhupIVAOSXVrqVTaJKH2E6A0R2OGA6lYvs
         dZrtWVlSDCJs6dBnIt7SO/exYEOzSJCk5/+dthkkgUuccN1LHmv2itC1Xv+7l3zeYv/o
         48aHjnRUI70l+TQAdSrJyh4WFAS7xFGdHTNQLuT87Q5cnfD1LOK25zNnO8IpQC5uHQEu
         l4el/o7X+r3SKRboSSaRGFXOSzMe2TjH38FBUhfqHWVWzLAkfZZIo67u/XsjbeuLz68c
         +YaW/j2gPVGgSpWOf+eQVOXhCKo7GGy7DCu6daIw0OE/CcWtX3Huv+9HzKC0wdvBjoLr
         Di7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Bp+koMHyJhYvcQ8Lgq+Gx/4EVz7QA47b0FriZ3wtiAQ=;
        fh=O+xLTi2HdcidkxWHh3nhLIEHuKHpEBjqrvaBhPsTVow=;
        b=KtBBTsERnL090A0XZkkVrMhpZfFHQ41GTTiXfDS4YZsAG15Gp1YR3DvkBI5TSuqdbA
         gdtG0ZMNnSZu41i9U5n3eVT9sfmZPL7czVu3aPTMw4+SgmRH3pFLjoZbYmzPNEBW3HTq
         USTyZ189sLMjW0tPl6YCZGTa71UU9b+fBuyudlxPv2qvNTsNS3tbSC3QTqXN8Ieg6IuE
         0VgkxoWjj+sjfPvWvob8rmNshF8FzS9n6OO0zHah9DePABOjrbNNZSPu77eHB0U7sY7H
         9PHkz2axkqsP8TKpNxkIqulVnQdQvwbEnhZ8n2tuTRuXGB/QsG8uuDOvt5xwATjscT4W
         LuLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768836272; x=1769441072; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bp+koMHyJhYvcQ8Lgq+Gx/4EVz7QA47b0FriZ3wtiAQ=;
        b=iO8omINvUDy4J66CavCb6j1tHYiUhRqOQEDIjtzwNjV3CEdw9aqIkcDUfhFOP6q0kM
         brMQP990kQI8CTT8wBi6LKVT9CKUbWzuDCWgmMg2k5BCeEcb9SDf2WM8Uz9otTEipeA9
         tFQFPi7wG7CfymyrSjxx1vH8G2Oih7qmt35fsMBucfvn7XwU1eKV9pXG3QUbvaSL2AYy
         il6BHLt7HFaY9mq/SvtuqZhqL8o+8SOX8pCUIsizYAuPrpG02BX2F/7Q+wycYDWmMyr/
         PRImUtheQOq4LSgSGnz799K6f+ZNf/k7BRMvNHCF1Ts+SAoRqWGlJwvSbpYpHbT33scU
         VaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768836272; x=1769441072;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp+koMHyJhYvcQ8Lgq+Gx/4EVz7QA47b0FriZ3wtiAQ=;
        b=Q0Xbj8ReNHfOwzvPyEfmEQ3IZZF+Y8/BQguzBg5ANWmx7U5i/2hABDRS/nwl1vNDv2
         XaGqEcM0C5S2HCrJHx0pzKgwgEgtKIPk0yuptBPUw4IEaP+wqVJPQwgjZts44wDGTZfv
         4TmMMMVr6a7DGb1b/uo6RG6oSMIhtL8zfo/MsGweme9kyP6ZkxnohxD2ncoEj//Lvqa4
         b2TasXFkpm9V9l4O47f6SRRB2J9cMAWbY2lYibzZ0epo+eRGEQYLkCvLceiXSGlJHIYP
         8tqLPvkyHtXemC/hICblXKiAGiZlsnA1K2xUm5VrHKABc+/eFOgA+8Kz/s8cR/RSLK4w
         3bxg==
X-Gm-Message-State: AOJu0YwGJRMY/aj1pZC50FSUk07sFK2TKFWW/oOQU+yaBeFkrO7JiAkR
	WZka1j9+6hWHW02ceYIIzWJjSm3KROTOYklD1DJiaj2EPWvekRKc7XgWRKY2DP/b3G9g3OQ8u6y
	xyYsOQWZvzmwEIEys9pGZ7o97v8TjKVA=
X-Gm-Gg: AY/fxX6SvGKGRdN+FJ6+nXdkK1mfc5wE7A/7WXJhNjb2/AFFpVvh71ivi1UObtIBrKQ
	+HmCfz1CZfIT9zPuyz+1rkcEtHn5mmyS7IzOod0aJ9Zb2mAZRM0o8wPDZhsMHdqqtrD3F8kCnOJ
	tSLkL4WRFSL4/B/MyIqFPSsgEjIWOSsMtZcQjpIQ+859Q/A4vx9dMaHx33hAlF7a6k7yXWBtriZ
	4pMwDDL/BYVo5zA2t30Uv23UsDvhGOxdJc+infBiO+wICXQpMw9ZXTdVw1jheApxNO0a94=
X-Received: by 2002:a05:6402:5242:b0:650:854c:454a with SMTP id
 4fb4d7f45d1cf-654524cdd07mr5566062a12.1.1768836271722; Mon, 19 Jan 2026
 07:24:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117101948.297411-1-dg573847474@gmail.com>
In-Reply-To: <20260117101948.297411-1-dg573847474@gmail.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Mon, 19 Jan 2026 23:24:20 +0800
X-Gm-Features: AZwV_QhDGfA0P5NQAxZ6Tql4iD55TpiTGiala80GCnJiKmVfXo6bIqkPwysjhNk
Message-ID: <CAAo+4rVW=CNyf1g6Gmnxi_te87Qn2oGYOEDgEyDOJFVzpFuCvA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
To: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>  drivers/scsi/pm8001/pm8001_sas.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6a8d35aea93a..2d73e65db4c0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -49,9 +49,10 @@
>   */
>  static int pm8001_find_tag(struct sas_task *task, u32 *tag)
>  {
> -       if (task->lldd_task) {
> -               struct pm8001_ccb_info *ccb;
> -               ccb = task->lldd_task;
> +       struct pm8001_ccb_info *ccb;
> +
> +       ccb = READ_ONCE(task->lldd_task);
> +       if (ccb) {
>                 *tag = ccb->ccb_tag;
>                 return 1;
>         }
> @@ -617,7 +618,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>                         pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
>         }
>
> -       task->lldd_task = NULL;
> +       WRITE_ONCE(task->lldd_task, NULL);
>         pm8001_ccb_free(pm8001_ha, ccb);
>  }
>
> --
> 2.25.1
>

> Fix this by using READ_ONCE() to read task->lldd_task exactly once,
> eliminating the TOCTOU window. Also use WRITE_ONCE() in
> pm8001_ccb_task_free() for proper memory ordering.

It just hit me that the patch can only eliminate the race on
task->lldd_task but cannot guarantee cbb has not released by
pm8001_ccb_free(pm8001_ha, ccb) when accssed. Maybe we still require a
lock synchronization?

Chengfeng
