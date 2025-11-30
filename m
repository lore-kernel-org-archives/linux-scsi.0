Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155B720299B
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2025 01:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764467902; cv=none; b=iK7gZZW1T60wFFDWMgkh5AuQFMtZ8gMA1qmhQGBBypXO4C3F0BLKO5jsbXDMFWIuht7VntMZARax4I9QhCb1eRklrhUiQ7PuLGs7/2bIi0Ap4clpBC8IUWTFfoRnf0gT/CiwTW5z6CwsgQO6fDtIoRSNGfzoSvcJ3nyoMgstfzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764467902; c=relaxed/simple;
	bh=yloQgqF3EzBjlTkAscBVHRmQKjFJie36E52+dG5Tn+4=;
	h=Cc:Mime-Version:Message-Id:To:Subject:Date:References:In-Reply-To:
	 Content-Type:From; b=ScxbDf/emUBeCZn91ZcdHkd5dVHeI0KTQ85yu9ahMb8bIoLz9eGHxrjs5EVS/0rCCfTEL3BqM2SNsNwkPn0HPPI1PsEvOFip6i+VlVqe3PR+DEloNRoprlUSRATSTA3Xak+E9IyMuvSd0lsb1iMl3LtQfZpG181gZl4dUE+CSl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=pJS3HFzr; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="pJS3HFzr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764467888;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+D9+7rgPjm1JXzQBzR20yHuHwAln2Tj2XSSp5K4gMXM=;
 b=pJS3HFzrj8vpbph6Vmic8g6IyRTxcBYm3WUBEV9qzSnigh8imhxSpveC4l4wzgk762QrQU
 bcaCijMi/bnH34OM2kY5deXROr8CX+dq0/k+8wsKu6SYAgtrus49wnosAcI5Bt0gYJ9C5B
 VdfGga1WCaJUIA4K81amAlHWMEtomECP0ZAfHqGtks8YnnyMPEN2Msko51TDgzCQYl5IJ7
 jWDF+HmuRpuNRrUluE3BQSjSBQA7VbVyiJruvKXOQEZftn7QXy42gQWwg8l98cUrPyJGPA
 tmVHeC852+DbPU+xs9+IrKwNC1Omw5lV6yIQC7sMhIbzOWN4XrDy9kl9dsSiQg==
Cc: <berrange@redhat.com>, <neil@brown.name>, <hch@lst.de>, 
	<pasha.tatashin@soleen.com>, <mclapinski@google.com>, 
	<khazhy@google.com>
Reply-To: yukuai@fnnas.com
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <a5066e6e-40ec-4c58-a60d-55510191bf27@fnnas.com>
Organization: fnnas
X-Lms-Return-Path: <lba+2692ba4ae+c6a5e7+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 30 Nov 2025 09:58:05 +0800
To: "Tarun Sahu" <tarunsahu@google.com>, <linux-raid@vger.kernel.org>, 
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [RFC PATCH v2] md: remove legacy 1s delay in md_notify_reboot
Date: Sun, 30 Nov 2025 09:58:04 +0800
References: <20251121191422.2758555-1-tarunsahu@google.com>
In-Reply-To: <20251121191422.2758555-1-tarunsahu@google.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>

=E5=9C=A8 2025/11/22 3:14, Tarun Sahu =E5=86=99=E9=81=93:

> During system shutdown, the md driver registered notifier function
> (md_notify_reboot) currently imposes a hardcoded one-second delay.
>
> This delay was introduced approximately 23 years ago and was likely
> necessary for the hardware generation of that time. Proposing this
> patch to make sure there are no known devices that need this delay.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
> v2:
> 	Added linux-scsi mailing list
>
>   drivers/md/md.c | 11 -----------
>   1 file changed, 11 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b086cbf24086..66c4d66b4b86 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9704,7 +9704,6 @@ static int md_notify_reboot(struct notifier_block *=
this,
>   			    unsigned long code, void *x)
>   {
>   	struct mddev *mddev;
> -	int need_delay =3D 0;
>  =20
>   	spin_lock(&all_mddevs_lock);
>   	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> @@ -9718,21 +9717,11 @@ static int md_notify_reboot(struct notifier_block=
 *this,
>   				mddev->safemode =3D 2;
>   			mddev_unlock(mddev);
>   		}
> -		need_delay =3D 1;
>   		spin_lock(&all_mddevs_lock);
>   		mddev_put_locked(mddev);
>   	}
>   	spin_unlock(&all_mddevs_lock);
>  =20
> -	/*
> -	 * certain more exotic SCSI devices are known to be
> -	 * volatile wrt too early system reboots. While the
> -	 * right place to handle this issue is the given
> -	 * driver, we do want to have a safe RAID driver ...
> -	 */
> -	if (need_delay)
> -		msleep(1000);
> -
>   	return NOTIFY_DONE;
>   }
>  =20

Applied to md-6.19
--=20
Thanks,
Kuai
