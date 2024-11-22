Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD16517C215;
	Fri, 22 Nov 2024 22:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313899; cv=none; b=ie89xSYvUCErToQ4xYNw8UdZYhOezDKSLGZp3qi+LvnWkCShZG1jZMNcdMdUb3y9Y+cHhvjScEtz6OC13S530O08Ky9/gwKC1a2UnyUh+8R6YdsyA4Bi2vSQLl901BEYPUCSjTcF5D7ljLupWLCR4J4glzyg3v4Xrf88IN51te4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313899; c=relaxed/simple;
	bh=lMjgrtTcMD4b1SW1Y2OSEccQ5BSxGRFtVQDLVVuTrX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qQfCzT8lL0oM+6zhttKOUonnk1JrHKYtsMu8t5NxN2bmh2eyLvXNWlNlxs8vYWJjyaKC5L6HQ36c75pqct6B8fB9HWU8Obank+Oh8XCohyaGnWEOOvGbznSHsIToMwVvltFrBu9gqDYVoC7CEPdtCU6PbRw9isCuoa51kTnYmaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LdlxPW1r; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LdlxPW1r"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xw8cn05gDzlgMVW;
	Fri, 22 Nov 2024 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732313893; x=1734905894; bh=Z45+r6YX3qsDn7MweFwZioaj
	MgJoNThdbLqP8orzRrI=; b=LdlxPW1rrsJVdlIwiZoZ5sJUVwUiDUwrgOZTzj6f
	YS1iOwl5Vp3zhs0yYaG46/dUQLbeXVhRsaPtQjpumbYMTER6miHZA5PqIBWaUlTX
	TYig0odET7DZjvZm4UkPFrNz/3AAW/TKXCiL5UIBtdUACa6zLHS5Ln8+yZP6TB6G
	t4g2SIv60kOI2P2/v/mp5DojHpDDLCcY8K8UNf/CRiSIGJ5ILIrD0S3Bi1HelBHh
	dNsc8tyBebqp+z/9y5/6kICcyztkJOsFZP5AcKbILq52yAUF5r95hyYPOoLFc3+L
	/9+CnC7OkOF2jxyadFpa4OgEErrev3xpUY3SGP6Eo55ebg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SbD8TEb3FKhY; Fri, 22 Nov 2024 22:18:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xw8ch4qN6zlgMVV;
	Fri, 22 Nov 2024 22:18:12 +0000 (UTC)
Message-ID: <da02f209-8524-4281-a9d3-1b524bd966da@acm.org>
Date: Fri, 22 Nov 2024 14:18:10 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
To: Sam Protsenko <semen.protsenko@linaro.org>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241112170050.1612998-3-hch@lst.de>
 <20241122050419.21973-1-semen.protsenko@linaro.org>
 <20241122120444.GA25679@lst.de>
 <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAPLW+4==a515TCD93Kp-8zC8iYyYdh92U=j_emnG5sT_d7z64w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/22/24 1:55 PM, Sam Protsenko wrote:
> On Fri, Nov 22, 2024 at 6:04=E2=80=AFAM Christoph Hellwig <hch@lst.de> =
wrote:
>>
>> On Thu, Nov 21, 2024 at 11:04:19PM -0600, Sam Protsenko wrote:
>>> Hi Christoph,
>>>
>>> This patch causes a regression on E850-96 board. Specifically, there =
are
>>> two noticeable time lags when booting Debian rootfs:
>>
>> What storage driver does this board use?  Anything else interesting
>> about the setup?
>>
>=20
> It's an Exynos based board with eMMC, so it uses DW MMC driver, with
> Exynos glue layer on top of it, so:
>=20
>      drivers/mmc/host/dw_mmc.c
>      drivers/mmc/host/dw_mmc-exynos.c
>=20
> I'm using the regular ARM64 defconfig. Nothing fancy about this setup
> neither, the device tree with eMMC definition (mmc_0) is here:
>=20
>      arch/arm64/boot/dts/exynos/exynos850-e850-96.dts
>=20
> FWIW, I was able to narrow down the issue to dd_insert_request()
> function. With this hack the freeze is gone:
>=20
> 8<-------------------------------------------------------------------->=
8
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index acdc28756d9d..83d272b66e71 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -676,7 +676,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx
> *hctx, struct request *rq,
>          struct request_queue *q =3D hctx->queue;
>          struct deadline_data *dd =3D q->elevator->elevator_data;
>          const enum dd_data_dir data_dir =3D rq_data_dir(rq);
> -       u16 ioprio =3D req_get_ioprio(rq);
> +       u16 ioprio =3D 0; /* the same as old req->ioprio */
>          u8 ioprio_class =3D IOPRIO_PRIO_CLASS(ioprio);
>          struct dd_per_prio *per_prio;
>          enum dd_prio prio;
> 8<-------------------------------------------------------------------->=
8
>=20
> Does it tell you anything about where the possible issue can be?

It seems like eMMC devices do not tolerate I/O prioritization. How about
disabling I/O prioritization for eMMC setups? Is the ioprio cgroup
controller perhaps activated by the user space software that is running
on this setup?

Thanks,

Bart.
