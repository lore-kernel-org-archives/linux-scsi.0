Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5890132A3FF
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991980; cv=none; b=hsVpH9LF96nQ5Zjz6Y8Kv9RaL0TOXKGVc8jqVkGMM5pKXKWVBo67rZ6B2jAXPt0U6H9YUheI4Tc5uSO6YhbBscMRCkt6OxWoFieFdxHiUp9AYbUS211z1wmYqGCW/F2j4+VFeCZ+fsMB272ws7WxBPutn7Xnc3eK5wP6O9CurWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991980; c=relaxed/simple;
	bh=LdH1ik0FuhW1Amt+nJOdDgVmYk/lpJcN77adosaIcS4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=R7YYqqUR9KXlijYmA0Jt+kUovBvx7moXbGZ9mg9EKFlXMQSzAocCy6g+sFeey5Yo5Qigm3tzzTRvyvx5veeuMSe5H/caMig15qcUXK8AmT+tYQ7q0vxxOp+hgbxya28oJh2WhQnESbjMww2B/8u2aQ896mg+WneNp3E/gJRHb6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcPTEvbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcPTEvbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E391F000C4;
	Wed, 14 Oct 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991979;
	bh=h/QVjTI0wF0kU/DGbFxRwdrnwsMxSPnCMWEo1PTkZdA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RcPTEvbNp90EQP/zv2BmzuW4aaTYdnYaXI0O5FmUfABUAV2C++0P3i5NOvJyIQVfK
	 fQIe9vn7xgPxSyZA21uI+FanL3PCAkSmwu1X/mh+AwZuonkofKfFpxC8Du6l/yUN8O
	 wUuaTL29RbZlMAHAf9zBUe0f3xJjZoX2Qy56t4jbAs1JEAqO85dOcDFb6S4Dd0iak8
	 RQHB+9zjTVJdjioGFKHU/SkGk5uXa8QXhV8sX+BWSkOyu6oVUBTqpt8jrboqsj1tPm
	 zxehopxMCRynIPZZ8W56KqMZj4C5e15dhWNO9eNVtqjiikjtwOopNjVqbCU+xvu1Dx
	 z3TgLkhiCzFdg==
Message-ID: <sashiko-outbox-171472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/6] scsi: mvumi: bound the per-event parameter and
 sense dumps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-2-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:32:57 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mvumi: missing endianness conversion for firmware event fi=
elds
--

commit edf8fe53e2e86275574e11fc999d2a119ef7acd5
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: bound the per-event parameter and sense dumps

This commit adds bounds checking to the event parameter and sense data
loops in mvumi_show_event() to prevent out-of-bounds reads when printing
firmware events to the system log.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..38a92f8c25f5b 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1361,7 +1361,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
>  	if (ptr->param_count) {
>  		printk(KERN_WARNING "Event param(len 0x%x): ",
>  						ptr->param_count);
> -		for (i =3D 0; i < ptr->param_count; i++)
> +		for (i =3D 0; i < ptr->param_count &&
> +		     i < ARRAY_SIZE(ptr->params); i++)
>  			printk(KERN_WARNING "0x%x ", ptr->params[i]);

[Severity: Medium]
As this patch modifies the parameter array loop in mvumi_show_event(), does
this code miss an endianness conversion when reading from the hardware DMA
buffer?

The u32 parameter fields from the event payload (ptr->params[i]) are
printed natively. On Big-Endian architectures, this could lead to
byte-swapped values appearing in the system logs whenever the firmware
reports an event.

Additionally, just prior to this loop in mvumi_show_event(), other
multi-byte fields from the hardware event structure (sequence_no, event_id,
and device_id) are also printed natively. Can these fields cause garbage
values to be logged on Big-Endian systems if they are not converted using
functions like le32_to_cpu() or le16_to_cpu()?

> =20
>  		printk(KERN_WARNING "\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D1
